function RMSE = load_RMSE_results(reload, data_directory, data_table_file)
filename = [data_directory,'/RMSE.mat'];
if reload == 1 %full reload
    N = -1;
    [RMSE.rmse_stim_optimized_preference_acq, RMSE.rmse_opt_optimized_preference_acq]= load_RMSE('preference', 'maxvar_challenge', 0,N, data_table_file, data_directory);
    [RMSE.rmse_stim_optimal,RMSE.rmse_opt_optimal] = load_RMSE([], 'optimal', 0,N, data_table_file, data_directory);
    [RMSE.rmse_stim_optimized_preference_random,RMSE.rmse_opt_optimized_preference_random] = load_RMSE('preference', 'random', 0,N, data_table_file, data_directory);
    [RMSE.rmse_stim_optimized_preference_acq_misspecification, RMSE.rmse_opt_optimized_preference_acq_misspecification] = load_RMSE('preference', 'maxvar_challenge', 1, N, data_table_file, data_directory);
    [RMSE.rmse_stim_optimal_misspecification,RMSE.rmse_opt_optimal_misspecification] = load_RMSE([], 'optimal', 1, N, data_table_file, data_directory);
    [RMSE.rmse_stim_optimized_E_TS,RMSE.rmse_opt_optimized_E_TS] = load_RMSE('E', 'TS_binary', 0, N, data_table_file, data_directory);
    [RMSE.rmse_stim_control,RMSE.rmse_opt_control] = load_RMSE([], 'control', 0, N, data_table_file, data_directory);
    [RMSE.rmse_stim_naive,RMSE.rmse_opt_naive] = load_RMSE([], 'naive', 0, N, data_table_file, data_directory); 
    save(filename, 'RMSE')
elseif reload==0 %use saved data
    load(filename,'RMSE')
end
end

function [RMSE_stim, RMSE_opt]= load_RMSE(task, exp, misspecification, n, data_table_file, data_directory)
%% Careful : this function assumes that the table is ordered by subjects and seeds
T = load(data_table_file).T;

load('subjects_to_remove.mat', 'subjects_to_remove') %remove data from participants who did not complete the experiment;
T = T(all(T.Subject ~= subjects_to_remove,2),:);

% T = T(T.Subject == 'SG', :);

if n ~= -1
    T=T(end-n+1:end,:);
end
indices = 1:size(T,1);
indices = indices(T.Acquisition=='maxvar_challenge' & T.Misspecification == 0);
N = numel(indices);

RMSE_stim = NaN(1,N);
RMSE_opt = NaN(1,N);


if strcmp(exp, 'optimal') || strcmp(exp, 'control') || strcmp(exp, 'naive')
    acquisition = 'maxvar_challenge';
    task = 'preference';
else
    acquisition = exp;
end
% t = T(T.Task == task & T.Acquisition==acquisition & T.Misspecification==misspecification,:);
% T = T(T.Subject == 'FF', :);
k = 0;
pymod = [];
ignore_pickle=1; % Wether to use a precomputed axon map (0) or not (1)
optimal_magnitude = 0;

add_directories;
Stimuli_folder = [Stimuli_folder, '/letters'];


while k<N
    k=k+1;
    i = indices(k);
    subject = char(T(i,:).Subject);
    model_seed = T(i,:).Model_Seed;
    j = T(T.Subject == subject & T.Task == task & T.Acquisition == acquisition & T.Misspecification == misspecification & T.Model_Seed == model_seed,:).Index;
    rmse_stim = NaN;
    rmse_opt = NaN;
    
    if isempty(j)
        l=1;
    else
        for l= 1:numel(j)
            filename = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', acquisition, '_experiment_', num2str(j(l))];
            load(filename, 'experiment');
            S = load_stimuli_letters(experiment);

            [~, M] = encoder(experiment.true_model_params, experiment, ignore_pickle, optimal_magnitude, 'pymod', pymod);
            experiment.M = M;
            if strcmp(exp, 'optimal')
                  [rmse_stim, ~, rmse_opt] = loss_function(M, experiment.true_model_params, S, experiment, 'optimal_magnitude', 1);                 
            elseif strcmp(exp, 'control')
                x_control = experiment.model_params;
                x_control(experiment.ib) = experiment.xtrain(experiment.ib,1);

                 [rmse_stim, ~, rmse_opt] = loss_function(M, x_control, S, experiment, 'optimal_magnitude', optimal_magnitude);                                 
            elseif strcmp(exp, 'naive')
                W = naive_encoder(experiment);                
                p = vision_model(M,W,S);                
                rmse_stim = sqrt(immse(p/255, S/255));
                
                optimal_magnitude= 1;
                [Wopt, ~] = encoder(experiment.true_model_params, experiment,ignore_pickle, 1);
                popt= vision_model(M,Wopt,S);
                rmse_opt = sqrt(immse(p./255, popt./255));
            else
                [rmse_stim, ~, rmse_opt] = loss_function(M, experiment.x_best(:,end), S, experiment, 'optimal_magnitude', optimal_magnitude);                
            end
            RMSE_stim(k+l-1) = rmse_stim;
            RMSE_opt(k+l-1) = rmse_opt;
        end
    end
    k=k+l-1;
end
end


