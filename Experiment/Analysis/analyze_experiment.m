function analyze_experiment(filename, varargin)
%% Compute the estimated maximum of the latent GP at each iteration

opts = namevaluepairtostruct(struct( ...
    'for_all', 1 ...
    ), varargin);

UNPACK_STRUCT(opts, false)

load(filename, 'experiment');
% Compute the maxima

unknown_theta = 0;
[experiment.x_best, experiment.values, experiment.x_best_norm] = compute_GP_max(filename, for_all, unknown_theta); % Compute the max of the GP ( for_all = 1, for all iterations,  for_all=0, only for the last iteration)


save(filename, 'experiment')
end


