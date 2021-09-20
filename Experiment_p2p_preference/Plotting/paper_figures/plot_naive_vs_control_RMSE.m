function plot_naive_vs_control_RMSE

%% Plot the results of the preference-based optimization
graphics_style_paper;

add_directories
graphics_style_paper;
folder = paper_figures_folder;
data_directory = [experiment_path,'/Data'];
figures_folder = [experiment_path,'/Figures'];
reload = 0;
RMSE= load_RMSE_results(reload, data_directory, data_table_file);
pref  = load_preferences(reload,data_directory, data_table_file);

legend_pos = [-0.18,1.1];


% VA_scale_E= [min([RMSE.rmse_stim_control, RMSE.rmse_stim_naive]), max([RMSE.rmse_stim_control, RMSE.rmse_stim_naive])];
% VA_scale_Snellen=[min([RMSE.rmse_opt_control, RMSE.rmse_opt_naive]), max([RMSE.rmse_opt_control, RMSE.rmse_opt_naive])];
% 
% VA_scale = [min(VA_scale_E(1), VA_scale_Snellen(1)),max(VA_scale_E(2), VA_scale_Snellen(2))];
% VA_scale = [VA_scale;VA_scale];
rmse_stim_combined = [RMSE.rmse_stim_optimized_preference_acq,RMSE.rmse_stim_optimized_preference_random, ...
    RMSE.rmse_stim_control, RMSE.rmse_stim_control, RMSE.rmse_stim_optimized_preference_acq_misspecification, ...
    RMSE.rmse_stim_optimal_misspecification, RMSE.rmse_stim_optimized_E_TS, RMSE.rmse_stim_naive];
rmse_opt_combined = [RMSE.rmse_opt_optimized_preference_acq,RMSE.rmse_opt_optimized_preference_random, ...
    RMSE.rmse_opt_control, RMSE.rmse_opt_control, RMSE.rmse_opt_optimized_preference_acq_misspecification, ...
    RMSE.rmse_opt_optimal_misspecification, RMSE.rmse_opt_optimized_E_TS, RMSE.rmse_opt_naive];

RMSE_scale_stim= [min(rmse_stim_combined), max(rmse_stim_combined)];
RMSE_scale_stim = [RMSE_scale_stim;RMSE_scale_stim];
RMSE_scale_opt=[min(rmse_opt_combined), max(rmse_opt_combined)];
RMSE_scale_opt = [RMSE_scale_opt;RMSE_scale_opt];
% VA_scale = [min(VA_scale_E(1), VA_scale_Snellen(1)),max(VA_scale_E(2), VA_scale_Snellen(2))];
% VA_scale = [VA_scale;VA_scale];

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



keep = find((~isnan(RMSE.rmse_stim_naive)).*(~isnan(RMSE.rmse_stim_control)).*(~isnan(RMSE.rmse_opt_naive)).*(~isnan(RMSE.rmse_opt_control)));
nexttile(1)
tail = 'both';
i=4;
Y{1} = RMSE.rmse_stim_naive(keep);
X{1} = RMSE.rmse_stim_control(keep);
scatter_plot_combined(X,Y, tail,['logMAR' newline '(random $\phi$)'],['logMAR' newline '(naive)'],[], 'categories', {'E','Snellen'}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

nexttile(2)
tail = 'both';
i=4;
Y{1} = RMSE.rmse_opt_naive(keep);
X{1} = RMSE.rmse_opt_control(keep);
scatter_plot_combined(X,Y, tail,['logMAR' newline '(random $\phi$)'],['logMAR' newline '(naive)'],[], 'categories', {'E','Snellen'}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)


 
% figname  = 'Parameterization_effect';
% folder = [folder,figname];
% savefig(fig, [folder,'/', figname, '.fig'])
% exportgraphics(fig, [folder,'/' , figname, '.pdf']);
% exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);

% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize',letter_font) %with compact margins
% 
% nexttile(4)
% tail = 'both';
% i=4;
% Y{1} = RMSE.rmse_stim_naive;
% X{1} = RMSE.rmse_stim_control;
% Y{2} = RMSE.rmse_opt_naive;
% X{2} = RMSE.rmse_opt_control;
% scatter_plot_combined(X,Y, tail,['logMAR' newline '(random $\phi$)'],['logMAR' newline '(naive)'],VA_scale, 'categories', {'E','Snellen'}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)
% 
%  
% 
% figname  = 'Parameterization_effect';
% folder = [folder,figname];
% savefig(fig, [folder,'/', figname, '.fig'])
% exportgraphics(fig, [folder,'/' , figname, '.pdf']);
% exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);
% 
