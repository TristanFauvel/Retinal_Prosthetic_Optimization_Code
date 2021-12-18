%% All subjects
reload = 0; %whether you want to reload the subjects (1) data or use preprocessed ones (0); 
pref  = load_preferences(reload,data_directory, data_table_file);
VA  = load_VA_results(reload,data_directory, data_table_file);

%% Subjects: remote experiment
subjects_to_keep = {'AD', 'CF', 'IO', 'MB', 'MC', 'TN', 'TO', 'AA', 'PC', 'RB', 'SC', 'RC'};

reload = 1; %whether you want to reload the subjects (1) data or use preprocessed ones (0); 
pref_rem  = load_preferences(reload,data_directory, data_table_file,subjects_to_keep);
VA_rem  = load_VA_results(reload,data_directory, data_table_file,subjects_to_keep);

%% Subjects in the lab
subjects_to_keep = {'FF', 'SG', 'BF', 'SF', 'SV', 'IE', 'FT', 'DP', 'MS', 'PY', 'OM', 'TB'};
 
reload = 1; %whether you want to reload the subjects (1) data or use preprocessed ones (0); 
pref_lab  = load_preferences(reload,data_directory, data_table_file,subjects_to_keep);
VA_lab  = load_VA_results(reload,data_directory, data_table_file,subjects_to_keep);

%%
VA_scale_E= [min([VA.VA_E_optimized_preference_acq,VA.VA_E_optimized_preference_random,VA.VA_E_control]), max([VA.VA_E_optimized_preference_acq,VA.VA_E_optimized_preference_random,VA.VA_E_control])];
VA_scale_Snellen=[min([VA.VA_Snellen_optimized_preference_acq,VA.VA_Snellen_optimized_preference_random,VA.VA_Snellen_control]), max([VA.VA_Snellen_optimized_preference_acq,VA.VA_Snellen_optimized_preference_random,VA.VA_Snellen_control])];
VA_scale = [min(VA_scale_E(1), VA_scale_Snellen(1)),max(VA_scale_E(2), VA_scale_Snellen(2))];
VA_scale = [VA_scale;VA_scale];

VA_scale_E = [VA_scale_E;VA_scale_E];
VA_scale_Snellen = [VA_scale_Snellen;VA_scale_Snellen];
pref_scale = [0,1;0,1];

%%

tail = 'both';

graphics_style_paper;
mr = 3;
mc = 1;
i = 1;
legend_pos = [-0.1,1];

fig=figure('units','centimeters','outerposition',1+[0 0 fwidth 22]);
fig.Color =  [1 1 1];
tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','tight');
% keep = find((~isnan(VA.VA_E_naive)).*(~isnan(VA.VA_E_control)).*(~isnan(VA.VA_Snellen_naive)).*(~isnan(VA.VA_Snellen_control)));

clear('X', 'Y')
nexttile()
Y{1} = VA_lab.VA_E_naive;
X{1} = VA_rem.VA_E_naive;
Y{2} = VA_lab.VA_E_optimal;
X{2} = VA_rem.VA_E_optimal;
Y{3} = VA_lab.VA_E_optimized_preference_acq;
X{3} = VA_rem.VA_E_optimized_preference_acq;
 Y{4} = VA_lab.VA_E_optimized_preference_random;
X{4} = VA_rem.VA_E_optimized_preference_random;
Y{5} = VA_lab.VA_E_control;
X{5} = VA_rem.VA_E_control;
Y{6} = VA_lab.VA_E_optimal_misspecification;
X{6} = VA_rem.VA_E_optimal_misspecification;
Y{7} = VA_lab.VA_E_optimized_preference_acq_misspecification;
X{7} = VA_rem.VA_E_optimized_preference_acq_misspecification;
Y{8} = VA_lab.VA_E_optimized_E_TS;
X{8} = VA_rem.VA_E_optimized_E_TS;

ylabels = 'VA (logMAR, E task)';
xlabels = {'', 'Naive', 'True $\phi$',  'Adaptive pref.',  'Non-adaptive pref.', 'Random $\phi$', 'Misspecified', 'Misspecified opt.', 'Performance-based'};
groups = {'Remote', 'Lab'};
barplot_groups(X, Y, xlabels, ylabels, groups)
text(legend_pos(1), legend_pos(2),['$\bf{', letters(1), '}$'],'Units','normalized','Fontsize', letter_font)


nexttile()
Y{1} = VA_lab.VA_Snellen_naive;
X{1} = VA_rem.VA_Snellen_naive;
Y{2} = VA_lab.VA_Snellen_optimal;
X{2} = VA_rem.VA_Snellen_optimal;
Y{3} = VA_lab.VA_Snellen_optimized_preference_acq;
X{3} = VA_rem.VA_Snellen_optimized_preference_acq;
 Y{4} = VA_lab.VA_Snellen_optimized_preference_random;
X{4} = VA_rem.VA_Snellen_optimized_preference_random;
Y{5} = VA_lab.VA_Snellen_control;
X{5} = VA_rem.VA_Snellen_control;
Y{6} = VA_lab.VA_Snellen_optimal_misspecification;
X{6} = VA_rem.VA_Snellen_optimal_misspecification;
Y{7} = VA_lab.VA_Snellen_optimized_preference_acq_misspecification;
X{7} = VA_rem.VA_Snellen_optimized_preference_acq_misspecification;
Y{8} = VA_lab.VA_Snellen_optimized_E_TS;
X{8} = VA_rem.VA_Snellen_optimized_E_TS;

ylabels = 'VA (logMAR, Snellen task)';
 groups = {'Remote', 'Lab'};
barplot_groups(X, Y, xlabels, ylabels, groups)
text(legend_pos(1), legend_pos(2),['$\bf{', letters(2), '}$'],'Units','normalized','Fontsize', letter_font)


%%

% 
% fig=figure('units','centimeters','outerposition',1+[0 0 fwidth fheight(1)]);
% fig.Color =  [1 1 1];
% tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','compact');
% keep = find((~isnan(VA.VA_E_naive)).*(~isnan(VA.VA_E_control)).*(~isnan(VA.VA_Snellen_naive)).*(~isnan(VA.VA_Snellen_control)));
Y{1} =  pref_lab.control_vs_naive_training;
X{1} = pref_rem.control_vs_naive_training;
Y{2} = pref_lab.acq_vs_control_training;
X{2} = pref_rem.acq_vs_control_training;
Y{3} = pref_lab.acq_vs_opt_training;
X{3} = pref_rem.acq_vs_opt_training;
Y{4} = pref_lab.acq_vs_random_training;
X{4} = pref_rem.acq_vs_random_training;
Y{5} = pref_lab.E_vs_control_training;
X{5} = pref_rem.E_vs_control_training;
Y{6} = pref_lab.Pref_vs_E_training;
X{6} = pref_rem.Pref_vs_E_training;
Y{7} = pref_lab.optimized_miss_vs_controlmiss_training;
X{7} = pref_rem.optimized_miss_vs_controlmiss_training;
Y{8} = pref_lab.optimized_miss_vs_control_training;
X{8} = pref_rem.optimized_miss_vs_control_training;
Y{9} = pref_lab.optimized_miss_vs_opt_miss_training;
X{9} = pref_rem.optimized_miss_vs_opt_miss_training;
% Y{1} =  pref_lab.control_vs_naive_training;
% X{1} = pref_rem.control_vs_naive_training;
% Y{2} = [pref_lab.acq_vs_control_test, pref_lab.acq_vs_control_training];
% X{2} = [pref_rem.acq_vs_control_test, pref_rem.acq_vs_control_training];
% Y{3} = [pref_lab.acq_vs_opt_test, pref_lab.acq_vs_opt_training];
% X{3} = [pref_rem.acq_vs_opt_test, pref_rem.acq_vs_opt_training];
% Y{4} = [pref_lab.acq_vs_random_test, pref_lab.acq_vs_random_training];
% X{4} = [pref_rem.acq_vs_random_test, pref_rem.acq_vs_random_training];
% Y{5} = pref_lab.E_vs_control_training;
% X{5} = pref_rem.E_vs_control_training;
% Y{6} = [pref_lab.Pref_vs_E_test, pref_lab.Pref_vs_E_training];
% X{6} = [pref_rem.Pref_vs_E_test, pref_rem.Pref_vs_E_training];
% Y{7} = [pref_lab.optimized_miss_vs_controlmiss_test, pref_lab.optimized_miss_vs_controlmiss_training];
% X{7} = [pref_rem.optimized_miss_vs_controlmiss_test, pref_rem.optimized_miss_vs_controlmiss_training];
% Y{8} = pref_lab.optimized_miss_vs_control_training;
% X{8} = pref_rem.optimized_miss_vs_control_training;
% Y{9} = pref_lab.optimized_miss_vs_opt_miss_training;
% X{9} = pref_rem.optimized_miss_vs_opt_miss_training;
nexttile()
ylabels = 'Preference';
xlabels = {'Random $\phi$ vs naive', 'Adaptive pref. vs random $\phi$', 'Adaptive pref. vs $\phi^\star$', ...
    'Adaptive pref.vs non-adaptive ', 'Performance-based vs random $\phi$', 'Adaptive pref. vs performance-based', 'Optimized miss. vs random $\phi$ miss.', ...
     'Optimized miss. vs control miss.', 'Optimized miss. vs optimized miss.'};
groups = {'Remote', 'Lab'};
barplot_groups_pref(X, Y, xlabels, ylabels, groups)
text(legend_pos(1), legend_pos(2),['$\bf{', letters(3), '}$'],'Units','normalized','Fontsize', letter_font)


folder = paper_figures_folder;
figname  = ['remote_vs_lab'];
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);

