global pathname

f = filesep;
code_directory = pathname;
experiment_directory = code_directory;

data_directory = [experiment_directory, f, 'Data'];
raw_data_directory = [experiment_directory,  f, 'Raw_Data'];
data_table_file = [data_directory,  f, 'data_table.mat'];
stable_perceptual_models_directory = [experiment_directory,  f,'Perceptual_Models_stable_p2p'];
latest_perceptual_models_directory = [experiment_directory, f,'Perceptual_Models_latest_p2p'];
stable_perceptual_model_table_file = [code_directory, f, 'stable_perceptual_model_table.mat'];
latest_perceptual_model_table_file = [code_directory, f, 'latest_perceptual_model_table.mat'];
Stimuli_folder =  [code_directory, f, 'Stimuli'];
Letters_folder = [Stimuli_folder, '/letters'];
figures_folder = [experiment_directory, f, 'Figures'];
experiment_directory = [code_directory, f, 'Experiment'];
paper_figures_folder = figures_folder;


if ~exist(figures_folder ,'dir')
    mkdir(figures_folder)
end

