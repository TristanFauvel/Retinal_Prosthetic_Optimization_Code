function [acq_vs_random_training, acq_vs_random_test, acq_vs_opt_training, acq_vs_opt_test]  = load_preferences_expv1(reload)

add_directories;

data_table_file ='/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Data/data_table_v1.mat';
data_directory = '/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Data/Data_v1';

savetofilename =[data_directory, '/preferences_v1.mat'];

if reload == 0
    load(savetofilename , 'acq_vs_random_training', 'acq_vs_random_test', 'acq_vs_opt_training', 'acq_vs_opt_test');
    
elseif reload == 1
    T = load(data_table_file).T;
    indices = 1:size(T,1);
    acquisition= 'maxvar_challenge';
    indices = indices(T.Acquisition==acquisition & T.Misspecification == 0);
    [acq_vs_random_training, acq_vs_random_test, acq_vs_opt_training, acq_vs_opt_test]  = load_pref(T, indices);
    save(savetofilename , 'acq_vs_random_training', 'acq_vs_random_test', 'acq_vs_opt_training', 'acq_vs_opt_test');
elseif reload == 2 %only reload the last experiments
    
    T = load(data_table_file).T;
    indices = 1:size(T,1);
    acquisition= 'maxvar_challenge';
    indices = indices(T.Acquisition==acquisition & T.Misspecification == 0);
    indices = indices(end);
    
    [  new_acq_vs_random_training, new_acq_vs_random_test, new_acq_vs_opt_training, new_acq_vs_opt_test]  = load_pref(T, indices);
    
    load(savetofilename , 'acq_vs_random_training', 'acq_vs_random_test', 'acq_vs_opt_training', 'acq_vs_opt_test');
    acq_vs_random_training = [acq_vs_random_training, new_acq_vs_random_training];
    acq_vs_random_test =[acq_vs_random_test, new_acq_vs_random_test];
    acq_vs_opt_training = [acq_vs_opt_training,new_acq_vs_opt_training];
    acq_vs_opt_test = [acq_vs_opt_test, new_acq_vs_opt_test];
    save(savetofilename , 'acq_vs_random_training', 'acq_vs_random_test', 'acq_vs_opt_training', 'acq_vs_opt_test');
    
end
end


function  [ acq_vs_random_training, acq_vs_random_test, acq_vs_opt_training, acq_vs_opt_test]  = load_pref(T, indices)
data_directory = '/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Data/Data_v1';

N = numel(indices);
acq_vs_random_training = NaN(1,N);
acq_vs_random_test = NaN(1,N);
acq_vs_opt_training = NaN(1,N);
acq_vs_opt_test = NaN(1,N);

for i =1:N
    index = indices(i);
    filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    load(filename, 'experiment');
    
    if isfield(experiment,'acq_vs_random_training')
        acq_vs_random_training(i) = experiment.acq_vs_random_training.pref;
    end
    
    if isfield(experiment,'acq_vs_random_test')
        acq_vs_random_test(i) = experiment.acq_vs_random_test.pref;
    end
    
    if isfield(experiment,'acq_vs_opt_training')
        acq_vs_opt_training(i) = experiment.acq_vs_opt_training.pref;
    end
    
    if isfield(experiment,'acq_vs_opt_test')
        acq_vs_opt_test(i) = experiment.acq_vs_opt_test.pref;
    end
end
end
