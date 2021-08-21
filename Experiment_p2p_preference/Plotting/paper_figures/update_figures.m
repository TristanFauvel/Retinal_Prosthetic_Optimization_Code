add_modules;

elements_of_figure4(4)% plot_figure_challenge(4)
elements_of_figure5(5) % plot_figure_challenge_VA(5) 
plot_figure_performance(6)
plot_figure_misspecification(7)
plot_figure_misspecified_opt(8)
plot_figure_E_Snellen(9)
plot_figure_Value_VA(10) 
plot_figure_VA_precision(11)
plot_figure_intersubject(12)

plot_figure_Value_preference(id)


% data_table_file_v1 = '/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Data/data_table_v1.mat';
% data_table_file_v2 = '/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Data/data_table_v2.mat';
% 
% T1 = load(data_table_file_v1).T;
% T1 = sortrows(T1, [6,2,3,4,5]);
% T2 = load(data_table_file_v2).T;
% T2 = sortrows(T2, [6,2,3,4,5]);
% 
% Tc = [T1;T2];
% writetable(Tc, 'combined_data.xls')

reload = 0;
pref  = load_preferences(reload,data_directory, data_table_file);
data_directory = [experiment_path,'/Data'];
figures_folder = [experiment_path,'/Figures'];


T = load(data_table_file).T;
T= T(T.Acquisition == 'maxvar_challenge' & T.Misspecification == 0, :);
subject_to_remove = {'KM','TF', 'test', 'CW'}; %remove data from participants who did not complete the experiment;
T = T(all(T.Subject ~= subject_to_remove,2),:);

Acq_vs_random = pref.acq_vs_random_training';
Subjects = T.Subject;
table(Subjects, Acq_vs_random)

