function analyze_experiment(filename, varargin)
opts = namevaluepairtostruct(struct( ...
    'for_all', 1 ...
    ), varargin);

UNPACK_STRUCT(opts, false)

load(filename, 'experiment');
% Compute the maxima
%  if  any(isnan(experiment.x_best(:)))
unknown_theta = 0;
[experiment.x_best, experiment.values, experiment.x_best_norm] = compute_GP_max(filename, for_all, unknown_theta); % Compute the max of the GP ( for_all = 1, for all iterations,  for_all=0, only for the last iteration)*
%  end
% if ~ isfield(experiment, 'x_best_unknown_hyps')
%     [experiment.x_best_unknown_hyps, experiment.values_unknown_hyps] = compute_GP_max(filename, for_all, 0); % Compute the max of the GP ( for_all = 1, for all iterations,  for_all=0, only for the last iteration)*

save(filename, 'experiment')
end


