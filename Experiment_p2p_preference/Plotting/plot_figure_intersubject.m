function plot_figure_intersubject(id)
%% Plot to study the variability of the optimization results from subject to subject
add_directories


graphics_style_paper;


data_directory = [experiment_path,'/Data'];
figures_folder = [experiment_path,'/Figures'];
reload = 0;
VA= load_VA_results(reload, data_directory, data_table_file);
p  = load_preferences(reload,data_directory, data_table_file);


T = load(data_table_file).T;
load('subjects_to_remove.mat', 'subjects_to_remove') %remove data from participants who did not complete the experiment;
T = T(all(T.Subject ~= subjects_to_remove,2),:);

indices = 1:size(T,1);
acquisition= 'maxvar_challenge';
indices = indices(T.Acquisition==acquisition & T.Misspecification == 0);
N = numel(indices);

seeds_data = T(indices,:).Model_Seed;
seeds = unique(seeds_data);

acq_vs_random_test_paired = NaN(2, numel(seeds));
acq_vs_random_training_paired= NaN(2, numel(seeds));
acq_vs_opt_test_paired= NaN(2, numel(seeds));
acq_vs_opt_training_paired= NaN(2, numel(seeds));

Pref_vs_E_test_paired = NaN(2, numel(seeds));
Pref_vs_E_training_paired= NaN(2, numel(seeds));
optimized_misspecified_vs_optimized_training_paired = NaN(2, numel(seeds));
optimized_misspecified_vs_optimized_test_paired = NaN(2, numel(seeds));

for i = 1:numel(seeds)
    idx = find(seeds_data== seeds(i));
    if numel(idx)>1
        idx = idx(1:2);
        acq_vs_random_test_paired(:,i) = p.acq_vs_random_test(idx);
        acq_vs_random_training_paired(:,i) = p.acq_vs_random_training(idx);
        acq_vs_opt_test_paired(:,i) = p.acq_vs_opt_test(idx);
        acq_vs_opt_training_paired(:,i) = p.acq_vs_opt_training(idx);
        Pref_vs_E_test_paired(:,i) = p.Pref_vs_E_test(:,idx);
        Pref_vs_E_training_paired(:,i)= p.Pref_vs_E_training(:,idx);
        optimized_misspecified_vs_optimized_training_paired(:,i) = p.optimized_misspecified_vs_optimized_training(:,idx);
        optimized_misspecified_vs_optimized_test_paired(:,i) = p.optimized_misspecified_vs_optimized_test(:,idx);
    end
end
paired_VA.VA_E_optimized_preference_acq= NaN(2, numel(seeds));
paired_VA.VA_E_optimal =  NaN(2, numel(seeds));
paired_VA.VA_Snellen_optimized_preference_acq= NaN(2, numel(seeds));
paired_VA.VA_Snellen_optimal =  NaN(2, numel(seeds));
paired_control_E =NaN(2, numel(seeds));
paired_control_Snellen =NaN(2, numel(seeds));

paired_VA.VA_E_optimized_preference_random = NaN(2, numel(seeds));
paired_VA.VA_Snellen_optimized_preference_random= NaN(2, numel(seeds));
paired_VA.VA_E_optimized_preference_acq_misspecification  = NaN(2, numel(seeds));
paired_VA.VA_Snellen_optimized_preference_acq_misspecification= NaN(2, numel(seeds));
paired_VA.VA_E_optimal_misspecification= NaN(2, numel(seeds));
paired_VA.VA_Snellen_optimal_misspecification= NaN(2, numel(seeds));
paired_VA.VA_E_optimized_E_TS= NaN(2, numel(seeds));
paired_VA.VA_Snellen_optimized_E_TS = NaN(2, numel(seeds));

for i = 1:numel(seeds)
    idx = find(seeds_data== seeds(i));
    if numel(idx)>1
        idx = idx(1:2);
    paired_VA.VA_E_optimized_preference_acq(:,i) = VA.VA_E_optimized_preference_acq(idx)';
    paired_VA.VA_Snellen_optimized_preference_acq(:,i) = VA.VA_Snellen_optimized_preference_acq(idx)';
    paired_VA.VA_E_optimal(:,i) = VA.VA_E_optimal(idx)';
    paired_VA.VA_Snellen_optimal(:,i) = VA.VA_Snellen_optimal(idx)';
    paired_control_E(:,i) = VA.VA_E_control(idx)';
    paired_control_Snellen(:,i) = VA.VA_Snellen_control(idx)';
    
    paired_VA.VA_E_optimized_preference_random(:,i) = VA.VA_E_optimized_preference_random(idx)';
    paired_VA.VA_Snellen_optimized_preference_random(:,i)= VA.VA_Snellen_optimized_preference_random(idx)';
    paired_VA.VA_E_optimized_preference_acq_misspecification(:,i) = VA.VA_E_optimized_preference_acq_misspecification(idx)';
    paired_VA.VA_Snellen_optimized_preference_acq_misspecification(:,i) = VA.VA_Snellen_optimized_preference_acq_misspecification(idx)';
    paired_VA.VA_E_optimal_misspecification(:,i) = VA.VA_E_optimal_misspecification(idx)';
    paired_VA.VA_Snellen_optimal_misspecification(:,i) = VA.VA_Snellen_optimal_misspecification(idx)';
    paired_VA.VA_E_optimized_E_TS(:,i) = VA.VA_E_optimized_E_TS(idx)';
    paired_VA.VA_Snellen_optimized_E_TS(:,i) =  VA.VA_Snellen_optimized_E_TS(idx)';
    end
end


tail = 'both';
mc =4;
mr = 1;
legend_pos = [-0.18,1.15];

% fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
% fig.Color =  [1 1 1];
% tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','tight');
% 
% nexttile
% x = [p.acq_vs_random_test_paired(1,:), p.acq_vs_opt_test_paired(1,:)];
% y = [p.acq_vs_random_test_paired(2,:), p.acq_vs_opt_test_paired(2,:)];
% scatter_plot(x, y, tail,'Subject  1', 'Subject  2',pref_scale, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
% text(legend_pos(1), legend_pos(2),'$\bf{A}$','Units','normalized','Fontsize', letter_font)
% title('Optimization set')
% nexttile
% x = [p.acq_vs_random_training_paired(1,:), p.acq_vs_opt_training_paired(1,:)];
% y = [p.acq_vs_random_training_paired(2,:), p.acq_vs_opt_training_paired(2,:)];
% scatter_plot(x, y, tail,'Subject  1', 'Subject  2',pref_scale, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
% text(legend_pos(1), legend_pos(2),'$\bf{A}$','Units','normalized','Fontsize', letter_font)
% title('Transfer set')


letters ='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
tail = 'both';
mc =4;
mr = 2;
legend_pos = [-0.18,1.15];
pref_scale = [0,1;0,1];

i=0;
fig=figure('units','centimeters','outerposition',1+[0 0 16 1.4/2*16]);
fig.Color =  [1 1 1];
fig.Name = "subject_to_subject_optimization_variability";
tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','tight');
nexttile
i=i+1;
scatter_plot(acq_vs_random_training_paired(1,:),acq_vs_random_training_paired(2,:), tail,'Subject  1', 'Subject  2',pref_scale, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)
% title('Challenge vs Random, test')
nexttile
i=i+1;
scatter_plot(acq_vs_random_test_paired(1,:),acq_vs_random_test_paired(2,:), tail,'Subject  1', 'Subject  2',pref_scale, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)
% title('Challenge vs Random, training')
nexttile
i=i+1;
scatter_plot(acq_vs_opt_test_paired(1,:),acq_vs_opt_test_paired(2,:), tail,'Subject  1', 'Subject  2',pref_scale, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)
% title('Challenge vs Ground truth, test')
nexttile
i=i+1;
scatter_plot(acq_vs_opt_training_paired(1,:),acq_vs_opt_training_paired(2,:), tail,'Subject  1', 'Subject  2',pref_scale, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)
% title('Challenge vs Ground truth, training')
nexttile
i=i+1;
scatter_plot(paired_VA.VA_E_optimized_preference_acq(1,:),paired_VA.VA_E_optimized_preference_acq(2,:), tail,'Subject  1', 'Subject  2',[], 'linreg', 1,'color', C(1,:)); %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)
nexttile
i=i+1;
scatter_plot(paired_VA.VA_Snellen_optimized_preference_acq(1,:),paired_VA.VA_Snellen_optimized_preference_acq(2,:), tail,'Subject  1', 'Subject  2',[], 'linreg', 1,'color', C(2,:)); %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)
nexttile
i=i+1;
scatter_plot(paired_VA.VA_E_optimized_E_TS(1,:),paired_VA.VA_E_optimized_E_TS(2,:), tail,'Subject  1', 'Subject  2',[], 'linreg', 1, 'color', C(1,:)); %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)
nexttile
i=i+1;
scatter_plot(paired_VA.VA_Snellen_optimized_E_TS(1,:),paired_VA.VA_Snellen_optimized_E_TS(2,:), tail,'Subject  1', 'Subject  2',[], 'linreg', 1, 'color', C(2,:)); %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

folder = 'C:\Users\tfauvel\Documents\PhD\Figures\Paper_figures\Figure9\';


figname  = ['Figure',num2str(id)];
folder = [paper_figures_folder,'Figure_',num2str(id),'/'];
if ~isdir(folder)
    mkdir(folder)
end
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);
