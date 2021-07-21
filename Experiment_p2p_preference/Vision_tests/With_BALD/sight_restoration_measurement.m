function VA_CS_measure = sight_restoration_measurement(experiment, W, test)
% Visual acuity measurement using landolt C test and active learning.

add_directories


acquisition_fun =@adaptive_sampling_binary_grid_gpml;

rng(experiment.seed)
nx = experiment.nx;
ny = experiment.ny;

viewing_distance = experiment.viewing_distance;
visual_field_size = experiment.visual_field_size;
display_size = floor(experiment.display_size);

nd=2;
switch test
    case 'LandoltC'
        bounds = [10, display_size(1);0,1]; %size range for the C
        Stimuli_folder =  [Stimuli_folder,'/landoltC'];
        update_period = 200;
        
    case 'Vernier'
        barwidth=10;
        b = 15; %margin
        bounds = [-15,15;0,1]; %[-(nx-barwidth)+30+b, nx-barwidth-30-b];
        maxiter = 80;
        update_period = 200;
        
    case 'E'
        bounds = [20, display_size(1);0,1]; %size range for the E
        Stimuli_folder =  [Stimuli_folder,'/E'];
        maxiter = 80;
        update_period = 10;
end

lb = bounds(:,1);
ub = bounds(:,2);

size_range = linspace(lb(1),ub(1),150);
contrast_range=  linspace(lb(2),ub(2),80);
[p,q] = meshgrid(size_range, contrast_range);
x =  [p(:),q(:)]';

meanfunc = @meanConst; hyp.mean = norminv(0.25);
mask1 = [0,1];
mask2 = [1,0];
covfunc = {@covProd,{{'covMask',{mask1,'covLINiso'}},{'covMask',{mask2,'covLINiso'}}}};

hyp.cov = log([1 1]);

likfunc = @likErf;
% We want to keep the constant mean hyperparameter fixed:
prior.mean = {@priorClamped};
inf_func = {@infPrior,@infLaplace,prior};

%% Initialize the experiment

idx = randsample(size(x,2),1);
new_x= x(:,idx);

nopt = 15; % number of time steps before starting using the acquisition function

close all;

% theta_lb = [-10;-30;-10;-10;-30;-10];
% theta_ub= [5;30;5;5;30;5];

% options_theta.verbose = 1;
% options_theta.method = 'sd'; %'lbfgs';
M = experiment.M;


% query_response_VA_test(test, M, x, S, nx, ny, correct_response, pymod, display_size, xrange, yrange, xystep, n_ax_segments, n_axons)

% wbar = waitbar(0,'Experiment complextion');
%
% if strcmp(test, 'E')
%     xfake = [size_range,zeros(1, numel(contrast_range));zeros(1, numel(size_range)),  contrast_range];
% %     xfake = repmat(xfake,1,3);
%     cfake = rand(1,size(xfake,2))>0.75;
%
%     idfake = randsample(numel(cfake), 100);
%     xtrain = [xtrain, xfake(:, idfake)];
%     ctrain= [ctrain, cfake(idfake)];
% end

xtrain =  NaN(size(new_x,1),maxiter);
ctrain = NaN(1,maxiter);

x_norm = (x-lb)./(ub-lb);
i=0;
while i<maxiter
    i=i+1;
    %     waitbar(i/maxiter,wbar,'Experiment complextion');
    
    switch test
        case 'LandoltC'
            correct_response = randsample([1,2,3,4,6,7,8,9], 1);
            S = load_landolt_C(correct_response, new_x(1), nx, ny, Stimuli_folder,new_x(2));
        case 'Vernier'
            offset = new_x(1);
            if numel(1+b+ceil((abs(offset) + barwidth)/2): (nx-b -floor((abs(offset)+barwidth)/2))) == 1
                center = 1+b+ceil((abs(offset) + barwidth)/2);
            else
                %center = randsample(1+ceil((abs(offset) + barwidth)/2): (nx -floor((abs(offset)+barwidth)/2)),1);
                if isempty(1+b+ceil((abs(offset) + barwidth)/2): (nx-b -floor((abs(offset)+barwidth)/2)))
                    center = floor(nx/2);
                else
                    center = randsample(1+b+ceil((abs(offset) + barwidth)/2): (nx-b -floor((abs(offset)+barwidth)/2)),1);
                end
            end
            correct_response = sign(offset);
            S = Vernier_frame(offset, nx, ny, barwidth, center,new_x(2));
        case 'E'
            correct_response = randsample([8,6,2,4], 1);
            S = load_E(correct_response, new_x(1), display_size(2), display_size(1), Stimuli_folder,new_x(2));
    end
    %[c, response]= query_response_VA_test(test, M, W, S, correct_response, display_size, experiment);
      
    c = query_response_task(M, W, S, display_size, experiment, test, 'correct_response', correct_response);
    switch test
        case {'LandoltC','E'}
            ctrain(i) = c;
        case 'Vernier'
            ctrain(i) = response;
    end
    %% Normalize data so that the bound of the search space are 0 and 1.
    
    if isnan(c)
        i=i-2;
        new_x = xtrain(:, i+1);
    else
        
        xtrain(:,i) = new_x;
        xtrain_norm = (xtrain(:,i)-lb)./(ub-lb);
        
        if i > nopt
            if i== nopt+1 || mod(i, update_period) ==1
                nd = numel(hyp.cov);
                theta_ub = 10*ones(nd,1);
                theta_lb = -10*ones(nd,1);
                ncandidates= 5;
                starting_points= NaN(nd,ncandidates);
                for k = 1:nd
                    starting_points(k,:)= theta_lb(k)+(theta_ub(k)-theta_lb(k))*rand(1,ncandidates);
                end
                if nd ==2
                    starting_points = [starting_points(1,:);starting_points(1,:)];
                end
                
                minval=inf;
                for k = 1:ncandidates
                    hyp.cov = starting_points(:,k)';
                    hyp= minimize(hyp, @gp, -400, inf_func, meanfunc, covfunc, likfunc, xtrain_norm', (2*ctrain-1)');
                    val = gp(hyp, inf_func, meanfunc, covfunc, likfunc, xtrain_norm', (2*ctrain-1)');
                    if ~isnan(val) && val < minval
                        best = hyp;
                        minval = val;
                    end
                end
                hyp = best;
            end
            new_x = acquisition_fun(x_norm, hyp, xtrain_norm, ctrain, meanfunc, covfunc, likfunc);
            new_x = new_x.*(ub-lb)+lb;
        else %When we have not started to train the GP classification model, the acquisition is random
            idx = randsample(size(x,2),1);
            new_x= x(:,idx);
        end
    end
end
VA_CS_measure.ctrain= ctrain;
VA_CS_measure.xtrain = xtrain;
VA_CS_measure.xtrain_norm = xtrain_norm;
VA_CS_measure.hyp = hyp;
VA_CS_measure.contrast_range = contrast_range;
VA_CS_measure.size_range=size_range;
VA_CS_measure.viewing_distance=viewing_distance;
VA_CS_measure.bounds = bounds;
VA_CS_measure.x_norm = x_norm;
