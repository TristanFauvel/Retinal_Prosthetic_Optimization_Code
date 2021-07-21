function  measure = vision_test_QUEST(experiment, W, test, task)
% Visual acuity measurement using Snellen test and active learning.
% Task = 'E' or 'Snellen'
% global pathname

add_directories;

rng(experiment.seed)
% Uncomment this when I run the final experiment
dpcm = get(0,'ScreenPixelsPerInch')/2.54; % number of pixels per centimeter

global viewing_distance

angle_to_pixels = @(angle) floor(2*tan(angle*pi/180/2)*viewing_distance*100*dpcm); %angles are in degree

display_size = angle_to_pixels(experiment.visual_field_size); % Size of the image on screen (in pixels)

switch task
    case 'E'
        nalt = 4;
        Stimuli_folder =  [Stimuli_folder,'/E'];
        ne = 50;
        e_range=linspace(0,0.1,ne); %error rate range
        threshold = 0.8;
        maxNTrials = 50;
    case 'Eneg'
        nalt = 4;
        Stimuli_folder =  [Stimuli_folder,'/E'];
        ne = 50;
        e_range=linspace(0,0.1,ne); %error rate range
        threshold = 0.8;
        maxNTrials = 50;
    case 'Snellen'
        nalt = 26;
        Stimuli_folder =  [Stimuli_folder,'/letters'];
        threshold = 0.5;
        maxNTrials = 80;
end

b = norminv(1/nalt,0,1);
stim_res = 255;

switch test
    case 'CS'
        bounds = [0,1];
        %         param_ub = log10((norminv(threshold)-b)*stim_res); % Maxmum slope it is possible to measure given min stimulus intensity
        %         param_lb = log10((norminv(threshold)-b)/bounds(2)); % Minimum slope it is possible to measure given max stimulus intensity
        param_ub = (norminv(threshold)-b)*stim_res; % Maxmum slope it is possible to measure given min stimulus intensity
        param_lb = (norminv(threshold)-b)/bounds(2); % Minimum slope it is possible to measure given max stimulus intensity
        a_range = linspace(param_lb,param_ub,2000);
        
    case 'VA'
        stim_var = 'angular_diameter';
        %         bounds = [0.01, display_size(1)]; %size range for the letter (in px)
        %         param_ub = log10((norminv(threshold)-b)/bounds(1)); % Maxmum slope it is possible to measure given min stimulus intensity
        %         param_lb = log10((norminv(threshold)-b)/bounds(2)); % Minimum slope it is possible to measure given max stimulus intensity
        bounds = [10/60, min(experiment.visual_field_size)]; %size range for the letter
        param_ub = (norminv(threshold)-b); % Maxmum slope it is possible to measure given min stimulus intensity
        param_lb = -3; % Minimum slope it is possible to measure given max stimulus intensity
        a_range = logspace(param_lb,log10(param_ub),2000);
        
        
end

lb = bounds(1);
ub = bounds(2);
x = linspace(lb,ub,stim_res);
stimDomain = x;
respDomain = [0 1];

if strcmp(task,'Snellen')
    F = @(x,a)([1-(normcdf(a.*x+b)),normcdf(a.*x+b)])';
    paramDomain = {a_range};
    y1 = unifpdf(paramDomain{1},param_lb,param_ub);
    y1 = y1./sum(y1);
    priors = {y1};
    
else
    F = @(x,a,e)([1-((1-e)*normcdf(a.*x+b)+e/nalt),(1-e)*normcdf(a.*x+b)+e/nalt])';
    paramDomain = {a_range, e_range};
    y1 = unifpdf(paramDomain{1},param_lb,param_ub);
    y1 = y1./sum(y1);
    y2 = betapdf(paramDomain{2},1,20);
    y2 = y2./sum(y2);
    priors = {y1, y2};
end

stop_rule = 'entropy';
stop_criterion = 2.5;
minNTrials = 10;

% x_norm = (x-lb)./(ub-lb);

try
    %load([experiment_directory, '/QPlikelihoods_', task, '_', test], 'QP');
    load([experiment_path, '/QPlikelihoods_', task, '_', test], 'QP');
catch
    QP = QuestPlus(F, stimDomain, paramDomain, respDomain, stop_rule, stop_criterion, minNTrials, maxNTrials);
    % initialise (with default, uniform, prior)
    QP.initialise(priors);
    %     save([experiment_directory, '/QPlikelihoods_', task, '_', test], 'QP');
    save([experiment_path, '/QPlikelihoods_', task, '_', test], 'QP');
end

%% Initialize the experiment
burnin = 5;

close all;
graphics_style_paper;

if isfield(experiment, 'M')
    M = experiment.M;
else
    pymod = [];
    load_python;
    %Compute the true perceptual model
    ignore_pickle=1; % Wether to use a precomputed axon map (0) or not (1)
    optimal_magnitude = 0;
    [~, M, nx,ny] = encoder(experiment.true_model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
end

new_x= randsample(x,1);
base_stim_size = 0.8*min(experiment.visual_field_size);
base_contrast = 1;
stim_size = base_stim_size;
contrast = base_contrast;
display_height = display_size(1);
display_width = display_size(2);

correct_response = [];
for i = 1:burnin
    %     correct_response = randsample(types, 1);
    
    switch test
        case 'CS'
            contrast = new_x;
        case 'VA'
            stim_size = new_x;
    end
    [S,correct_response] = compute_stimulus(experiment, task, angle_to_pixels(stim_size), display_width, display_height, Stimuli_folder, contrast, 'previous_stim',correct_response);
    
    query_response_task(M, W, S, display_size, experiment, task, correct_response);
    
    idx = randsample(size(x,2),1);
    new_x= x(:,idx);
end

while ~QP.isFinished()
    again =1;
    while again
        new_x =  QP.getTargetStim();
        
        switch test
            case 'CS'
                contrast = new_x;
                stim_size = base_stim_size;
            case 'VA'
                contrast = base_contrast;
                stim_size = new_x;
        end
        [S,correct_response] = compute_stimulus(experiment, task, angle_to_pixels(stim_size), display_width, display_height, Stimuli_folder, contrast, 'previous_stim',correct_response);
        
        c = query_response_task(M, W, S, display_size, experiment, task, correct_response);
        if ~isnan(c)
            again = 0;
        end
    end
    QP.update(new_x, c);
end

measure.dpcm = dpcm;
measure.display_size = display_size;
measure.task = task;
measure.nalt = nalt ;
measure.Stimuli_folder =Stimuli_folder;
measure.threshold = threshold;
measure.b = b;
measure.stim_res = stim_res;
measure.bounds = bounds;
measure.param_ub = param_ub;
measure.param_lb = param_lb;
measure.stim_var = stim_var;
measure.lb = lb;
measure.ub = ub;
measure.QP =  QP;
measure.F = F;
measure.base_contrast = base_contrast;
measure.base_stim_size = base_stim_size;
measure.stop_rule = stop_rule;
measure.stop_criterion = stop_criterion;

QP
return

