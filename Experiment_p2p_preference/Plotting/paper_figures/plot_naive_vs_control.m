function plot_naive_vs_control

%% Plot the results of the preference-based optimization
graphics_style_paper;

add_directories
graphics_style_paper;
folder = paper_figures_folder;
data_directory = [experiment_path,'/Data'];
figures_folder = [experiment_path,'/Figures'];
reload = 0;
VA= load_VA_results(reload, data_directory, data_table_file);
pref  = load_preferences(reload,data_directory, data_table_file);

legend_pos = [-0.18,1.1];


% VA_scale_E= [min([VA.VA_E_control, VA.VA_E_naive]), max([VA.VA_E_control, VA.VA_E_naive])];
% VA_scale_Snellen=[min([VA.VA_Snellen_control, VA.VA_Snellen_naive]), max([VA.VA_Snellen_control, VA.VA_Snellen_naive])];
% 
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

boxp = 1;
load('subjects_to_remove.mat', 'subjects_to_remove') %remove data from participants who did not complete the experiment;

T = load(data_table_file).T;
T = T(all(T.Subject ~= subjects_to_remove,2),:);
% s_index = find(T.Subject == 'PC', :)
s_index = 2;
T = T(T.Subject == 'PC', :);
[p_after_optim, p_opt, p_control, p_after_optim_rand, p_naive, nx,ny] = encoders_comparison(s_index, T);

mr = 1;
mc = 4;
i = 0;
k=1;
fig=figure('units','centimeters','outerposition',1+[0 0 16 0.5*16]);
fig.Color =  [1 1 1];
tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','compact');

h =  nexttile;
i=i+1;
imagesc(reshape(p_naive(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[],'dataAspectRatio',[1 1 1], 'Fontsize', Fontsize),
h.CLim = [0, 255];
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
title('Naive encoder')
colormap('gray')
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize',letter_font) %with compact margins


h = nexttile;
i=i+1;
imagesc(reshape(p_control(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[],'dataAspectRatio',[1 1 1], 'Fontsize', Fontsize)
h.CLim = [0, 255];
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
title('Random $\phi$')
colormap('gray')
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize',letter_font) %with compact margins

nexttile(4)
tail = 'both';
i=4;
Y{1} = VA.VA_E_naive;
X{1} = VA.VA_E_control;
Y{2} = VA.VA_Snellen_naive;
X{2} = VA.VA_Snellen_control;
scatter_plot_combined(X,Y, tail,['logMAR' newline '(random $\phi$)'],['logMAR' newline '(naive)'],VA_scale, 'categories', {'E','Snellen'}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

h = nexttile(3);
xlabels = {'Random $\phi$ vs naive'};
ylabels = {'Fraction preferred',''};
Y = {pref.control_vs_naive_training};
scatter_bar(Y, xlabels, ylabels{1},'boxp', boxp,'stat', 'median', 'pval', 'ineq', 'pba', [1,1,1], ...
    'test', 'Bayes', 'Ncomp', 13);
i=3
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize',letter_font) %with compact margins
 

figname  = 'Parameterization_effect';
folder = [folder,figname];
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);
 colormap('gray')
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize',letter_font) %with compact margins

nexttile(4)
tail = 'both';
i=4;
Y{1} = VA.VA_E_naive;
X{1} = VA.VA_E_control;
Y{2} = VA.VA_Snellen_naive;
X{2} = VA.VA_Snellen_control;
scatter_plot_combined(X,Y, tail,['logMAR' newline '(random $\phi$)'],['logMAR' newline '(naive)'],VA_scale, 'categories', {'E','Snellen'}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

h = nexttile(3);
xlabels = {'Random $\phi$ vs naive'};
ylabels = {'Fraction preferred',''};
Y = {pref.control_vs_naive_training};
scatter_bar(Y, xlabels, ylabels{1},'boxp', boxp,'stat', 'median', 'pval', 'ineq', 'pba', [1,1,1], ...
    'test', 'Bayes', 'Ncomp', 13);
i=3
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize',letter_font) %with compact margins
 

figname  = 'Parameterization_effect';
folder = [folder,figname];
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);

