function VA_CS_measure = sight_restoration_measurement(experiment, W, test)
% Visual acuity measurement using landolt C test and active learning.

% UNPACK_STRUCT(experiment, false)
add_directories


acquisition_fun =@adaptive_sampling_binary_grid;
acquisition_fun =@adaptive_sampling_binary_grid;

rng(experiment.seed)
nx = experiment.nx;
ny = experiment.ny;

viewing_distance = experiment.viewing_distance;
visual_field_size = experiment.visual_field_size
display_size = floor(experiment.display_size);

% dpcm = get(0,'ScreenPixelsPerInch')/2.54; % number of pixels per centimeter
% display_size = 2*viewing_distance*tan(0.5*visual_field_size*pi/180); % Size of the image on screen (in m)
% display_size = display_size*100*dpcm ; % Size of the image on screen (in pixels)

nd=2;
switch test
    case 'LandoltC'
        bounds = [10, display_size(1);0,1]; %size range for the C
        Stimuli_folder =  [Stimuli_folder,'/landoltC'];
        update_period = 200;

    case 'Vernier'
        barwidth=10;
        %         bounds = [-floor((nx-barwidth)/2), floor((nx-barwidth)/2)];
        b = 15; %margin
        bounds = [-15,15;0,1]; %[-(nx-barwidth)+30+b, nx-barwidth-30-b];
        maxiter = 80;
        update_period = 200;

     case 'E'
        bounds = [20, display_size(1);0,1]; %size range for the E
        Stimuli_folder =  [Stimuli_folder,'/E']; 
        maxiter = 80;
        update_period = 200;

end

lb = bounds(:,1);
ub = bounds(:,2);

size_range = linspace(bounds(1,1),bounds(1,2),150);
contrast_range=  linspace(bounds(2,1),bounds(2,2),80);
[p,q] = meshgrid(size_range, contrast_range);
x =  [p(:),q(:)]';

modeltype = 'exp_prop'; % Approximation model: laplace or exp_prop
kernelname = 'linear'; % We choose a linear kernel because of the monotonicity of the psychometric curve
base_kernelfun = @linear_kernelfun;

% kernelfun = @(theta, x0,x,training) mydeal(@sum_kernel, {theta, x0, x, training, base_model 1, 2, 1:(nd+1), nd+2:nd+4});
kernelfun = @(theta, x0,x,training) mydeal(@product_kernel, {theta, x0, x, training, base_model 1, 2, 1:(nd+1), nd+2:nd+4});

theta = [1;1;1;1;1;1];

%% Initialize the experiment
xtrain = [];
ctrain = [];

idx = randsample(size(x,2),1);
new_x= x(:,idx);

nopt = 40; % number of time steps before starting using the acquisition function

close all;

hyp_lb = [-10;-30;-10;-10;-30;-10];
hyp_ub= [5;30;5;5;30;5];

options_theta.verbose = 1;
options_theta.method = 'sd'; %'lbfgs';
M = experiment.M;


% query_response_VA_test(test, M, x, S, nx, ny, correct_response, pymod, display_size, xrange, yrange, xystep, n_ax_segments, n_axons)

% wbar = waitbar(0,'Experiment complextion');

if strcmp(test, 'E')
    xfake = [size_range,zeros(1, numel(contrast_range));zeros(1, numel(size_range)),  contrast_range];
%     xfake = repmat(xfake,1,3);
    cfake = rand(1,size(xfake,2))>0.75;
    
    idfake = randsample(numel(cfake), 100);
    xtrain = [xtrain, xfake(:, idfake)];
    ctrain= [ctrain, cfake(idfake)];
end


x_norm = (x-lb)./(ub-lb);
for i=1:maxiter %x corresponds to the diameter of the C.
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
            %             center = floor(nx/2) +1;
            correct_response = sign(offset);
            S = Vernier_frame(offset, nx, ny, barwidth, center,new_x(2));
        case 'E'
           correct_response = randsample([8,6,2,4], 1);
           S = load_E(correct_response, new_x(1), display_size(2), display_size(1), Stimuli_folder,new_x(2));
%            figure(1)
%            imagesc(S)

    end
    %c= query_response_VA_test(test,M, xparams, S, nx, ny, correct_response, pymod, display_size, xrange, yrange, xystep, n_ax_segments, n_axons);
    [c, response]= query_response_VA_test(test, M, W, S, nx, ny, correct_response, display_size);
    
    switch test
        case {'LandoltC','E'}
            ctrain =  [ctrain,c];
        case 'Vernier'
            ctrain =  [ctrain,response];
    end
    %% Normalize data so that the bound of the search space are 0 and 1.
    xtrain = [xtrain, new_x];
    xtrain_norm = (xtrain-lb)./(ub-lb);
    
    if i > nopt
        if i== nopt+1 || mod(i, update_period) ==1
            theta = multistart_minConf(@(hyp)negloglike_bin(hyp, xtrain_norm, ctrain, model), hyp_lb, hyp_ub,3, theta,options_theta);
        end
        new_x = acquisition_fun(x_norm, theta, xtrain_norm, ctrain,model);
        new_x = new_x.*(ub-lb)+lb;
    else %When we have not started to train the GP classification model, the acquisition is random
        idx = randsample(size(x,2),1);
        new_x= x(:,idx);
    end
end
VA_CS_measure.ctrain= ctrain;
VA_CS_measure.xtrain = xtrain;
VA_CS_measure.xtrain_norm = xtrain_norm;
VA_CS_measure.hyp_lb = hyp_lb ;
VA_CS_measure.hyp_ub = hyp_ub ;
VA_CS_measure.kernelfun = kernelfun;
VA_CS_measure.modeltype = modeltype;
VA_CS_measure.theta = theta;
VA_CS_measure.contrast_range = contrast_range;
VA_CS_measure.size_range=size_range;
VA_CS_measure.viewing_distance=viewing_distance;
VA_CS_measure.bounds = bounds;
VA_CS_measure.options_theta=options_theta;
VA_CS_measure.x_norm = x_norm;
