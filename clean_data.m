

data_folder = '/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Raw_Data/Raw_Data_v1_cleaned';
data_table_file = '/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Data/Data_v1/data_table_v1.mat';


f1 = '/Data_Experiment_p2p_E';
f2 = '/Data_Experiment_p2p_preference';


T= load(data_table_file, 'T');
T = T.T;

fields_to_rem = {'VA_E_QUEST_optimized','VA_E_QUEST_control','VA_Snellen_QUEST_optimized','VA_Snellen_QUEST_control','Snellen_VA_optimized','E_VA_optimized','E_VA_control','E_Snellen_control','Snellen_VA_control','optimized_misspecified_vs_optimized_test','optimized_misspecified_vs_optimized_training','VA_E_QUEST_optimal', 'VA_Snellen_QUEST_optimal','Snellen_VA_optimal', 'E_VA_optimal', 'optimized_misspecified_vs_optimized_training', 'Pref_vs_E_test', 'Pref_vs_E_training', 'E_vs_naive_training', 'E_vs_control_training', 'optimized_miss_vs_opt_miss_training', 'optimized_miss_vs_control_training','optimized_vs_naive_test', 'optimized_vs_naive_training'};
        
for j=1:2
    if j ==1
        f = f1;
    elseif j == 2
        f = f2;
    end
    list=dir([data_folder, f]);
    for i = 1:numel(list)
        if ~ (strcmp(list(i).name, '.') || strcmp(list(i).name, '..'))
            disp(i)
            filename = list(i).name;
            folder = list(i).folder;
            subfold = [folder, '/', filename];
            sublist=dir(subfold);
            
            
            for k = 1:numel(sublist)
                if ~sublist(k).isdir && ~strcmp(sublist(k).name,'index.mat')
                    filename = sublist(k).name;
                    folder = sublist(k).folder;
                    
                    load([folder, '/', filename], 'experiment')
%                     if numel(fields(experiment))>120
%                         disp('stop')
%                     end
                    
                    for j=1:numel(fields_to_rem)
                        try
                            experiment = rmfield(experiment,fields_to_rem{j});
                        end
                    end
                    save([folder, '/', filename], 'experiment')
                end
            end
            
        end
    end
end


