% global experiment_path code_directory data_directory perceptual_models_directory
% global experiment_path code_directory data_directory perceptual_models_directory
if ispc
    global pathname
    pathname = 'C:\Users\tfauvel\Documents\'; % C:\Users\tfauvel\Documents;
%     [experiment_path, code_directory, data_directory, data_table_file, stable_perceptual_models_directory, latest_perceptual_models_directory, stable_perceptual_model_table_file, latest_perceptual_model_table_file, Stimuli_folder, figures_folder] = add_directories(pathname);
    add_directories;
    if ~exist(stable_perceptual_models_directory,'dir')
        mkdir(stable_perceptual_models_directory)
    end
    if ~exist(latest_perceptual_models_directory,'dir')
        mkdir(latest_perceptual_models_directory)
    end
    
    addpath(genpath(experiment_path))
    
    addpath(genpath(code_directory))
else
    
    global pathname
    pathname = '/media/sf_Documents/';
%     [experiment_path, code_directory, data_directory, data_table_file, stable_perceptual_models_directory, latest_perceptual_models_directory, stable_perceptual_model_table_file, latest_perceptual_model_table_file, Stimuli_folder, figures_folder] = add_directories(pathname);
    add_directories;
    if ~exist(stable_perceptual_models_directory,'dir')
        mkdir(stable_perceptual_models_directory)
    end
    if ~exist(latest_perceptual_models_directory,'dir')
        mkdir(latest_perceptual_models_directory)
    end
    
    addpath(genpath(experiment_path))
    
    addpath(genpath(code_directory))
end