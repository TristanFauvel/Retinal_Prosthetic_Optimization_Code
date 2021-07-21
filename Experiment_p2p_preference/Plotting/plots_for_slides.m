% clear all
add_directories


graphics_style_paper;

data_directory = [experiment_path,'/Data'];
figures_folder = [experiment_path,'/Figures'];
letter_font = 0.01;
reload = 0;
[VA_E_optimized_preference_acq, VA_Snellen_optimized_preference_acq, VA_E_optimal,VA_Snellen_optimal, VA_E_optimized_preference_random,VA_Snellen_optimized_preference_random, VA_E_optimized_preference_acq_misspecification, VA_Snellen_optimized_preference_acq_misspecification, VA_E_optimal_misspecification,VA_Snellen_optimal_misspecification, VA_E_optimized_E_TS,VA_Snellen_optimized_E_TS, VA_E_control,VA_Snellen_control] = load_VA_results(reload);
[Pref_vs_E_training, Pref_vs_E_test, acq_vs_random_training, acq_vs_random_test, acq_vs_opt_training, acq_vs_opt_test, optimized_misspecified_vs_optimized_training, optimized_misspecified_vs_optimized_test]  = load_preferences(reload);

boxp = 0;

VA_scale_E= [];
VA_scale_Snellen= [];
% xlabels = {'Acquisition/Optimal', 'Acquisition/Random', 'Preference/E', 'Acquisition/Misspecified'};
xlabels = {'Random','Ground truth'};
ylabels = {'Preference',''};
fig=figure('units','centimeters','outerposition',1+[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
fig.Name = 'Preference';
subplot(1,3,1);
Y = {acq_vs_random_training, acq_vs_opt_training};
scatter_bar(Y, xlabels, ylabels{1},'boxp', boxp,'stat', 'median', 'pval', 'ineq');
% barplot(Y, xlabels, ylabels{1}, 'scatter_points', 1)
pbaspect([1 1 1])
subplot(1,3,2)
x =acq_vs_opt_training;
y= acq_vs_opt_test;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Optimization set', 'Transfer set',[]); % H1: x – y come from a distribution with greater than 0
title('Challenge vs Ground truth')
subplot(1,3,3)
x = acq_vs_random_training;
y = acq_vs_random_test;
tail = 'both';
scatter_plot(x,y, tail,'Optimization set', '',[]);  %H1 : x – y come from a distribution with median different than 0
title('Challenge vs Random')

fig=figure('units','centimeters','outerposition',1+[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
fig.Name = 'Preference';
x = acq_vs_random_training;
y = acq_vs_random_test;
tail = 'both';
scatter_plot(x,y, tail,'Optimization set', 'Transfer set',[]);  %H1 : x – y come from a distribution with median different than 0
title('Challenge vs Random')

%%
xlabels = {'E (Optimization set)', 'E (Transfer set)'};
ylabels = {'Preference',''};
fig=figure('units','centimeters','outerposition',1+[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
fig.Name = 'Preference';
subplot(1,3,1);
Y = {Pref_vs_E_training, Pref_vs_E_test};
scatter_bar(Y, xlabels, ylabels{1},'boxp', boxp,'stat', 'median', 'pval', 'ineq');
pbaspect([1 1 1])
subplot(1,3,2);
x = VA_E_optimized_E_TS;
y = VA_E_optimized_preference_acq;
scatter_plot(x,y, tail,'TS','Challenge',VA_scale_E);  %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')
subplot(1,3,3);
x = VA_Snellen_optimized_E_TS;
y = VA_Snellen_optimized_preference_acq;
scatter_plot(x,y, tail,'TS','Challenge',VA_scale_E);  %H1 : x – y come from a distribution with median greater than 0
title('Snellen')


%%
fig=figure('units','centimeters','outerposition',1+[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
fig.Name = 'Preference';
subplot(1,3,1);
Y = {Pref_vs_E_training, Pref_vs_E_test};
scatter_bar(Y, xlabels, ylabels{1},'boxp', boxp,'stat', 'median', 'pval', 'ineq');
pbaspect([1 1 1])
subplot(1,3,2);
x = VA_E_optimized_E_TS;
y = VA_E_optimized_preference_acq;
scatter_plot(x,y, tail,'TS','Challenge',VA_scale_E);  %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')
subplot(1,3,3);
x = VA_Snellen_optimized_E_TS;
y = VA_Snellen_optimized_preference_acq;
scatter_plot(x,y, tail,'TS','Challenge',VA_scale_E);  %H1 : x – y come from a distribution with median greater than 0
title('Snellen')


%%
fig=figure('units','centimeters','outerposition',1+[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
fig.Name = 'Preference';
subplot(1,2,1);
y = VA_E_optimized_E_TS;
x = VA_E_control;
scatter_plot(x,y, tail,'Control','TS',VA_scale_E);  %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')
subplot(1,2,2);
y = VA_Snellen_optimized_E_TS;
x = VA_Snellen_control;
scatter_plot(x,y, tail,'Control','TS',VA_scale_Snellen);  %H1 : x – y come from a distribution with median greater than 0
title('Snellen')



%%
fig=figure('units','centimeters','outerposition',1+[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
fig.Name = 'Preference';
subplot(1,2,1);
y = VA_E_optimized_preference_acq_misspecification;
x = VA_E_control;
scatter_plot(x,y, tail,'Control','MaxVarChallenge (Misspecified)',VA_scale_E);  %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')
subplot(1,2,2);
y = VA_Snellen_optimized_preference_acq_misspecification;
x = VA_Snellen_control;
scatter_plot(x,y, tail,'Control','MaxVarChallenge (Misspecified)',VA_scale_Snellen);  %H1 : x – y come from a distribution with median greater than 0
title('Snellen')

%
% mr = 2;
% mc = 4;
% fig=figure();
% fig.Color =  [1 1 1];
% subplot(mr, mc,1);
% phat = fitdist(acq_vs_opt_training','Beta');
% X = linspace(0,1,100);
% Y = betapdf(X, phat.a, phat.b);
% plot(X,Y, 'linewidth', linewidth); hold on;
% scatter(acq_vs_opt_training,zeros(1,numel(acq_vs_opt_training)), markersize, 'k', 'filled'); hold on;
% vline(phat.a/(phat.a+ phat.b)); hold off
% box off
% pbaspect([1,1,1])
% title('Challenge vs Ground truth')
%
% subplot(mr, mc,2);
% phat =  fitdist(acq_vs_random_training','Beta');
% X = linspace(0,1,100);
% Y = betapdf(X, phat.a, phat.b);
% plot(X,Y, 'linewidth', linewidth); hold on;
% scatter(acq_vs_random_training,zeros(1,numel(acq_vs_random_training)), markersize, 'k', 'filled');hold on;
% vline(phat.a/(phat.a+ phat.b)); hold off
% box off
% pbaspect([1,1,1])
% title('Challenge vs Random')
%
% subplot(mr, mc,3);
% phat =  fitdist(Pref_vs_E_training','Beta');
% X = linspace(0,1,100);
% Y = betapdf(X, phat.a, phat.b);
% plot(X,Y, 'linewidth', linewidth); hold on;
% scatter(Pref_vs_E_training,zeros(1,numel(Pref_vs_E_training,zeros)), markersize, 'k', 'filled');hold on;
% vline(phat.a/(phat.a+ phat.b)); hold off
% box off
% pbaspect([1,1,1])
% title('Challenge vs TS')
%
% subplot(mr, mc,4);
% phat =  fitdist(1-optimized_misspecified_vs_optimized_training','Beta');
% X = linspace(0,1,100);
% Y = betapdf(X, phat.a, phat.b);
% plot(X,Y, 'linewidth', linewidth); hold on;
% scatter(1-optimized_misspecified_vs_optimized_training,zeros(1,numel(optimized_misspecified_vs_optimized_training)), markersize, 'k', 'filled');hold on;
% vline(phat.a/(phat.a+ phat.b)); hold off
% box off
% pbaspect([1,1,1])
% title('Challenge vs Challenge Misspecified')


%% Transfer set set vs training set
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
mr= 2;
mc = 2;
fig.Color =  [1 1 1];
subplot(mr, mc,1)
x =acq_vs_opt_training;
y= acq_vs_opt_test;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Optimization set', 'Transfer set',[]); % H1: x – y come from a distribution with greater than 0
text(-0.18,1.15,'A','Units','normalized','Fontsize', letter_font,'FontWeight', 'Bold')
title('Challenge vs Ground truth')

subplot(mr,mc,2)
x = acq_vs_random_training;
y = acq_vs_random_test;
tail = 'both';
scatter_plot(x,y, tail,'Optimization set', '',[]);  %H1 : x – y come from a distribution with median different than 0
text(-0.18,1.15,'B','Units','normalized','Fontsize', letter_font,'FontWeight', 'Bold')
title('Challenge vs Random')

subplot(mr,mc,3)
x = Pref_vs_E_training;
y = Pref_vs_E_test;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Optimization set', '',[]); %H1 : x – y come from a distribution with median greater than 0
text(-0.18,1.15,'C','Units','normalized','Fontsize', letter_font,'FontWeight', 'Bold')
title('Challenge vs TS')

subplot(mr,mc,4)
x = 1-optimized_misspecified_vs_optimized_training;
y = 1-optimized_misspecified_vs_optimized_test;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Optimization set', '',[]); %H1 : x – y come from a distribution with median greater than 0
title('Ground truth vs misspecified')

%%

%%
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
mr = 1;
mc  = 2;
subplot(mr, mc,1)
x = VA_E_control;
y= VA_E_optimized_preference_acq;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Control', 'Challenge',VA_scale_E); % H1: x – y come from a distribution with greater than 0
text(-0.18,1.15,'A','Units','normalized','Fontsize', letter_font,'FontWeight', 'Bold')
title('Tumbling E')
subplot(mr, mc,2)
x = VA_Snellen_control;
y= VA_Snellen_optimized_preference_acq;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Control', 'Challenge',VA_scale_Snellen); % H1: x – y come from a distribution with greater than 0
text(-0.18,1.15,'B','Units','normalized','Fontsize', letter_font,'FontWeight', 'Bold')
title('Snellen')



fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
mr = 1;
mc  = 2;
subplot(mr, mc,1)
x = VA_E_optimized_preference_random;
y= VA_E_optimized_preference_acq;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Random', 'Challenge',VA_scale_E); % H1: x – y come from a distribution with greater than 0
text(-0.18,1.15,'A','Units','normalized','Fontsize', letter_font,'FontWeight', 'Bold')
title('Tumbling E')
subplot(mr, mc,2)
x = VA_Snellen_optimized_preference_random;
y= VA_Snellen_optimized_preference_acq;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Random', 'Challenge',VA_scale_Snellen); % H1: x – y come from a distribution with greater than 0
text(-0.18,1.15,'B','Units','normalized','Fontsize', letter_font,'FontWeight', 'Bold')
title('Snellen')


%%
mr = 1;
mc = 2;
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
fig.Color =  [1 1 1];
fig.Name = 'Ground truth vs misspecified';

subplot(mr,mc,1)
x = VA_E_optimal;
y = VA_E_optimal_misspecification;
scatter_plot(x,y, tail,'Ground truth','Misspecified', VA_scale_E); %H1 : x – y come from a distribution with median less than 0
title('Tumbling E')
subplot(mr,mc,2)
x = VA_Snellen_optimal;
y = VA_Snellen_optimal_misspecification;
scatter_plot(x,y, tail,'Ground truth','Misspecified', VA_scale_Snellen); %H1 : x – y come from a distribution with median less than 0
title('Snellen')

%%
mr = 1;
mc = 2;
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
fig.Color =  [1 1 1];
fig.Name = 'Ground truth vs misspecified';

subplot(mr,mc,1)
y = VA_E_optimized_preference_acq_misspecification;
x = VA_E_optimized_preference_acq;
tail = 'both'; %'right';
scatter_plot(x,y,tail,'Challenge Misspecified','Challenge',VA_scale_E); %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')
subplot(mr,mc,2)
y = VA_Snellen_optimized_preference_acq_misspecification;
x = VA_Snellen_optimized_preference_acq;
tail = 'both'; %'right';
scatter_plot(x,y,tail,'Challenge Misspecified','Challenge',VA_scale_Snellen); %H1 : x – y come from a distribution with median greater than 0
title('Snellen')

%%
mr = 1;
mc = 2;
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
fig.Color =  [1 1 1];
subplot(mr,mc,1)
y = VA_E_optimized_preference_acq-VA_E_optimized_preference_random;
x = acq_vs_random_training;
tail = 'both'; %'right';
scatter_plot(x,y,tail,'Preference MaxVarChallenge/Random','VA MaxVarChallenge/Random',[], 'equal_axes', 0, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')
subplot(mr,mc,2)
y = VA_E_optimized_preference_acq-VA_E_optimal;
x = acq_vs_opt_training;
tail = 'both'; %'right';
scatter_plot(x,y,tail,'Preference MaxVarChallenge/Ground truth','VA MaxVarChallenge/Ground truth',[], 'equal_axes', 0, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')


%%
[val_optimized_preference_acq, val_optimal, val_optimized_preference_random, val_optimized_preference_acq_misspecification, val_optimal_misspecification, val_optimized_E_TS,val_control] = load_values(0);

mr = 1;
mc = 2;
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
fig.Color =  [1 1 1];
subplot(mr,mc,1)
y = VA_E_optimized_preference_acq./VA_E_optimized_preference_random;
x = val_optimized_preference_acq-val_optimized_preference_random;
tail = 'both'; %'right';
scatter_plot(x,y,tail,'VA MaxVarChallenge/Random','value MaxVarChallenge/Random',[], 'equal_axes', 0, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')
subplot(mr,mc,2)
y = VA_E_optimized_preference_acq./VA_E_optimal;
x = val_optimized_preference_acq-val_optimal;
tail = 'both'; %'right';
scatter_plot(x,y,tail,'VA MaxVarChallenge/Ground truth','value MaxVarChallenge/Ground truth',[], 'equal_axes', 0, 'linreg', 1); %H1 : x – y come from a distribution with median greater than 0
title('Tumbling E')
%%


mr = 1;
mc = 4;
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
subplot(mr, mc,1)
x = VA_E_control;
y= VA_Snellen_control;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'E', 'Snellen',[], 'equal_axes', 0, 'linreg', 1); % H1: x – y come from a distribution with greater than 0
title('Control')
text(-0.18,1.15,'A','Units','normalized','Fontsize',  letter_font,'FontWeight', 'Bold')

subplot(mr,mc,2)
x = VA_E_optimal;
y = VA_Snellen_optimal;
tail = 'both';
scatter_plot(x,y, tail,'E', '', [], 'equal_axes', 0, 'linreg', 1); %H1 : x – y come from a distribution with median different than 0*
title('Ground truth')
text(-0.18,1.15,'B','Units','normalized','Fontsize',  letter_font,'FontWeight', 'Bold')

subplot(mr,mc,3)
x = VA_E_optimized_preference_random;
y = VA_Snellen_optimized_preference_random;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'E', '', [], 'equal_axes', 0,  'linreg', 1);  %H1 : x – y come from a distribution with median greater than 0
title('Random')
text(-0.18,1.15,'C','Units','normalized','Fontsize',  letter_font,'FontWeight', 'Bold')

% VA_scale = [];
subplot(mr, mc,4)
x = VA_E_optimized_preference_acq;
y= VA_Snellen_optimized_preference_acq;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'E', 'Snellen', [], 'equal_axes', 0,  'linreg', 1);  % H1: x – y come from a distribution with greater than 0
title('Challenge')
text(-0.18,1.15,'C','Units','normalized','Fontsize',  letter_font,'FontWeight', 'Bold')

%%

fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
fig.Color =  [1 1 1];fig.Name = 'VA Snellen vs E';

VA_E = [VA_E_optimized_preference_acq,  VA_E_optimal, VA_E_optimized_preference_random, VA_E_optimized_preference_acq_misspecification, VA_E_optimal_misspecification, VA_E_optimized_E_TS, VA_E_control];
VA_S = [VA_Snellen_optimized_preference_acq,  VA_Snellen_optimal, VA_Snellen_optimized_preference_random, VA_Snellen_optimized_preference_acq_misspecification, VA_Snellen_optimal_misspecification, VA_Snellen_optimized_E_TS, VA_Snellen_control];
x  = VA_E;
y = VA_S;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'E', 'Snellen',[], 'equal_axes', 0, 'linreg', 1); % H1: x – y come from a distribution with greater than 0

%%
T = load(data_table_file).T;
indices = 1:size(T,1);
indices = indices(T.Acquisition=='maxvar_challenge' & T.Misspecification == 0);
T(indices,:).Subject