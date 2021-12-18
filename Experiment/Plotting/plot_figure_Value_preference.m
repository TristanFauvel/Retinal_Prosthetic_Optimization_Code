function plot_figure_Value_preference(id)
add_directories;
reload = 0;
pref = load_preferences(reload, data_directory, data_table_file);
val = load_values(0, data_directory, data_table_file);
va = load_VA_results(reload, data_directory, data_table_file);

graphics_style_paper;
%% Plot the relationship between VA and measured preference

mr = 2;
mc = 2;
fig=figure('units','centimeters','outerposition',1+[0 0 16 fheight(mr)]);
fig.Color =  [1 1 1];

tiledlayout(mr,mc)
nexttile()
y = [va.VA_E_optimized_preference_acq-va.VA_E_optimized_preference_random];
x = val.optimized_preference_acq-val.optimized_preference_random;
tail = 'both'; %'right';
scatter_plot(x,y,tail,'VA MaxVarChallenge/Random','value MaxVarChallenge/Random',[], 'equal_axes', 0, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')

nexttile()
y = va.VA_E_optimized_preference_acq./va.VA_E_optimal;
x = val.optimized_preference_acq-val.optimal;
tail = 'both'; %'right';
scatter_plot(x,y,tail,'VA MaxVarChallenge/Ground truth','value MaxVarChallenge/Ground truth',[], 'equal_axes', 0, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')

nexttile()
y = va.VA_E_optimized_preference_acq-va.VA_E_optimized_preference_random;
x = pref.acq_vs_random_training;
tail = 'both'; %'right';
scatter_plot(x,y,tail,'Preference MaxVarChallenge/Random','VA MaxVarChallenge/Random',[], 'equal_axes', 0, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')

nexttile()
y = va.VA_E_optimized_preference_acq-va.VA_E_optimal;
x = pref.acq_vs_opt_training;
tail = 'both'; %'right';
scatter_plot(x,y,tail,'Preference MaxVarChallenge/Ground truth','VA MaxVarChallenge/Ground truth',[], 'equal_axes', 0, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')

figname  = ['Figure',num2str(id)];
folder = [paper_figures_folder,'Figure_',num2str(id),'/'];
if ~isdir(folder)
    mkdir(folder)
end
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);
