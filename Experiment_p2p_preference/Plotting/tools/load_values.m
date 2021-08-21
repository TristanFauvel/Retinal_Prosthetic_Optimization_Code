function val = load_values(reload, data_directory, data_table_file)
filename = [data_directory, '/values.mat'];
if reload == 1
    N = -1;
    val.optimized_preference_acq = load_val('preference', 'maxvar_challenge', 0, N, data_table_file, data_directory);
    val.optimal = load_val([], 'optimal', 0, N, data_table_file, data_directory);
    val.optimized_preference_random = load_val('preference', 'random', 0, N, data_table_file, data_directory);
    val.optimized_preference_acq_misspecification = load_val('preference', 'maxvar_challenge', 1, N, data_table_file, data_directory);
    val.optimal_misspecification = load_val([], 'optimal', 1, N, data_table_file, data_directory);
    val.optimized_E_TS = load_val('E', 'TS_binary', 0, N, data_table_file, data_directory);
    val.control = load_val([], 'control', 0, N, data_table_file, data_directory);
    
    save(filename,'val')
elseif reload == 0
    load(filename, 'val')
elseif reload == 2
    N = 1;
    load(filename, 'val');
    val.optimized_preference_acq = [val.optimized_preference_acq, new_val.optimized_preference_acq];
    val.optimal = [val.optimal,  new_val.optimal];
    val.optimized_preference_random = [val.optimized_preference_random, new_val.optimized_preference_random];
    val.optimized_preference_acq_misspecification = [val.optimized_preference_acq_misspecification, new_val.optimized_preference_acq_misspecification];
    val.optimal_misspecification = [val.optimal_misspecification, new_val.optimal_misspecification];
    val.optimized_E_TS = [val.optimized_E_TS, new_val.optimized_E_TS];
    val.control = [val.control, new_val.control ];
    save(filename,'val')
end
end

function  val = load_val(task, exp, misspecification, N, data_table_file, data_directory)
T = load(data_table_file).T;
subject_to_remove = {'KM','TF', 'test', 'CW'}; %remove data from participants who did not complete the experiment;
T = T(all(T.Subject ~= subject_to_remove,2),:);

indices = 1:size(T,1);
indices = indices(T.Acquisition=='maxvar_challenge' & T.Misspecification == 0);

if N == -1
N = numel(indices);
else
indices = indices(end-N+1:end);
end
val = NaN(1,N);

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

base_kernelfun  =@Matern52_kernelfun;
k = 0;

while k<N
    k=k+1;
    i = indices(k);
    subject = char(T(i,:).Subject);
    model_seed = T(i,:).Model_Seed;
    j = T(T.Subject == subject & T.Task == task & T.Acquisition == acquisition & T.Misspecification == misspecification & T.Model_Seed == model_seed,:).Index;
    for l = 1:numel(j)
        filename = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', acquisition, '_experiment_', num2str(j(l))];
        load(filename, 'experiment');
        if strcmp(task, 'preference')
            D = size(experiment.xtrain,1)/2;
            model.D = D;
            kernelfun = @(theta, x,xp,training, regularization) base_kernelfun(theta, x(1:D,:),xp(1:D,:),training, regularization);
        else
            kernelfun = @(theta,xi,xj,training, regularization) preference_kernelfun(theta,base_kernelfun,xi,xj,training, regularization);
        end
        model.kernelfun = kernelfun;
        model.modeltype = experiment.modeltype;
        model.regularization = 'nugget';
        model.link = experiment.link;
        model.lb_norm= experiment.lb_norm;
        model.ub_norm = experiment.ub_norm;
        model.ub = experiment.ub;
        model.lb = experiment.lb;

         if strcmp(exp, 'optimal')
            [~, v] = prediction_bin(experiment.theta, experiment.xtrain_norm, experiment.ctrain, ...
                [(experiment.model_params(experiment.ib)-experiment.lb(:))./(experiment.ub(:)-experiment.lb(:)); experiment.x0.*ones(experiment.d,1)], model, post);        
        elseif strcmp(exp, 'control')
            xparams = experiment.xtrain(1:experiment.d,1);
            xparams =[(xparams-experiment.lb(:))./(experiment.ub(:)-experiment.lb(:)); experiment.x0.*ones(experiment.d,1)];
            [~, v] = prediction_bin(experiment.theta, experiment.xtrain_norm, experiment.ctrain, xparams, model, post);
        else
            if strcmp(task, 'preference')
                [~, v] = prediction_bin(experiment.theta, experiment.xtrain_norm, experiment.ctrain, [experiment.x_best_norm; experiment.x0.*ones(experiment.d,size(experiment.x_best_norm,2))], model, post);
            else
                [~, v] = prediction_bin(experiment.theta, experiment.xtrain_norm, experiment.ctrain, experiment.x_best_norm, model, post);
            end
        end
        val(k+l-1) = v(end);
        %    end
    end
    k=k+l-1;
end
end

