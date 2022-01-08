% global experiment_path code_directory data_directory perceptual_models_directory
currentFile = mfilename( 'fullpath' );
global pathname
[pathname,~,~] = fileparts( currentFile );
addpath(genpath(pathname))
addpath(genpath([fileparts(pathname), '/GP_toolbox']))
addpath(genpath([fileparts(pathname), '/BO_toolbox']))
addpath(genpath([fileparts(pathname), '/Code_Efficient_exploration_in_BO']))

add_directories

if ~exist(stable_perceptual_models_directory,'dir')
    mkdir(stable_perceptual_models_directory)
end
if ~exist(latest_perceptual_models_directory,'dir')
    mkdir(latest_perceptual_models_directory)
end

addpath(genpath(experiment_path))
addpath(genpath(code_directory))
 