clear all
add_directories

data_directory = [experiment_directory,'/Data'];
figures_folder = [experiment_directory,'/Figures'];

[Pref_vs_E_training, Pref_vs_E_test, acq_vs_random_training, acq_vs_random_test, acq_vs_opt_training, acq_vs_opt_test, optimized_misspecified_vs_optimized_training, optimized_misspecified_vs_optimized_test]  = load_preferences(0);

graphics_style_paper;

% xlabels = {'Acquisition/Optimal', 'Acquisition/Random', 'Preference/E', 'Acquisition/Misspecified'};
xlabels = {'Ground truth', 'Random', 'E', 'Opt. misspec.'};
ylabels = {'Preference',''};
 boxp = 0;
fig=figure('units','centimeters','outerposition',1+[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
fig.Name = 'Preference';
subplot(1,2,1);
Y = {acq_vs_opt_training, acq_vs_random_training, Pref_vs_E_training, 1-optimized_misspecified_vs_optimized_training};
scatter_bar(Y, xlabels, ylabels{1}, 'boxp', boxp)
text(-0.2,1,'A','Units','normalized','Fontsize', 12, 'FontWeight', 'Bold')
subplot(1,2,2);
Y = {acq_vs_opt_test, acq_vs_random_test, Pref_vs_E_test, 1-optimized_misspecified_vs_optimized_test};
scatter_bar(Y, xlabels, ylabels{2}, 'boxp', boxp)
text(-0.18,1,'B','Units','normalized','Fontsize', 12,'FontWeight', 'Bold')
savefig(fig, [figures_folder,'/preferences.fig'])
exportgraphics(fig, [figures_folder,'/preferences.eps'])
exportgraphics(fig, [figures_folder,'/preferences.pdf'])
exportgraphics(fig, [figures_folder,'/preferences.png'])


%%
xlabels = {'Ground truth', 'Random', 'E', 'Opt. misspec.'};
ylabels = {'Preference',''};
fig=figure('units','centimeters','outerposition',1+[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
fig.Name = 'Preference';
subplot(1,2,1);
Y = {acq_vs_opt_training, acq_vs_random_training, Pref_vs_E_training, 1-optimized_misspecified_vs_optimized_training};
barplot(Y, xlabels, ylabels{1})
text(-0.2,1,'A','Units','normalized','Fontsize', 12, 'FontWeight', 'Bold')
subplot(1,2,2);
Y = {acq_vs_opt_test, acq_vs_random_test, Pref_vs_E_test, 1-optimized_misspecified_vs_optimized_test};
barplot(Y, xlabels, ylabels{2})
text(-0.18,1,'B','Units','normalized','Fontsize', 12,'FontWeight', 'Bold')
savefig(fig, [figures_folder,'/preferences.fig'])
exportgraphics(fig, [figures_folder,'/preferences_sem.eps'])
exportgraphics(fig, [figures_folder,'/preferences_sem.pdf'])
exportgraphics(fig, [figures_folder,'/preferences_sem.png'])

%%
n= numel(acq_vs_opt_training);
mr = 1;
mc = 4;
fig=figure();
fig.Color =  [1 1 1];
subplot(mr, mc,1);
phat = betafit(acq_vs_opt_training); 
X = linspace(0,1,100);
Y = betapdf(X, phat(1), phat(2));
plot(X,Y, 'linewidth', linewidth); hold on;
scatter(acq_vs_opt_training,zeros(1,n), markersize, 'k', 'filled'); hold on;
vline(phat(1)/(phat(1)+ phat(2))); hold off
box off
pbaspect([1,1,1])
title('Challenge vs Ground truth')

subplot(mr, mc,2);
phat = betafit(acq_vs_random_training); 
X = linspace(0,1,100);
Y = betapdf(X, phat(1), phat(2));
plot(X,Y, 'linewidth', linewidth); hold on;
scatter(acq_vs_random_training,zeros(1,n), markersize, 'k', 'filled');hold on;
vline(phat(1)/(phat(1)+ phat(2))); hold off
box off
pbaspect([1,1,1])
title('Challenge vs Random')

subplot(mr, mc,3);
phat = betafit(Pref_vs_E_training); 
X = linspace(0,1,100);
Y = betapdf(X, phat(1), phat(2));
plot(X,Y, 'linewidth', linewidth); hold on;
scatter(Pref_vs_E_training,zeros(1,n), markersize, 'k', 'filled');hold on;
vline(phat(1)/(phat(1)+ phat(2))); hold off
box off
pbaspect([1,1,1])
title('Challenge vs TS')

subplot(mr, mc,4);
phat = betafit(1-optimized_misspecified_vs_optimized_training); 
X = linspace(0,1,100);
Y = betapdf(X, phat(1), phat(2));
plot(X,Y, 'linewidth', linewidth); hold on;
scatter(1-optimized_misspecified_vs_optimized_training,zeros(1,n), markersize, 'k', 'filled');hold on;
vline(phat(1)/(phat(1)+ phat(2))); hold off
box off
pbaspect([1,1,1])
title('Challenge vs Challenge Misspecified')

%%mr = 1;
mc = 4;
fig=figure();
fig.Color =  [1 1 1];
subplot(mr, mc,1);
phat = fitdist(acq_vs_opt_training','Beta'); 
X = linspace(0,1,100);
Y = betapdf(X, phat.a, phat.b);
plot(X,Y, 'linewidth', linewidth); hold on;
scatter(acq_vs_opt_training,zeros(1,n), markersize, 'k', 'filled'); hold on;
vline(phat.a/(phat.a+ phat.b)); hold off
box off
pbaspect([1,1,1])
title('Challenge vs Ground truth')

subplot(mr, mc,2);
phat =  fitdist(acq_vs_random_training','Beta'); 
X = linspace(0,1,100);
Y = betapdf(X, phat.a, phat.b);
plot(X,Y, 'linewidth', linewidth); hold on;
scatter(acq_vs_random_training,zeros(1,n), markersize, 'k', 'filled');hold on;
vline(phat.a/(phat.a+ phat.b)); hold off
box off
pbaspect([1,1,1])
title('Challenge vs Random')

subplot(mr, mc,3);
phat =  fitdist(Pref_vs_E_training','Beta'); 
X = linspace(0,1,100);
Y = betapdf(X, phat.a, phat.b);
plot(X,Y, 'linewidth', linewidth); hold on;
scatter(Pref_vs_E_training,zeros(1,n), markersize, 'k', 'filled');hold on;
vline(phat.a/(phat.a+ phat.b)); hold off
box off
pbaspect([1,1,1])
title('Challenge vs TS')

subplot(mr, mc,4);
phat =  fitdist(1-optimized_misspecified_vs_optimized_training','Beta'); 
X = linspace(0,1,100);
Y = betapdf(X, phat.a, phat.b);
plot(X,Y, 'linewidth', linewidth); hold on;
scatter(1-optimized_misspecified_vs_optimized_training,zeros(1,n), markersize, 'k', 'filled');hold on;
vline(phat.a/(phat.a+ phat.b)); hold off
box off
pbaspect([1,1,1])
title('Challenge vs Challenge Misspecified')


%% New set set vs training set
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
subplot(mr, mc,1)
x =acq_vs_opt_training;
y= acq_vs_opt_test;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Optimization set', 'New set',[]); % H1: x – y come from a distribution with greater than 0
text(-0.18,1.15,'A','Units','normalized','Fontsize', 12,'FontWeight', 'Bold')
title('Challenge vs Ground truth')

subplot(mr,mc,2)
x = acq_vs_random_training;
y = acq_vs_random_test;
tail = 'both'; 
scatter_plot(x,y, tail,'Optimization set', '',[]);  %H1 : x – y come from a distribution with median different than 0
text(-0.18,1.15,'B','Units','normalized','Fontsize', 12,'FontWeight', 'Bold')
title('Challenge vs Random')

subplot(mr,mc,3)
x = Pref_vs_E_training;
y = Pref_vs_E_test;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Optimization set', '',[]); %H1 : x – y come from a distribution with median greater than 0 
text(-0.18,1.15,'C','Units','normalized','Fontsize', 12,'FontWeight', 'Bold')
title('Challenge vs TS')

subplot(mr,mc,4)
x = 1-optimized_misspecified_vs_optimized_training;
y = 1-optimized_misspecified_vs_optimized_test;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Optimization set', '',[]); %H1 : x – y come from a distribution with median greater than 0 
title('Ground truth vs misspecified')

%%
seeds_data = T.Model_Seed(1:4:end);
% [~, seeds_data] = sort(seeds_data);

seeds = unique(seeds_data);
acq_vs_random_test_paired = zeros(2, numel(seeds));
acq_vs_random_training_paired= zeros(2, numel(seeds));
acq_vs_opt_test_paired= zeros(2, numel(seeds));
acq_vs_opt_training_paired= zeros(2, numel(seeds));
  
  for i = 1:numel(seeds)
      acq_vs_random_test_paired(:,i) = acq_vs_random_test(seeds_data == seeds(i));
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
scatter_plot(acq_vs_random_test_paired(1,:),acq_vs_random_test_paired(2,:), tail,'Subject 1', 'Subject 2',[], 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0 
title('Challenge vs Random, test')
subplot(mr,mc,2)
scatter_plot(acq_vs_random_training_paired(1,:),acq_vs_random_training_paired(2,:), tail,'Subject 1', 'Subject 2',[], 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0 
title('Challenge vs Random, training')
subplot(mr,mc,3)
scatter_plot(acq_vs_opt_test_paired(1,:),acq_vs_opt_test_paired(2,:), tail,'Subject 1', 'Subject 2',[], 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0 
title('Challenge vs Ground truth, test')
subplot(mr,mc,4)
scatter_plot(acq_vs_opt_training_paired(1,:),acq_vs_opt_training_paired(2,:), tail,'Subject 1', 'Subject 2',[], 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0 
title('Challenge vs Ground truth, training')

