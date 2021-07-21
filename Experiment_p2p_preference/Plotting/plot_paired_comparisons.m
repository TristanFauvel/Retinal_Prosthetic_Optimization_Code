% clear all
add_directories


graphics_style_paper;

data_directory = [experiment_path,'/Data'];
figures_folder = [experiment_path,'/Figures'];
letter_size = 0.01;
reload = 0;
[VA_E_optimized_preference_acq, VA_Snellen_optimized_preference_acq, VA_E_optimal,VA_Snellen_optimal, VA_E_optimized_preference_random,VA_Snellen_optimized_preference_random, VA_E_optimized_preference_acq_misspecification, VA_Snellen_optimized_preference_acq_misspecification, VA_E_optimal_misspecification,VA_Snellen_optimal_misspecification, VA_E_optimized_E_TS,VA_Snellen_optimized_E_TS, VA_E_control,VA_Snellen_control] = load_VA_results(reload);
[Pref_vs_E_training, Pref_vs_E_test, acq_vs_random_training, acq_vs_random_test, acq_vs_opt_training, acq_vs_opt_test, optimized_misspecified_vs_optimized_training, optimized_misspecified_vs_optimized_test]  = load_preferences(reload);


T = load(data_table_file).T;

indices = 1:size(T,1);
acquisition= 'maxvar_challenge';
indices = indices(T.Acquisition==acquisition & T.Misspecification == 0);
N = numel(indices);

seeds_data = T(indices,:).Model_Seed;
seeds = unique(seeds_data);

acq_vs_random_test_paired = zeros(2, numel(seeds));
acq_vs_random_training_paired= zeros(2, numel(seeds));
acq_vs_opt_test_paired= zeros(2, numel(seeds));
acq_vs_opt_training_paired= zeros(2, numel(seeds));

for i = 1:numel(seeds)
    acq_vs_random_test_paired(:,i) = acq_vs_random_test(seeds_data== seeds(i));
    acq_vs_random_training_paired(:,i) = acq_vs_random_training(seeds_data == seeds(i));
    acq_vs_opt_test_paired(:,i) = acq_vs_opt_test(seeds_data == seeds(i));
    acq_vs_opt_training_paired(:,i) = acq_vs_opt_training(seeds_data == seeds(i));
end

tail = 'both';
mc = 2;
mr = 2;
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
subplot(mr,mc,1)
scatter_plot(acq_vs_random_test_paired(1,:),acq_vs_random_test_paired(2,:), tail,'Subject  1', 'Subject  2',[], 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
title('Challenge vs Random, test')
subplot(mr,mc,2)
scatter_plot(acq_vs_random_training_paired(1,:),acq_vs_random_training_paired(2,:), tail,'Subject  1', 'Subject  2',[], 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
title('Challenge vs Random, training')
subplot(mr,mc,3)
scatter_plot(acq_vs_opt_test_paired(1,:),acq_vs_opt_test_paired(2,:), tail,'Subject  1', 'Subject  2',[], 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
title('Challenge vs Ground truth, test')
subplot(mr,mc,4)
scatter_plot(acq_vs_opt_training_paired(1,:),acq_vs_opt_training_paired(2,:), tail,'Subject  1', 'Subject  2',[], 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
title('Challenge vs Ground truth, training')



%%
%  [a,b]=groupcounts(seeds_data);
%  seeds_data(any((seeds_data == b(a~=2)')')) = [];
% seeds = unique(seeds_data);
optimized_E= zeros(2, numel(seeds));
gtruth_E =  zeros(2, numel(seeds));
optimized_Snellen= zeros(2, numel(seeds));
gtruth_Snellen =  zeros(2, numel(seeds));
control_E =zeros(2, numel(seeds));
control_Snellen =zeros(2, numel(seeds));

for i = 1:numel(seeds)
    optimized_E(:,i) = VA_E_optimized_preference_acq(seeds_data == seeds(i))';
        optimized_Snellen(:,i) = VA_Snellen_optimized_preference_acq(seeds_data == seeds(i))';
    gtruth_E(:,i) = VA_E_optimal(seeds_data == seeds(i))';
    gtruth_Snellen(:,i) = VA_Snellen_optimal(seeds_data == seeds(i))';
    control_E(:,i) = VA_E_control(seeds_data == seeds(i))';
    control_Snellen(:,i) = VA_Snellen_control(seeds_data == seeds(i))';
end

mr = 2;
mc = 1;
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
subplot(mr,mc,1)
scatter_plot(optimized_E(1,:),optimized_E(2,:), tail,'Subject 1', 'Subject 2',[], 'linreg', 1, 'equal_axes',1);
title('MaxVarChallenge, tumbling E')
subplot(mr,mc,2)
scatter_plot(optimized_Snellen(1,:),optimized_Snellen(2,:), tail,'Subject 1', 'Subject 2',[], 'linreg', 1, 'equal_axes',1);
title('MaxVarChallenge,  Snellen')


mr = 2;
mc = 2;
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
subplot(mr,mc,1)
scatter_plot(gtruth_E(1,:),gtruth_E(2,:), tail,'Subject 1', 'Subject 2',[], 'linreg', 1, 'equal_axes',1);
title('Ground truth, tumbling E')
subplot(mr,mc,2)
scatter_plot(gtruth_Snellen(1,:),gtruth_Snellen(2,:), tail,'Subject 1', 'Subject 2',[], 'linreg', 1, 'equal_axes',1);
title('Ground truth, Snellen')
subplot(mr,mc,3)
scatter_plot(control_E(1,:),control_E(2,:), tail,'Subject 1', 'Subject 2',[], 'linreg', 1, 'equal_axes',1);
title('Control, tumbling E')
subplot(mr,mc,4)
scatter_plot(control_Snellen(1,:),control_Snellen(2,:), tail,'Subject 1', 'Subject 2',[], 'linreg', 1, 'equal_axes',1);
title('Control, Snellen')

mr = 1;
mc = 2;
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
subplot(mr,mc,1)
scatter_plot([gtruth_E(1,:),control_E(1,:)],[gtruth_E(2,:),control_E(2,:)], tail,'Subject 1', 'Subject 2',[], 'linreg', 1, 'equal_axes',1);
title('Tumbling E')
subplot(mr,mc,2)
scatter_plot([gtruth_Snellen(1,:),control_Snellen(1,:)],[gtruth_Snellen(2,:),control_Snellen(2,:)], tail,'Subject 1', 'Subject 2',[], 'linreg', 1, 'equal_axes',1);
title('Snellen')


figname  = ['Figure',num2str(id)];
folder = ['C:\Users\tfauvel\Documents\PhD\Figures\Paper_figures\',figname];
savefig(fig, [folder,'\', figname, '.fig'])
exportgraphics(fig, [folder,'\' , figname, '.pdf']);
exportgraphics(fig, [folder,'\' , figname, '.png'], 'Resolution', 300);
