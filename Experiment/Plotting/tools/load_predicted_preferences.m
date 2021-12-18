%% THIS FILE IS NOT USED.

function [pref_optimized_preference_acq, pref_optimal, pref_optimized_preference_random, pref_optimized_preference_acq_misspecification, pref_optimal_misspecification, pref_optimized_E_TS,pref_control] = load_prefues(reload)
add_directories,
filename = [data_directory, '/predicted_preferences.mat'];
if reload == 1
    n = -1;
    pref_optimized_preference_acq = load_pref('preference', 'MUC', 0, n);
    pref_optimal = load_pref([], 'optimal', 0, n);
    pref_optimized_preference_random = load_pref('preference', 'random', 0, n);
    pref_optimized_preference_acq_misspecification = load_pref('preference', 'MUC', 1, n);
    pref_optimal_misspecification = load_pref([], 'optimal', 1, n);
    pref_optimized_E_TS = load_pref('E', 'TS_binary', 0, n);
    pref_control = load_pref([], 'control', 0, n);
    
    save(filename, 'pref_optimized_preference_acq', 'pref_optimal', 'pref_optimized_preference_random', 'pref_optimized_preference_acq_misspecification', 'pref_optimal_misspecification', 'pref_optimized_E_TS','pref_control');
elseif reload == 0
    load(filename, 'pref_optimized_preference_acq', 'pref_optimal', 'pref_optimized_preference_random', 'pref_optimized_preference_acq_misspecification', 'pref_optimal_misspecification', 'pref_optimized_E_TS','pref_control');
elseif reload == 2
    n = 1;
    new_pref_optimized_preference_acq = load_pref('preference', 'MUC', 0, n);
    new_pref_optimal = load_pref([], 'optimal', 0, n);
    new_pref_optimized_preference_random = load_pref('preference', 'random', 0, n);
    new_pref_optimized_preference_acq_misspecification = load_pref('preference', 'MUC', 1, n);
    new_pref_optimal_misspecification = load_pref([], 'optimal', 1, n);
    new_pref_optimized_E_TS = load_pref('E', 'TS_binary', 0, n);
    new_pref_control = load_pref([], 'control', 0, n);
    load(filename, 'pref_optimized_preference_acq', 'pref_optimal', 'pref_optimized_preference_random', 'pref_optimized_preference_acq_misspecification', 'pref_optimal_misspecification', 'pref_optimized_E_TS','pref_control');
    pref_optimized_preference_acq = [pref_optimized_preference_acq, new_pref_optimized_preference_acq];
    pref_optimal = [pref_optimal,  new_pref_optimal];
    pref_optimized_preference_random = [pref_optimized_preference_random, new_pref_optimized_preference_random];
    pref_optimized_preference_acq_misspecification = [pref_optimized_preference_acq_misspecification, new_pref_optimized_preference_acq_misspecification];
    pref_optimal_misspecification = [pref_optimal_misspecification, new_pref_optimal_misspecification];
    pref_optimized_E_TS = [pref_optimized_E_TS, new_pref_optimized_E_TS];
    pref_control = [pref_control, new_pref_control ];
end
end

function  val = load_pref(task, exp, misspecification, N)
% task: 'E' or 'preference
% exp : acquisition function name, control or optimal
% misspecification : 0 or 1
% N : 
add_directories;
T = load(data_table_file).T;

indices = 1:size(T,1);
indices = indices(T.Acquisition=='MUC' & T.Misspecification == 0);

if N == -1
N = numel(indices);
else
indices = indices(end-N+1:end);
end
val = NaN(1,N);

if strcmp(exp, 'optimal') || strcmp(exp, 'control')
    acquisition = 'MUC';
    task = 'preference';
else
    acquisition = exp;
end

for i =1:numel(indices)
    index = indices(i);
    subject = char(T(index,:).Subject);
    model_seed = T(index,:).Model_Seed;
    
    %filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    j = T(T.Subject == subject & T.Task == task & T.Acquisition == acquisition & T.Misspecification == misspecification & T.Model_Seed == model_seed,:).Index;
    if ~isempty(j)
        filename = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', acquisition, '_experiment_', num2str(j)];
        load(filename, 'experiment');
        
        %   try
        if strcmp(exp, 'optimal')
            [~, v] = model.prediction(experiment.theta, experiment.xtrain_norm, experiment.ctrain, [(experiment.model_params(experiment.ib)-experiment.lb')./(experiment.ub'-experiment.lb'); experiment.x0.*ones(experiment.d,1)], experiment.kernelfun, 'modeltype', experiment.modeltype);
        elseif strcmp(exp, 'control')
            xparams = experiment.xtrain(1:experiment.d,1);
            xparams =[(xparams-experiment.lb')./(experiment.ub'-experiment.lb'); experiment.x0.*ones(experiment.d,1)];
            [~, v] = model.prediction(experiment.theta, experiment.xtrain_norm, experiment.ctrain, xparams, experiment.kernelfun, 'modeltype', experiment.modeltype);
        else
            if strcmp(task, 'preference')
                [~, v] = model.prediction(experiment.theta, experiment.xtrain_norm, experiment.ctrain, [experiment.x_best_norm; experiment.x0.*ones(experiment.d,size(experiment.x_best_norm,2))], experiment.kernelfun, 'modeltype', experiment.modeltype);
            else
                [~, v] = model.prediction(experiment.theta, experiment.xtrain_norm, experiment.ctrain, experiment.x_best_norm, experiment.kernelfun, 'modeltype', experiment.modeltype);
            end
        end
        val(i) = v(end);
        %    end
    end
end
end

