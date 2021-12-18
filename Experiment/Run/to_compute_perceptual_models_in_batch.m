seed = 1;
add_directories

rng(seed)

implant_name = 'Argus II';
experiment.n_electrodes = 60;

rho_range = [137,415];
lambda_range =[358,1510];
rot_range = [-15,15]*pi/180; %+- 30° precision
center_x_range = [-500,500]; %1 mm center precision
center_y_range = [-500,500];
beta_sup_range = [-2.5,-1.3];
beta_inf_range = [0.1,1.3];
z_range =[0,500];
magnitude_range = [0,300];

 %% Define the implant
implant.array_shape = [6,10];
%% Initialize the true patient-specific perceptual model


to_update = {'rho', 'lambda', 'rot', 'center_x', 'center_y', 'magnitude' 'beta_sup', 'beta_inf'};
default_values = [200,400,0,0,0,175.8257,-2.5,0.1,0]; %Default parameter values
[rho,lambda, rot, center_x, center_y, magnitude, beta_sup, beta_inf,z, lb, ub] = sample_perceptual_model(to_update, default_values, rho_range,lambda_range,rot_range,center_x_range,center_y_range,beta_sup_range,beta_inf_range,z_range,magnitude_range);
% Select beta values at one extreme
xrange = py.list([-18, 16]);
yrange = py.list([-11, 11]);
xystep = 0.3;
n_ax_segments=int64(300);
n_axons=int64(300);

experiment.n_ax_segments = n_ax_segments;
experiment.n_axons = n_axons;
experiment.xrange = xrange;
experiment.yrange = yrange;
experiment.xystep = xystep;
experiment.p2p_version = 'latest';
experiment.implant_name = implant_name;
% kwargs = pyargs('rho', rho, 'axlambda', lambda, 'x', center_x, 'y', center_y, 'z', 0, 'rot', rot, 'eye','RE', 'xrange', xrange, 'yrange', yrange, 'xystep', xystep, 'n_ax_segments', n_ax_segments, 'n_axons', n_axons, 'beta_sup', beta_sup, 'beta_inf', beta_inf);

% flag = int32(bitor(2, 8)); %To avoid memory allocation erros
% py.sys.setdlopenflags(flag);
% pymod = py.importlib.import_module('perceptual_model');
% cd([code_directory,'/Experiment'])
% 
% pymod.Compute_perceptual_model(kwargs);
% 
true_model_params = [rho,lambda, rot, center_x, center_y, magnitude, beta_sup, beta_inf,z]';

%Compute the true perceptual model
misspecification= 0;
params = {'rho','lambda', 'rot','center_x', 'center_y', 'magnitude', 'beta_sup', 'beta_inf', 'z'};
model_params = true_model_params;
[~, ib] = intersect(params,to_update);
ib = sort(ib);
d=numel(to_update);

min_x = lb';
max_x = ub';
lb_norm = zeros(size(lb));
ub_norm = ones(size(ub));
ignore_pickle = 1;

for i = 1:2000
%     if i ==1
%         ignore_pickle = 1;
%     else
%         ignore_pickle = 0;
%     end
    new_x = random_acquisition_binary([], [], [], [],[], [], max_x, min_x, lb_norm, ub_norm);
    x = model_params;
    x(ib) = new_x;
    encoder(x , experiment, ignore_pickle);
end





