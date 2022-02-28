function [new_x, M] = rand_model(ub, lb, magnitude_range, experiment, ib, ignore_pickle)
add_directories;

if strcmp(experiment.p2p_version, 'stable')
    perceptual_model_table_file = stable_perceptual_model_table_file;
elseif strcmp(experiment.p2p_version, 'latest')
    perceptual_model_table_file = latest_perceptual_model_table_file;
end

P = load(perceptual_model_table_file);
T =P.T;
T = T(T.implant == experiment.implant_name,:);

default_values=num2cell(experiment.default_values);
[d_rho,d_lambda, d_rot, d_center_x, d_center_y, d_magnitude, d_beta_sup, d_beta_inf,d_z] = deal(default_values{:});
to_update = experiment.to_update;
%% To avoid bias in sampling from precomputed models

if strcmp(experiment.implant_name, 'Argus II') %% If the implant is epiretinal, these parameters matter.
    if ~ismember('rho', to_update)
        T = T(T.rho == d_rho,:);
    else
        T = T(T.rho~= d_rho,:);
    end
    if ~ismember('lambda', to_update)
        T = T(T.axlambda == d_lambda,:);
    else
        T = T(T.axlambda ~= d_lambda,:);
    end
    if ~ismember('beta_sup', to_update)
        T = T(T.beta_sup == d_beta_sup,:);
    else
        T = T(T.beta_sup ~= d_beta_sup,:);
    end
    if ~ismember('beta_inf', to_update)
        T = T(T.beta_inf == d_beta_inf,:);
    else
        T = T(T.beta_inf ~= d_beta_inf,:);
    end
    
end
if ~ismember('rot', to_update)
    T = T(T.rot == d_rot,:);
else
    T = T(T.rot ~= d_rot,:);
end
if ~ismember('center_x', to_update)
    T = T(T.center_x == d_center_x,:);
else
    T = T(T.center_x ~= d_center_x,:);
end
if ~ismember('center_y', to_update)
    T = T(T.center_y == d_center_y,:);
else
    T = T(T.center_y ~= d_center_y,:);
end
if ~ismember('z', to_update)
    T = T(T.z == d_z,:);
else
    T = T(T.z ~= d_z,:);
end
if ~ismember('magnitude', to_update)
    magnitude= d_magnitude;
else
    magnitude = rand_interval(magnitude_range(1), magnitude_range(2));
end

% remove the models that are outside the bounds for the experiment.


t= [T.rho, T.axlambda, T.rot, T.center_x, T.center_y, magnitude*ones(size(T,1),1), T.beta_sup, T.beta_inf,T.z];

id1 = any(t > ub(:)',2);
id2 = any(t < lb(:)',2);
T= T(~(id1 | id2),:);

nmodels= 2000;
if isempty(T) || size(T,1)< nmodels
     new_x = rand_interval(lb,ub); 
    warning('The number of precomputed models is to small, compute a new model.')
else
    i = randsample(nmodels,1);
    
    rho = T(i,:).rho;
    axlambda = T(i,:).axlambda;
    rot = T(i,:).rot;
    z = T(i,:).z;
    center_x = T(i,:).center_x;
    center_y = T(i,:).center_y;
    beta_sup = T(i,:).beta_sup;
    beta_inf = T(i,:).beta_inf;
    new_x = [rho,axlambda, rot, center_x, center_y, magnitude, beta_sup, beta_inf,z]';
end

[~, M] = encoder(new_x, experiment, ignore_pickle);
new_x = new_x(ib);



