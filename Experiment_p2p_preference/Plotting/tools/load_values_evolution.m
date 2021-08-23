function val_evo = load_values_evolution(reload, data_directory, data_table_file)
filename = [data_directory, '/values_evolution.mat'];
if reload
    val_evo.optimized_preference_acq= load_val('preference', 'maxvar_challenge', 0, data_table_file, data_directory);
    val_evo.optimized_preference_random = load_val('preference', 'random', 0, data_table_file, data_directory);
    val_evo.optimized_preference_acq_misspecification = load_val('preference', 'maxvar_challenge', 1, data_table_file, data_directory);
    val_evo.optimized_E_TS = load_val('E', 'TS_binary', 0, data_table_file, data_directory);
    
    save(filename, 'val_evo');
else
    load(filename, 'val_evo');
end
end

function  val = load_val(task, exp, misspecification,data_table_file, data_directory)
T = load(data_table_file).T;

load('subjects_to_remove.mat', 'subjects_to_remove'); %remove data from participants who did not complete the experiment;
T = T(all(T.Subject ~= subjects_to_remove,2),:);


base_kernelfun = @Matern52_kernelfun;
       kernelfun = @(theta, x,xp,training, regularization) base_kernelfun(theta, x(1:0.5*size(x,1),:),xp(1:0.5*size(x,1),:),training, regularization);

indices = 1:size(T,1);
indices = indices(T.Acquisition=='maxvar_challenge' & T.Misspecification == 0);
N = numel(indices);

maxiter = 60;
val = NaN(maxiter,N);

if strcmp(exp, 'optimal') || strcmp(exp, 'control')
    acquisition = 'maxvar_challenge';
    task = 'preference';
else
    acquisition = exp;
end
% indices = 1:size(T,1);
% indices = indices(T.Task == task & T.Acquisition==acquisition & T.Misspecification==misspecification);
% [a,b] = sort(T(indices,:).Model_Seed);
% indices = indices(b);
post = [];
regularization = 'nugget';

k = 0;
while k<N
 k=k+1;
    i = indices(k);
    subject = char(T(i,:).Subject);
    model_seed = T(i,:).Model_Seed;
    j = T(T.Subject == subject & T.Task == task & T.Acquisition == acquisition & T.Misspecification == misspecification & T.Model_Seed == model_seed,:).Index;
    for l= 1:numel(j)
        filename = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', acquisition, '_experiment_', num2str(j(l))];
        load(filename, 'experiment');
         model.kernelfun = kernelfun;
        model.modeltype = experiment.modeltype;
        model.regularization = 'nugget';
        model.link = experiment.link;
        model.lb_norm= experiment.lb_norm;
        model.ub_norm = experiment.ub_norm;
        model.ub = experiment.ub;
        model.lb = experiment.lb;
            if strcmp(task, 'preference')
                [~, v] = prediction_bin(experiment.theta, experiment.xtrain_norm, experiment.ctrain, [experiment.x_best_norm; experiment.x0.*ones(experiment.d,size(experiment.x_best_norm,2))], model, post);
            else
                [~, v] = prediction_bin(experiment.theta, experiment.xtrain_norm, experiment.ctrain, experiment.x_best_norm,  model, post);
            end
        val(:,k+l-1) = v;
    end
    k=k+l-1;
end
end

