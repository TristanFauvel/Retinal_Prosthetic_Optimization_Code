function plot_figure_E_Snellen(id)
%% Plot the comparisons between Snellen VA and Tumbling E VA.
reload = 0;
[VA_E_optimized_preference_acq, VA_Snellen_optimized_preference_acq, VA_E_optimal,VA_Snellen_optimal, VA_E_optimized_preference_random,VA_Snellen_optimized_preference_random, VA_E_optimized_preference_acq_misspecification, VA_Snellen_optimized_preference_acq_misspecification, VA_E_optimal_misspecification,VA_Snellen_optimal_misspecification, VA_E_optimized_E_TS,VA_Snellen_optimized_E_TS, VA_E_control,VA_Snellen_control] = load_VA_results(reload);
 [Pref_vs_E_training, Pref_vs_E_test, acq_vs_random_training, acq_vs_random_test, acq_vs_opt_training, acq_vs_opt_test, optimized_misspecified_vs_optimized_training, optimized_misspecified_vs_optimized_test,optimized_miss_vs_opt_miss_test, optimized_miss_vs_opt_miss_training, acq_vs_control_test, acq_vs_control_training, optimized_vs_naive_training, optimized_vs_naive_test, optimized_miss_vs_control_training, optimized_miss_vs_control_test, optimized_miss_vs_naive_training, optimized_miss_vs_naive_test, control_vs_naive_training, E_vs_naive_training,E_vs_control_training,opt_miss_vs_control_training]  = load_combined_preferences(reload)

graphics_style_paper;
letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
i = 0;
mr = 1;
mc = 4;
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','tight')
nexttile();
i = i+1;
x = VA_E_control;
y= VA_Snellen_control;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Tumbling E', 'Snellen',[], 'equal_axes', 0, 'linreg', 1,'title_str', 'Control'); % H1: x – y come from a distribution with greater than 0
text(-0.18,1.15,'$\bf{A}$','Units','normalized','Fontsize',  letter_font)

nexttile();
i = i+1;
x = VA_E_optimal;
y = VA_Snellen_optimal;
tail = 'both';
scatter_plot(x,y, tail,'Tumbling E', '', [], 'equal_axes', 0, 'linreg', 1, 'title_str', 'Ground truth'); %H1 : x – y come from a distribution with median different than 0*
text(-0.18,1.15,'$\bf{B}$','Units','normalized','Fontsize',  letter_font)

nexttile();
i = i+1;
x = VA_E_optimized_preference_random;
y = VA_Snellen_optimized_preference_random;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Tumbling E', '', [], 'equal_axes', 0,  'linreg', 1,'title_str', 'Random');  %H1 : x – y come from a distribution with median greater than 0
text(-0.18,1.15,'$\bf{C}$','Units','normalized','Fontsize',  letter_font)

nexttile();
i = i+1;
x = VA_E_optimized_preference_acq;
y= VA_Snellen_optimized_preference_acq;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Tumbling E', 'Snellen', [], 'equal_axes', 0,  'linreg', 1,'title_str', 'Challenge');  % H1: x – y come from a distribution with greater than 0
text(-0.18,1.15,'$\bf{D}$','Units','normalized','Fontsize',  letter_font)

fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
fig.Color =  [1 1 1];fig.Name = 'VA Snellen vs E';
subplot(mr,mc,2)
VA_E = [VA_E_optimized_preference_acq,  VA_E_optimal, VA_E_optimized_preference_random, VA_E_optimized_preference_acq_misspecification, VA_E_optimal_misspecification, VA_E_optimized_E_TS, VA_E_control];
VA_S = [VA_Snellen_optimized_preference_acq,  VA_Snellen_optimal, VA_Snellen_optimized_preference_random, VA_Snellen_optimized_preference_acq_misspecification, VA_Snellen_optimal_misspecification, VA_Snellen_optimized_E_TS, VA_Snellen_control];
x  = VA_E;
y = VA_S;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Tumbling E', 'Snellen',[], 'equal_axes', 0, 'linreg', 1); % H1: x – y come from a distribution with greater than 0


figname  = ['Figure',num2str(id)];
folder = [paper_figures_folder,'Figure_',num2str(id),'/'];
if ~isdir(folder)
    mkdir(folder)
end
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);
