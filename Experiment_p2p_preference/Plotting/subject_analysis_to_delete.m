function [p_after_optim, p_opt, p_control, p_after_optim_rand, nx,ny] = subject_analysis_to_delete(s_index, T)
add_directories;

filename = [data_directory, '/Data_Experiment_p2p_',char(T(s_index,:).Task),'/', char(T(s_index,:).Subject), '/', char(T(s_index,:).Subject), '_', char(T(s_index,:).Acquisition), '_experiment_',num2str(T(s_index,:).Index)];
graphics_style_paper;

%%
save_figures = 0;
showall = 'yes';
load(filename)
UNPACK_STRUCT(experiment, false)

add_directories;

filename_base = [task,'_', subject, '_', acquisition_fun_name,'_',num2str(s_index)];
figure_directory = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/Figures/'];

if ~exist(figure_directory)
    mkdir(figure_directory)
end

Stimuli_folder = [Stimuli_folder, '/letters'];
S = load_stimuli_letters(experiment);

best_params = model_params*ones(1,maxiter);
best_params(ib,:) = x_best(ib,:);

%%
kernel_list = {'ARD', 'RQ', 'Matern52', 'Matern32', 'Polynomial'};
if strcmp(task, 'preference') && misspecification
    theta_filename = [data_directory, '/Dataset_preference_misspecified_seed_6_theta.mat'];    
elseif strcmp(task, 'preference') && ~misspecification
        theta_filename = [data_directory, '/Dataset_preference_seed_6_theta.mat'];
elseif strcmp(task, 'E')
        theta_filename = [data_directory, '/Dataset_E_seed_6_theta.mat'];
end
load(theta_filename,'ktheta')
kernelname = 'ARD';
switch(kernelname)
    case 'Gaussian'
        base_kernelfun =  @Gaussian_kernelfun;%kernel used within the preference learning kernel, for subject = computer
         theta_init = -4*ones(2,1);
    case 'ARD'
        base_kernelfun =  @ARD_kernelfun;%kernel used within the preference learning kernel, for subject = computer
%         theta_init = [-0.1011,-10.0000,0.8080,-1.3494,-1.6468,1.6123,-1.7985,-0.2213,1.6397];
theta_init = ktheta{1};
    case 'Matern52'
         base_kernelfun = @Matern52_kernelfun;
%         theta_init = [-0.3544;1.6781];
theta_init = ktheta{3};
    case 'Matern32'
        base_kernelfun = @Matern32_kernelfun;
%         theta_init = [-0.0843;2.0791];   
theta_init = ktheta{4};
end

if ~strcmp(task, 'preference')
    kernelfun = @(theta, x0,x,training) base_kernelfun(theta, x0(1:d,:),x(1:d,:),training);
else
            kernelfun = @(theta, xi, xj, training) preference_kernelfun(theta, base_kernelfun, xi, xj, training);
end
theta = theta_init;
i = maxiter;
old = x_best_norm(:,i);
if strcmp(task,'preference')
        x_best_norm(:,i)= multistart_minConf(@(x)to_maximize_value_function(theta, xtrain_norm(:,i), ctrain(:,i), x, kernelfun, x0,modeltype), lb_norm, ub_norm, 5, [], options_maxmean);
    else
        x_best_norm(:,i) = multistart_minConf(@(x)to_maximize_mean_GP(theta, xtrain_norm(:,1:i), ctrain(1:i), x, kernelfun, modeltype), lb_norm, ub_norm, 5, [], options_maxmean);
        
end
new =x_best_norm(:,i)
[old, new]
x_best = model_params.*ones(1,maxiter);
x_best(ib,:) = x_best_norm(ib,:).*(max_x(ib)-min_x(ib))' + min_x(ib)';
best_params = x_best;
%%
pymod = [];
ignore_pickle=1; % Wether to use a precomputed axon map (0) or not (1)
optimal_magnitude = 0;
[~, M, nx,ny] = encoder(true_model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
g = @(x, optimal_magnitude) loss_function(M, x, S, experiment, 'optimal_magnitude', optimal_magnitude);
[~,p_after_optim] = g(best_params(:,end), []);
[~,p_opt] = g(model_params, 1);
x_control = model_params;
x_control(ib) = xtrain(ib,1);
[~,p_control] = g(x_control, []);

%%
task = char(T(s_index,:).Task);
subject = char(T(s_index,:).Subject);
acquisition = 'random';
model_seed = T(s_index,:).Model_Seed;
j = T(T.Subject == subject & T.Task == task & T.Acquisition == acquisition & T.Misspecification == 0 & T.Model_Seed == model_seed,:).Index;
filename = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', 'random', '_experiment_',num2str(j)];
load(filename, 'experiment');
experiment.x_best_norm(:,i)= multistart_minConf(@(x)to_maximize_value_function(theta, experiment.xtrain_norm(:,i), experiment.ctrain(:,i), x, kernelfun, x0,modeltype), lb_norm, ub_norm, 5, [], options_maxmean);
experiment.x_best = model_params.*ones(1,maxiter);
experiment.x_best(ib,:) =experiment. x_best_norm(ib,:).*(max_x(ib)-min_x(ib))' + min_x(ib)';

best_params_rand= experiment.x_best;
% [~, M, nx,ny] = encoder(true_model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
% g = @(x) loss_function(M, x, S, experiment);
[~,p_after_optim_rand] = g(best_params_rand(:,end), []);

%%
k=1;
fig = figure('units','pixels');
fig.Color = [1,1,1];
nk = 4;
h = subplot(1,nk,1);
imagesc(reshape(p_opt(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
set(gca,'dataAspectRatio',[1 1 1])
h.CLim = [0, 255];
title('Ground truth')
h = subplot(1,nk,2);
imagesc(reshape(p_after_optim(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
set(gca,'dataAspectRatio',[1 1 1])
h.CLim = [0, 255];
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
title('MaxVarChallenge')
h = subplot(1,nk,3);
imagesc(reshape(p_after_optim_rand(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
set(gca,'dataAspectRatio',[1 1 1])
h.CLim = [0, 255];
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
title('Random')
h = subplot(1,nk,4);
imagesc(reshape(p_control(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
set(gca,'dataAspectRatio',[1 1 1])
h.CLim = [0, 255];
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
title('Control')
colormap('gray')
if save_figures
export_fig(fig, [figure_directory,filename_base , '_compare_encoders.png'])
end
close all
% %%
% range = [2.^(1:floor(log2(maxiter))), maxiter];
% nk = numel(range);
% percept= [];
% 
% for k = 1:nk
%     [~,p_optimized] = g(best_params(:,range(k)));
%     percept = [percept,p_optimized(:,1)];
% end
% 
% 
% nl = 10;
% 
% %%
% letter2number = @(c)1+lower(c)-'a';
% % range = [2.^(1:floor(log2(maxiter))), maxiter];
% range = floor(linspace(1,maxiter, 6));
% 
% nk = numel(range);
% p1= [];
% p2= [];
% popt = [];
% for k = 1:nk
%     xm = model_params;
%     xm(ib) = xtrain(1:d,range(k));
%     [~,percept] = g(xm);
%     letter = letter2number(experiment.displayed_stim{k});
%     p1 = [p1, percept(:,letter)];
%     xm = model_params;
%     xm(ib) = xtrain((d+1):end,range(k));
%     
%     [~,percept] = g(xm);
%     p2 = [p2, percept(:,letter)];
%     
%      [~,percept] = g(x_best(:, range(k)));
% 
% %     [~,percept] = g(x_best_unknown_hyps(:, range(k)));
%     popt = [popt, percept(:,1)];
% end
% 
% fig3 = figure('units','pixels');
% fig3.Color = [1,1,1];
% width = 0.3347;
% height = 0.0873;
% xpositions = zeros(nk,2);
% ypositions = zeros(nk,2);
% 
% yoffset = 0.06; %0.0857;
% xoffset = 0.04; %0.0571;
% 
% yoffsets =0.9 -(0:(nk-1))*yoffset;
% xoffsets = 0.1+(0:(nk-1))*xoffset;
% xpositions(:,1) = xoffsets;
% xpositions(:,2) = xoffsets+ 0.07;
% ypositions(:,1) = yoffsets;
% ypositions(:,2) = yoffsets;
% 
% c = 0;
% for k = 1:nk
%     c=c+1;
%     img1 = reshape(p1(:,k),ny,nx);
%     rgbImage1 = cat(3, img1, img1, img1)./255;
%     img2 = reshape(p2(:,k),ny,nx);
%     rgbImage2 = cat(3, img2, img2, img2)./255;
% 
%     if ctrain(range(k))
%         rgbImage1= addborder(rgbImage1, 3,[1,0,0], 'center');
%     else
%         rgbImage2= addborder(rgbImage2, 3,[1,0,0], 'center');
%     end
%     
%         h =subplot(nk,2,c);
%         imshow(rgbImage1);
%     set(gca,'xtick',[],'ytick',[],'title',[]); 
%     set(gca,'dataAspectRatio',[1 1 1])
%     posnew = [xpositions(k,1), ypositions(k,1), width, height]; 
%     
%     set(h, 'Position', posnew)
%     h.CLim = [0, 255];
%     
%     %     title(range(k));
%     ylabel(num2str(range(k)));
%     hYLabel = get(gca,'YLabel');
%     set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
%     c=c+1;
%     
%     h =subplot(nk,2,c);
%             imshow(rgbImage2);
%     axis off
%     set(gca,'dataAspectRatio',[1 1 1])
%     posnew = [xpositions(k,2), ypositions(k,2), width, height];
%     set(h, 'Position', posnew)
%     h.CLim = [0, 255];
%    
% 
% end
% colormap('gray')
% disp('next')
% 
% if save_figures
% savefig(fig3, [figure_directory,filename_base , '_comparisons_sequence.fig'])
% export_fig(fig3, [figure_directory,filename_base , '_comparisons_sequence.png'])
% end
% 
% fig = figure('units','pixels');
% fig.Color = [1,1,1];
% 
% c = 0;
% for k = 1:nk
%     c=c+1;
%     h =subplot(nk,1,c);
%     imagesc(reshape(popt(:,k),ny,nx));
%     set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
%     set(gca,'dataAspectRatio',[1 1 1])
%     posnew = [xpositions(k,1), ypositions(k,1), width, height];
% %     set(h, 'Position', posnew)
%     h.CLim = [0, 255];
%     ylabel(num2str(range(k)));
%     hYLabel = get(gca,'YLabel');
%     set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
% end
% colormap('gray')
% 
% if save_figures
% savefig(fig, [figure_directory,filename_base , '_optimization_sequence.fig'])
% export_fig(fig, [figure_directory,filename_base , '_optimization_sequence.png'])
% end
% %%
% 
% fig= figure('units','pixels');
% fig.Color = [1,1,1];
% f= 1;
% width = f*0.3347;
% height = f*0.0873;
% xpositions = zeros(nk,2);
% ypositions = zeros(nk,2);
% 
% yoffset = f*0.1;
% xoffset = f*0.06;
% % 
% yoffsets =0.9 -(0:(nk-1))*yoffset;
% xoffsets = 0.1; %+(0:(nk-1))*xoffset;
% xpositions(:,1) = xoffsets;
% xpositions(:,2) = xoffsets+ f*0.1;
% ypositions(:,1) = yoffsets;
% ypositions(:,2) = yoffsets;
% 
% c = 0;
% for k = 1:nk
%     c=c+1;
%     img1 = reshape(p1(:,k),ny,nx);
%     rgbImage1 = cat(3, img1, img1, img1)./255;
%     img2 = reshape(p2(:,k),ny,nx);
%     rgbImage2 = cat(3, img2, img2, img2)./255;
% 
%     if ctrain(range(k))
%         rgbImage1= addborder(rgbImage1, 3,[1,0,0], 'center');
%     else
%         rgbImage2= addborder(rgbImage2, 3,[1,0,0], 'center');
%     end
%     
%         h =subplot(nk,2,c);
%         imshow(rgbImage1);
%     set(gca,'xtick',[],'ytick',[],'title',[]); 
%     set(gca,'dataAspectRatio',[1 1 1])
%     posnew = [xpositions(k,1), ypositions(k,1), width, height]; 
%     
%     set(h, 'Position', posnew)
%     h.CLim = [0, 255];
%     
%     %     title(range(k));
%     ylabel(num2str(range(k)));
%     hYLabel = get(gca,'YLabel');
%     set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
%     c=c+1;
%     
%     h =subplot(nk,2,c);
%             imshow(rgbImage2);
%     axis off
%     set(gca,'dataAspectRatio',[1 1 1])
%     posnew = [xpositions(k,2), ypositions(k,2), width, height];
%     set(h, 'Position', posnew)
%     h.CLim = [0, 255];
%    
% 
% end
% colormap('gray')
% disp('next')
% 
% if save_figures
% savefig(fig, [figure_directory,filename_base , '_comparisons_sequence_straight.fig'])
% export_fig(fig, [figure_directory,filename_base , '_comparisons_sequence_straight.png'])
% end
% 
% close all

return

Stimuli_folder = '/media/sf_Documents/Retinal_Prosthetic_Optimization/Retinal_Prosthetic_Optimization_Code/Stimuli/E'
S = compute_stimulus(experiment, 'E', 40, 114, 74, Stimuli_folder, 1);
   % S = imresize(S, [ny, nx], 'method', 'bilinear');

figure()
imagesc(S)
colormap('gray')

[W, ~] = encoder(model_params, experiment,ignore_pickle, optimal_magnitude);
        
a = W*S(:);
fig = figure('units','pixels');
fig.Color = [1,1,1];
imagesc(reshape(a,6,10));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
set(gca,'dataAspectRatio',[1 1 1])
h.CLim = [0, 255];
colormap('gray')


