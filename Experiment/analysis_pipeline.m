data_table_file ='/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Data/data_table.mat';
data_directory = '/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Data';
raw_data_directory = '/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Raw_Data';

T = load(data_table_file).T;


% raw_data_table_file = '/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Data/raw_data_table.mat';
% save(raw_data_table_file, 'T')
load('subjects_to_remove.mat', 'subjects_to_remove');
T = T(all(T.Subject ~= subjects_to_remove,2),:);

%Analyze data and save results in the processed data directory
n  = size(T,1);
n = 4*1;
T = T(end-n+1:end,:);
for i=1:n
    disp(i)
    raw_filename =  [raw_data_directory, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
     filename = [data_directory, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
     load(raw_filename, 'experiment')
     save(filename, 'experiment') % Create the processed data file.
     analyze_experiment(filename, 'for_all', 1)
end

to_compute_thresholds_QUEST(T, 'Snellen', data_table_file, data_directory)
to_compute_thresholds_QUEST(T, 'E', data_table_file, data_directory)


subjects_to_remove = {'SG2', 'FF2'};
filename = '/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Retinal_Prosthetic_Optimization_Code/subjects_to_remove';
save(filename, 'subjects_to_remove')

reload = 1; %  1: to reload all the data, 2: to add only the last experiment
load_VA_results(reload, data_directory, data_table_file)
load_preferences(reload, data_directory, data_table_file)

load_values(reload, data_directory, data_table_file)
load_values_evolution(reload, data_directory, data_table_file)
load_values_evolution_combined_data(reload, data_directory, data_table_file)

 RMSE = load_RMSE_results(reload, data_directory, data_table_file);

T = load(data_table_file).T;
subjects_to_remove = load('subjects_to_remove.mat');
subjects_to_remove  =subjects_to_remove.subjects_to_remove;
T = T(all(T.Subject ~= subjects_to_remove,2),:);

T = T(T.Subject == 'TF', : );

T(T.Subject == 'SG' & T.Index == 3 & T.Acquisition == 'MUC',:).Subject = 'SG2';

%%%%%%%%%%
T = load(data_table_file).T;
T = T(T.Subject == 'TF', : );

%save(data_table_file, 'T')

id = 1:size(T,1);
acquisition= 'MUC';
id = id(T.Acquisition==acquisition & T.Misspecification == 0);
% id = id(T(id,:).Subject == 'BF');
N = numel(id);
for i = 16:N
    close all
    index = id(i);
 
    subject_analysis(index,T);
end



reload = 0;
pref  = load_preferences(reload,data_directory, data_table_file);
VA  = load_VA_results(reload,data_directory, data_table_file);

data_directory = [experiment_directory,'/Data'];
figures_folder = [experiment_directory,'/Figures'];


T = load(data_table_file).T;
T= T(T.Acquisition == 'MUC' & T.Misspecification == 0, :);
subject_to_remove = load('subjects_to_remove.mat'); %remove data from participants who did not complete the experiment;
T = T(all(T.Subject ~= subject_to_remove.subjects_to_remove,2),:);

Acq_vs_random = pref.acq_vs_random_training';
VA_E_optimized_preference_acq = VA.VA_E_optimized_preference_acq';
VA_E_optimized_preference_random = VA.VA_E_optimized_preference_random';

Subjects = T.Subject;
table(Subjects, Acq_vs_random, VA_E_optimized_preference_acq, VA_E_optimized_preference_random)

 
