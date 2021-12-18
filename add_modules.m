% global experiment_path code_directory data_directory perceptual_models_directory

if ispc
    global pathname
    pathname = 'C:\Users\tfauvel\Documents\'; % C:\Users\tfauvel\Documents;
    add_directories
    %     [experiment_path, code_directory, data_directory, data_table_file, stable_perceptual_models_directory, latest_perceptual_models_directory, stable_perceptual_model_table_file, latest_perceptual_model_table_file, Stimuli_folder, figures_folder] = add_directories(pathname);
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
    pathname = '/home/tfauvel/Documents'; %%'/media/sf_Documents/';
    add_directories

    %     [experiment_path, code_directory, data_directory, data_table_file, stable_perceptual_models_directory, latest_perceptual_models_directory, stable_perceptual_model_table_file, latest_perceptual_model_table_file, Stimuli_folder, figures_folder] = add_directories(pathname);
    if ~exist(stable_perceptual_models_directory,'dir')
        mkdir(stable_perceptual_models_directory)
    end
    if ~exist(latest_perceptual_models_directory,'dir')
        mkdir(latest_perceptual_models_directory)
    end
    
    addpath(genpath(experiment_path))
    
    addpath(genpath(code_directory))
    addpath(genpath('/home/tfauvel/Documents/GP_toolbox'))
    addpath(genpath('/home/tfauvel/Documents/BO_toolbox'))
     addpath(genpath('/home/tfauvel/Documents/Code_Efficient_exploration_in_BO'))
end
