function plot_optimization_VA(varargin)
%% Plot the results of the preference-based optimization

add_modules;

id = 5;
data_directory = [experiment_directory,'/Data'];
figures_folder = [experiment_directory,'/Figures'];
reload = 0;
VA = load_VA_results(reload, data_directory, data_table_file);
%[Pref_vs_E_training, Pref_vs_E_test, pref.acq_vs_random_training, pref.acq_vs_random_test, pref.acq_vs_opt_training, pref.acq_vs_opt_test, optimized_misspecified_vs_optimized_training, optimized_misspecified_vs_optimized_test,optimized_miss_vs_opt_miss_test, optimized_miss_vs_opt_miss_training, pref.acq_vs_control_test, pref.acq_vs_control_training]  = load_preferences(reload);
pref= load_preferences(reload, data_directory, data_table_file);

boxp = 1;
% 
% VA_scale_E= [min([VA.VA_E_optimized_preference_acq,VA.VA_E_optimized_preference_random,VA.VA_E_control]), max([VA.VA_E_optimized_preference_acq,VA.VA_E_optimized_preference_random,VA.VA_E_control])];
% VA_scale_Snellen=[min([VA.VA_Snellen_optimized_preference_acq,VA.VA_Snellen_optimized_preference_random,VA.VA_Snellen_control]), max([VA.VA_Snellen_optimized_preference_acq,VA.VA_Snellen_optimized_preference_random,VA.VA_Snellen_control])];
% 
% VA_scale = [min(VA_scale_E(1), VA_scale_Snellen(1)),max(VA_scale_E(2), VA_scale_Snellen(2))];
% VA_scale = [VA_scale;VA_scale];
% 
% VA_scale_E = [VA_scale_E;VA_scale_E];
% VA_scale_Snellen = [VA_scale_Snellen;VA_scale_Snellen];
% 

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


mr =1;
mc = 3;
legend_pos = [-0.18,1.15];
graphics_style_paper;

fig=figure('units','centimeters','outerposition',1+[0 0 16 1.3*fheight(mr)]);
fig.Color =  [1 1 1];
fig.Name = 'Fraction preferred';
tail = 'both';

i=2;
layout1 = tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','compact');

folder = [paper_figures_folder,'optimization_VA/'];
if ~isdir(folder)
    mkdir(folder)
end

I = imread([folder,'/Snellen_chart_and_TumblingE_tasks.png']);
clear('X', 'Y')
% nexttile()
% i=i+1;
% Y{1} = VA.VA_E_optimized_preference_acq;
% X{1} = VA.VA_E_naive;
% Y{2} = VA.VA_Snellen_optimized_preference_acq;
% X{2} = VA.VA_Snellen_naive;
% scatter_plot_combined(X,Y, tail,['logMAR' newline '(naive)'],['logMAR' newline '(adaptive pref.)'],VA_scale, 'categories', {'E','Snellen'}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

nexttile()
i=i+1;
Y{1} = VA.VA_E_optimized_preference_acq;
X{1} = VA.VA_E_control;
Y{2} = VA.VA_Snellen_optimized_preference_acq;
X{2} = VA.VA_Snellen_control;
scatter_plot_combined(X,Y, tail,['logMAR' newline '(random $\phi$)'],['logMAR' newline '(adaptive pref.)'],VA_scale, 'categories', {'E','Snellen'}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

nexttile()
i=i+1;
Y{1} = VA.VA_E_optimized_preference_acq;
X{1} = VA.VA_E_optimized_preference_random;
Y{2} = VA.VA_Snellen_optimized_preference_acq;
X{2} = VA.VA_Snellen_optimized_preference_random;
scatter_plot_combined(X,Y, tail,['logMAR' newline '(non-adaptive pref.)'],'',VA_scale, 'categories', {'E','Snellen'}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)


nexttile()
i=i+1;
Y{1} = VA.VA_E_optimized_preference_acq;
X{1} = VA.VA_E_optimal;
Y{2} = VA.VA_Snellen_optimized_preference_acq;
X{2} = VA.VA_Snellen_optimal;
scatter_plot_combined(X,Y, tail,['logMAR' newline '(ground truth)'],'',VA_scale, 'categories', {'E','Snellen'}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

figname  = ['optimization_VA_2'];

savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);

