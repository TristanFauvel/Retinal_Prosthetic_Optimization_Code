function plot_figure_Value_VA(id)
add_directories;
reload = 0;
[VA_E_optimized_preference_acq, VA_Snellen_optimized_preference_acq, VA_E_optimal,VA_Snellen_optimal, VA_E_optimized_preference_random,VA_Snellen_optimized_preference_random, VA_E_optimized_preference_acq_misspecification, VA_Snellen_optimized_preference_acq_misspecification, VA_E_optimal_misspecification,VA_Snellen_optimal_misspecification, VA_E_optimized_E_TS,VA_Snellen_optimized_E_TS, VA_E_control,VA_Snellen_control] = load_VA_results(reload);
[Pref_vs_E_training, Pref_vs_E_test, acq_vs_random_training, acq_vs_random_test, acq_vs_opt_training, acq_vs_opt_test, optimized_misspecified_vs_optimized_training, optimized_misspecified_vs_optimized_test]  = load_preferences(reload);
graphics_style_paper;
%% Plot the relationship between VA and value

[val_optimized_preference_acq, val_optimal, val_optimized_preference_random, val_optimized_preference_acq_misspecification, val_optimal_misspecification, val_optimized_E_TS,val_control] = load_values(0);

mr = 1;
mc = 2;

tiledlayout(mr,mc)
nexttile()
y = [VA_E_optimized_preference_acq, VA_E_optimized_preference_random;
x = val_optimized_preference_acq-val_optimized_preference_random;
tail = 'both'; %'right';
scatter_plot(x,y,tail,'VA MaxVarChallenge/Random','value MaxVarChallenge/Random',[], 'equal_axes', 0, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')

nexttile()
y = VA_E_optimized_preference_acq./VA_E_optimal;
x = val_optimized_preference_acq-val_optimal;
tail = 'both'; %'right';
scatter_plot(x,y,tail,'VA MaxVarChallenge/Ground truth','value MaxVarChallenge/Ground truth',[], 'equal_axes', 0, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')

nexttile()
y = VA_E_optimized_preference_acq-VA_E_optimized_preference_random;
x = acq_vs_random_training;
tail = 'both'; %'right';
scatter_plot(x,y,tail,'Preference MaxVarChallenge/Random','VA MaxVarChallenge/Random',[], 'equal_axes', 0, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')

nexttile()
y = VA_E_optimized_preference_acq-VA_E_optimal;
x = acq_vs_opt_training;
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
