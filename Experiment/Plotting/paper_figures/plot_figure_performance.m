function plot_figure_performance(id, varargin)%% Plot the results of the performance-based optimization
add_directories;
graphics_style_paper;


data_directory = [experiment_path,'/Data'];
figures_folder = [experiment_path,'/Figures'];
reload = 0;
VA= load_VA_results(reload, data_directory, data_table_file);
pref  = load_preferences(reload,data_directory, data_table_file);
boxp = 1;

VA_scale_E= [min([VA.VA_E_optimized_preference_acq,VA.VA_E_optimized_preference_random,VA.VA_E_control]), max([VA.VA_E_optimized_preference_acq,VA.VA_E_optimized_preference_random,VA.VA_E_control])];
VA_scale_Snellen=[min([VA.VA_Snellen_optimized_preference_acq,VA.VA_Snellen_optimized_preference_random,VA.VA_Snellen_control]), max([VA.VA_Snellen_optimized_preference_acq,VA.VA_Snellen_optimized_preference_random,VA.VA_Snellen_control])];
VA_scale = [min(VA_scale_E(1), VA_scale_Snellen(1)),max(VA_scale_E(2), VA_scale_Snellen(2))];
VA_scale = [VA_scale;VA_scale];

VA_scale_E = [VA_scale_E;VA_scale_E];
VA_scale_Snellen = [VA_scale_Snellen;VA_scale_Snellen];
pref_scale = [0,1;0,1];

tail = 'both';
mr =1;
mc = 4;

legend_pos = [-0.18,1.15];

fig=figure('units','centimeters','outerposition',1+[0 0 16 16/2]);
fig.Color =  [1 1 1];

i = 0;
tiledlayout(mr,mc, 'TileSpacing', 'compact', 'padding','tight')
t = nexttile();
i=i+1;

Y{1} = VA.VA_E_optimized_E_TS;
X{1} = VA.VA_E_control;
Y{2} = VA.VA_Snellen_optimized_E_TS;
X{2} = VA.VA_Snellen_control;

scatter_plot_combined(X,Y, tail,'logMAR (random $\phi$)','logMAR (performance-based)',VA_scale, 'categories', {'E', 'Snellen'}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)
 
pos = get(gca, 'Position');
nexttile();
i=i+1;

 Y{1} =  VA.VA_E_optimized_E_TS;
X{1} = VA.VA_E_optimized_preference_acq;
Y{2} = VA.VA_Snellen_optimized_E_TS;
X{2} = VA.VA_Snellen_optimized_preference_acq;

scatter_plot_combined(X, Y, tail,'logMAR (adaptive pref.)', '',VA_scale, 'categories', {'E', 'Snellen'}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0

text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

mc =2;
t = nexttile([1,mc]);
i=i+1;
% Y = {pref.E_vs_naive_training, pref.E_vs_control_training, 1-pref.Pref_vs_E_training};
% xlabels = {'Naive', 'Control', 'Adaptive pref.'};
Y = {pref.E_vs_control_training, 1-pref.Pref_vs_E_training};
% Y = {pref.E_vs_control_test, 1-pref.Pref_vs_E_test};

xlabels = {'Random $\phi$', 'Adaptive pref.'};

ylabels = {'Fraction preferred',''};
h = scatter_bar(Y, xlabels, ylabels{1},'boxp', boxp,'stat', 'median', 'pval', 'ineq', 'pba', [mc,1,1], 'test', 'Bayes', 'Ncomp', 13);
% pbaspect([1,1,1])
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)
pos2 = get(gca, 'Position');
set(gca, 'Position', [pos2(1), pos(2), pos2(3), pos(4)])


figname  = 'performance_based_opt';
folder = [paper_figures_folder,figname,'/'];
if ~isdir(folder)
    mkdir(folder)
end

savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);
