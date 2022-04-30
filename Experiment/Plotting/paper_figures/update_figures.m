add_modules;


reload = 0; %whether you want to reload the subjects (1) data or use preprocessed ones (0); 
pref  = load_preferences(reload,data_directory, data_table_file);
VA  = load_VA_results(reload,data_directory, data_table_file);

plot_naive_vs_control()
plot_optimization_preference()
plot_optimization_VA()
plot_figure_performance()
plot_figure_misspecification_effect()
plot_figure_misspecified_opt()
plot_naive_vs_control_RMSE()
plot_figure_E_Snellen()

%%

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
Acq_vs_opt = pref.acq_vs_opt_training';

Pref_vs_E_training = pref.Pref_vs_E_training'; 
E_vs_control_training = pref.E_vs_control_training'; 

Subjects = T.Subject;
table(Subjects, Pref_vs_E_training, E_vs_control_training )

table(Subjects, Acq_vs_random, VA.VA_E_optimized_preference_acq')


 