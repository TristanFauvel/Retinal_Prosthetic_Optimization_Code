function [slope_E_optimized_preference_acq, slope_Snellen_optimized_preference_acq, slope_E_optimal,slope_Snellen_optimal, slope_E_optimized_preference_random,slope_Snellen_optimized_preference_random, slope_E_optimized_preference_acq_misspecification, slope_Snellen_optimized_preference_acq_misspecification, slope_E_optimal_misspecification,slope_Snellen_optimal_misspecification, slope_E_optimized_E_TS,slope_Snellen_optimized_E_TS, slope_E_control,slope_Snellen_control] = load_slopes(reload)
add_directories;
filename = [data_directory,'/slope.mat'];
if reload
    [slope_E_optimized_preference_acq, slope_Snellen_optimized_preference_acq]= load_slope('preference', 'maxvar_challenge', 0);
    [slope_E_optimal,slope_Snellen_optimal] = load_slope([], 'optimal', 0);
    [slope_E_optimized_preference_random,slope_Snellen_optimized_preference_random] = load_slope('preference', 'random', 0);
    [slope_E_optimized_preference_acq_misspecification, slope_Snellen_optimized_preference_acq_misspecification] = load_slope('preference', 'maxvar_challenge', 1);
    [slope_E_optimal_misspecification,slope_Snellen_optimal_misspecification] = load_slope([], 'optimal', 1);
    [slope_E_optimized_E_TS,slope_Snellen_optimized_E_TS] = load_slope('E', 'TS_binary', 0);
    [slope_E_control,slope_Snellen_control] = load_slope([], 'control', 0);
    save(filename, 'slope_E_optimized_preference_acq', 'slope_Snellen_optimized_preference_acq', 'slope_E_optimal','slope_Snellen_optimal', 'slope_E_optimized_preference_random','slope_Snellen_optimized_preference_random', 'slope_E_optimized_preference_acq_misspecification', 'slope_Snellen_optimized_preference_acq_misspecification', 'slope_E_optimal_misspecification','slope_Snellen_optimal_misspecification', 'slope_E_optimized_E_TS','slope_Snellen_optimized_E_TS', 'slope_E_control','slope_Snellen_control');
else
    load(filename,'slope_E_optimized_preference_acq', 'slope_Snellen_optimized_preference_acq', 'slope_E_optimal','slope_Snellen_optimal', 'slope_E_optimized_preference_random','slope_Snellen_optimized_preference_random', 'slope_E_optimized_preference_acq_misspecification', 'slope_Snellen_optimized_preference_acq_misspecification', 'slope_E_optimal_misspecification','slope_Snellen_optimal_misspecification', 'slope_E_optimized_E_TS','slope_Snellen_optimized_E_TS', 'slope_E_control','slope_Snellen_control');
    
end
end

function [slope_E, slope_Snellen]= load_slope(task, exp, misspecification)
add_directories;
T = load(data_table_file).T;

indices = 1:size(T,1);
indices = indices(T.Acquisition=='maxvar_challenge' & T.Misspecification == 0);
N = numel(indices);

slope_E = NaN(1,N);
slope_Snellen = NaN(1,N);


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
    %     filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    j = T(T.Subject == subject & T.Task == task & T.Acquisition == acquisition & T.Misspecification == misspecification & T.Model_Seed == model_seed,:).Index;
    slope_snellen = NaN;
    slope_e = NaN;
    if ~isempty(j)
        filename = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', acquisition, '_experiment_', num2str(j)];
        load(filename, 'experiment');      
        
        
        if strcmp(exp, 'optimal')
            if isfield(experiment, 'E_VA_slope_optimal')
                slope_e = experiment.E_VA_slope_optimal;
            end
            if isfield(experiment, 'Snellen_slope_optimal')
                slope_snellen = experiment.Snellen_slope_optimal;
            end
        elseif strcmp(exp, 'control')
            if isfield(experiment, 'E_VA_slope_control')
                slope_e = experiment.E_VA_slope_control;
            end
            if isfield(experiment, 'Snellen_slope_control')
                slope_snellen = experiment.Snellen_slope_control;
            end
        else
            if isfield(experiment, 'E_VA_slope_optimized')
                slope_e = experiment.E_VA_slope_optimized;
            end
            if isfield(experiment, 'Snellen_slope_optimized')
                slope_snellen = experiment.Snellen_slope_optimized;
            end
        end
        slope_E(i) = slope_e;
        slope_Snellen(i) = slope_snellen;
    end
end
end



