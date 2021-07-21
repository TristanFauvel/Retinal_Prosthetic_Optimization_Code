

data_folder = '/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Raw_Data/Raw_Data_v2_copy';
data_table_file = '/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Data/Data_v2/data_table_v2.mat';

data_folder = '/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Raw_Data/Raw_Data_v1';
data_table_file = '/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Data/Data_v1/data_table_v1.mat';

data_folder = '/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Raw_Data';
data_table_file = '/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Raw_Data';

f1 = '/Data_Experiment_p2p_E';
f2 = '/Data_Experiment_p2p_preference';


T= load(data_table_file, 'T');
T = T.T;
T(:,:) = [];
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
            
            if strcmp(f,f1)
                for k = 1:numel(sublist)
                    if ~sublist(k).isdir && ~strcmp(sublist(k).name,'index.mat')
                        filename = sublist(k).name;
                        folder = sublist(k).folder;
                        
                        load([folder, '/', filename], 'experiment')
                        
                        Acquisition = categorical(cellstr(experiment.acquisition_fun_name));
                        Subject = categorical(cellstr(experiment.subject));
                        Task =categorical(cellstr(experiment.task));
                        Model_Seed = experiment.model_seed;
                        Seed =experiment.seed;
                        Index= experiment.index;
                        Misspecification = experiment.misspecification;
                        Implant =categorical(cellstr(experiment.implant_name));
                        NAxon_Segments = experiment.n_ax_segments;
                        NAxons= experiment.n_axons;
                        
                        t = table(Index, Model_Seed, Seed, Task, Acquisition, Subject,Misspecification, Implant, NAxons, NAxon_Segments);
                        T = [T;t];
                    end
                end
            elseif strcmp(f,f2)
                for k = 1:numel(sublist)
                    if ~sublist(k).isdir && ~strcmp(sublist(k).name,'index.mat')
                        filename = sublist(k).name;
                        folder = sublist(k).folder;
                        
                        load([folder, '/', filename], 'experiment')
                        
                        Acquisition = categorical(cellstr(experiment.acquisition_fun_name));
                        Subject = categorical(cellstr(experiment.subject));
                        Task =categorical(cellstr(experiment.task));
                        Model_Seed = experiment.model_seed;
                        Seed =experiment.seed;
                        Index= experiment.index;
                        Misspecification = experiment.misspecification;
                        Implant =categorical(cellstr(experiment.implant_name));
                        NAxon_Segments = experiment.n_ax_segments;
                        NAxons= experiment.n_axons;
                        t = table(Index, Model_Seed, Seed, Task, Acquisition, Subject,Misspecification, Implant, NAxons, NAxon_Segments);
                        T = [T;t];
                    end                    
                end
            end
            if ~strcmp(num2str(experiment.index),filename(end-4))
                disp('problem')
            end
        end
    end
    
end
[a,b] = sortrows(T(:,[6,2]));
T = T(b,:);

save(data_table_file, 'T')

