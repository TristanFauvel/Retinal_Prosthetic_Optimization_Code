function  filename = BO_p2p(task, maxiter, subject, acquisition_fun, acquisition_fun_name, model_seed, seed,visual_field_size, viewing_distance, misspecification, implant_name, Stimuli_folder, use_ptb3, p2p_version)
%Note: the problem is a maximization problem
close all
parallel = 0; % Choose wether to run the perecptual model computation and the random queries in parallel

add_directories;
rng(model_seed)

dpcm = get(0,'ScreenPixelsPerInch')/2.54; % number of pixels per centimeter
display_size = 2*viewing_distance*tan(0.5*visual_field_size*pi/180); % Size of the image on screen (in m)
display_size = floor(display_size*100*dpcm) ; % Size of the image on screen (in pixels)
% 360/pi*atan(s/(100*dpcm)/(2*viewing_distance))
display_width = display_size(2);
display_height = display_size(1);
experiment.display_size = display_size;
% Experiment index
index_file = [raw_data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/index.mat'];
if isfile (index_file)
    load(index_file);
    index = index + 1 ;
else
    index = 1;
end

if ~exist([data_directory, '/Data_Experiment_p2p_',task,'/',subject],'dir')
    mkdir([data_directory, '/Data_Experiment_p2p_',task,'/',subject])
end

if ~exist([raw_data_directory, '/Data_Experiment_p2p_',task,'/',subject],'dir')
    mkdir([raw_data_directory, '/Data_Experiment_p2p_',task,'/',subject])
end

% List the perceptual model parameters
params = {'rho','lambda', 'rot','center_x', 'center_y', 'magnitude', 'beta_sup', 'beta_inf', 'z'};

% List the parameters to update (we do not update z because of a bug with
% pulse2percept).

if strcmp(implant_name, 'Argus II')
    to_update = {'rho', 'lambda', 'rot', 'center_x', 'center_y', 'magnitude', 'beta_sup', 'beta_inf'};
elseif strcmp(implant_name, 'PRIMA')
    to_update = {'rot', 'center_x', 'center_y', 'magnitude'};
end

% Value range for each parameter

rho_range = [137,415];
lambda_range =[358,1510];
rot_range = [-15,15]*pi/180; %+- 30° precision
center_x_range = [-500,500]; %1 mm center precision
center_y_range = [-500,500];
beta_sup_range = [-2.5,-1.3];
beta_inf_range = [0.1,1.3];
z_range =[0,500];
magnitude_range = [0,300];


default_values = [200,400,0,0,0,175.8257,-2.5,0.1,0]; %Default parameter values

%% Initialize the true patient-specific perceptual model
experiment.p2p_version = p2p_version;
experiment.default_values=  default_values;


pymod = [];
load_python;



%Sample a perceptual model
[rho,lambda, rot, center_x, center_y, magnitude, ~, ~,z, lb, ub, model_lb, model_ub] = sample_perceptual_model(to_update, default_values, rho_range,lambda_range,rot_range,center_x_range,center_y_range,beta_sup_range,beta_inf_range,z_range,magnitude_range);
% Select beta values at one extreme
beta_sup = beta_sup_range(2);
beta_inf = beta_inf_range(2);


true_model_params = [rho,lambda, rot, center_x, center_y, magnitude, beta_sup, beta_inf,z]';
model_params = true_model_params;


%% Define the implant
if strcmp(implant_name, 'Argus II')
    implant.array_shape = [6,10];
    nelectrodes = implant.array_shape(1)*implant.array_shape(2);
    experiment.implant_size = implant.array_shape;
elseif strcmp(implant_name, 'PRIMA')
    nelectrodes = 378;
end
implant.rot = rot;
xrange = py.list([-18, 16]);
yrange = py.list([-11, 11]);
xystep = 0.3; % Spatial resolution of the model
n_ax_segments= int64(300); %int64(300);
n_axons= int64(300); %int64(400);
experiment.n_electrodes =nelectrodes;


experiment.n_ax_segments = n_ax_segments;
experiment.n_axons = n_axons;
experiment.xrange = xrange;
experiment.yrange = yrange;
experiment.xystep = xystep;
experiment.use_ptb3 = use_ptb3;
experiment.implant_name = implant_name;

%Compute the true perceptual model
ignore_pickle=1; % Wether to use a precomputed axon map (0) or not (1)
optimal_magnitude = 0;
[~, M, nx,ny] = encoder(true_model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
experiment.nx = nx;
experiment.ny = ny;
experiment.M = M;
experiment.task = task;

if misspecification
    % We assume some values of the model that are purposedly wrong, so as to
    % misspecify the model
    to_update = {'rho', 'lambda', 'rot', 'center_x', 'center_y','magnitude'};
    [~,~,~,~,~,~, ~, ~,~, lb, ub] = sample_perceptual_model(to_update, default_values, rho_range,lambda_range,rot_range,center_x_range,center_y_range,beta_sup_range,beta_inf_range,z_range,magnitude_range);

    beta_sup = beta_sup_range(1);%-2.5;
    beta_inf = beta_inf_range(1);% 0.1;


    model_params = [rho,lambda, rot, center_x, center_y, magnitude,  beta_sup, beta_inf,z]';
    %Precompute the axon map according to the estimated perceptual model (it may not change anymore if beta_sup and beta_inf
    %are not updated)
    encoder(model_params, experiment,1, optimal_magnitude, 'pymod', pymod);
end

%% Avoid recomputing the axon map if not necessary
if ~(ismember('beta_inf', to_update) || ismember('beta_sup', to_update))
    ignore_pickle = 0;
end

experiment.to_update=to_update;
d=numel(to_update);

%% Initialize the surrogate model
 kernelname = 'Matern52';% 'ARD'; %'ARD';'Matern52'
% kernelname = 'ARD';% 'ARD'; %'ARD';'Matern52'

if strcmp(task, 'preference') && misspecification
    theta_filename = [data_directory, '/Dataset_preference_misspecified_seed_6_theta.mat'];
elseif strcmp(task, 'preference') && ~misspecification
    theta_filename = [data_directory, '/Dataset_preference_seed_6_theta.mat'];
elseif strcmp(task, 'E')
    theta_filename = [data_directory, '/Dataset_E_seed_6_theta.mat'];
end
load(theta_filename,'ktheta')

switch(kernelname)
    case 'Gaussian'
        base_kernelfun =  @Gaussian_kernelfun;
        theta_init = -4*ones(2,1);
    case 'ARD'
        base_kernelfun =  @ARD_kernelfun;
        theta_init = ktheta{1};
    case 'Matern52'
        base_kernelfun = @Matern52_kernelfun;
        theta_init = ktheta{3};
    case 'Matern32'
        base_kernelfun = @Matern32_kernelfun;
        theta_init = ktheta{4};
end

 

hyp_lb = -10*ones(size(theta_init));
hyp_ub = 10*ones(size(theta_init));

[~, ib] = intersect(params,to_update);
ib = sort(ib);
experiment.params = params;
experiment.ib = ib;
theta.cov = theta_init;
theta.mean = 0;
post = [];

  

lb_norm = zeros(d,1);
ub_norm = ones(d,1);


switch task
    case 'preference'
        x0 = zeros(d,1);
        condition.x0 = zeros(d,1);
        Stimuli_folder =  [Stimuli_folder, '/letters'];
        letters = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
        experiment.letters_range = 1:2:26; % [1,2,5,6,8,13,14,18];
        bounds = floor(0.9*display_size(1))*[1,1];
     case 'LandoltC'
        Stimuli_folder =  [Stimuli_folder, '/landoltC'];
        bounds = [10, display_size(1)]; %size range for the C
    case 'E'
        bounds = 0.35*[display_size(1), display_size(1)]; %[0.9*display_size(1), 0.9*display_size(1)]; %size range for the E
        Stimuli_folder =  [Stimuli_folder, '/E'];
    case  'Vernier'
        barwidth=10;
        b = 15; %margin
        bounds = [0,nx-barwidth-1-b];
end

rand_acq = @() rand_model(model_ub, model_lb, magnitude_range, experiment, ib,ignore_pickle);

rng(seed)

if strcmp(task, 'preference')
    x_duel1 = rand_acq();
    x_duel2 = rand_acq();
    new_duel= [x_duel1; x_duel2];
    xtrain =  NaN(size(new_duel,1),maxiter);

else
    new_x = rand_acq();
    xtrain =  NaN(size(new_x,1),maxiter);
    access_param = NaN(1,maxiter);
end
%% Initialize the experiment
ctrain = NaN(1,maxiter);

nopt = 2; % number of time steps before starting using the acquisition function %%%%%%%%%%%%%%%%%%%%%%%%%ù

if strcmp(acquisition_fun_name, 'random')
    nopt = maxiter +1;
end

options_theta.method = 'lbfgs';
options_theta.verbose = 1;
update_period = 100000;
rt = NaN(1,maxiter);
contrast = 1 ;
i = 0;
hyps = NaN(maxiter,numel(theta.cov));
displayed_stim = cell(1,maxiter);

if ~ismember('magnitude', to_update)
    optimal_magnitude = 1;
else
    optimal_magnitude = 0;
end

options_maxmean.method = 'sd';
options_maxmean.verbose = 1;

stopping_criterion =0;
x_best_norm = NaN(d,maxiter);


regularization = 'nugget';

condition.x0 = zeros(d,1);
condition.y0 = 0;
link = @normcdf;
modeltype = 'exp_prop';

meanfun = @constant_mean;
hyperparameters.ncov_hyp =numel(theta.cov); % number of hyperparameters for the covariance function
hyperparameters.nmean_hyp =1; % number of hyperparameters for the mean function
hyperparameters.hyp_lb = -10*ones(hyperparameters.ncov_hyp  + hyperparameters.nmean_hyp,1);
hyperparameters.hyp_ub = 10*ones(hyperparameters.ncov_hyp  + hyperparameters.nmean_hyp,1);

ns = 0;
if strcmp(task,'preference')
    identification = 'mu_g';
    model = gp_preference_model(d, meanfun, base_kernelfun, regularization, ...
        hyperparameters, lb,ub, 'preference', link, modeltype, kernelname, condition, 0);
    optim = preferential_BO([], task, identification, maxiter, nopt, nopt, update_period, 'all', acquisition_fun, d,  ns);
else
    identification = 'mu_c';
    model = gp_classification_model(d, meanfun, base_kernelfun, regularization, ...
        hyperparameters, lb,ub, 'classification', link, modeltype, kernelname, ns);
    optim = binary_BO([], task, identification, maxiter, nopt, nopt, update_period, 'all', acquisition_fun, d, ns);
end

%% Compute the kernel approximation if needed
if strcmp(model.kernelname, 'Matern52') || strcmp(model.kernelname, 'Matern32') %|| strcmp(kernelname, 'ARD')
    approximation.method = 'RRGP';
else
    approximation.method = 'SSGP';
end
approximation.decoupled_bases = 1;
approximation.nfeatures = 6561;

if  strcmp(task, 'preference')
    [approximation.phi_pref, approximation.dphi_pref_dx, approximation.phi, approximation.dphi_dx]= sample_features_preference_GP(theta, model, approximation);
else
    [approximation.phi, approximation.dphi_dx]= sample_features_GP(theta, model, approximation);
end


while ~ stopping_criterion
    i=i+1;


    hyps(i,:) = theta.cov;
    disp(i)
    access_param(i) = rand_interval(bounds(1), bounds(2));

    if strcmp(task, 'preference')

        xtrain(:,i)=  new_duel;
        x_duel = model_params;
        x_duel(ib) = x_duel1;
        x_duel1 = x_duel;
        x_duel(ib) = x_duel2;
        x_duel2 = x_duel;

        %% Normalize data so that the bound of the search space are 0 and 1.
        xtrain_norm = (xtrain(:,1:i) - [lb; lb])./([ub; ub]- [lb; lb]);


        W{1} = encoder(x_duel1, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
        W{2} = encoder(x_duel2, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
        [S,displayed_stim{i}] = compute_stimulus(experiment, task,access_param(i), display_width, display_height, Stimuli_folder, contrast);
        [c, rt(i)] = query_response_task(M, W, S, display_size, experiment, task, displayed_stim{i});
    else
        xtrain(:,i) = new_x;
        new = new_x;
        new_x = model_params;
        new_x(ib) = new;

        %% Normalize data so that the bound of the search space are 0 and 1.
        xtrain_norm = (xtrain(:,1:i) - lb(:))./(ub(:)- lb(:));

        W= encoder(new_x,experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);

        [S.S,S.correct_response] = compute_stimulus(experiment, task,access_param(i), display_width, display_height, Stimuli_folder, contrast);
        [c, rt(i)] = query_response_task(M, W, S.S, display_size, experiment, task,S.correct_response);
        displayed_stim{i}  = S.correct_response;
    end
    ctrain(i) = c;

    if isnan(c)
        i=max(i-2,0);
        x_duel1 = xtrain(1:d, i+1);
        x_duel2 = xtrain(d+1:end, i+1);
        new_x = [x_duel1;x_duel2];
    else
        post =  model.prediction(theta, xtrain_norm(:,1:i), ctrain(1:i), [], post);
        if i >= nopt
            %Optimization of hyperparameters
            if mod(i, update_period) == 0
                theta = model.model_selection(xtrain_norm(:,1:i), ctrain(1:i), theta, optim. hyps_update);
                post =  model.prediction(theta, xtrain_norm(:,1:i), ctrain(1:i), [], post);
                if  strcmp(task, 'preference')
                    [approximation.phi_pref, approximation.dphi_pref_dx, approximation.phi, approximation.dphi_dx]= sample_features_preference_GP(theta, d, model, approximation);
                else
                    [approximation.phi, approximation.dphi_dx]= sample_features_GP(theta, model, approximation);
                end
            end
                 new_x = acquisition_fun(theta, xtrain_norm(:,1:i), ctrain(1:i), model, post,approximation, optim);
                 if strcmp(task, 'preference')
                     x_duel1 = new_x(1:d);
                     x_duel2 = new_x((d+1):end);
                 end

        else %When we have not started to train the GP classification model, the acquisition is random
            if strcmp(task, 'preference')
                x_duel1 = rand_acq();
                x_duel2 = rand_acq();
                new_duel= [x_duel1; x_duel2];
            else
                new_x = rand_acq();
            end
        end
    end

    if i == maxiter
       x_best_norm(:,i)  = optim.identify(model, theta, xtrain_norm, ctrain, post);                
    end
    if i>= maxiter
        stopping_criterion = 1;
    end
end

x_best = model_params.*ones(1,maxiter);
x_best(ib,:) = x_best_norm(ib,:).*(model_ub(ib)-model_lb(ib))  + model_lb(ib) ;


if ~strcmp(task, 'preference')
    if lb(end) == ub(end) %correspond to a constant control variable for the acuity task
        xtrain_norm = xtrain_norm(1:end-1,:);
        ub = lb(1:end-1);
        lb = lb(1:end-1);
        lb_norm = lb_norm(1:end-1);
        ub_norm = ub_norm(1:end-1);
    end
end

close all

disp(mean(ctrain))

experiment.display_size = display_size;
experiment.p2p_version = p2p_version;
experiment.default_values = default_values;
experiment.n_ax_segments = n_ax_segments;
experiment.n_axons = n_axons;
experiment.xystep = xystep;
experiment.implant_name = implant_name;
experiment.nx = nx ;
experiment.ny = ny;
experiment.task = task;
experiment.to_update = to_update;
experiment.params = params;
experiment.ib = ib ;
experiment.Stimuli_folder = Stimuli_folder;
experiment.acquisition_fun = acquisition_fun;
experiment.acquisition_fun_name = acquisition_fun_name;
experiment.beta_inf = beta_inf;
experiment.beta_inf_range = beta_inf_range;
experiment.beta_sup = beta_sup;
experiment.beta_sup_range = beta_sup_range;
experiment.center_x = center_x;
experiment.center_x_range = center_x_range;
experiment.center_y = center_y;
experiment.center_y_range = center_y_range;
experiment.contrast = contrast;
experiment.ctrain = ctrain;
experiment.d = d;
experiment.display_height = display_height;
experiment.display_width = display_width;
experiment.displayed_stim = displayed_stim;
experiment.dpcm = dpcm;
experiment.hyps = hyps;
experiment.implant = implant;
experiment.index = index;
experiment.model = model;
experiment.lambda = lambda;
experiment.lambda_range = lambda_range;
experiment.latest_perceptual_model_table_file = latest_perceptual_model_table_file;
experiment.latest_perceptual_models_directory = latest_perceptual_models_directory;
experiment.lb = lb;
experiment.lb_norm = lb_norm;
experiment.link = link;
experiment.magnitude = magnitude;
experiment.magnitude_range = magnitude_range;
experiment.maxiter = maxiter;
experiment.misspecification = misspecification;
experiment.model_params = model_params;
experiment.model_seed = model_seed;
experiment.modeltype = modeltype;
experiment.nelectrodes = nelectrodes;
experiment.nopt = nopt;
experiment.options_maxmean = options_maxmean;
experiment.options_theta = options_theta;
experiment.rho = rho;
experiment.rho_range = rho_range;
experiment.rot = rot;
experiment.rot_range = rot_range;
experiment.rt = rt;
experiment.seed = seed;
experiment.stable_perceptual_model_table_file = stable_perceptual_model_table_file;
experiment.stable_perceptual_models_directory = stable_perceptual_models_directory;
experiment.stopping_criterion = stopping_criterion;
experiment.subject = subject;
experiment.theta = theta;
experiment.theta_init = theta_init;
experiment.true_model_params = true_model_params;
experiment.update_period = update_period;
experiment.viewing_distance = viewing_distance;
experiment.visual_field_size = visual_field_size;
experiment.x_best = x_best;
experiment.x_best_norm = x_best_norm;
experiment.xtrain = xtrain;
experiment.xtrain_norm = xtrain_norm;
experiment.z = z;
experiment.z_range = z_range;
if strcmp(task, 'preference')
    experiment.x0 = x0;
    experiment.letters = letters;
end

experiment = rmfield(experiment, 'M');

filename = [raw_data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];

save(filename, 'experiment')
save(index_file, 'index')


Acquisition = categorical(cellstr(acquisition_fun_name));
Subject = categorical(cellstr(subject));
Task =categorical(cellstr(task));
Model_Seed = model_seed;
Seed =seed;
Index= index;
Misspecification = misspecification;
Implant =categorical(cellstr(implant_name));
NAxon_Segments = n_ax_segments;
NAxons= n_axons;

t = table(Index, Model_Seed, Seed, Task, Acquisition, Subject,Misspecification, Implant, NAxons, NAxon_Segments);
if exist(data_table_file)
    T = load(data_table_file);
    T = [T.T;t];
else
    T = t;
end
save(data_table_file, 'T')

