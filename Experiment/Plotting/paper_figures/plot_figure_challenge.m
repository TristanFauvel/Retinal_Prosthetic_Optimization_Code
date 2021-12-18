function plot_figure_challenge(id, varargin)
%% Plot the results of the preference-based optimization

add_modules;
graphics_style_paper;

data_directory = [experiment_path,'/Data'];
figures_folder = [experiment_path,'/Figures'];
reload = 0;
[VA_E_optimized_preference_acq, VA_Snellen_optimized_preference_acq, VA_E_optimal,VA_Snellen_optimal, VA_E_optimized_preference_random,VA_Snellen_optimized_preference_random, VA_E_optimized_preference_acq_misspecification, VA_Snellen_optimized_preference_acq_misspecification, VA_E_optimal_misspecification,VA_Snellen_optimal_misspecification, VA_E_optimized_E_TS,VA_Snellen_optimized_E_TS, VA_E_control,VA_Snellen_control] = load_VA_results(reload);
[Pref_vs_E_training, Pref_vs_E_test, acq_vs_random_training, acq_vs_random_test, acq_vs_opt_training, acq_vs_opt_test, optimized_misspecified_vs_optimized_training, optimized_misspecified_vs_optimized_test,optimized_miss_vs_opt_miss_test, optimized_miss_vs_opt_miss_training, acq_vs_control_test, acq_vs_control_training, optimized_vs_naive_training, optimized_vs_naive_test, optimized_miss_vs_control_training, optimized_miss_vs_control_test, optimized_miss_vs_naive_training, optimized_miss_vs_naive_test, control_vs_naive_training, E_vs_naive_training,E_vs_control_training]  = load_preferences(reload);
[val_optimized_preference_acq_evolution_combined, val_optimized_preference_random_evolution_combined] = load_values_evolution_combined_data(reload)

boxp = 1;

VA_scale_E= [min([VA_E_optimized_preference_acq,VA_E_optimized_preference_random,VA_E_control]), max([VA_E_optimized_preference_acq,VA_E_optimized_preference_random,VA_E_control])];
VA_scale_Snellen=[min([VA_Snellen_optimized_preference_acq,VA_Snellen_optimized_preference_random,VA_Snellen_control]), max([VA_Snellen_optimized_preference_acq,VA_Snellen_optimized_preference_random,VA_Snellen_control])];

VA_scale = [min(VA_scale_E(1), VA_scale_Snellen(1)),max(VA_scale_E(2), VA_scale_Snellen(2))];
VA_scale = [VA_scale;VA_scale];

VA_scale_E = [VA_scale_E;VA_scale_E];
VA_scale_Snellen = [VA_scale_Snellen;VA_scale_Snellen];

pref_scale = [0,1;0,1];

%%
%filename = [data_directory, '/Data_Experiment_p2p_preference/BF/BF_MUC_experiment_2'];
filename =[data_directory,'/Data_Experiment_p2p_preference/MC/MC_MUC_experiment_2'];

load(filename, 'experiment')
exp = experiment;
filename_base = [exp.task,'_', exp.subject, '_', exp.acquisition_fun_name,'_',num2str(exp.index)];

add_directories;
figure_directory = [data_directory, '/Data_Experiment_p2p_',exp.task,'/',exp.subject,'/Figures/'];

if ~exist(figure_directory,'dir')
    mkdir(figure_directory)
end

if strcmp(exp.implant_name, 'Argus II')
    im_ny = floor(0.9*exp.ny);
    im_nx = floor(0.9*exp.nx);
elseif strcmp(exp.implant_name, 'PRIMA')
    im_ny = floor(0.5*exp.ny);
    im_nx = floor(0.5*exp.nx);
end
image_size = [im_ny, im_nx];


Stimuli_folder =  [Stimuli_folder,'/letters'];
S = load_stimuli_letters(experiment);
best_params = exp.model_params*ones(1,exp.maxiter);
best_params(exp.ib,:) = exp.x_best(exp.ib,:);
g = @(x, optimal_magnitude) loss_function(exp.M, x, S, experiment, 'optimal_magnitude', optimal_magnitude);
[~,p_after_optim] = g(best_params(:,end), []);
[~,p_opt] = g(exp.model_params, 1);

%% Compute the naive encoder
Wi=  naive_encoder(experiment);

range = [2.^(1:floor(log2(exp.maxiter))), exp.maxiter];
nk = numel(range);
percept= [];

for k = 1:nk
    [~,p_optimized] = g(best_params(:,range(k)), []);
    percept = [percept,p_optimized(:,1)];
end

nl = 10;
p = vision_model(exp.M,Wi,S);
graphics_style_paper;

%%
letter2number = @(c)1+lower(c)-'a';
range = [2.^(1:floor(log2(exp.maxiter))), exp.maxiter];
nk = numel(range);
p1= [];
p2= [];
popt = [];
for k = 1:nk
    xm = exp.model_params;
    xm(exp.ib) = exp.xtrain(1:exp.d,range(k));
    [~,percept] = g(xm, []);
    letter = letter2number(experiment.displayed_stim{k});
    p1 = [p1, percept(:,letter)];
    xm = exp.model_params;
    xm(exp.ib) = exp.xtrain((exp.d+1):end,range(k));
    
    [~,percept] = g(xm, []);
    p2 = [p2, percept(:,letter)];
    
     [~,percept] = g(exp.x_best(:, range(k)), []);

%     [~,percept] = g(x_best_unknown_hyps(:, range(k)));
    popt = [popt, percept(:,1)];
end

letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
%%
task = 'preference';
subject = 'BF';
acquisition_fun_name = 'MUC';
mr = 2;
mc = 4;
fig=figure('units','centimeters','outerposition',1+[0 0 16 1.5/2*16]);
fig.Color =  [1 1 1];
fig.Name = 'Fraction preferred';
layout1 = tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','compact');
nt=3;
layout2 = tiledlayout(layout1,6,nt);
layout2.Layout.Tile = 1;
layout2.Layout.TileSpan = [2 2];

layout3 = tiledlayout(layout1,2,4);
layout3.Layout.Tile = 3;
layout3.Layout.TileSpan = [2 2];

c = 0;
s=1;
i=0;
ny = exp.ny;
nx = exp.nx;
for k = 1:nk
    c=c+1;
    img1 = reshape(p1(:,k),ny,nx);
    rgbImage1 = cat(3, img1, img1, img1)./255;
    img2 = reshape(p2(:,k),ny,nx);
    rgbImage2 = cat(3, img2, img2, img2)./255;

    if exp.ctrain(range(k))
        rgbImage1= addborder(rgbImage1, 3,[1,0,0], 'center');
    else
        rgbImage2= addborder(rgbImage2, 3,[1,0,0], 'center');
    end
            h = nexttile(layout2, 1+(c-1)*nt);

        hi = imshow(rgbImage1);
    set(gca,'xtick',[],'ytick',[],'title',[]); 
    set(gca,'dataAspectRatio',[1 1 1])
    h.CLim = [0, 255];

    if k==1
        text(-0.525641025641026, 1.14553014553015,'Iteration','Units','normalized','Fontsize', letter_font)
    end
    ylabel(num2str(range(k)));
    hYLabel = get(gca,'YLabel');
    set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
    h = nexttile(layout2, 2+(c-1)*nt);

            imshow(rgbImage2);
    axis off
    set(gca,'dataAspectRatio',[1 1 1])
    h.CLim = [0, 255];
    
     h = nexttile(layout2, 3+(c-1)*nt);
    imshow(reshape(popt(:,k),ny,nx));
    axis off
    set(gca,'dataAspectRatio',[1 1 1])
    h.CLim = [0, 255];
   
  
end
colormap('gray')


 s_index = 7; %7 11 13
T = load(data_table_file).T;
[p_after_optim, p_opt, p_control, p_after_optim_rand, nx,ny] = encoders_comparison(s_index, T);

h = nexttile(layout3);
i=i+1;
 imagesc(reshape(p_opt(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
set(gca,'dataAspectRatio',[1 1 1])
h.CLim = [0, 255];
title('Ground truth')
 
h = nexttile(layout3);
i=i+1;
 imagesc(reshape(p_after_optim(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
set(gca,'dataAspectRatio',[1 1 1])
h.CLim = [0, 255];
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
title('MaxVarChallenge')
 
h = nexttile(layout3);
i=i+1;
 imagesc(reshape(p_after_optim_rand(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
set(gca,'dataAspectRatio',[1 1 1])
h.CLim = [0, 255];
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
title('Non-adaptive pref.')
 
h =nexttile(layout3);
i=i+1;
 imagesc(reshape(p_control(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
set(gca,'dataAspectRatio',[1 1 1])
h.CLim = [0, 255];
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
title('Random $\phi$')
colormap('gray')

nexttile(layout3, mc/2+1, [mr/2,mc/2])
xlabels = {'Random','Ground truth'};
ylabels = {'Fraction preferred',''};

Y = {acq_vs_random_training, acq_vs_opt_training};
scatter_bar(Y, xlabels, ylabels{1},'boxp', boxp,'stat', 'median', 'pval', 'ineq');
 i=i+1;
text(-1.22,1.05,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize',letter_font) %with compact margins

i=i+1;

 

figname  = ['Figure',num2str(id)];
folder = ['C:\Users\tfauvel\Documents\PhD\Figures\Paper_figures\',figname];
savefig(fig, [folder,'\', figname, '.fig'])
exportgraphics(fig, [folder,'\' , figname, '.pdf']);
exportgraphics(fig, [folder,'\' , figname, '.png'], 'Resolution', 300);
)
colormap('gray')
 

nexttile(layout3, mc/2+1, [mr/2,mc/2])
xlabels = {'Random','Ground truth'};
ylabels = {'Fraction preferred',''};

Y = {acq_vs_random_training, acq_vs_opt_training};
scatter_bar(Y, xlabels, ylabels{1},'boxp', boxp,'stat', 'median', 'pval', 'ineq');
 i=i+1;
text(-1.22,1.05,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize',letter_font) %with compact margins

i=i+1;

 

figname  = ['Figure',num2str(id)];
folder = ['C:\Users\tfauvel\Documents\PhD\Figures\Paper_figures\',figname];
savefig(fig, [folder,'\', figname, '.fig'])
exportgraphics(fig, [folder,'\' , figname, '.pdf']);
exportgraphics(fig, [folder,'\' , figname, '.png'], 'Resolution', 300);
