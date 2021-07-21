function [val_optimized_preference_acq_evolution_combined, val_optimized_preference_random_evolution_combined] = load_values_evolution_combined_data(reload)
add_directories,
filename = [data_directory, '/values_evolution_combined.mat'];
if reload
%     val_optimized_preference_acq_evolution_combined= load_val('preference', 'maxvar_challenge', 0);
%     val_optimized_preference_random_evolution_combined = load_val('preference', 'random', 0);
%     val_optimized_preference_acq_miss_evolution_combined = load_val('preference', 'maxvar_challenge', 1);
%     val_optimized_E_TS_evolution_combined = load_val('E', 'TS_binary', 0);
    add_directories;
    T = load(data_table_file).T;
    
    indices = 1:size(T,1);
    indices = indices(T.Acquisition=='maxvar_challenge' & T.Misspecification == 0);
    N = numel(indices);
    
    maxiter = 60;
    val_optimized_preference_acq_evolution_combined = NaN(maxiter,N);
     val_optimized_preference_random_evolution_combined = NaN(maxiter,N);
   
        task = 'preference';
    for i =1:N
        index = indices(i);
        subject = char(T(index,:).Subject);
        model_seed = T(index,:).Model_Seed;
        
        %filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
       misspecification= 0;
       acquisition = 'maxvar_challenge';
        j_challenge = T(T.Subject == subject & T.Task == task & T.Acquisition == acquisition & T.Misspecification == misspecification & T.Model_Seed == model_seed,:).Index;
        filename_challenge = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', acquisition, '_experiment_', num2str(j_challenge)];        
        acquisition = 'random';
        j_random = T(T.Subject == subject & T.Task == task & T.Acquisition == acquisition & T.Misspecification == misspecification & T.Model_Seed == model_seed,:).Index;
        filename_random = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', acquisition, '_experiment_', num2str(j_random)];

        if ~isempty(j_challenge) && ~isempty(j_random)
            load(filename_challenge, 'experiment');
            exp_challenge = experiment;
            load(filename_random, 'experiment');
            exp_rand = experiment;
            
                [~, v_challenge] = prediction_bin_preference(exp_challenge.theta, [exp_challenge.xtrain_norm,exp_rand.xtrain_norm], [exp_challenge.ctrain, exp_rand.ctrain], [exp_challenge.x_best_norm; exp_challenge.x0.*ones(exp_challenge.d,size(exp_challenge.x_best_norm,2))], exp_challenge.kernelfun, 'modeltype', exp_challenge.modeltype);
                [~, v_rand] = prediction_bin_preference(exp_rand.theta, [exp_challenge.xtrain_norm,exp_rand.xtrain_norm], [exp_challenge.ctrain, exp_rand.ctrain], [exp_rand.x_best_norm; exp_challenge.x0.*ones(exp_challenge.d,size(exp_challenge.x_best_norm,2))], exp_challenge.kernelfun, 'modeltype', exp_challenge.modeltype);

               val_optimized_preference_acq_evolution_combined(:,i) = v_challenge;
                              val_optimized_preference_random_evolution_combined(:,i) = v_rand;

            %    end
        end
    end
    save(filename, 'val_optimized_preference_acq_evolution_combined', 'val_optimized_preference_random_evolution_combined');
else
    load(filename, 'val_optimized_preference_acq_evolution_combined', 'val_optimized_preference_random_evolution_combined');
end


