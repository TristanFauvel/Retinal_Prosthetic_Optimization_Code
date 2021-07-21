data_table_file ='/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Data/Data/data_table.mat';
data_directory = '/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Data';
raw_data_directory = '/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Raw_Data';


%%%%
T1 =  load('data_table_v1.mat', 'T')
T1 = T1.T,
T2 = load('data_table_v2.mat', 'T')
 T2=T2.T;

%%%
T = load(data_table_file).T;

%Analyze data and save results in the processed data directory
n  = size(T,1);
% n = 4*1;
% T = T(end-n+1:end,:);
for i=1:n
    raw_filename =  [raw_data_directory, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
    load(raw_filename, 'experiment') %Load the raw data file
    filename = [data_directory, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
    save(filename, 'experiment') % Create the processed data file.
    analyze_experiment(filename, 'for_all', 1)
end

to_compute_thresholds_QUEST(T, 'E', data_table_file, data_directory)
to_compute_thresholds_QUEST(T, 'Snellen', data_table_file, data_directory)

reload = 1; %  1: to reload all the data, 2: to add only the last experiment
load_VA_results(reload, data_directory, data_table_file)
load_preferences(reload, data_directory, data_table_file)
load_values(reload, data_directory, data_table_file)
load_values_evolution(reload, data_directory, data_table_file)
load_values_evolution_combined_data(reload)

% id = 1:size(T,1);
% id = id(T.Acquisition=='maxvar_challenge' & T.Misspecification == 0);
% for i = 1:numel(id)
%     subject_analysis(id(i), T)
% end

