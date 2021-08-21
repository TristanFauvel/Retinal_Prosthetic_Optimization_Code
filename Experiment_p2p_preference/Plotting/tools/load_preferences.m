function p  = load_preferences(reload, data_directory, data_table_file)
savetofilename =[data_directory, '/preferences.mat'];

subject_to_remove = {'KM','TF', 'test', 'CW'}; %remove data from participants who did not complete the experiment;

T = load(data_table_file).T;
T = T(all(T.Subject ~= subject_to_remove,2),:);
indices = 1:size(T,1);

acquisition= 'maxvar_challenge';
indices = indices(T.Acquisition==acquisition & T.Misspecification == 0);

if reload == 0
    %     load(savetofilename, 'p.Pref_vs_E_training', 'p.Pref_vs_E_test', 'p.acq_vs_random_training', 'p.acq_vs_random_test', 'p.acq_vs_opt_training', 'p.acq_vs_opt_test', 'p.optimized_misspecified_vs_optimized_training', 'p.optimized_misspecified_vs_optimized_test', 'p.optimized_miss_vs_opt_miss_test', 'p.optimized_miss_vs_opt_miss_training', 'p.acq_vs_control_test', 'p.acq_vs_control_training', 'optimized_vs_naive_training', 'optimized_vs_naive_test', 'p.optimized_miss_vs_control_training', 'p.optimized_miss_vs_control_test', 'p.optimized_miss_vs_naive_training', 'p.optimized_miss_vs_naive_test', 'control_vs_naive_training', 'E_vs_naive_training', 'E_vs_control_training', 'opt_miss_vs_control_training');
    load(savetofilename, 'p');
    
elseif reload == 1
    p  = load_pref(T, indices,data_directory);
    
    save(savetofilename, 'p')
elseif reload == 2 %only reload the last experiments
    
    indices = indices(end);
    new_p = load_pref(T, indices,data_directory);
    
    load(savetofilename, 'p')
    p.Pref_vs_E_training = [p.Pref_vs_E_training, new_p.Pref_vs_E_training];
    p.Pref_vs_E_test= [p.Pref_vs_E_test, new_p.Pref_vs_E_test];
    p.acq_vs_random_training = [p.acq_vs_random_training, new_p.acq_vs_random_training];
    p.acq_vs_random_test =[p.acq_vs_random_test, new_p.acq_vs_random_test];
    p.acq_vs_opt_training = [p.acq_vs_opt_training,new_p.acq_vs_opt_training];
    p.acq_vs_opt_test = [p.acq_vs_opt_test, new_p.acq_vs_opt_test];
    p.optimized_misspecified_vs_optimized_training = [p.optimized_misspecified_vs_optimized_training, new_p.optimized_misspecified_vs_optimized_training];
    p.optimized_misspecified_vs_optimized_test =[p.optimized_misspecified_vs_optimized_test, new_p.optimized_misspecified_vs_optimized_test];
    p.optimized_miss_vs_opt_miss_test = [p.optimized_miss_vs_opt_miss_test, new_p.optimized_miss_vs_opt_miss_test];
    p.optimized_miss_vs_opt_miss_training = [p.optimized_miss_vs_opt_miss_training, new_p.optimized_miss_vs_opt_miss_training];
    p.acq_vs_control_test = [p.acq_vs_control_test, new_p.acq_vs_control_test];
    p.acq_vs_control_training = [p.acq_vs_control_training,new_p.acq_vs_control_training];
    p.optimized_vs_naive_training = [p.optimized_vs_naive_training, new_optimized_vs_naive_training];
    p.optimized_vs_naive_test = [p.optimized_vs_naive_test, new_optimized_vs_naive_test];
    p.optimized_miss_vs_control_training = [p.optimized_miss_vs_control_training, new_p.optimized_miss_vs_control_training];
    p.optimized_miss_vs_control_test = [p.optimized_miss_vs_control_test, new_p.optimized_miss_vs_control_test];
    p.optimized_miss_vs_naive_training = [p.optimized_miss_vs_naive_training, new_p.optimized_miss_vs_naive_training];
    p.optimized_miss_vs_naive_test = [p.optimized_miss_vs_naive_test, new_p.optimized_miss_vs_naive_test];
    p.control_vs_naive_training = [p.control_vs_naive_training, new_p.control_vs_naive_training];
    p.E_vs_naive_training = [p.E_vs_naive_training, new_p.E_vs_naive_training];
    p.E_vs_control_training = [p.E_vs_control_training, new_p.E_vs_control_training];
    p.opt_miss_vs_control_training = [p.opt_miss_vs_control_training, new_p.opt_miss_vs_control_training];
    save(savetofilename,'p')
end


function  p  = load_pref(T, indices, data_directory)
N = numel(indices);
p.Pref_vs_E_training = NaN(1,N);
p.Pref_vs_E_test= NaN(1,N);
p.acq_vs_random_training = NaN(1,N);
p.acq_vs_random_test = NaN(1,N);
p.acq_vs_opt_training = NaN(1,N);
p.acq_vs_opt_test = NaN(1,N);
p.optimized_misspecified_vs_optimized_training = NaN(1,N);
p.optimized_misspecified_vs_optimized_test = NaN(1,N);
p.optimized_miss_vs_opt_miss_test = NaN(1,N);
p.optimized_miss_vs_opt_miss_training = NaN(1,N);
p.acq_vs_control_test = NaN(1,N);
p.acq_vs_control_training = NaN(1,N);
p.optimized_vs_naive_training = NaN(1,N);
p.optimized_vs_naive_test = NaN(1,N);
p.optimized_miss_vs_control_test = NaN(1,N);
p.optimized_miss_vs_control_training = NaN(1,N);
p.optimized_miss_vs_naive_training= NaN(1,N);
p.optimized_miss_vs_naive_test = NaN(1,N);
p.control_vs_naive_training = NaN(1,N);
p.E_vs_naive_training = NaN(1,N);
p.E_vs_control_training = NaN(1,N);
p.opt_miss_vs_control_training = NaN(1,N);
i=0;
while i <N
    i=i+1;
    index= indices(i);
    task = char(T(index,:).Task);
    subject = char(T(index,:).Subject);
    acquisition = char(T(index,:).Acquisition);
    model_seed = T(index,:).Model_Seed;
    %     j = T(T.Subject == subject & T.Task == task & T.Acquisition == acquisition & T.Misspecification == 0 & T.Model_Seed == model_seed,:).Index;
    j1 = T(T.Subject == subject & T.Task == task & T.Acquisition == acquisition & T.Misspecification == 0 & T.Model_Seed == model_seed,:).Index;
    j2 = T(T.Subject == subject & T.Task == task & T.Acquisition == acquisition & T.Misspecification == 1 & T.Model_Seed == model_seed,:).Index;
    for k = 1:numel(j1)
        
        filename = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', acquisition, '_experiment_',num2str(j1(k))];
        load(filename, 'experiment');
        if isfield(experiment,'Pref_vs_E_training')
            p.Pref_vs_E_training(i+k-1) = experiment.Pref_vs_E_training.pref;
        end
        if isfield(experiment,'Pref_vs_E_test')
            p.Pref_vs_E_test(i+k-1) = experiment.Pref_vs_E_test.pref;
        end
        if isfield(experiment,'acq_vs_random_training')
            p.acq_vs_random_training(i+k-1) = experiment.acq_vs_random_training.pref;
        end
        
        if isfield(experiment,'acq_vs_random_test')
            p.acq_vs_random_test(i+k-1) = experiment.acq_vs_random_test.pref;
        end
        
        if isfield(experiment,'acq_vs_opt_training')
            p.acq_vs_opt_training(i+k-1) = experiment.acq_vs_opt_training.pref;
        end
        
        if isfield(experiment,'acq_vs_opt_test')
            p.acq_vs_opt_test(i+k-1) = experiment.acq_vs_opt_test.pref;
        end
        if isfield(experiment,'acq_vs_control_training')
            p.acq_vs_control_training(i+k-1) = experiment.acq_vs_control_training.pref;
        end
        
        if isfield(experiment,'acq_vs_control_test')
            p.acq_vs_control_test(i+k-1) = experiment.acq_vs_control_test.pref;
        end
        if  isfield(experiment, 'optimized_vs_naive_test')
            p.optimized_vs_naive_test(i+k-1) = experiment.optimized_vs_naive_test.pref;
        end
        if  isfield(experiment, 'optimized_vs_naive_training')
            p.optimized_vs_naive_training(i+k-1) = experiment.optimized_vs_naive_training.pref;
        end
        if  isfield(experiment, 'control_vs_naive_training')
            p.control_vs_naive_training(i+k-1) = experiment.control_vs_naive_training.pref;
        end
        if  isfield(experiment, 'E_vs_naive_training')
            p.E_vs_naive_training(i+k-1) = experiment.E_vs_naive_training.pref;
        end
        if  isfield(experiment, 'E_vs_control_training')
            p.E_vs_control_training(i+k-1) = experiment.E_vs_control_training.pref;
        end
        
        if ~isempty(j2)
            filename = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', acquisition, '_experiment_',num2str(j2(k))];
            load(filename, 'experiment');
            if isfield(experiment,'optimized_misspecified_vs_optimized_test')
                pref =  experiment.optimized_miss_vs_optimized_test.pref;
                p.optimized_misspecified_vs_optimized_test(i+k-1) = pref;
            end
            if isfield(experiment,'optimized_misspecified_vs_optimized_training')
                pref = experiment.optimized_misspecified_vs_optimized_training.pref;
                p.optimized_misspecified_vs_optimized_training(i+k-1) = pref;
            end
            if isfield(experiment,'optimized_miss_vs_opt_miss_test')
                p.optimized_miss_vs_opt_miss_test(i+k-1) = experiment.optimized_miss_vs_opt_miss_test.pref;
            end
            if isfield(experiment,'optimized_miss_vs_opt_miss_training')
                p.optimized_miss_vs_opt_miss_training(i+k-1) = experiment.optimized_miss_vs_opt_miss_training.pref;
            end
            if  isfield(experiment,'optimized_miss_vs_control_test')
                p.optimized_miss_vs_control_test(i+k-1) = experiment.optimized_miss_vs_control_test.pref;
            end
            if  isfield(experiment,'optimized_miss_vs_control_training')
                p.optimized_miss_vs_control_training(i+k-1) = experiment.optimized_miss_vs_control_training.pref;
            end
            if  isfield(experiment,'optimized_miss_vs_naive_test')
                p.optimized_miss_vs_naive_test(i+k-1) = experiment.optimized_miss_vs_naive_test.pref;
            end
            if  isfield(experiment,'optimized_miss_vs_naive_training')
                p.optimized_miss_vs_naive_training(i+k-1) = experiment.optimized_miss_vs_naive_training.pref;
            end
            if isfield(experiment, 'opt_miss_vs_control_training')
                p.opt_miss_vs_control_training(i+k-1) = experiment.opt_miss_vs_control_training.pref;
            end
        end
    end
    i=k+i-1;
end
