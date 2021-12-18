function plot_figure_misspecified_opt(varargin)
%% Plot the VA results with the misspecified encoder
add_modules;
add_directories;
T = load(data_table_file).T;
T = T(T.Acquisition == 'MUC' & T.Misspecification == 1,:);

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

if ~isfield(experiment, 'M')
    ignore_pickle=1; % Wether to use a precomputed axon map (0) or not (1)
    optimal_magnitude = 0;
    pymod = [];
    [~, M] = encoder(experiment.true_model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
end


[Wopt, Mopt, nx,ny] = encoder(true_model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
[Wmiss, Mmiss, nx,ny] = encoder(model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
S = load_stimuli_letters(experiment);
[popt, pmax] = vision_model(M,Wopt,S);
[pmiss, pmax] = vision_model(M,Wmiss,S);

data_directory = [experiment_path,'/Data'];
figures_folder = [experiment_path,'/Figures'];
reload = 0;
VA = load_VA_results(reload,data_directory, data_table_file);
pref = load_preferences(reload,data_directory, data_table_file);
boxp = 1;

% VA_scale_E= [min([VA.VA_E_optimized_preference_acq,VA.VA_E_optimized_preference_random,VA.VA_E_control]), max([VA.VA_E_optimized_preference_acq,VA.VA_E_optimized_preference_random,VA.VA_E_control])];
% VA_scale_Snellen=[min([VA.VA_Snellen_optimized_preference_acq,VA.VA_Snellen_optimized_preference_random,VA.VA_Snellen_control]), max([VA.VA_Snellen_optimized_preference_acq,VA.VA_Snellen_optimized_preference_random,VA.VA_Snellen_control])];
% VA_scale = [min(VA_scale_E(1), VA_scale_Snellen(1)),max(VA_scale_E(2), VA_scale_Snellen(2))];
% VA_scale = [VA_scale;VA_scale];

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



VA_scale_E = [VA_scale_E;VA_scale_E];
VA_scale_Snellen = [VA_scale_Snellen;VA_scale_Snellen];

pref_scale = [0,1;0,1];

k = 1;
 graphics_style_paper;

tail = 'both';
mr = 1;
mc = 4;

fig=figure('units','centimeters','outerposition',1+[0 0 16 0.6*16]);
fig.Color =  [1 1 1];
fig.Name = 'Ground truth vs misspecified';

layout1 = tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','compact');

% layout2 = tiledlayout(layout1,1,4);
% layout2.Layout.Tile = 5;
% layout2.Layout.TileSpan = [1,4];

i=0;

% h = nexttile(layout1);
% i=i+1;
% X{1} = VA.VA_E_naive;
% Y{1} = VA.VA_E_optimized_preference_acq_misspecification;
% X{2} = VA.VA_Snellen_naive;
% Y{2} = VA.VA_Snellen_optimized_preference_acq_misspecification;
% 
% scatter_plot_combined(X,Y, tail,['logMAR' newline '(naive)'], ['logMAR' newline '(challenge miss.)'], VA_scale,  'categories', {'E', 'Snellen'}, 'legend_position', 'north'); %H1 : x – y come from a distribution with median less than 0
% text(-0.18,1.15,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

i=3;
h = nexttile(layout1, i);
Y{1} = VA.VA_E_optimized_preference_acq_misspecification;
X{1} = VA.VA_E_control;
X{2} = VA.VA_Snellen_control;
Y{2} = VA.VA_Snellen_optimized_preference_acq_misspecification;

scatter_plot_combined(X,Y, tail,['logMAR' newline '(random $\phi$)'],['logMAR' newline '(opt. miss.)'], VA_scale,  'categories', {'E', 'Snellen'}, 'legend_position', 'north'); %H1 : x – y come from a distribution with median less than 0
text(-0.18,1.15,['$\bf{', letters(2), '}$'],'Units','normalized','Fontsize', letter_font)

i=4;
h = nexttile(layout1,i);
X{1} = VA.VA_E_optimal_misspecification;
Y{1} = VA.VA_E_optimized_preference_acq_misspecification;
X{2} = VA.VA_Snellen_optimal_misspecification;
Y{2} = VA.VA_Snellen_optimized_preference_acq_misspecification;
scatter_plot_combined(X,Y, tail,['logMAR' newline '(misspecified)'],'', VA_scale,  'categories', {'E', 'Snellen'}, 'legend_position', 'north'); %H1 : x – y come from a distribution with median less than 0
text(-0.18,1.15,['$\bf{', letters(3), '}$'],'Units','normalized','Fontsize', letter_font)

% i=4;
% h = nexttile(layout1,i);
% X{1} = VA.VA_E_optimized_preference_acq;
% Y{1} = VA.VA_E_optimized_preference_acq_misspecification;
% X{2} = VA.VA_Snellen_optimized_preference_acq;
% Y{2} = VA.VA_Snellen_optimized_preference_acq_misspecification;
% scatter_plot_combined(X,Y, tail,['logMAR' newline '(adaptive pref.)'],'', VA_scale,  'categories', {'E', 'Snellen'}, 'legend_position', 'north'); %H1 : x – y come from a distribution with median less than 0
% text(-0.18,1.15,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

i=1;
h = nexttile(layout1,[1,2]);
xlabels = {'Control miss.', 'Control','Misspecified'};
ylabels = {'Fraction preferred',''};

Y = {pref.optimized_miss_vs_controlmiss_training, pref.optimized_miss_vs_control_training, pref.optimized_miss_vs_opt_miss_training};

scatter_bar(Y, xlabels, ylabels{1},'boxp', boxp,'stat', 'median', 'pval', 'ineq', 'rotation', 0 ,'Ncomp', 13,'pba', [2,1,1]);
text(-0.18,1.15,['$\bf{', letters(1), '}$'], 'Units','normalized','Fontsize', letter_font)


% 
% nexttile()
% y = VA.VA_Snellen_optimized_preference_acq_misspecification;
% x = VA.VA_Snellen_control;
% scatter_plot(x,y, tail,'Control','Challenge, miss.',VA_scale_Snellen, 'color', colors_chart(2,:), 'title_str', 'Snellen');  %H1 : x – y come from a distribution with median greater than 0
% text(-0.18,1.15,'$\bf{H}$','Units','normalized','Fontsize', letter_font)

figname  = 'Misspecified_opt';
folder = [paper_figures_folder,'Figure_',figname,'/'];
if ~isdir(folder)
    mkdir(folder)
end

savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);

%%
% figure()
% xlabels = {'Control miss.', 'Control','Misspecified', 'Adaptive pref.'};
% ylabels = {'Fraction preferred',''};
% 
% Y = {mean([pref.optimized_miss_vs_controlmiss_training; pref.optimized_miss_vs_controlmiss_test],1), ...
%     mean([pref.optimized_miss_vs_control_training; pref.optimized_miss_vs_control_test],1), ...
%     mean([pref.optimized_miss_vs_opt_miss_training; pref.optimized_miss_vs_control_test],1), ...
%     mean([pref.optimized_misspecified_vs_optimized_training; pref.optimized_misspecified_vs_optimized_test],1)};
% 
% scatter_bar(Y, xlabels, ylabels{1},'boxp', boxp,'stat', 'median', 'pval', 'ineq', 'rotation', 45, 'test', 'Bayes', 'Ncomp', 26);
% text(-0.18,1.15,['$\bf{', letters(i), '}$'], 'Units','normalized','Fontsize', letter_font)
