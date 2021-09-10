function measure_vision_E(filename, varargin)
opts = namevaluepairtostruct(struct( ...
    'short_version', 0, ...
    'codes', [] ...
    ), varargin);
tests = 'VA';
task = 'E';
% tests  : 'VA' or 'CS'
% task : 'E' or 'Snellen'
UNPACK_STRUCT(opts, false)

% tasks= {'Snellen', 'E'}
load(filename, 'experiment');
add_directories;

if ~isfield(experiment, 'M')
    ignore_pickle=1; % Wether to use a precomputed axon map (0) or not (1)
    optimal_magnitude = 0;
    pymod = [];
    [~, experiment.M] = encoder(experiment.true_model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
end

acquisition_fun_name  ='maxvar_challenge';
if isempty(codes)
    if strcmp(experiment.acquisition_fun_name, acquisition_fun_name) %&& strcmp(experiment.task, 'preference') %&& experiment.misspecification ==0
        if experiment.misspecification ==0
            if short_version == 1
                codes = {'optimized', 'control'};
            elseif short_version == 2
                codes = {'optimal'};
            elseif short_version == 3
                codes = {'optimized', 'optimal', 'control'};
            else
                codes = {'optimized', 'optimal', 'control', 'naive'};
            end
        else
            if short_version == 1
                codes = {'optimized'};
            elseif short_version == 2
                codes = {'optimized'};
            else
                codes = {'optimized', 'optimal'};
            end
        end
    else
        codes = {'optimized'};
        if short_version ==2 && strcmp(experiment.task, 'preference')
            codes = {};
        end
    end
end

experiments_order  =randperm(numel(codes));
for k =1:numel(codes)
    code = codes{experiments_order(k)};
    switch code
        case 'optimized' % Select the best encoder found at the end of the optimization
            W = encoder(experiment.x_best(:, end), experiment,1,0); 
            code = experiment.acquisition_fun_name;
        case 'optimal' % Select the best encoder
            W = encoder(experiment.model_params, experiment,1,1);            
        case 'control'
            xparams = experiment.model_params;
            xparams(experiment.ib) = experiment.xtrain(experiment.ib,1);
            W = encoder(xparams, experiment,1,0);
        case 'naive'
            W = naive_encoder(experiment);
    end    
    for i = 1:numel(tests)
        test = tests{i};
        experiment.([test, '_', task ,'_QUEST_',code]) = vision_test_QUEST(experiment, W, test, task);
    end
end

close all
experiment = rmfield(experiment, 'M');

save(filename, 'experiment')
