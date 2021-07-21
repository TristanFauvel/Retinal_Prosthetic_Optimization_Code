function [val_optimized_preference_acq_evolution, val_optimized_preference_random_evolution, val_optimized_preference_acq_misspecification_evolution, val_optimized_E_TS_evolution] = load_values_evolution(reload, data_directory, data_table_file)
filename = [data_directory, '/values_evolution.mat'];
if reload
    val_optimized_preference_acq_evolution= load_val('preference', 'maxvar_challenge', 0, data_table_file, data_directory);
    val_optimized_preference_random_evolution = load_val('preference', 'random', 0, data_table_file, data_directory);
    val_optimized_preference_acq_misspecification_evolution = load_val('preference', 'maxvar_challenge', 1, data_table_file, data_directory);
    val_optimized_E_TS_evolution = load_val('E', 'TS_binary', 0, data_table_file, data_directory);
    
    save(filename, 'val_optimized_preference_acq_evolution', 'val_optimized_preference_random_evolution', 'val_optimized_preference_acq_misspecification_evolution', 'val_optimized_E_TS_evolution');
else
    load(filename, 'val_optimized_preference_acq_evolution', 'val_optimized_preference_random_evolution', 'val_optimized_preference_acq_misspecification_evolution', 'val_optimized_E_TS_evolution');
end
end

function  val = load_val(task, exp, misspecification,data_table_file, data_directory)
T = load(data_table_file).T;

indices = 1:size(T,1);
indices = indices(T.Acquisition=='maxvar_challenge' & T.Misspecification == 0);
N = numel(indices);

maxiter = 60;
val = NaN(maxiter,N);

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
for i =1:N
    index = indices(i);
    subject = char(T(index,:).Subject);
    model_seed = T(index,:).Model_Seed;
    
    %filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    j = T(T.Subject == subject & T.Task == task & T.Acquisition == acquisition & T.Misspecification == misspecification & T.Model_Seed == model_seed,:).Index;
    if ~isempty(j)
        filename = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', acquisition, '_experiment_', num2str(j)];
        load(filename, 'experiment');
        
        %   try
            if strcmp(task, 'preference')
                [~, v] = prediction_bin_preference(experiment.theta, experiment.xtrain_norm, experiment.ctrain, [experiment.x_best_norm; experiment.x0.*ones(experiment.d,size(experiment.x_best_norm,2))], experiment.kernelfun, 'modeltype', experiment.modeltype);
            else
                [~, v] = prediction_bin(experiment.theta, experiment.xtrain_norm, experiment.ctrain, experiment.x_best_norm, experiment.kernelfun, 'modeltype', experiment.modeltype);
            end
        val(:,i) = v;
        %    end
    end
end
end

