function val_combined = load_values_evolution_combined_data(reload, data_directory, data_table_file)
filename = [data_directory, '/values_evolution_combined.mat'];
if reload
    base_kernelfun = @Matern52_kernelfun;

    kernelfun = @(theta, x,xp,training, regularization) base_kernelfun(theta, x(1:0.5*size(x,1),:),xp(1:0.5*size(x,1),:),training, regularization);

    T = load(data_table_file).T;
      load('subjects_to_remove.mat', 'subjects_to_remove') %remove data from participants who did not complete the experiment;
    T = T(all(T.Subject ~= subjects_to_remove,2),:);

    indices = 1:size(T,1);
    indices = indices(T.Acquisition=='maxvar_challenge' & T.Misspecification == 0);
    N = numel(indices);

    maxiter = 60;
    val_combined.optimized_preference_acq_evolution = NaN(maxiter,N);
    val_combined.optimized_preference_random_evolution = NaN(maxiter,N);

    task = 'preference';
    k = 0;
    while k<N
        k=k+1;
        i = indices(k);
        subject = char(T(i,:).Subject);
        model_seed = T(i,:).Model_Seed;

        %filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
        misspecification= 0;
        acquisition = 'maxvar_challenge';
        j_challenge = T(T.Subject == subject & T.Task == task & T.Acquisition == acquisition & T.Misspecification == misspecification & T.Model_Seed == model_seed,:).Index;
        acquisition = 'random';
        j_random = T(T.Subject == subject & T.Task == task & T.Acquisition == acquisition & T.Misspecification == misspecification & T.Model_Seed == model_seed,:).Index;

        for l= 1:numel(j_challenge)
            acquisition = 'maxvar_challenge';
            filename_challenge = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', acquisition, '_experiment_', num2str(j_challenge(l))];
            acquisition = 'random';
            filename_random = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', acquisition, '_experiment_', num2str(j_random(l))];

            if ~isempty(j_challenge) && ~isempty(j_random)
                load(filename_challenge, 'experiment');
                exp_challenge = experiment;
                load(filename_random, 'experiment');
                exp_rand = experiment;

                model.kernelfun = kernelfun;
                model.modeltype = exp_challenge.modeltype;
                model.regularization = 'nugget';
                model.link = exp_challenge.link;
                model.lb_norm= exp_challenge.lb_norm;
                model.ub_norm = exp_challenge.ub_norm;
                model.ub = exp_challenge.ub;
                model.lb = exp_challenge.lb;

                [~, v_challenge] = model.prediction(exp_challenge.theta, [exp_challenge.xtrain_norm,exp_rand.xtrain_norm], ...
                    [exp_challenge.ctrain, exp_rand.ctrain], [exp_challenge.x_best_norm; exp_challenge.x0.*ones(exp_challenge.d,size(exp_challenge.x_best_norm,2))], model, []);
                [~, v_rand] = model.prediction(exp_rand.theta, [exp_challenge.xtrain_norm,exp_rand.xtrain_norm], ...
                    [exp_challenge.ctrain, exp_rand.ctrain], [exp_rand.x_best_norm; exp_challenge.x0.*ones(exp_challenge.d,size(exp_challenge.x_best_norm,2))], model, []);

                val_combined.optimized_preference_acq_evolution(:,k+l-1) = v_challenge;
                val_combined.optimized_preference_random_evolution(:,k+l-1) = v_rand;
            end
        end
        k=k+l-1;
    end
    save(filename, 'val_combined');
else
    load(filename, 'val_combined');
end

%
% acquisition = 'maxvar_challenge';
%  T(T.Subject == subject & T.Task == task & T.Acquisition == 'maxvar_challenge' & T.Misspecification ==1 & T.Model_Seed == model_seed,:)
%
%  filename = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', acquisition, '_experiment_', num2str(1)];
% load(filename, 'experiment')
% experiment.misspecification
%  filename = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', acquisition, '_experiment_', num2str(3)];
% load(filename, 'experiment')
% experiment.misspecification
%
% t = T(T.Subject == 'SG',:);
% t(5,:).Index = 4;
% T(T.Subject == 'SG',:)= t;
