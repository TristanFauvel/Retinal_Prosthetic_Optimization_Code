function plot_figure_challenge_VA(id, varargin)
%% Plot the results of the preference-based optimization

add_modules;
graphics_style_paper;

data_directory = [experiment_directory,'/Data'];
figures_folder = [experiment_directory,'/Figures'];
reload = 0;
[VA_E_optimized_preference_acq, VA_Snellen_optimized_preference_acq, VA_E_optimal,VA_Snellen_optimal, VA_E_optimized_preference_random,VA_Snellen_optimized_preference_random, VA_E_optimized_preference_acq_misspecification, VA_Snellen_optimized_preference_acq_misspecification, VA_E_optimal_misspecification,VA_Snellen_optimal_misspecification, VA_E_optimized_E_TS,VA_Snellen_optimized_E_TS, VA_E_control,VA_Snellen_control] = load_VA_results(reload);
[Pref_vs_E_training, Pref_vs_E_test, acq_vs_random_training, acq_vs_random_test, acq_vs_opt_training, acq_vs_opt_test, optimized_misspecified_vs_optimized_training, optimized_misspecified_vs_optimized_test,optimized_miss_vs_opt_miss_test, optimized_miss_vs_opt_miss_training, acq_vs_control_test, acq_vs_control_training]  = load_preferences(reload)
boxp = 1;

VA_scale_E= [min([VA_E_optimized_preference_acq,VA_E_optimized_preference_random,VA_E_control]), max([VA_E_optimized_preference_acq,VA_E_optimized_preference_random,VA_E_control])];
VA_scale_Snellen=[min([VA_Snellen_optimized_preference_acq,VA_Snellen_optimized_preference_random,VA_Snellen_control]), max([VA_Snellen_optimized_preference_acq,VA_Snellen_optimized_preference_random,VA_Snellen_control])];

VA_scale = [min(VA_scale_E(1), VA_scale_Snellen(1)),max(VA_scale_E(2), VA_scale_Snellen(2))];
VA_scale = [VA_scale;VA_scale];

VA_scale_E = [VA_scale_E;VA_scale_E];
VA_scale_Snellen = [VA_scale_Snellen;VA_scale_Snellen];

pref_scale = [0,1;0,1];

 
mr = 2;
mc = 4;
legend_pos = [-0.18,1.15];
% fig=figure('units','centimeters','outerposition',1+[0 0 16 1.5/2*16]);
fig=figure();

fig.Color =  [1 1 1];
fig.Name = 'Fraction preferred';
i=0;
layout1 = tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','compact');
k=1;

I = imread('C:\Users\tfauvel\Documents\PhD\Figures\Material\Snellen_chart_and_Tumbling_tasks.png');
h = nexttile([1,mc]);
i=i+1;

image(I)
axis image
axis off

acq_vs_control_training = acq_vs_random_training;
 acq_vs_control_test = acq_vs_random_training;

 
nexttile()
i=i+1;
x = [acq_vs_control_training, acq_vs_random_training, acq_vs_opt_training];
y = [acq_vs_control_test, acq_vs_random_test, acq_vs_opt_test];
tail = 'both'; %'right';
scatter_plot(x,y, tail, ['Fraction preferred' newline '(Opt. set)'], ['Fraction preferred' newline '(Trans. set)'], pref_scale,'title_str', ''); % H1: x ??? y come from a distribution with greater than 0
text(-0.18,1.15,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

nexttile()
% h = subplot(mr,mc,[7,9;16,19])
i=i+1;
tail = 'both'; %'right';
Y{1} = VA_E_optimized_preference_acq;
X{1} = VA_E_control;
[h,hleg] = scatter_plot_combined(X,Y, tail, ['logMAR' newline '(random $\phi$)'], ['logMAR' newline '(adaptive pref.)'],VA_scale_E, 'categories', {'E'}, 'color', colors_chart(1,:));  %H1 : x ??? y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

% nexttile(layout1, (mr/2*mc)+mc/2+1, [mr/2,mc/4])
nexttile()
i=i+1;
Y{1} = VA_Snellen_optimized_preference_acq;
X{1} = VA_Snellen_control;
[h,hleg] = scatter_plot_combined(X,Y, tail, ['logMAR' newline '(random $\phi$)'],['logMAR' newline '(adaptive pref.)'],VA_scale_Snellen, 'categories', {'Snellen'}, 'color', colors_chart(2,:));  %H1 : x ??? y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

nexttile()
i=i+1;
tail = 'both'; %'right';
Y{1} = VA_E_optimized_preference_acq;
X{1} = VA_E_optimized_preference_random;
[h,hleg] = scatter_plot_combined(X,Y, tail,['logMAR' newline '(random)'],['logMAR' newline '(adaptive pref.)'],VA_scale_E, 'categories', {'E'}, 'color', colors_chart(1,:));  %H1 : x ??? y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

nexttile()
i=i+1;
Y{1} = VA_Snellen_optimized_preference_acq;
X{1} = VA_Snellen_optimized_preference_random;
[h,hleg] = scatter_plot_combined(X,Y, tail,['logMAR' newline '(random)'],['logMAR' newline '(adaptive pref.)'],VA_scale_Snellen, 'categories', {'Snellen'}, 'color', colors_chart(2,:));  %H1 : x ??? y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

nexttile()
i=i+1;
Y{1} = VA_E_optimized_preference_acq;
X{1} = VA_E_optimized_preference_random;
Y{2} = VA_Snellen_optimized_preference_acq;
X{2} = VA_Snellen_optimized_preference_random;
[h,hleg] = scatter_plot_combined(X,Y, tail,['logMAR' newline '(random)'],['logMAR' newline '(adaptive pref.)'],VA_scale_Snellen, 'categories', {'E','Snellen'}, 'color', colors_chart);  %H1 : x ??? y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)


figname  = ['Figure',num2str(id)];
folder = [[figures_folder, '/'],figname];
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);

