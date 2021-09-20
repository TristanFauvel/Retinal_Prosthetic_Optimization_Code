function plot_optimization_RMSE 
%% Plot the results of the preference-based optimization

add_modules;

id = 5;
data_directory = [experiment_path,'/Data'];
figures_folder = [experiment_path,'/Figures'];
reload = 0;
RMSE = load_RMSE_results(reload, data_directory, data_table_file);
%[Pref_vs_E_training, Pref_vs_E_test, pref.acq_vs_random_training, pref.acq_vs_random_test, pref.acq_vs_opt_training, pref.acq_vs_opt_test, optimized_misspecified_vs_optimized_training, optimized_misspecified_vs_optimized_test,optimized_miss_vs_opt_miss_test, optimized_miss_vs_opt_miss_training, pref.acq_vs_control_test, pref.acq_vs_control_training]  = load_preferences(reload);
pref= load_preferences(reload, data_directory, data_table_file);

boxp = 1;
% 
% VA_scale_E= [min([RMSE.rmse_stim_optimized_preference_acq,RMSE.rmse_stim_optimized_preference_random,RMSE.rmse_stim_control]), max([RMSE.rmse_stim_optimized_preference_acq,RMSE.rmse_stim_optimized_preference_random,RMSE.rmse_stim_control])];
% VA_scale_Snellen=[min([RMSE.rmse_opt_optimized_preference_acq,RMSE.rmse_opt_optimized_preference_random,RMSE.rmse_opt_control]), max([RMSE.rmse_opt_optimized_preference_acq,RMSE.rmse_opt_optimized_preference_random,RMSE.rmse_opt_control])];
% 
% VA_scale = [min(VA_scale_E(1), VA_scale_Snellen(1)),max(VA_scale_E(2), VA_scale_Snellen(2))];
% VA_scale = [VA_scale;VA_scale];
% 
% VA_scale_E = [VA_scale_E;VA_scale_E];
% VA_scale_Snellen = [VA_scale_Snellen;VA_scale_Snellen];
% 

rmse_stim_combined = [RMSE.rmse_stim_optimized_preference_acq,RMSE.rmse_stim_optimized_preference_random, ...
    RMSE.rmse_stim_control, RMSE.rmse_stim_control, RMSE.rmse_stim_optimized_preference_acq_misspecification, ...
    RMSE.rmse_stim_optimal_misspecification, RMSE.rmse_stim_optimized_E_TS, RMSE.rmse_stim_naive];
rmse_opt_combined = [RMSE.rmse_opt_optimized_preference_acq,RMSE.rmse_opt_optimized_preference_random, ...
    RMSE.rmse_opt_control, RMSE.rmse_opt_control, RMSE.rmse_opt_optimized_preference_acq_misspecification, ...
    RMSE.rmse_opt_optimal_misspecification, RMSE.rmse_opt_optimized_E_TS, RMSE.rmse_opt_naive];

VA_scale_E= [min(rmse_stim_combined), max(rmse_stim_combined)];
VA_scale_Snellen=[min(rmse_opt_combined), max(rmse_opt_combined)];
VA_scale = [min(VA_scale_E(1), VA_scale_Snellen(1)),max(VA_scale_E(2), VA_scale_Snellen(2))];
VA_scale = [VA_scale;VA_scale];


 
letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

mr =1;
mc = 3;
legend_pos = [-0.18,1.15];
graphics_style_paper;

fig=figure('units','centimeters','outerposition',1+[0 0 16 1.3*fheight(mr)]);
fig.Color =  [1 1 1];
fig.Name = 'Fraction preferred';
tail = 'both';

i=0;
layout1 = tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','compact');

folder = [paper_figures_folder,'optimization_VA/'];
if ~isdir(folder)
    mkdir(folder)
end

I = imread([folder,'/Snellen_chart_and_TumblingE_tasks.png']);
clear('X', 'Y')
% nexttile()
% i=i+1;
% Y{1} = RMSE.rmse_stim_optimized_preference_acq;
% X{1} = RMSE.rmse_stim_naive;
% Y{2} = RMSE.rmse_opt_optimized_preference_acq;
% X{2} = RMSE.rmse_opt_naive;
% scatter_plot_combined(X,Y, tail,['logMAR' newline '(naive)'],['logMAR' newline '(adaptive pref.)'],VA_scale, 'categories', {'E','Snellen'}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

nexttile()
i=i+1;
Y{1} = RMSE.rmse_stim_optimized_preference_acq;
X{1} = RMSE.rmse_stim_control;
scatter_plot_combined(X,Y, tail,['MSE' newline '(random $\phi$)'],['MSE' newline '(adaptive pref.)'],[], 'categories', {''}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

% nexttile()
% i=i+1;
% Y{1} = RMSE.rmse_stim_optimized_preference_acq;
% X{1} = RMSE.rmse_stim_optimized_preference_random;
% scatter_plot_combined(X,Y, tail,['logMAR' newline '(non-adaptive pref.)'],'',[], 'categories', {'E','Snellen'}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)
nexttile()
i=i+1;
Y{1} = RMSE.rmse_stim_optimized_preference_acq;
X{1} = RMSE.rmse_stim_optimal;
scatter_plot_combined(X,Y, tail,['MSE' newline '(ground truth)'],'',[], 'categories', {''}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

nexttile()
i=i+1;
Y{1} = [RMSE.rmse_stim_optimized_preference_acq-RMSE.rmse_stim_control,RMSE.rmse_stim_optimized_preference_acq-RMSE.rmse_stim_optimal];
X{1} = [pref.acq_vs_control_training, pref.acq_vs_opt_training];
scatter_plot_combined(X,Y, tail,'Preference','Difference in MSE',[], 'categories', {''}, 'color', C, 'equal_axes', 0, 'linreg', 1, 'disp_mean',0);  %H1 : x – y come from a distribution with median greater than 0
% scatter(X,Y);  %H1 : x – y come from a distribution with median greater than 0

text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)


%%
% nexttile()
% i=i+1;
%  Y{1} = RMSE.rmse_opt_optimized_preference_acq;
% X{1} = RMSE.rmse_opt_control;
% scatter_plot_combined(X,Y, tail,['logMAR' newline '(random $\phi$)'],['logMAR' newline '(adaptive pref.)'],[], 'categories', {'E','Snellen'}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)
% 
% nexttile()
% i=i+1;
%  Y{1} = RMSE.rmse_opt_optimized_preference_acq;
% X{1} = RMSE.rmse_opt_optimized_preference_random;
% scatter_plot_combined(X,Y, tail,['logMAR' newline '(non-adaptive pref.)'],'',[], 'categories', {'E','Snellen'}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)
% 
% nexttile()
% i=i+1;
%  Y{1} = RMSE.rmse_opt_optimized_preference_acq;
% X{1} = RMSE.rmse_opt_optimal;
% scatter_plot_combined(X,Y, tail,['logMAR' newline '(ground truth)'],'',[], 'categories', {'E','Snellen'}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

figname  = ['RMSE'];

savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);

