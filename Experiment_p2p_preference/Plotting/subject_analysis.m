function [p_after_optim, p_opt, p_control, p_after_optim_rand, nx,ny] = subject_analysis(s_index, T)
add_directories;

filename = [data_directory, '/Data_Experiment_p2p_',char(T(s_index,:).Task),'/', char(T(s_index,:).Subject), '/', char(T(s_index,:).Subject), '_', char(T(s_index,:).Acquisition), '_experiment_',num2str(T(s_index,:).Index)];
graphics_style_paper;

%%
save_figures = 1;
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
pymod = [];
ignore_pickle=1; % Wether to use a precomputed axon map (0) or not (1)
optimal_magnitude = 0;
[~, M, nx,ny] = encoder(true_model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
g = @(x,optimal_magnitude) loss_function(M, x, S, experiment, 'optimal_magnitude', optimal_magnitude);
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
j = j(1);

filename = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', 'random', '_experiment_',num2str(j)];
exp_rand = load(filename, 'experiment');
best_params_rand= exp_rand.model_params*ones(1,maxiter);
best_params_rand(ib,:) = exp_rand.x_best(ib,:);
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
%%
range = [2.^(1:floor(log2(maxiter))), maxiter];
nk = numel(range);
percept= [];

for k = 1:nk
    [~,p_optimized] = g(best_params(:,range(k)), []);
    percept = [percept,p_optimized(:,1)];
end


nl = 10;

%%
letter2number = @(c)1+lower(c)-'a';
% range = [2.^(1:floor(log2(maxiter))), maxiter];
range = floor(linspace(1,maxiter, 6));

nk = numel(range);
p1= [];
p2= [];
popt = [];
for k = 1:nk
    xm = model_params;
    xm(ib) = xtrain(1:d,range(k));
    [~,percept] = g(xm, []);
    letter = letter2number(experiment.displayed_stim{k});
    p1 = [p1, percept(:,letter)];
    xm = model_params;
    xm(ib) = xtrain((d+1):end,range(k));
    
    [~,percept] = g(xm, []);
    p2 = [p2, percept(:,letter)];
    
     [~,percept] = g(x_best(:, range(k)), []);

%     [~,percept] = g(x_best_unknown_hyps(:, range(k)));
    popt = [popt, percept(:,1)];
end

fig3 = figure('units','pixels');
fig3.Color = [1,1,1];
width = 0.3347;
height = 0.0873;
xpositions = zeros(nk,2);
ypositions = zeros(nk,2);

yoffset = 0.06; %0.0857;
xoffset = 0.04; %0.0571;

yoffsets =0.9 -(0:(nk-1))*yoffset;
xoffsets = 0.1+(0:(nk-1))*xoffset;
xpositions(:,1) = xoffsets;
xpositions(:,2) = xoffsets+ 0.07;
ypositions(:,1) = yoffsets;
ypositions(:,2) = yoffsets;

c = 0;
for k = 1:nk
    c=c+1;
    img1 = reshape(p1(:,k),ny,nx);
    rgbImage1 = cat(3, img1, img1, img1)./255;
    img2 = reshape(p2(:,k),ny,nx);
    rgbImage2 = cat(3, img2, img2, img2)./255;

    if ctrain(range(k))
        rgbImage1= addborder(rgbImage1, 3,[1,0,0], 'center');
    else
        rgbImage2= addborder(rgbImage2, 3,[1,0,0], 'center');
    end
    
        h =subplot(nk,2,c);
        imshow(rgbImage1);
    set(gca,'xtick',[],'ytick',[],'title',[]); 
    set(gca,'dataAspectRatio',[1 1 1])
    posnew = [xpositions(k,1), ypositions(k,1), width, height]; 
    
    set(h, 'Position', posnew)
    h.CLim = [0, 255];
    
    %     title(range(k));
    ylabel(num2str(range(k)));
    hYLabel = get(gca,'YLabel');
    set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
    c=c+1;
    
    h =subplot(nk,2,c);
            imshow(rgbImage2);
    axis off
    set(gca,'dataAspectRatio',[1 1 1])
    posnew = [xpositions(k,2), ypositions(k,2), width, height];
    set(h, 'Position', posnew)
    h.CLim = [0, 255];
   

end
colormap('gray')
disp('next')

if save_figures
savefig(fig3, [figure_directory,filename_base , '_comparisons_sequence.fig'])
export_fig(fig3, [figure_directory,filename_base , '_comparisons_sequence.png'])
end

fig = figure('units','pixels');
fig.Color = [1,1,1];

c = 0;
for k = 1:nk
    c=c+1;
    h =subplot(nk,1,c);
    imagesc(reshape(popt(:,k),ny,nx));
    set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
    set(gca,'dataAspectRatio',[1 1 1])
    posnew = [xpositions(k,1), ypositions(k,1), width, height];
%     set(h, 'Position', posnew)
    h.CLim = [0, 255];
    ylabel(num2str(range(k)));
    hYLabel = get(gca,'YLabel');
    set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
end
colormap('gray')

if save_figures
savefig(fig, [figure_directory,filename_base , '_optimization_sequence.fig'])
export_fig(fig, [figure_directory,filename_base , '_optimization_sequence.png'])
end
%%

fig= figure('units','pixels');
fig.Color = [1,1,1];
f= 1;
width = f*0.3347;
height = f*0.0873;
xpositions = zeros(nk,2);
ypositions = zeros(nk,2);

yoffset = f*0.1;
xoffset = f*0.06;
% 
yoffsets =0.9 -(0:(nk-1))*yoffset;
xoffsets = 0.1; %+(0:(nk-1))*xoffset;
xpositions(:,1) = xoffsets;
xpositions(:,2) = xoffsets+ f*0.1;
ypositions(:,1) = yoffsets;
ypositions(:,2) = yoffsets;

c = 0;
for k = 1:nk
    c=c+1;
    img1 = reshape(p1(:,k),ny,nx);
    rgbImage1 = cat(3, img1, img1, img1)./255;
    img2 = reshape(p2(:,k),ny,nx);
    rgbImage2 = cat(3, img2, img2, img2)./255;

    if ctrain(range(k))
        rgbImage1= addborder(rgbImage1, 3,[1,0,0], 'center');
    else
        rgbImage2= addborder(rgbImage2, 3,[1,0,0], 'center');
    end
    
        h =subplot(nk,2,c);
        imshow(rgbImage1);
    set(gca,'xtick',[],'ytick',[],'title',[]); 
    set(gca,'dataAspectRatio',[1 1 1])
    posnew = [xpositions(k,1), ypositions(k,1), width, height]; 
    
    set(h, 'Position', posnew)
    h.CLim = [0, 255];
    
    %     title(range(k));
    ylabel(num2str(range(k)));
    hYLabel = get(gca,'YLabel');
    set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
    c=c+1;
    
    h =subplot(nk,2,c);
            imshow(rgbImage2);
    axis off
    set(gca,'dataAspectRatio',[1 1 1])
    posnew = [xpositions(k,2), ypositions(k,2), width, height];
    set(h, 'Position', posnew)
    h.CLim = [0, 255];
   

end
colormap('gray')
disp('next')

if save_figures
savefig(fig, [figure_directory,filename_base , '_comparisons_sequence_straight.fig'])
export_fig(fig, [figure_directory,filename_base , '_comparisons_sequence_straight.png'])
end

close all


% %%%%%%%%%%%%%%%%%%%

range = 1:maxiter;

nk = numel(range);
p1= [];
p2= [];
popt = [];
for k = 1:nk
    xm = model_params;
    xm(ib) = xtrain(1:d,range(k));
    [~,percept] = g(xm, []);
    letter = letter2number(experiment.displayed_stim{k});
    p1 = [p1, percept(:,letter)];
    xm = model_params;
    xm(ib) = xtrain((d+1):end,range(k));
    
    [~,percept] = g(xm, []);
    p2 = [p2, percept(:,letter)];
    
     [~,percept] = g(x_best(:, range(k)), []);

%     [~,percept] = g(x_best_unknown_hyps(:, range(k)));
    popt = [popt, percept(:,1)];
end



c = 0;
for k = 1:nk
    c=c+1;
    img1 = reshape(p1(:,k),ny,nx);
    rgbImage1 = cat(3, img1, img1, img1)./255;
    img2 = reshape(p2(:,k),ny,nx);
    rgbImage2 = cat(3, img2, img2, img2)./255;

    if ctrain(range(k))
        rgbImage1= addborder(rgbImage1, 3,[1,0,0], 'center');
    else
        rgbImage2= addborder(rgbImage2, 3,[1,0,0], 'center');
    end
    
    fig= figure('units','pixels');
    fig.Color = [1,1,1];    
    h =subplot(1,2,1);
    imshow(rgbImage1);
    set(gca,'xtick',[],'ytick',[],'title',[]);
    set(gca,'dataAspectRatio',[1 1 1])
    h.CLim = [0, 255];
    ylabel(num2str(range(k)));
    hYLabel = get(gca,'YLabel');
    set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
    c=c+1;    
    h =subplot(1,2,2);
    imshow(rgbImage2);
    axis off
    set(gca,'dataAspectRatio',[1 1 1])
    h.CLim = [0, 255];
    colormap('gray')
    if save_figures
        sdir = [figure_directory,filename_base , '_comparisons/'];
        
        if ~isdir(sdir)
        mkdir(sdir)
        end
        saveas(fig, [sdir, 'comparison_', num2str(k),'.png'])
    end
end

