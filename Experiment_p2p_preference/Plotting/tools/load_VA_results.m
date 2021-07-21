function [VA_E_optimized_preference_acq, VA_Snellen_optimized_preference_acq, VA_E_optimal,VA_Snellen_optimal, VA_E_optimized_preference_random,VA_Snellen_optimized_preference_random, VA_E_optimized_preference_acq_misspecification, VA_Snellen_optimized_preference_acq_misspecification, VA_E_optimal_misspecification,VA_Snellen_optimal_misspecification, VA_E_optimized_E_TS,VA_Snellen_optimized_E_TS, VA_E_control,VA_Snellen_control, VA_E_naive, VA_Snellen_naive] = load_VA_results(reload, data_directory, data_table_file)
filename = [data_directory,'/VA.mat'];
if reload == 1 %full reload
    N = -1;
    [VA_E_optimized_preference_acq, VA_Snellen_optimized_preference_acq]= load_VA('preference', 'maxvar_challenge', 0,N, data_table_file, data_directory);
    [VA_E_optimal,VA_Snellen_optimal] = load_VA([], 'optimal', 0,N, data_table_file, data_directory);

    [VA_E_optimized_preference_random,VA_Snellen_optimized_preference_random] = load_VA('preference', 'random', 0,N, data_table_file, data_directory);
    [VA_E_optimized_preference_acq_misspecification, VA_Snellen_optimized_preference_acq_misspecification] = load_VA('preference', 'maxvar_challenge', 1, N, data_table_file, data_directory);
    [VA_E_optimal_misspecification,VA_Snellen_optimal_misspecification] = load_VA([], 'optimal', 1, N, data_table_file, data_directory);
    [VA_E_optimized_E_TS,VA_Snellen_optimized_E_TS] = load_VA('E', 'TS_binary', 0, N, data_table_file, data_directory);
    [VA_E_control,VA_Snellen_control] = load_VA([], 'control', 0, N, data_table_file, data_directory);
    [VA_E_naive,VA_Snellen_naive] = load_VA([], 'naive', 0, N, data_table_file, data_directory);
    save(filename, 'VA_E_optimized_preference_acq', 'VA_Snellen_optimized_preference_acq', 'VA_E_optimal','VA_Snellen_optimal', 'VA_E_optimized_preference_random','VA_Snellen_optimized_preference_random', 'VA_E_optimized_preference_acq_misspecification', 'VA_Snellen_optimized_preference_acq_misspecification', 'VA_E_optimal_misspecification','VA_Snellen_optimal_misspecification', 'VA_E_optimized_E_TS','VA_Snellen_optimized_E_TS', 'VA_E_control','VA_Snellen_control', 'VA_E_naive', 'VA_Snellen_naive');
elseif reload==0 %use saved data
    load(filename,'VA_E_optimized_preference_acq', 'VA_Snellen_optimized_preference_acq', 'VA_E_optimal','VA_Snellen_optimal', 'VA_E_optimized_preference_random','VA_Snellen_optimized_preference_random', 'VA_E_optimized_preference_acq_misspecification', 'VA_Snellen_optimized_preference_acq_misspecification', 'VA_E_optimal_misspecification','VA_Snellen_optimal_misspecification', 'VA_E_optimized_E_TS','VA_Snellen_optimized_E_TS', 'VA_E_control','VA_Snellen_control', 'VA_E_naive', 'VA_Snellen_naive');
elseif reload == 2 %only reload the last experiments
    load(filename,'VA_E_optimized_preference_acq', 'VA_Snellen_optimized_preference_acq', 'VA_E_optimal','VA_Snellen_optimal', 'VA_E_optimized_preference_random','VA_Snellen_optimized_preference_random', 'VA_E_optimized_preference_acq_misspecification', 'VA_Snellen_optimized_preference_acq_misspecification', 'VA_E_optimal_misspecification','VA_Snellen_optimal_misspecification', 'VA_E_optimized_E_TS','VA_Snellen_optimized_E_TS', 'VA_E_control','VA_Snellen_control', 'VA_E_naive', 'VA_Snellen_naive');
    N = 4;
    [new_VA_E_optimized_preference_acq, new_VA_Snellen_optimized_preference_acq]= load_VA('preference', 'maxvar_challenge', 0, N, data_table_file, data_directory);
    [new_VA_E_optimal,new_VA_Snellen_optimal] = load_VA([], 'optimal', 0,N, data_table_file, data_directory);
    [new_VA_E_optimized_preference_random,new_VA_Snellen_optimized_preference_random] = load_VA('preference', 'random', 0,N, data_table_file, data_directory);
    [new_VA_E_optimized_preference_acq_misspecification, new_VA_Snellen_optimized_preference_acq_misspecification] = load_VA('preference', 'maxvar_challenge', 1,N, data_table_file, data_directory);
    [new_VA_E_optimal_misspecification,new_VA_Snellen_optimal_misspecification] = load_VA([], 'optimal', 1,N, data_table_file, data_directory);
    [new_VA_E_optimized_E_TS,new_VA_Snellen_optimized_E_TS] = load_VA('E', 'TS_binary', 0,N, data_table_file, data_directory);
    [new_VA_E_control,new_VA_Snellen_control] = load_VA([], 'control', 0,N, data_table_file, data_directory);
    [new_VA_E_naive,new_VA_Snellen_naive] = load_VA([], 'naive', 0,N, data_table_file, data_directory);
    
    VA_E_optimized_preference_acq= [VA_E_optimized_preference_acq, new_VA_E_optimized_preference_acq];
    VA_Snellen_optimized_preference_acq = [VA_Snellen_optimized_preference_acq, new_VA_Snellen_optimized_preference_acq];
    VA_E_optimal = [VA_E_optimal, new_VA_E_optimal];
    VA_Snellen_optimal= [VA_Snellen_optimal, new_VA_Snellen_optimal];
    VA_E_optimized_preference_random= [VA_E_optimized_preference_random, new_VA_E_optimized_preference_random];
    VA_Snellen_optimized_preference_random= [VA_Snellen_optimized_preference_random, new_VA_Snellen_optimized_preference_random];
    VA_E_optimized_preference_acq_misspecification= [VA_E_optimized_preference_acq_misspecification, new_VA_E_optimized_preference_acq_misspecification];
    VA_Snellen_optimized_preference_acq_misspecification= [VA_Snellen_optimized_preference_acq_misspecification, new_VA_Snellen_optimized_preference_acq_misspecification];
    VA_E_optimal_misspecification= [VA_E_optimal_misspecification, new_VA_E_optimal_misspecification];
    VA_Snellen_optimal_misspecification= [VA_Snellen_optimal_misspecification, new_VA_Snellen_optimal_misspecification];
    VA_E_optimized_E_TS= [VA_E_optimized_E_TS, new_VA_E_optimized_E_TS];
    VA_Snellen_optimized_E_TS= [VA_Snellen_optimized_E_TS, new_VA_Snellen_optimized_E_TS];
    VA_E_control= [VA_E_control, new_VA_E_control];
    VA_Snellen_control= [VA_Snellen_control, new_VA_Snellen_control];
    VA_E_naive= [VA_E_naive, new_VA_E_naive];
    VA_Snellen_naive= [VA_Snellen_naive, new_VA_Snellen_naive];
    save(filename, 'VA_E_optimized_preference_acq', 'VA_Snellen_optimized_preference_acq', 'VA_E_optimal','VA_Snellen_optimal', 'VA_E_optimized_preference_random','VA_Snellen_optimized_preference_random', 'VA_E_optimized_preference_acq_misspecification', 'VA_Snellen_optimized_preference_acq_misspecification', 'VA_E_optimal_misspecification','VA_Snellen_optimal_misspecification', 'VA_E_optimized_E_TS','VA_Snellen_optimized_E_TS', 'VA_E_control','VA_Snellen_control', 'VA_E_naive', 'VA_Snellen_naive');    
end
end

function [VA_E, VA_Snellen]= load_VA(task, exp, misspecification, n, data_table_file, data_directory)

T = load(data_table_file).T;
if n ~= -1
    T=T(end-n+1:end,:);
end
indices = 1:size(T,1);
indices = indices(T.Acquisition=='maxvar_challenge' & T.Misspecification == 0);
N = numel(indices);

VA_E = NaN(1,N);
VA_Snellen = NaN(1,N);


if strcmp(exp, 'optimal') || strcmp(exp, 'control') || strcmp(exp, 'naive')
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
    %     filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    j = T(T.Subject == subject & T.Task == task & T.Acquisition == acquisition & T.Misspecification == misspecification & T.Model_Seed == model_seed,:).Index;
    va_snellen = NaN;
    va_e = NaN;
    if ~isempty(j)
        filename = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', acquisition, '_experiment_', num2str(j)];
        load(filename, 'experiment');
        
        
        if strcmp(exp, 'optimal')
            if isfield(experiment, 'E_VA_optimal')
                va_e = experiment.E_VA_optimal;
            end
            if isfield(experiment, 'Snellen_VA_optimal')
                va_snellen = experiment.Snellen_VA_optimal;
            end
        elseif strcmp(exp, 'control')
            if isfield(experiment, 'E_VA_control')
                va_e = experiment.E_VA_control;
            end
            if isfield(experiment, 'Snellen_VA_control')
                va_snellen = experiment.Snellen_VA_control;
            end
        elseif strcmp(exp, 'naive')
            if isfield(experiment, 'E_VA_naive')
                va_e = experiment.E_VA_naive;
            end
            if isfield(experiment, 'Snellen_VA_naive')
                va_snellen = experiment.Snellen_VA_naive;
            end
        else
            if isfield(experiment, 'E_VA_optimized')
                va_e = experiment.E_VA_optimized;
            end
            if isfield(experiment, 'Snellen_VA_optimized')
                va_snellen = experiment.Snellen_VA_optimized;
            end
        end
        VA_E(i) = va_e;
        VA_Snellen(i) = va_snellen;
    end
end
end



