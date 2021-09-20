function [loss, p, loss_opt] = loss_function(M, x, S, experiment, varargin)
%  loss_opt : distance from the optimally encoded percept
opts = namevaluepairtostruct(struct( ...
    'optimal_magnitude', [] ...
    ), varargin);

UNPACK_STRUCT(opts, false)

ignore_pickle = 1;
if isempty(optimal_magnitude)
    if ~ismember('magnitude', experiment.to_update)
        optimal_magnitude = 1;
    else
        optimal_magnitude = 0;
        
    end
end

[W, ~] = encoder(x, experiment,ignore_pickle, optimal_magnitude);
% kwargs = pyargs('rho', rho, 'axlambda', axlambda, 'x', center_x, 'y', center_y, 'z', 0, 'rot', rot, 'eye','RE','xrange', xrange, 'yrange', yrange, 'xystep', xystep, 'n_ax_segments', n_ax_segments, 'n_axons', n_axons);
% pymod.Compute_perceptual_model(kwargs);

p = vision_model(M,W,S);

loss = immse(p./255, S./255);

%%
 optimal_magnitude= 1;
[Wopt, ~] = encoder(experiment.true_model_params, experiment,ignore_pickle, 1);
popt= vision_model(M,Wopt,S);
loss_opt = sqrt(immse(p./255, popt./255));

loss_opt = immse(p./255, popt./255);

return
 