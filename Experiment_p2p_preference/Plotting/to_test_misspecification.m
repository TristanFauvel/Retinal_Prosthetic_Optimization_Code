% true_model_params = [rho,lambda, rot, center_x, center_y, magnitude,beta_sup_range(1),beta_inf_range(2),500];
% 
% encoder(true_model_params, experiment);
% M = load('perceptual_model.mat');
% M = M.M;
% M= reshape(M, nx*ny,nelectrodes);
% 
% model_params = [rho,lambda, rot, center_x, center_y, magnitude, beta_sup, beta_inf,z]';
% encoder(model_params, experiment);
% M_if_the_assumed_model_was_true = load('perceptual_model.mat');
% M_if_the_assumed_model_was_true = M_if_the_assumed_model_was_true.M;
% M_if_the_assumed_model_was_true= reshape(M_if_the_assumed_model_was_true, nx*ny,nelectrodes);
% 
% c = query_preference(M, model_params, model_params, S, display_size, experiment); %If we knew the true parameters for the misspecified model
% c = query_preference(M, true_model_params, true_model_params, S, display_size, experiment); % If we knew the misspecified model
% c = query_preference(M_if_the_assumed_model_was_true, model_params, model_params, S, display_size, experiment); % If the misspecified model was the correct one
% 
% %%
% true_model_params = experiment.true_model_params;
% model_params = experiment.model_params;
clear all
add_directories

letters = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
letter = randsample(1:13,1);
letter =1;
Stimuli_folder =  [Stimuli_folder, '/letters'];
Data_folder = [experiment_path,'/Data'];


params = {'rho','lambda', 'rot','center_x', 'center_y', 'magnitude', 'beta_sup', 'beta_inf', 'z'};

to_update = {'rho', 'lambda', 'rot', 'center_x', 'center_y', 'magnitude', 'beta_sup', 'beta_inf'};  

%% Initialize the true patient-specific perceptual model
rho_range = [137,415];
lambda_range =[358,1510];
rot_range = [-15,15]*pi/180; %+- 30° precision
center_x_range = [-500,500]; %1 mm center precision
center_y_range = [-500,500];
beta_sup_range = [-2.5,-1.3];
beta_inf_range = [0.1,1.3];
z_range =[0,500];
magnitude_range = [0,300];
default_values = [200,400,0,0,0,175.8257,-1.9,0.5,0];
experiment.default_values=  default_values;
[rho,lambda, rot, center_x, center_y, magnitude, beta_sup, beta_inf,z, lb, ub] = sample_perceptual_model(to_update, default_values, rho_range,lambda_range,rot_range,center_x_range,center_y_range,beta_sup_range,beta_inf_range,z_range,magnitude_range);
    beta_sup = -2.5;
    beta_inf = 0.1;

true_model_params = [rho,lambda, rot, center_x, center_y, magnitude, beta_sup, beta_inf,z]';

min_x = [rho_range(1),lambda_range(1),rot_range(1),center_x_range(1),center_y_range(1),magnitude_range(1),beta_sup_range(1),beta_inf_range(1), z_range(1)];
max_x = [rho_range(2),lambda_range(2),rot_range(2),center_x_range(2),center_y_range(2),magnitude_range(2),beta_sup_range(2),beta_inf_range(2), z_range(2)];

    %% Define the implant
implant.array_shape = [6,10];
implant.rot = rot;
xrange = py.list([-18, 16]);
yrange = py.list([-11, 11]);
xystep = 0.3;
n_ax_segments=int64(300);
n_axons=int64(400);

experiment.n_ax_segments = n_ax_segments;
experiment.n_axons = n_axons;
experiment.xrange = xrange;
experiment.yrange = yrange;
experiment.xystep = xystep;
experiment.implant_name = 'Argus II';

%Compute the true perceptual model
ignore_pickle=1;
[Wopt, Mtrue, nx,ny] = encoder(true_model_params, experiment,ignore_pickle);
experiment.nx = nx;
experiment.ny = ny;
S = load_stimuli_letters(experiment);
misspecification=1;
if misspecification
    % We assume some values of the model that are purposedly wrong, so as to
    % misspecify the model    
    to_update = {'rho', 'lambda', 'rot', 'center_x', 'center_y','magnitude'};    
    [~, ~, ~,~,~,~, beta_sup, beta_inf,~, lb, ub] = sample_perceptual_model(to_update, default_values, rho_range,lambda_range,rot_range,center_x_range,center_y_range,beta_sup_range,beta_inf_range,z_range,magnitude_range);
    beta_sup = -1.3;
    beta_inf = 1.3;

    model_params = [rho,lambda, rot, center_x, center_y, magnitude,  beta_sup, beta_inf,z]';
    
    %Precompute the axon map according to the estimated perceptual model (it may not change anymore if beta_sup and beta_inf
    %are not updated)
end

[W,M] = encoder(model_params, experiment,ignore_pickle);

% viewing_distance = 0.4; % viewing distance in m;
visual_field_size = [21,29]; % size of the visual field, in dva.  (height, width)
dpcm = get(0,'ScreenPixelsPerInch')/2.54; % number of pixels per centimeter
display_size = 2*viewing_distance*tan(0.5*visual_field_size*pi/180); % Size of the image on screen (in m)
display_size = floor(display_size*100*dpcm) ; % Size of the image on screen (in pixels)


p1 = vision_model(Mtrue,Wopt,S(:,letter));  %If we knew the true parameters for the model
percept1 = reshape(p1, ny,nx);
percept1 = imresize(percept1, display_size,'method', 'bilinear');

%If we knew the true parameters for the misspecified model
p2 = vision_model(Mtrue,W,S(:,letter));
percept2 = reshape(p2, ny,nx);
percept2 = imresize(percept2, display_size, 'method', 'bilinear');

p3 = vision_model(M,W,S(:,letter));
percept3 = reshape(p3, ny,nx);
percept3= imresize(percept3, display_size, 'method', 'bilinear');


cmap = gray(256);
clims = [0,255];
fig1= figure(1);
fig1.Color =  [1 1 1];
subplot(1,3,1)
imagesc(percept1,clims)
colormap(cmap);
title(letters(letter))
set(gca,'XColor', 'none','YColor','none')
daspect([1 1 1])
subplot(1,3,2)
imagesc(percept2,clims)
colormap(cmap);
title(letters(letter))
set(gca,'XColor', 'none','YColor','none')
daspect([1 1 1])
subplot(1,3,3)
imagesc(percept3,clims)
colormap(cmap);
title(letters(letter))
set(gca,'XColor', 'none','YColor','none')
daspect([1 1 1])

[model_params, true_model_params]


% 
% T = load(data_table_file).T;
% T = T(T.Misspecification == 1,:);
% for index = 1:size(T,1)
%     filename = [Data_folder, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
%     load(filename, 'experiment');
%     cmap = gray(256);
% 
%     nx = experiment.nx;
%     ny = experiment.ny;
%     S = load_stimuli(nx, ny, Stimuli_folder);
% 
%     dpcm = get(0,'ScreenPixelsPerInch')/2.54; % number of pixels per centimeter
%     display_size = 2*experiment.viewing_distance*tan(0.5*experiment.visual_field_size*pi/180); % Size of the image on screen (in m)
%     display_size = floor(display_size*100*dpcm) ; % Size of the image on screen (in pixels)
% 
%     %[experiment.true_model_params(1:6), experiment.model_params]
% %     M = experiment.M;
%     
%     [Wopt,M] = encoder(experiment.true_model_params, experiment);
% %     z = 0;
% %     beta_sup =  -1.9;
% %     beta_inf = 0.5;
% %     model_params = [rho,lambda, rot, center_x, center_y, magnitude, beta_sup, beta_inf,z]';
%     model_params = experiment.true_model_params;
% %     model_params(end) = 300;
%     
%     p1 = vision_model(M,Wopt,S(:,letter));  %If we knew the true parameters for the model
%     percept1 = reshape(p1, ny,nx);
%     percept1 = imresize(percept1, display_size);
% 
%    [W, Mest] = encoder(model_params, experiment);  %If we knew the true parameters for the misspecified model
% %     W = encoder([experiment.model_params;experiment.z;experiment.beta_sup;experiment.beta_inf], experiment);  %If we knew the true parameters for the misspecified model
%     p2 = vision_model(M,W,S(:,letter));
%     percept2 = reshape(p2, ny,nx);
%     percept2 = imresize(percept2, display_size, 'method', 'bilinear');
% 
%     
%     clims = [0,255];
%     fig1= figure(1);
%     fig1.Color =  [1 1 1];
%     subplot(1,2,1)
%     imagesc(percept1,clims)
%     colormap(cmap);
%     title(letters(letter))
%     set(gca,'XColor', 'none','YColor','none')
%     daspect([1 1 1])
%     subplot(1,2,2)
%     imagesc(percept2,clims)
%     colormap(cmap);
%     title(letters(letter))
%     set(gca,'XColor', 'none','YColor','none')
%     daspect([1 1 1])  
%    disp(sqrt((model_params(end-2:end)-experiment.true_model_params(end-2:end)).^2))
% 
% %     disp(([experiment.z;experiment.beta_sup;experiment.beta_inf]-experiment.true_model_params(end-2:end)).^2)
%     disp(index)
%     [model_params,experiment.true_model_params]
% end
% sum((Wopt(:)-W(:)).^2)
%     sum((Wopt(:)-W(:)).^2)
% 
%     matrix_visualization(M,experiment)
