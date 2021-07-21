function plot_figure_misspecification(id)
%% Plot the VA results with the misspecified encoder
add_modules;
add_directories;
T = load(data_table_file).T;
T = T(T.Acquisition == 'maxvar_challenge' & T.Misspecification == 1,:);

% data_directory = 'C:\Users\tfauvel\Documents\Retinal_Prosthetic_Optimization\Data_former_version';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T = load('C:\Users\tfauvel\Documents\Retinal_Prosthetic_Optimization\Data_former_version\data_table.mat').T;

color =  [0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980];
index = 2;
task = char(T(index,:).Task);
subject = char(T(index,:).Subject);
filename_base = [task,'_', subject, '_', subject,'_',num2str(T(index,:).Index)];
figure_directory = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/Figures/'];

filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];

load(filename, 'experiment');
UNPACK_STRUCT(experiment, false)

add_modules;
add_directories;

optimal_magnitude = 1;
ignore_pickle = 1;
pymod = [];

[Wopt, Mopt, nx,ny] = encoder(true_model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
[Wmiss, Mmiss, nx,ny] = encoder(model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
S = load_stimuli_letters(experiment);
[popt, pmax] = vision_model(M,Wopt,S);
[pmiss, pmax] = vision_model(M,Wmiss,S);

data_directory = [experiment_path,'/Data'];
figures_folder = [experiment_path,'/Figures'];
reload = 0;
 [VA_E_optimized_preference_acq, VA_Snellen_optimized_preference_acq, VA_E_optimal,VA_Snellen_optimal, VA_E_optimized_preference_random,VA_Snellen_optimized_preference_random, VA_E_optimized_preference_acq_misspecification, VA_Snellen_optimized_preference_acq_misspecification, VA_E_optimal_misspecification,VA_Snellen_optimal_misspecification, VA_E_optimized_E_TS,VA_Snellen_optimized_E_TS, VA_E_control,VA_Snellen_control, VA_E_naive, VA_Snellen_naive] = load_VA_results(reload)
 [Pref_vs_E_training, Pref_vs_E_test, acq_vs_random_training, acq_vs_random_test, acq_vs_opt_training, acq_vs_opt_test, optimized_misspecified_vs_optimized_training, optimized_misspecified_vs_optimized_test,optimized_miss_vs_opt_miss_test, optimized_miss_vs_opt_miss_training, acq_vs_control_test, acq_vs_control_training, optimized_vs_naive_training, optimized_vs_naive_test, optimized_miss_vs_control_training, optimized_miss_vs_control_test, optimized_miss_vs_naive_training, optimized_miss_vs_naive_test, control_vs_naive_training, E_vs_naive_training,E_vs_control_training,opt_miss_vs_control_training]  = load_combined_preferences(reload)
boxp = 1;

VA_scale_E= [min([VA_E_optimized_preference_acq,VA_E_optimized_preference_random,VA_E_control]), max([VA_E_optimized_preference_acq,VA_E_optimized_preference_random,VA_E_control])];
VA_scale_Snellen=[min([VA_Snellen_optimized_preference_acq,VA_Snellen_optimized_preference_random,VA_Snellen_control]), max([VA_Snellen_optimized_preference_acq,VA_Snellen_optimized_preference_random,VA_Snellen_control])];
VA_scale = [min(VA_scale_E(1), VA_scale_Snellen(1)),max(VA_scale_E(2), VA_scale_Snellen(2))];
VA_scale = [VA_scale;VA_scale];

VA_scale_E = [VA_scale_E;VA_scale_E];
VA_scale_Snellen = [VA_scale_Snellen;VA_scale_Snellen];

pref_scale = [0,1;0,1];

k = 1;
letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
graphics_style_paper;

tail = 'both';
mr = 2;
mc = 4;

fig=figure('units','centimeters','outerposition',1+f*[0 0 16 0.66*16]);
fig.Color =  [1 1 1];
fig.Name = 'Ground truth vs misspecified';

layout1 = tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','compact');

% layout2 = tiledlayout(layout1,1,4);
% layout2.Layout.Tile = 5;
% layout2.Layout.TileSpan = [1,4];

i=0;

I = imread([paper_figures_folder,'axon_map_model.png']);
I = imresize(I, 0.09)
h = nexttile(layout1);
i=i+1;

%I = imresize(I,3);
p = image(I)
axis image
axis off
title('True axons map')
text(-0.18,1.15,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

I = imread([paper_figures_folder, '/axon_map_model_misspecified.png']);
h = nexttile(layout1);
i=i+1;

I = imresize(I, 0.09);
p = image(I)
axis image
axis off
title('Misspecified axons map')

text(-0.18,1.15,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

h =nexttile(layout1);
i=i+1;
 imagesc(reshape(popt(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
set(gca,'dataAspectRatio',[1 1 1])
h.CLim = [0, 255];
colormap(gca,'gray')
title('Ground truth')

text(-0.18,1.15,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

h = nexttile(layout1);
i=i+1;
imagesc(reshape(pmiss(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
set(gca,'dataAspectRatio',[1 1 1])
h.CLim = [0, 255];
colormap(gca,'gray')
title('Misspecified')

text(-0.18,1.15,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

h = nexttile(layout1);
i=i+1;
X{1} = VA_E_optimal;
Y{1} = VA_E_optimal_misspecification;
X{2} = VA_Snellen_optimal;
Y{2} = VA_Snellen_optimal_misspecification;

scatter_plot_combined(X,Y, tail,['LogMAR' newline '(ground truth)'], ['LogMAR' newline '(misspecified)'], VA_scale, 'categories', {'E', 'Snellen'}, 'legend_position', 'north'); %H1 : x – y come from a distribution with median less than 0
text(-0.18,1.15,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

h = nexttile(layout1);
i=i+1;
Y{1} = VA_E_optimal_misspecification;
X{1} = VA_E_control;
X{2} = VA_Snellen_control;
Y{2} = VA_Snellen_optimal_misspecification;

scatter_plot_combined(X,Y, tail,['LogMAR' newline '(control)'], ['LogMAR' newline '(misspecified)'], VA_scale, 'categories', {'E', 'Snellen'}, 'legend_position', 'north'); %H1 : x – y come from a distribution with median less than 0
text(-0.18,1.15,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

h = nexttile(layout1);
i=i+1;
Y{1} = VA_E_optimal_misspecification;
X{1} = VA_E_naive;
X{2} = VA_Snellen_naive;
Y{2} = VA_Snellen_optimal_misspecification;

scatter_plot_combined(X,Y, tail,['LogMAR' newline '(naive)'], ['LogMAR' newline '(misspecified)'], VA_scale, 'categories', {'E', 'Snellen'}, 'legend_position', 'north'); %H1 : x – y come from a distribution with median less than 0
text(-0.18,1.15,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)


h = nexttile(layout1);
 i=i+1;
xlabels = {'Miss. vs Control'};
ylabels = {'Fraction preferred',''};

Y = {opt_miss_vs_control_training};

scatter_bar(Y, xlabels, ylabels{1},'boxp', boxp,'stat', 'median', 'pval', 'ineq', 'rotation', 0);
text(-0.18,1.15,['$\bf{', letters(i), '}$'], 'Units','normalized','Fontsize', letter_font)

% 
% nexttile()
% y = VA_Snellen_optimized_preference_acq_misspecification;
% x = VA_Snellen_control;
% scatter_plot(x,y, tail,'Control','Challenge, miss.',VA_scale_Snellen, 'color', colors_chart(2,:), 'title_str', 'Snellen');  %H1 : x – y come from a distribution with median greater than 0
% text(-0.18,1.15,'$\bf{H}$','Units','normalized','Fontsize', letter_font)
figname  = ['Figure',num2str(id)];
folder = [paper_figures_folder,'Figure_',num2str(id),'/'];
if ~isdir(folder)
    mkdir(folder)
end

savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);

