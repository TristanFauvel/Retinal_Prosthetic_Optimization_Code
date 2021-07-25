function [val_optimized_preference_acq, val_optimal, val_optimized_preference_random, val_optimized_preference_acq_misspecification, val_optimal_misspecification, val_optimized_E_TS,val_control] = load_values(reload, data_directory, data_table_file)
filename = [data_directory, '/values.mat'];
if reload == 1
    N = -1;
    val_optimized_preference_acq = load_val('preference', 'maxvar_challenge', 0, N, data_table_file, data_directory);
    val_optimal = load_val([], 'optimal', 0, N, data_table_file, data_directory);
    val_optimized_preference_random = load_val('preference', 'random', 0, N, data_table_file, data_directory);
    val_optimized_preference_acq_misspecification = load_val('preference', 'maxvar_challenge', 1, N, data_table_file, data_directory);
    val_optimal_misspecification = load_val([], 'optimal', 1, N, data_table_file, data_directory);
    val_optimized_E_TS = load_val('E', 'TS_binary', 0, N, data_table_file, data_directory);
    val_control = load_val([], 'control', 0, N, data_table_file, data_directory);
    
    save(filename, 'val_optimized_preference_acq', 'val_optimal', 'val_optimized_preference_random', 'val_optimized_preference_acq_misspecification', 'val_optimal_misspecification', 'val_optimized_E_TS','val_control');
elseif reload == 0
    load(filename, 'val_optimized_preference_acq', 'val_optimal', 'val_optimized_preference_random', 'val_optimized_preference_acq_misspecification', 'val_optimal_misspecification', 'val_optimized_E_TS','val_control');
elseif reload == 2
    N = 1;
    new_val_optimized_preference_acq = load_val('preference', 'maxvar_challenge', 0, N, data_table_file, data_directory);
    new_val_optimal = load_val([], 'optimal', 0, N, data_table_file, data_directory);
    new_val_optimized_preference_random = load_val('preference', 'random', 0, N, data_table_file, data_directory);
    new_val_optimized_preference_acq_misspecification = load_val('preference', 'maxvar_challenge', 1, N, data_table_file, data_directory);
    new_val_optimal_misspecification = load_val([], 'optimal', 1, N, data_table_file, data_directory);
    new_val_optimized_E_TS = load_val('E', 'TS_binary', 0, N, data_table_file, data_directory);
    new_val_control = load_val([], 'control', 0, N, data_table_file, data_directory);
    load(filename, 'val_optimized_preference_acq', 'val_optimal', 'val_optimized_preference_random', 'val_optimized_preference_acq_misspecification', 'val_optimal_misspecification', 'val_optimized_E_TS','val_control');
    val_optimized_preference_acq = [val_optimized_preference_acq, new_val_optimized_preference_acq];
    val_optimal = [val_optimal,  new_val_optimal];
    val_optimized_preference_random = [val_optimized_preference_random, new_val_optimized_preference_random];
    val_optimized_preference_acq_misspecification = [val_optimized_preference_acq_misspecification, new_val_optimized_preference_acq_misspecification];
    val_optimal_misspecification = [val_optimal_misspecification, new_val_optimal_misspecification];
    val_optimized_E_TS = [val_optimized_E_TS, new_val_optimized_E_TS];
    val_control = [val_control, new_val_control ];
end
end

function  val = load_val(task, exp, misspecification, N, data_table_file, data_directory);
T = load(data_table_file).T;

indices = 1:size(T,1);
indices = indices(T.Acquisition=='maxvar_challenge' & T.Misspecification == 0);

if N == -1
N = numel(indices);
else
indices = indices(end-N+1:end);
end
val = NaN(1,N);

if strcmp(exp, 'optimal') || strcmp(exp, 'control')
    acquisition = 'maxvar_challenge';
    task = 'preference';
else
    acquisition = exp;
end
% indices = 1:size(T,1);
% indices = indices(T.Task == task & T.Acquisition==acquisition & T.Misspecification==misspecification);
% [a,b] = sort(T(indices,:).Model_Seed);
% indices = indices(b);
post = [];
regularization = 'nugget';

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
            [~, v] = prediction_bin(experiment.theta, experiment.xtrain_norm, experiment.ctrain, [(experiment.model_params(experiment.ib)-experiment.lb')./(experiment.ub'-experiment.lb'); experiment.x0.*ones(experiment.d,1)], experiment.kernelfun, experiment.modeltype, post, regularization);        elseif strcmp(exp, 'control')
            xparams = experiment.xtrain(1:experiment.d,1);
            xparams =[(xparams-experiment.lb')./(experiment.ub'-experiment.lb'); experiment.x0.*ones(experiment.d,1)];
            [~, v] = prediction_bin(experiment.theta, experiment.xtrain_norm, experiment.ctrain, xparams, experiment.kernelfun, experiment.modeltype, post, regularization);
        else
            if strcmp(task, 'preference')
                [~, v] = prediction_bin(experiment.theta, experiment.xtrain_norm, experiment.ctrain, [experiment.x_best_norm; experiment.x0.*ones(experiment.d,size(experiment.x_best_norm,2))], experiment.kernelfun, experiment.modeltype, post, regularization);
            else
                [~, v] = prediction_bin(experiment.theta, experiment.xtrain_norm, experiment.ctrain, experiment.x_best_norm, experiment.kernelfun, experiment.modeltype, post, regularization);
            end
        end
        val(i) = v(end);
        %    end
    end
end
end

