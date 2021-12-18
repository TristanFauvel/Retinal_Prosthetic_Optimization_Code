function p  = load_preferences(reload, data_directory, data_table_file, varargin)
savetofilename =[data_directory, '/preferences.mat'];

load('subjects_to_remove.mat', 'subjects_to_remove') %remove data from participants who did not complete the experiment;
T = load(data_table_file).T;
T = T(all(T.Subject ~= subjects_to_remove,2),:);

if ~isempty(varargin)
    subjects_to_keep = varargin{1};
    T = T(any(T.Subject == subjects_to_keep,2),:);
end


indices = 1:size(T,1);

acquisition= 'maxvar_challenge';
indices = indices(T.Acquisition==acquisition & T.Misspecification == 0);

if reload == 0
    %     load(savetofilename, 'p.Pref_vs_E_training', 'p.Pref_vs_E_test', 'p.acq_vs_random_training', 'p.acq_vs_random_test', 'p.acq_vs_opt_training', 'p.acq_vs_opt_test', 'p.optimized_misspecified_vs_optimized_training', 'p.optimized_misspecified_vs_optimized_test', 'p.optimized_miss_vs_opt_miss_test', 'p.optimized_miss_vs_opt_miss_training', 'p.acq_vs_control_test', 'p.acq_vs_control_training', 'optimized_vs_naive_training', 'optimized_vs_naive_test', 'p.optimized_miss_vs_control_training', 'p.optimized_miss_vs_control_test', 'p.optimized_miss_vs_naive_training', 'p.optimized_miss_vs_naive_test', 'control_vs_naive_training', 'E_vs_naive_training', 'E_vs_control_training', 'opt_miss_vs_control_training');
    load(savetofilename, 'p');
    
elseif reload == 1
    p  = load_pref(T, indices,data_directory);
    
    save(savetofilename, 'p')
else  %only reload the last experiments
    
    indices = indices(end-reload+2);
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
    p.optimized_vs_naive_training = [p.optimized_vs_naive_training, new_p.optimized_vs_naive_training];
    p.optimized_vs_naive_test = [p.optimized_vs_naive_test, new_p.optimized_vs_naive_test];
    p.optimized_miss_vs_control_training = [p.optimized_miss_vs_control_training, new_p.optimized_miss_vs_control_training];
    p.optimized_miss_vs_control_test = [p.optimized_miss_vs_control_test, new_p.optimized_miss_vs_control_test];
    p.optimized_miss_vs_naive_training = [p.optimized_miss_vs_naive_training, new_p.optimized_miss_vs_naive_training];
    p.optimized_miss_vs_naive_test = [p.optimized_miss_vs_naive_test, new_p.optimized_miss_vs_naive_test];
    p.control_vs_naive_training = [p.control_vs_naive_training, new_p.control_vs_naive_training];
    p.E_vs_naive_training = [p.E_vs_naive_training, new_p.E_vs_naive_training];
    p.E_vs_control_training = [p.E_vs_control_training, new_p.E_vs_control_training];
    p.opt_miss_vs_control_training = [p.opt_miss_vs_control_training, new_p.opt_miss_vs_control_training];
    p.optimized_miss_vs_controlmiss_test = [p.optimized_miss_vs_controlmiss_test, new_p.optimized_miss_vs_controlmiss_test];
    p.optimized_miss_vs_controlmiss_training = [p.optimized_miss_vs_controlmiss_training, new_p.optimized_miss_vs_controlmiss_training];
    
    save(savetofilename,'p')
end


function  p  = load_pref(T, indices, data_directory)
N = numel(indices);
V = (0:13)/13;

fields = {'Pref_vs_E_training', 'Pref_vs_E_test','acq_vs_random_training','acq_vs_random_test','acq_vs_opt_training', 'acq_vs_opt_test', ...
    'acq_vs_control_training', 'acq_vs_control_test','optimized_vs_naive_test','optimized_vs_naive_training','control_vs_naive_training', ...
    'E_vs_naive_training', 'E_vs_naive_test','E_vs_control_training'};
fields2 = {'optimized_misspecified_vs_optimized_test', 'optimized_misspecified_vs_optimized_training', 'optimized_miss_vs_opt_miss_test', ...
    'optimized_miss_vs_opt_miss_training', 'optimized_miss_vs_control_test', 'optimized_miss_vs_control_training', 'optimized_miss_vs_naive_test', ...
    'optimized_miss_vs_naive_training','optimized_miss_vs_naive_test', 'optimized_miss_vs_naive_training','opt_miss_vs_control_training', ...
    'opt_miss_vs_control_test', 'optimized_miss_vs_controlmiss_test', 'optimized_miss_vs_controlmiss_training'};
for field = fields2
    p.(field{:}) =  NaN(1,N);
end
for field = fields
    p.(field{:}) =  NaN(1,N);
end
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
        
        for field = fields
            if isfield(experiment,field{:})
                [~,closestIndex] = min(abs(experiment.(field{:}).pref-V'));
                p.(field{:})(i+k-1) = V(closestIndex);
            end
        end
        
        if ~isempty(j2)
            filename = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', acquisition, '_experiment_',num2str(j2(k))];
            load(filename, 'experiment');
            
            for field = fields2
                if isfield(experiment,field{:})
                    [~,closestIndex] = min(abs(experiment.(field{:}).pref-V'));
                    p.(field{:})(i+k-1) = V(closestIndex);
                 end
            end
        end
    end
    i=k+i-1;
end
