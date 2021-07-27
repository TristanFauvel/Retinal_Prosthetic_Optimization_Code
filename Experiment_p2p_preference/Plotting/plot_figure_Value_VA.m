function plot_figure_Value_VA(id)
add_directories;
reload = 0;

data_directory = [experiment_path,'/Data'];
figures_folder = [experiment_path,'/Figures'];
reload = 0;
VA= load_VA_results(reload, data_directory, data_table_file);
p  = load_preferences(reload,data_directory, data_table_file);
graphics_style_paper;
%% Plot the relationship between VA and value

val = load_values(0);

mr = 1;
mc = 2;

tiledlayout(mr,mc)
nexttile()
y = [VA.VA_E_optimized_preference_acq, VA.VA_E_optimized_preference_random;
x = val.optimized_preference_acq-val.optimized_preference_random;
tail = 'both'; %'right';
scatter_plot(x,y,tail,'VA MaxVarChallenge/Random','value MaxVarChallenge/Random',[], 'equal_axes', 0, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')

nexttile()
y = VA.VA_E_optimized_preference_acq./VA.VA_E_optimal;
x = val.optimized_preference_acq-val.optimal;
tail = 'both'; %'right';
scatter_plot(x,y,tail,'VA MaxVarChallenge/Ground truth','value MaxVarChallenge/Ground truth',[], 'equal_axes', 0, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')

nexttile()
y = VA.VA_E_optimized_preference_acq-VA.VA_E_optimized_preference_random;
x = p.acq_vs_random_training;
tail = 'both'; %'right';
scatter_plot(x,y,tail,'Preference MaxVarChallenge/Random','VA MaxVarChallenge/Random',[], 'equal_axes', 0, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')

nexttile()
y = VA.VA_E_optimized_preference_acq-VA.VA_E_optimal;
x = p.acq_vs_opt_training;
tail = 'both'; %'right';
scatter_plot(x,y,tail,'Preference MaxVarChallenge/Ground truth','VA MaxVarChallenge/Ground truth',[], 'equal_axes', 0, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')

figname  = 'Figure8';
folder = [paper_figures_folder,'Figure_',num2str(id),'/'];
if ~isdir(folder)
    mkdir(folder)
end
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);
