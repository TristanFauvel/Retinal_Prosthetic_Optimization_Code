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

% if strcmp(experiment.task, 'preference')
%     % Compute preference between optimal vs optimized
%     x_best_norm = (experiment.x_best(experiment.ib,end) - experiment.lb')./(experiment.ub'- experiment.lb');
%     model_params_norm = (experiment.model_params(experiment.ib) - experiment.lb')./(experiment.ub'- experiment.lb');
%     experiment.optimized_vs_optimal = prediction_bin(experiment.theta, experiment.xtrain_norm, experiment.ctrain, [x_best_norm;model_params_norm], experiment.kernelfun, 'modeltype', experiment.modeltype);
%     n = 1000;
%     experiment.optimized_vs_random = mean(prediction_bin(experiment.theta, experiment.xtrain_norm, experiment.ctrain, [repmat(x_best_norm,1,n);rand(size(x_best_norm,1),n)], experiment.kernelfun, 'modeltype', experiment.modeltype));
% end
% 

% save(filename, 'experiment')
% 
% experiment.rmse = compute_encoder_rmse(filename);
% save(filename, 'experiment')
% 

% compute_sight_restoration(filename)

%% Plot all the figures related to an experiment
% %
% if strcmp(experiment.subject, 'human')
%     plot_BO_p2p_results_human(filename)
% end
% plot_BO_p2p_results_human(filename)
