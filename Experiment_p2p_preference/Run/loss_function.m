function [loss, p] = loss_function(M, x, S, experiment, varargin)
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

loss = -immse(p, S);

return
 