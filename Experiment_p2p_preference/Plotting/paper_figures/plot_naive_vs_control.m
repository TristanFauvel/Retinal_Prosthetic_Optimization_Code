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

legend_pos = [-0.18,1];


VA_scale_E= [min([VA.VA_E_control, VA.VA_E_naive]), max([VA.VA_E_control, VA.VA_E_naive])];
VA_scale_Snellen=[min([VA.VA_Snellen_control, VA.VA_Snellen_naive]), max([VA.VA_Snellen_control, VA.VA_Snellen_naive])];

VA_scale = [min(VA_scale_E(1), VA_scale_Snellen(1)),max(VA_scale_E(2), VA_scale_Snellen(2))];
VA_scale = [VA_scale;VA_scale];

boxp = 1;

i = 0;
fig=figure('units','centimeters','outerposition',1+[0 0 0.5*16 0.5*16]);
fig.Color =  [1 1 1];
subplot(1,2,1)

xlabels = {'Control vs naive'};
ylabels = {'Fraction preferred',''};

Y = {pref.control_vs_naive_training};

scatter_bar(Y, xlabels, ylabels{1},'boxp', boxp,'stat', 'median', 'pval', 'ineq', 'pba', [1,1,1]);
i=i+1;
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize',letter_font) %with compact margins
 
subplot(1,2,2)

tail = 'both';
i=i+1;
Y{1} = VA.VA_E_naive;
X{1} = VA.VA_E_control;
Y{2} = VA.VA_Snellen_naive;
X{2} = VA.VA_Snellen_control;
scatter_plot_combined(X,Y, tail,['LogMAR' newline '(control)'],['LogMAR' newline '(naive)'],VA_scale, 'categories', {'E','Snellen'}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)



figname  = 'Parameterization_effect';
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);
