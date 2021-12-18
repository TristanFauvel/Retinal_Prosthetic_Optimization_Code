% function [experiment_path, code_directory, data_directory, data_table_file, stable_perceptual_models_directory, latest_perceptual_models_directory, stable_perceptual_model_table_file, latest_perceptual_model_table_file, Stimuli_folder, figures_folder] = add_directories(pathname)
% if ispc
%     global pathname
%     pathname = 'C:\Users\tfauvel\Documents\'; % C:\Users\tfauvel\Documents;
% else
%     global pathname
%     pathname = '/media/sf_Documents/';
% end
global pathname
if ispc
    experiment_path = [pathname, 'Retinal_Prosthetic_Optimization'];
    code_directory = [experiment_path,'\Retinal_Prosthetic_Optimization_Code'];
    data_directory = [experiment_path,'\Data'];
    raw_data_directory = [experiment_path,'\Raw_Data'];
    data_table_file = [data_directory, '\data_table.mat'];
    %data_table_file = [code_directory,'\Experiment_p2p_preference\data_table.mat'];
    stable_perceptual_models_directory = [experiment_path,'\Perceptual_Models_stable_p2p'];
    latest_perceptual_models_directory = [experiment_path,'\Perceptual_Models_latest_p2p'];
    stable_perceptual_model_table_file = [code_directory,'\stable_perceptual_model_table.mat'];
    latest_perceptual_model_table_file = [code_directory,'\latest_perceptual_model_table.mat'];
    Stimuli_folder =  [code_directory, '\Stimuli'];
    figures_folder = [experiment_path,'\Figures'];
    experiment_directory = [code_directory, '\Experiment'];
    paper_figures_folder = [pathname,'\PhD\Figures\Paper_figures\'];
else
    experiment_path = [pathname, '/Retinal_Prosthetic_Optimization'];
    code_directory = [experiment_path,'/Retinal_Prosthetic_Optimization_Code'];
    data_directory = [experiment_path,'/Data'];
    raw_data_directory = [experiment_path,'/Raw_Data'];
    %data_table_file = [code_directory,'/Experiment_p2p_preference/data_table.mat'];
    data_table_file = [data_directory, '/data_table.mat'];
    
    stable_perceptual_models_directory = [experiment_path,'/Perceptual_Models_stable_p2p'];
    latest_perceptual_models_directory = [experiment_path,'/Perceptual_Models_latest_p2p'];
    stable_perceptual_model_table_file = [code_directory,'/stable_perceptual_model_table.mat'];
    latest_perceptual_model_table_file = [code_directory,'/latest_perceptual_model_table.mat'];
    Stimuli_folder =  [code_directory, '/Stimuli'];
    figures_folder = [experiment_path,'/Figures'];
    paper_figures_folder = [pathname,'/PhD/Figures/Paper_figures/'];
    experiment_directory = [code_directory, '/Experiment'];
    
end



