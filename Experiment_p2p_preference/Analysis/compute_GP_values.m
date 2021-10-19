function  values = compute_GP_values(filename)
% I use this function to compute the dynamics of the value max estimate (not considering changes in hyperparameters).

load(filename, 'experiment');
UNPACK_STRUCT(experiment, false)
add_directories;
cd([code_directory,'/Experiment_p2p_preference'])


x0 = 0.5*ones(d,1);
if strcmp(task, 'preference')
    [~, values] = model.prediction(theta, xtrain_norm, ctrain, [x_best_norm; x0.*ones(d,size(x_best_norm,2))], post);
elseif strcmp(task, 'LandoltC') || strcmp(task, 'Vernier') || strcmp(task, 'E')
    [values, mu_y, ~,~] =model.prediction(theta, xtrain_norm, ctrain, x_best_norm, post);
end

return

