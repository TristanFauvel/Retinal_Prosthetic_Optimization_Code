function plot_figure_misspecification(id)
%% Plot the VA results with the misspecified encoder
add_directories;
T = load(data_table_file).T;
T = T(T.Acquisition == 'maxvar_challenge' & T.Misspecification == 1,:);

% data_directory = 'C:\Users\tfauvel\Documents\Retinal_Prosthetic_Optimization\Data_former_version';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T = load('C:\Users\tfauvel\Documents\Retinal_Prosthetic_Optimization\Data_former_version\data_table.mat').T;

index = 2;
task = char(T(index,:).Task);
subject = char(T(index,:).Subject);

filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];

load(filename, 'experiment');
UNPACK_STRUCT(experiment, false)

pymod = [];
ignore_pickle=1; % Wether to use a precomputed axon map (0) or not (1)
optimal_magnitude = 0;

[Wopt, Mopt, nx,ny] = encoder(true_model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
[Wmiss, Mmiss, nx,ny] = encoder(model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
S = load_stimuli_letters(experiment);
[popt, pmax] = vision_model(Mopt,Wopt,S);
[pmiss, pmax] = vision_model(Mopt,Wmiss,S);


data_directory = [experiment_path,'/Data'];
figures_folder = [experiment_path,'/Figures'];
reload = 0;
VA= load_VA_results(reload, data_directory, data_table_file);
pref  = load_preferences(reload,data_directory, data_table_file);
boxp = 1;

VA_E_combined = [VA.VA_E_optimized_preference_acq,VA.VA_E_optimized_preference_random, ...
    VA.VA_E_control, VA.VA_E_control, VA.VA_E_optimized_preference_acq_misspecification, ...
    VA.VA_E_optimal_misspecification, VA.VA_E_optimized_E_TS, VA.VA_E_naive];
VA_Snellen_combined = [VA.VA_Snellen_optimized_preference_acq,VA.VA_Snellen_optimized_preference_random, ...
    VA.VA_Snellen_control, VA.VA_Snellen_control, VA.VA_Snellen_optimized_preference_acq_misspecification, ...
    VA.VA_Snellen_optimal_misspecification, VA.VA_Snellen_optimized_E_TS, VA.VA_Snellen_naive];

VA_scale_E= [min(VA_E_combined), max(VA_E_combined)];
VA_scale_Snellen=[min(VA_Snellen_combined), max(VA_Snellen_combined)];
VA_scale = [min(VA_scale_E(1), VA_scale_Snellen(1)),max(VA_scale_E(2), VA_scale_Snellen(2))];
VA_scale = [VA_scale;VA_scale];

% VA_scale_E = [VA_scale_E;VA_scale_E];
% VA_scale_Snellen = [VA_scale_Snellen;VA_scale_Snellen];

pref_scale = [0,1;0,1];

k = 1;
letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
graphics_style_paper;

tail = 'both';
mr = 1;
mc = 3;

fig=figure('units','centimeters','outerposition',1+[0 0 16 0.66*16]);
fig.Color =  [1 1 1];
fig.Name = 'Ground truth vs misspecified';

layout1 = tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','compact');

i=0;

h =nexttile(layout1);

i=i+1;
imagesc(reshape(S(:,1),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[],'dataAspectRatio',[1 1 1],'Fontsize', Fontsize)
h.CLim = [0, 1];
colormap(gca,'gray')
title('Stimulus')

% text(-0.18,1.15,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)


i=i+1;
h = nexttile(layout1);
imagesc(reshape(popt(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[],'dataAspectRatio',[1 1 1],'Fontsize', Fontsize)
h.CLim = [0, 255];
colormap(gca,'gray')
title('Ground truth')

% text(-0.18,1.15,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

h = nexttile(layout1);
i=i+1;
imagesc(reshape(pmiss(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[],'dataAspectRatio',[1 1 1],'Fontsize', Fontsize)
h.CLim = [0, 255];
colormap(gca,'gray')
title('Misspecified')

figname  = 'Misspecification_effect';
folder = [paper_figures_folder,figname,'/'];
if ~isdir(folder)
    mkdir(folder)
end

savefig(fig, [folder,'/', figname, '_1.fig'])
exportgraphics(fig, [folder,'/' , figname, '_1.pdf']);
exportgraphics(fig, [folder,'/' , figname, '_1.png'], 'Resolution', 300);


%%
mr = 1;
mc = 4;
 
fig=figure('units','centimeters','outerposition',1+[0 0 16 0.66*16]);
fig.Color =  [1 1 1];
fig.Name = 'Ground truth vs misspecified';

layout1 = tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','compact');

h = nexttile(layout1);
i=i+1;
X{1} = VA.VA_E_optimal;
Y{1} = VA.VA_E_optimal_misspecification;
X{2} = VA.VA_Snellen_optimal;
Y{2} = VA.VA_Snellen_optimal_misspecification;

scatter_plot_combined(X,Y, tail,['logMAR' newline '(ground truth)'], ['logMAR' newline '(misspecified)'], VA_scale, 'categories', {'E', 'Snellen'}, 'legend_position', 'north'); %H1 : x – y come from a distribution with median less than 0
text(-0.18,1.15,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

h = nexttile(layout1);
i=i+1;
Y{1} = VA.VA_E_optimal_misspecification;
X{1} = VA.VA_E_control;
X{2} = VA.VA_Snellen_control;
Y{2} = VA.VA_Snellen_optimal_misspecification;

scatter_plot_combined(X,Y, tail,['logMAR' newline '(random $\phi$)'], ['logMAR' newline '(misspecified)'], VA_scale, 'categories', {'E', 'Snellen'}, 'legend_position', 'north'); %H1 : x – y come from a distribution with median less than 0
text(-0.18,1.15,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

% h = nexttile(layout1);
% i=i+1;
% Y{1} = VA.VA_E_optimal_misspecification;
% X{1} = VA.VA_E_naive;
% X{2} = VA.VA_Snellen_naive;
% Y{2} = VA.VA_Snellen_optimal_misspecification;
% 
% scatter_plot_combined(X,Y, tail,['logMAR' newline '(naive)'], ['logMAR' newline '(misspecified)'], VA_scale, 'categories', {'E', 'Snellen'}, 'legend_position', 'north'); %H1 : x – y come from a distribution with median less than 0
% text(-0.18,1.15,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)


h = nexttile(layout1);
i=i+1;
xlabels = {'Miss. vs random $\phi'};
ylabels = {'Fraction preferred',''};

Y = {pref.opt_miss_vs_control_training};

scatter_bar(Y, xlabels, ylabels{1},'boxp', boxp,'stat', 'median', 'pval', 'ineq', 'rotation', 0, 'test', 'Bayes', 'Ncomp', 13);
text(-0.18,1.15,['$\bf{', letters(i), '}$'], 'Units','normalized','Fontsize', letter_font)

%
% nexttile()
% y = VA.VA_Snellen_optimized_preference_acq_misspecification;
% x = VA.VA_Snellen_control;
% scatter_plot(x,y, tail,'Control','Challenge, miss.',VA_scale_Snellen, 'color', colors_chart(2,:), 'title_str', 'Snellen');  %H1 : x – y come from a distribution with median greater than 0
% text(-0.18,1.15,'$\bf{H}$','Units','normalized','Fontsize', letter_font)

savefig(fig, [folder,'/', figname, '_2.fig'])
exportgraphics(fig, [folder,'/' , figname, '_2.pdf']);
exportgraphics(fig, [folder,'/' , figname, '_2.png'], 'Resolution', 300);


