function [Pref_vs_E_training, Pref_vs_E_test, acq_vs_random_training, acq_vs_random_test, acq_vs_opt_training, acq_vs_opt_test, optimized_misspecified_vs_optimized_training, optimized_misspecified_vs_optimized_test,optimized_miss_vs_opt_miss_test, optimized_miss_vs_opt_miss_training, acq_vs_control_test, acq_vs_control_training, optimized_vs_naive_training, optimized_vs_naive_test, optimized_miss_vs_control_training, optimized_miss_vs_control_test, optimized_miss_vs_naive_training, optimized_miss_vs_naive_test, control_vs_naive_training, E_vs_naive_training,E_vs_control_training,opt_miss_vs_control_training]  = load_preferences(reload, data_directory, data_table_file)
savetofilename =[data_directory, '/preferences.mat'];

if reload == 0
    load(savetofilename, 'Pref_vs_E_training', 'Pref_vs_E_test', 'acq_vs_random_training', 'acq_vs_random_test', 'acq_vs_opt_training', 'acq_vs_opt_test', 'optimized_misspecified_vs_optimized_training', 'optimized_misspecified_vs_optimized_test', 'optimized_miss_vs_opt_miss_test', 'optimized_miss_vs_opt_miss_training', 'acq_vs_control_test', 'acq_vs_control_training', 'optimized_vs_naive_training', 'optimized_vs_naive_test', 'optimized_miss_vs_control_training', 'optimized_miss_vs_control_test', 'optimized_miss_vs_naive_training', 'optimized_miss_vs_naive_test', 'control_vs_naive_training', 'E_vs_naive_training', 'E_vs_control_training', 'opt_miss_vs_control_training');
    
elseif reload == 1
    T = load(data_table_file).T;
    indices = 1:size(T,1);
    acquisition= 'maxvar_challenge';
    indices = indices(T.Acquisition==acquisition & T.Misspecification == 0);
    [Pref_vs_E_training, Pref_vs_E_test, acq_vs_random_training, acq_vs_random_test, acq_vs_opt_training, acq_vs_opt_test, optimized_misspecified_vs_optimized_training, optimized_misspecified_vs_optimized_test,optimized_miss_vs_opt_miss_test, optimized_miss_vs_opt_miss_training, acq_vs_control_test, acq_vs_control_training, optimized_vs_naive_training, optimized_vs_naive_test, optimized_miss_vs_control_training, optimized_miss_vs_control_test, optimized_miss_vs_naive_training, optimized_miss_vs_naive_test, control_vs_naive_training, E_vs_naive_training,E_vs_control_training,opt_miss_vs_control_training]  = load_pref(T, indices,data_directory);
    
    save(savetofilename, 'Pref_vs_E_training', 'Pref_vs_E_test', 'acq_vs_random_training', 'acq_vs_random_test', 'acq_vs_opt_training', 'acq_vs_opt_test', 'optimized_misspecified_vs_optimized_training', 'optimized_misspecified_vs_optimized_test', 'optimized_miss_vs_opt_miss_test', 'optimized_miss_vs_opt_miss_training', 'acq_vs_control_test', 'acq_vs_control_training', 'optimized_vs_naive_training', 'optimized_vs_naive_test', 'optimized_miss_vs_control_training', 'optimized_miss_vs_control_test', 'optimized_miss_vs_naive_training', 'optimized_miss_vs_naive_test', 'control_vs_naive_training', 'E_vs_naive_training', 'E_vs_control_training','opt_miss_vs_control_training');
elseif reload == 2 %only reload the last experiments
    
    T = load(data_table_file).T;
    indices = 1:size(T,1);
    acquisition= 'maxvar_challenge';
    indices = indices(T.Acquisition==acquisition & T.Misspecification == 0);
    indices = indices(end);
    
    [new_Pref_vs_E_training, new_Pref_vs_E_test, new_acq_vs_random_training, new_acq_vs_random_test, new_acq_vs_opt_training, new_acq_vs_opt_test, new_optimized_misspecified_vs_optimized_training, new_optimized_misspecified_vs_optimized_test, new_optimized_miss_vs_opt_miss_test, new_optimized_miss_vs_opt_miss_training, new_acq_vs_control_test, new_acq_vs_control_training, new_optimized_vs_naive_training, new_optimized_vs_naive_test,  new_optimized_miss_vs_control_training, new_optimized_miss_vs_control_test, new_optimized_miss_vs_naive_training, new_optimized_miss_vs_naive_test, new_control_vs_naive_training, new_E_vs_naive_training, new_E_vs_control_training, new_opt_miss_vs_control_training]  = load_pref(T, indices,data_directory);
    
    load(savetofilename, 'Pref_vs_E_training', 'Pref_vs_E_test', 'acq_vs_random_training', 'acq_vs_random_test', 'acq_vs_opt_training', 'acq_vs_opt_test', 'optimized_misspecified_vs_optimized_training', 'optimized_misspecified_vs_optimized_test', 'optimized_miss_vs_opt_miss_test', 'optimized_miss_vs_opt_miss_training', 'acq_vs_control_test', 'acq_vs_control_training', 'optimized_vs_naive_training', 'optimized_vs_naive_test', 'optimized_miss_vs_control_training', 'optimized_miss_vs_control_test', 'optimized_miss_vs_naive_training', 'optimized_miss_vs_naive_test', 'control_vs_naive_training', 'E_vs_naive_training', 'E_vs_control_training','opt_miss_vs_control_training');
    Pref_vs_E_training = [Pref_vs_E_training, new_Pref_vs_E_training];
    Pref_vs_E_test= [Pref_vs_E_test, new_Pref_vs_E_test];
    acq_vs_random_training = [acq_vs_random_training, new_acq_vs_random_training];
    acq_vs_random_test =[acq_vs_random_test, new_acq_vs_random_test];
    acq_vs_opt_training = [acq_vs_opt_training,new_acq_vs_opt_training];
    acq_vs_opt_test = [acq_vs_opt_test, new_acq_vs_opt_test];
    optimized_misspecified_vs_optimized_training = [optimized_misspecified_vs_optimized_training, new_optimized_misspecified_vs_optimized_training];
    optimized_misspecified_vs_optimized_test =[optimized_misspecified_vs_optimized_test, new_optimized_misspecified_vs_optimized_test];
    optimized_miss_vs_opt_miss_test = [optimized_miss_vs_opt_miss_test, new_optimized_miss_vs_opt_miss_test];
    optimized_miss_vs_opt_miss_training = [optimized_miss_vs_opt_miss_training, new_optimized_miss_vs_opt_miss_training];
    acq_vs_control_test = [acq_vs_control_test, new_acq_vs_control_test];
    acq_vs_control_training = [acq_vs_control_training,new_acq_vs_control_training];
    optimized_vs_naive_training = [optimized_vs_naive_training, new_optimized_vs_naive_training];
    optimized_vs_naive_test = [optimized_vs_naive_test, new_optimized_vs_naive_test];
    optimized_miss_vs_control_training = [optimized_miss_vs_control_training, new_optimized_miss_vs_control_training];
    optimized_miss_vs_control_test = [optimized_miss_vs_control_test, new_optimized_miss_vs_control_test];
    optimized_miss_vs_naive_training = [optimized_miss_vs_naive_training, new_optimized_miss_vs_naive_training];
    optimized_miss_vs_naive_test = [optimized_miss_vs_naive_test, new_optimized_miss_vs_naive_test];
    control_vs_naive_training = [new_control_vs_naive_training, control_vs_naive_training];
    E_vs_naive_training = [new_E_vs_naive_training, E_vs_naive_training];
    E_vs_control_training = [new_E_vs_control_training, E_vs_control_training];
    opt_miss_vs_control_training = [new_opt_miss_vs_control_training, opt_miss_vs_control_training];
    save(savetofilename, 'Pref_vs_E_training', 'Pref_vs_E_test', 'acq_vs_random_training', 'acq_vs_random_test', 'acq_vs_opt_training', 'acq_vs_opt_test', 'optimized_misspecified_vs_optimized_training', 'optimized_misspecified_vs_optimized_test', 'optimized_miss_vs_opt_miss_test', 'optimized_miss_vs_opt_miss_training', 'acq_vs_control_test', 'acq_vs_control_training', 'optimized_vs_naive_training', 'optimized_vs_naive_test', 'optimized_miss_vs_control_training', 'optimized_miss_vs_control_test', 'optimized_miss_vs_naive_training', 'optimized_miss_vs_naive_test', 'control_vs_naive_training','E_vs_naive_training', 'E_vs_control_training','opt_miss_vs_control_training');
    
end
end


function  [Pref_vs_E_training, Pref_vs_E_test, acq_vs_random_training, acq_vs_random_test, acq_vs_opt_training, acq_vs_opt_test, optimized_misspecified_vs_optimized_training, optimized_misspecified_vs_optimized_test,optimized_miss_vs_opt_miss_test, optimized_miss_vs_opt_miss_training, acq_vs_control_test, acq_vs_control_training, optimized_vs_naive_training, optimized_vs_naive_test,  optimized_miss_vs_control_training, optimized_miss_vs_control_test,optimized_miss_vs_naive_training, optimized_miss_vs_naive_test,control_vs_naive_training, E_vs_naive_training,E_vs_control_training,opt_miss_vs_control_training]  = load_pref(T, indices, data_directory)
N = numel(indices);
Pref_vs_E_training = NaN(1,N);
Pref_vs_E_test= NaN(1,N);
acq_vs_random_training = NaN(1,N);
acq_vs_random_test = NaN(1,N);
acq_vs_opt_training = NaN(1,N);
acq_vs_opt_test = NaN(1,N);
optimized_misspecified_vs_optimized_training = NaN(1,N);
optimized_misspecified_vs_optimized_test = NaN(1,N);
optimized_miss_vs_opt_miss_test = NaN(1,N);
optimized_miss_vs_opt_miss_training = NaN(1,N);
acq_vs_control_test = NaN(1,N);
acq_vs_control_training = NaN(1,N);
optimized_vs_naive_training = NaN(1,N);
optimized_vs_naive_test = NaN(1,N);
optimized_miss_vs_control_test = NaN(1,N);
optimized_miss_vs_control_training = NaN(1,N);
optimized_miss_vs_naive_training= NaN(1,N);
optimized_miss_vs_naive_test = NaN(1,N);
control_vs_naive_training = NaN(1,N);
E_vs_naive_training = NaN(1,N);
E_vs_control_training = NaN(1,N);
opt_miss_vs_control_training = NaN(1,N);

for i= indices
    filename = [data_directory, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(index,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
    load(filename, 'experiment');
    if isfield(experiment,'Pref_vs_E_training')
        Pref_vs_E_training(i) = experiment.Pref_vs_E_training.pref;
    end
    
    if isfield(experiment,'Pref_vs_E_test')
        Pref_vs_E_test(i) = experiment.Pref_vs_E_test.pref;
    end
    
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
    if isfield(experiment,'acq_vs_control_training')
        acq_vs_control_training(i) = experiment.acq_vs_control_training.pref;
    end
    
    if isfield(experiment,'acq_vs_control_test')
        acq_vs_control_test(i) = experiment.acq_vs_control_test.pref;
    end
    if  isfield(experiment, 'optimized_vs_naive_test')
        optimized_vs_naive_test(i) = experiment.optimized_vs_naive_test.pref;
    end
    if  isfield(experiment, 'optimized_vs_naive_training')
        optimized_vs_naive_training(i) = experiment.optimized_vs_naive_training.pref;
    end
    if  isfield(experiment, 'control_vs_naive_training')
        control_vs_naive_training(i) = experiment.control_vs_naive_training.pref;
    end
    if  isfield(experiment, 'E_vs_naive_training')
        E_vs_naive_training(i) = experiment.E_vs_naive_training.pref;
    end
    if  isfield(experiment, 'E_vs_control_training')
        E_vs_control_training(i) = experiment.E_vs_control_training.pref;
    end
    task = char(T(i,:).Task);
    subject = char(T(i,:).Subject);
    acquisition = char(T(i,:).Acquisition);
    model_seed = T(i,:).Model_Seed;
    j = T(T.Subject == subject & T.Task == task & T.Acquisition == acquisition & T.Misspecification == 1 & T.Model_Seed == model_seed,:).Index;
    for k = 1:numel(j)
        l=l+1;
        filename = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', acquisition, '_experiment_',num2str(j(k))];
        load(filename, 'experiment');
        if isfield(experiment,'optimized_misspecified_vs_optimized_test')
            pref =  experiment.optimized_miss_vs_optimized_test.pref;
            optimized_misspecified_vs_optimized_test(l) = pref;
        end
        if isfield(experiment,'optimized_misspecified_vs_optimized_training')
            pref = experiment.optimized_misspecified_vs_optimized_training.pref;
            optimized_misspecified_vs_optimized_training(l) = pref;
        end
        if isfield(experiment, 'optimized_miss_vs_opt_miss_test')
            optimized_miss_vs_opt_miss_test(l) = experiment.optimized_miss_vs_opt_miss_test.pref;
        end
        if isfield(experiment, 'optimized_miss_vs_opt_miss_training')
            optimized_miss_vs_opt_miss_training(l) = experiment.optimized_miss_vs_opt_miss_training.pref;
        end
        if  isfield(experiment, 'optimized_miss_vs_control_test')
            optimized_miss_vs_control_test(l) = experiment.optimized_miss_vs_control_test.pref;
        end
        if  isfield(experiment, 'optimized_miss_vs_control_training')
            optimized_miss_vs_control_training(l) = experiment.optimized_miss_vs_control_training.pref;
        end
        if  isfield(experiment, 'optimized_miss_vs_naive_test')
            optimized_miss_vs_naive_test(l) = experiment.optimized_miss_vs_naive_test.pref;
        end
        if  isfield(experiment, 'optimized_miss_vs_naive_training')
            optimized_miss_vs_naive_training(l) = experiment.optimized_miss_vs_naive_training.pref;
        end
        if isfield(experiment, 'opt_miss_vs_control_training')
            opt_miss_vs_control_training(l) = experiment.opt_miss_vs_control_training.pref;
        end
    end
end
end