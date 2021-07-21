function plot_figure_VA_precision(id)%% Plot the variability of measurements with the same encoders, for different subjects, and for the same subject
add_directories


graphics_style_paper;

data_directory = [experiment_path,'/Data'];
figures_folder = [experiment_path,'/Figures'];
reload = 0;
[VA_E_optimized_preference_acq, VA_Snellen_optimized_preference_acq, VA_E_optimal,VA_Snellen_optimal, VA_E_optimized_preference_random,VA_Snellen_optimized_preference_random, VA_E_optimized_preference_acq_misspecification, VA_Snellen_optimized_preference_acq_misspecification, VA_E_optimal_misspecification,VA_Snellen_optimal_misspecification, VA_E_optimized_E_TS,VA_Snellen_optimized_E_TS, VA_E_control,VA_Snellen_control] = load_VA_results(reload);
[Pref_vs_E_training, Pref_vs_E_test, acq_vs_random_training, acq_vs_random_test, acq_vs_opt_training, acq_vs_opt_test, optimized_misspecified_vs_optimized_training, optimized_misspecified_vs_optimized_test]  = load_preferences(reload);

[VA_E_controls,VA_Snellen_controls] = load_control_VA_results(0);
VA_E_controls(:,isNaN(sum(VA_E_controls,1))) = [];
VA_Snellen_controls(:,isNaN(sum(VA_Snellen_controls,1))) = [];


T = load(data_table_file).T;

indices = 1:size(T,1);
acquisition= 'maxvar_challenge';
indices = indices(T.Acquisition==acquisition & T.Misspecification == 0);
N = numel(indices);

seeds_data = T(indices,:).Model_Seed;
seeds = unique(seeds_data);
paired_VA_E_optimal =  NaN(2, numel(seeds));
paired_VA_Snellen_optimal =  NaN(2, numel(seeds));
paired_control_E =NaN(2, numel(seeds));
paired_control_Snellen =NaN(2, numel(seeds));
paired_VA_E_optimal_misspecification= NaN(2, numel(seeds));
paired_VA_Snellen_optimal_misspecification= NaN(2, numel(seeds));

for i = 1:numel(seeds)
    if sum(seeds_data == seeds(i)) >1
    paired_VA_E_optimal(:,i) = VA_E_optimal(seeds_data == seeds(i))';
    paired_VA_Snellen_optimal(:,i) = VA_Snellen_optimal(seeds_data == seeds(i))';
    paired_control_E(:,i) = VA_E_control(seeds_data == seeds(i))';
    paired_control_Snellen(:,i) = VA_Snellen_control(seeds_data == seeds(i))';
    paired_VA_E_optimal_misspecification(:,i) = VA_E_optimal_misspecification(seeds_data == seeds(i))';
    paired_VA_Snellen_optimal_misspecification(:,i) = VA_Snellen_optimal_misspecification(seeds_data == seeds(i))';
    end
end
tail = 'both';
mc =4;
mr = 1;
legend_pos = [-0.18,1.15];
pref_scale = [0,1;0,1];
    
xE = [paired_VA_E_optimal(1,:), paired_control_E(1,:), paired_VA_E_optimal_misspecification(1,:)];
yE = [paired_VA_E_optimal(2,:), paired_control_E(2,:), paired_VA_E_optimal_misspecification(2,:)];
xS = [paired_VA_Snellen_optimal(1,:), paired_control_Snellen(1,:), paired_VA_E_optimal_misspecification(1,:)];
yS = [paired_VA_Snellen_optimal(2,:), paired_control_Snellen(2,:), paired_VA_E_optimal_misspecification(2,:)];

letters =  'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1.4/2*16]);
fig.Color =  [1 1 1];
fig.Name = "subject_to_subject_optimization_variability";
tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','compact');
i=0;
nexttile
i = i+1;
VA_rad = mean(abs(VA_E_controls-mean(VA_E_controls,1))./mean(VA_E_controls,1),1);
histogram(VA_rad,12, 'Facecolor',C(1,:));
pbaspect([1 1 1])
% title(['Tumbling E, (mean : ', num2str(round(mean(VA_rad),2)),')']);
xlabel('Relative average deviation')
xl = xlim();
xlim([0,xl(2)])
box off
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

nexttile
i = i+1;
VA_rad = mean(abs(VA_Snellen_controls-mean(VA_Snellen_controls,1))./mean(VA_Snellen_controls,1),1);
histogram(VA_rad,12, 'Facecolor',C(2,:));
% title(['Snellen, (mean : ', num2str(round(mean(VA_rad),2)),')']);
xlabel('Relative average deviation')
pbaspect([1 1 1])
box off
xl = xlim();
xlim([0,xl(2)])
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

nexttile
i = i+1;
scatter_plot(xE,yE, tail,'Subject  1', 'Subject  2',[], 'linreg', 1, 'color', C(1,:)); %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

nexttile
i = i+1;
scatter_plot(xS,yS, tail,'Subject  1', 'Subject  2',[], 'linreg', 1, 'color', C(2,:)); %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

figname  = ['Figure',num2str(id)];
folder = [paper_figures_folder, figname];
savefig(fig, [folder,'\', figname, '.fig'])
exportgraphics(fig, [folder,'\' , figname, '.pdf']);
exportgraphics(fig, [folder,'\' , figname, '.png'], 'Resolution', 300);
% fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1.4/2*16]);
% fig.Color =  [1 1 1];
% fig.Name = "subject_to_subject_optimization_variability";
% tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','tight');
% nexttile
% scatter_plot(paired_VA_E_optimal(1,:), paired_VA_E_optimal(2,:), tail,'Subject  1', 'Subject  2',[], 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
% text(legend_pos(1), legend_pos(2),'$\bf{E}$','Units','normalized','Fontsize', letter_font)
% nexttile
% scatter_plot(paired_VA_Snellen_optimal(1,:),paired_VA_Snellen_optimal(2,:), tail,'Subject  1', 'Subject  2',[], 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
% text(legend_pos(1), legend_pos(2),'$\bf{F}$','Units','normalized','Fontsize', letter_font)
% nexttile
% scatter_plot( paired_control_E(1,:), paired_control_E(2,:), tail,'Subject  1', 'Subject  2',[], 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
% text(legend_pos(1), legend_pos(2),'$\bf{G}$','Units','normalized','Fontsize', letter_font)
% nexttile
% scatter_plot(paired_control_Snellen(1,:), paired_control_Snellen(2,:), tail,'Subject  1', 'Subject  2',[], 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
% text(legend_pos(1), legend_pos(2),'$\bf{H}$','Units','normalized','Fontsize', letter_font)
% nexttile
% scatter_plot(paired_VA_E_optimal_misspecification(1,:), paired_VA_E_optimal_misspecification(2,:), tail,'Subject  1', 'Subject  2',[], 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
% text(legend_pos(1), legend_pos(2),'$\bf{G}$','Units','normalized','Fontsize', letter_font)
% nexttile
% scatter_plot( paired_VA_Snellen_optimal_misspecification(1,:),  paired_VA_Snellen_optimal_misspecification(2,:), tail,'Subject  1', 'Subject  2',[], 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
% text(legend_pos(1), legend_pos(2),'$\bf{H}$','Units','normalized','Fontsize', letter_font)
% 
