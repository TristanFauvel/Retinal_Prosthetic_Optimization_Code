clear all
add_directories
% acquisition_fun_name = 'pBOTS'; %422, 437
task = 'preference';
Data_folder = [experiment_path,'/Data'];
figures_folder = [experiment_path,'/Figures'];
alpha =0.01;

graphics_style_paper;

T = load(data_table_file).T;
T = T(T.Subject == 'TF',:);
T = T(13:end,:);

seed_condition = (T.Seed == 2 | T.Seed == 3 | T.Seed == 4 | T.Seed == 5 | T.Seed == 6);

indices_preference_kss = 1:size(T,1);

indices_preference_kss = indices_preference_kss(seed_condition & T.Task == task & T.Acquisition=='kernelselfsparring' & T.Misspecification==0);

indices_preference_kss_misspecification = 1:size(T,1);
indices_preference_kss_misspecification = indices_preference_kss_misspecification(seed_condition & T.Task == task & T.Misspecification==1);


indices_preference_random = 1:size(T,1);
indices_preference_random = indices_preference_random(seed_condition & T.Task ==task & T.Acquisition=='random');


indices_pPBOTS = 1:size(T,1);
indices_pPBOTS = indices_pPBOTS(seed_condition &  T.Task == task & T.Acquisition=='pBOTS' & T.Misspecification==0);
indices_pPBOTS = indices_pPBOTS(3:end);
% indices_preference_pBOrand = 1:size(T,1);
% indices_preference_pBOrand = indices_preference_pBOTS(T.Task == task & T.Acquisition=='pBOTS' & T.Misspecification==0);
% 
indices_E = 1:size(T,1);
indices_E = indices_E(seed_condition & T.Task == 'E');


%Remove the experiments for which the seed does not match random equivalent
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sdiff = setdiff(T(indices_preference_kss,:).Seed,T(indices_preference_random,:).Seed);
% sdiff = [sdiff;setdiff(T(indices_preference_kss,:).Seed,T(indices_preference_kss_misspecification,:).Seed)];
% sdiff = [sdiff;setdiff(T(indices_preference_kss,:).Seed,T(indices_E,:).Seed)];
%    
% if ~isempty(sdiff)
%     indices_preference_kss(any(T(indices_preference_kss,:).Seed' == sdiff)) = [];
%     indices_preference_random(any(T(indices_preference_random,:).Seed' == sdiff)) = [];
%     indices_preference_kss_misspecification(any(T(indices_preference_kss_misspecification,:).Seed' == sdiff)) = [];
%     indices_E(any(T(indices_E,:).Seed' == sdiff)) = [];       
% end
% [a,b] = sort(T(indices_preference_kss,:).Seed);
% indices_preference_kss = indices_preference_kss(b);
% [a,b] = sort(T(indices_preference_random,:).Seed);
% indices_preference_random= indices_preference_random(b);

% in = intersect(intersect(T(indices_preference_kss,:).Seed,T(indices_preference_random,:).Seed), T(indices_pPBOTS,:).Seed);
% in = intersect(T(indices_preference_kss,:).Seed,T(indices_preference_random,:).Seed);
% T(indices_pPBOTS,:).Seed == in
[a,b] = sort(T(indices_preference_kss,:).Seed);
indices_preference_kss = indices_preference_kss(b);
[a,b] = sort(T(indices_preference_random,:).Seed);
indices_preference_random= indices_preference_random(b);
[a,b] = sort(T(indices_E,:).Seed);
indices_E= indices_E(b);
[a,b] = sort(T(indices_pPBOTS,:).Seed);
indices_pPBOTS= indices_pPBOTS(b);

acuity_naive_preference_kss = [];
acuity_optimized_preference_kss = [];
acuity_optimal = [];
acuity_naive_preference_random = [];
acuity_optimized_preference_random = [];
acuity_optimal_preference_random = [];
acuity_naive_preference_kss_misspecification = [];
acuity_optimized_preference_kss_misspecification = [];
acuity_optimal_misspecification = [];
acuity_optimized_E_TS = [];
acuity_optimized_E_random = [];
acuity_optimized_DTS = [];
acuity_optimized_pPBO_random = [];
acuity_optimized_pPBOTS = [];

cs_naive_preference_kss = [];
cs_optimized_preference_kss = [];
cs_optimal = [];
cs_naive_preference_random = [];
cs_optimized_preference_random = [];
cs_optimal_preference_random = [];
cs_naive_preference_kss_misspecification = [];
cs_optimized_preference_kss_misspecification = [];
cs_optimal_misspecification = [];
cs_optimized_E_TS = [];
cs_optimized_E_random = [];
cs_optimized_DTS = [];
cs_optimized_pPBO_random = [];
cs_optimized_pPBOTS = [];



for i =1:numel(indices_preference_kss)
    index = indices_preference_kss(i);
    filename = [Data_folder, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    load(filename, 'experiment');
    
%     acuity_naive_preference_kss = [acuity_naive_preference_kss, experiment.acuity_E_naive];
    acuity_optimized_preference_kss = [acuity_optimized_preference_kss, experiment.acuity_E_optimized];
    acuity_optimal = [acuity_optimal, experiment.acuity_E_optimal];
%     cs_naive_preference_kss = [cs_naive_preference_kss, experiment.cs_E_naive];
    cs_optimized_preference_kss = [cs_optimized_preference_kss, experiment.cs_E_optimized];
    cs_optimal = [cs_optimal, experiment.cs_E_optimal];
end

misspecification = [];
for i =1:numel(indices_preference_kss_misspecification)
    index = indices_preference_kss_misspecification(i);
    filename = [Data_folder, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    load(filename, 'experiment');
    m = (experiment.true_model_params(end-2:end) - [experiment.beta_sup;experiment.beta_inf; experiment.z]);
    m = m./[experiment.beta_sup_range(2)-experiment.beta_sup_range(1);experiment.beta_inf_range(2)-experiment.beta_inf_range(1);experiment.z_range(2)-experiment.z_range(1)];
    misspecification = [misspecification, mean(m.^2)];
    
%     acuity_naive_preference_kss_misspecification = [acuity_naive_preference_kss_misspecification, experiment.acuity_E_naive];
    acuity_optimized_preference_kss_misspecification = [acuity_optimized_preference_kss_misspecification, experiment.acuity_E_optimized];
    acuity_optimal_misspecification = [acuity_optimal_misspecification, experiment.acuity_E_optimal];
%     cs_naive_preference_kss_misspecification = [cs_naive_preference_kss_misspecification, experiment.cs_E_naive];
    cs_optimized_preference_kss_misspecification = [cs_optimized_preference_kss_misspecification, experiment.cs_E_optimized];
    cs_optimal_misspecification = [cs_optimal_misspecification, experiment.cs_E_optimal];

end
    
for i =1:numel(indices_preference_random)
    index = indices_preference_random(i);
    filename = [Data_folder,'/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    load(filename, 'experiment');

    acuity_optimized_preference_random = [acuity_optimized_preference_random, experiment.acuity_E_optimized];
    cs_optimized_preference_random = [cs_optimized_preference_random, experiment.cs_E_optimized];
end


for i =1:numel(indices_E)
    index = indices_E(i);
    filename = [Data_folder,'/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    load(filename, 'experiment');
    acquisition_fun_name = T(index,:).Acquisition;
    if acquisition_fun_name == 'TS_binary'
        cs_optimized_E_TS = [cs_optimized_E_TS, experiment.cs_E_optimized];
        acuity_optimized_E_TS = [acuity_optimized_E_TS, experiment.acuity_E_optimized];
    elseif acquisition_fun_name == 'random'
        cs_optimized_E_random = [cs_optimized_E_random, experiment.cs_E_optimized];
        acuity_optimized_E_random = [acuity_optimized_E_random, experiment.acuity_E_optimized];
    end
end



for i =1:numel(indices_pPBOTS)
    index = indices_pPBOTS(i);
    filename = [Data_folder,'/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    load(filename, 'experiment');
    cs_optimized_pPBOTS = [cs_optimized_pPBOTS, experiment.cs_E_optimized];
    acuity_optimized_pPBOTS = [acuity_optimized_pPBOTS, experiment.acuity_E_optimized];
end

barcol = [1,1,1];
linecol= [0,0,0];
offset = 0.4;
% acuity_naive_preference_kss = log10(10./acuity_naive_preference_kss);
% acuity_optimized_preference_kss = log10(10./acuity_optimized_preference_kss);
% acuity_optimal = log10(10./acuity_optimal);
% acuity_optimized_preference_random = log10(10./acuity_optimized_preference_random);
% acuity_optimized_preference_kss_misspecification = log10(10./acuity_optimized_preference_kss_misspecification);
% acuity_optimal_misspecification = log10(10./acuity_optimal_misspecification);
% acuity_optimized_E_TS = log10(10./acuity_optimized_E_TS);
% acuity_optimized_E_random = log10(10./acuity_optimized_E_random);
% acuity_optimized_DTS = log10(10./acuity_optimized_DTS);
% acuity_optimized_pPBOTS = log10(10./acuity_optimized_pPBOTS);
% 
y = [mean(cs_optimal), mean(cs_optimized_preference_kss), mean(cs_optimized_preference_random), mean(cs_optimized_preference_kss_misspecification), mean(cs_optimal_misspecification), mean(cs_optimized_E_TS),mean(cs_optimized_E_random)];
X = 0:numel(y)-1; %categorical({'Naive', 'Optimal', 'KSS', 'Random'});

fig=figure('units','points','outerposition',[0 0 426/2 2/3*426]);
fig.Name = 'mean CS comparison';
fig.Color =  [1 1 1];
h =bar(X,y,'Facecolor', barcol); hold on
xticklabels({'Optimal', 'KSS', 'Random', 'KSS misspecified', 'Optimal misspecified', 'E TS', 'E Random'})
box off
ylabel('Contrast sensitivity')
i=0;
% scatter(i*ones(1,numel(cs_naive_preference_kss)),cs_naive_preference_kss, markersize, 'k', 'filled'); hold on;
% i=i+1;
scatter(i*ones(1,numel(cs_optimal)),cs_optimal, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(cs_optimized_preference_kss)),cs_optimized_preference_kss, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(cs_optimized_preference_random)),cs_optimized_preference_random, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(cs_optimized_preference_kss_misspecification)),cs_optimized_preference_kss_misspecification, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(cs_optimal_misspecification)),cs_optimal_misspecification, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(cs_optimized_E_TS)),cs_optimized_E_TS, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(cs_optimized_E_random)),cs_optimized_E_random, markersize, 'k', 'filled'); hold on;
% i=i+1;
% scatter(i*ones(1,numel(cs_optimized_pPBOTS)),cs_optimized_pPBOTS, markersize, 'k', 'filled'); hold off;
xlim([-offset,numel(y)-offset])


%%%%%%%%%


y = [mean(cs_optimal), mean(cs_optimized_preference_kss), mean(cs_optimized_preference_random), mean(cs_optimized_E_TS),mean(cs_optimized_E_random)];
X = 0:numel(y)-1; %categorical({'Naive', 'Optimal', 'KSS', 'Random'});
[h1,p1,ci,stats]  = ttest2(cs_optimal,cs_optimized_preference_kss, 'tail', 'both','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is different from acuity_optimal
[h2,p2,ci,stats]  = ttest2(cs_optimized_preference_kss,cs_optimized_preference_random, 'tail', 'left','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_optimal_preference_random
[h3,p3,ci,stats]  = ttest2(cs_optimized_E_TS,cs_optimized_E_random, 'tail', 'left','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_optimal_preference_random
[h4,p4,ci,stats]  = ttest2(cs_optimized_E_TS,cs_optimized_E_random, 'tail', 'left','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_optimal_preference_random

fig=figure('units','points','outerposition',[0 0 426/2 2/3*426]);
fig.Color =  [1 1 1];
fig.Name = 'Mean CS comparison KSS/E/random';
h =bar(X,y,'Facecolor', barcol); hold on
xticklabels({'Optimal', 'KSS', 'Random', 'E TS', 'E Random'})
box off
ylabel('Contrast sensitivity')
i=0;
scatter(i*ones(1,numel(cs_optimal)),cs_optimal, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(cs_optimized_preference_kss)),cs_optimized_preference_kss, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(cs_optimized_preference_random)),cs_optimized_preference_random, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(cs_optimized_E_TS)),cs_optimized_E_TS, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(cs_optimized_E_random)),cs_optimized_E_random, markersize, 'k', 'filled'); hold on;
xlim([-offset,numel(y)-offset])

% scatter(5*ones(1,numel(cs_optimized_pPBOTS)),cs_optimized_pPBOTS, markersize, 'k', 'filled'); hold off;
% 
% m=ylim;
% m=m(2);
% plot([X(1),X(3)],[m,m],'linewidth', linewidth, 'color', linecol)
% % plot((X(3)+X(1))/2,4+0.2,'*', 'color', linecol, 'MarkerSize', 25, 'LineWidth',linewidth)
% text((X(3)+X(1))/2,m*(1+0.01),markers{h1+1},'HorizontalAlignment','center')
% shift= 0.03;
% plot([X(2),X(3)],[m*(1+0.08),m*(1+0.08)],'linewidth', linewidth, 'color', linecol)
% text((X(3)+X(2))/2,m*(1+0.08+shift),markers{h2+1},'HorizontalAlignment','center')
% 
% plot([X(3),X(4)],[m*(1+0.04),m*(1+0.04)],'linewidth', linewidth, 'color', linecol)
% text((X(3)+X(4))/2,m*(1+0.04+shift),markers{h3+1},'HorizontalAlignment','center')

[h1,p1,ci,stats]  = ttest2(cs_optimal,cs_optimized_preference_kss, 'tail', 'both','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is different from acuity_optimal
[h2,p2,ci,stats]  = ttest2(cs_optimized_preference_kss,cs_optimized_preference_random, 'tail', 'left','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_optimal_preference_random
[h3,p3,ci,stats]  = ttest2(cs_optimized_E_TS,cs_optimized_E_random, 'tail', 'left','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_optimal_preference_random
[h4,p4,ci,stats]  = ttest2(cs_optimized_E_TS,cs_optimized_E_random, 'tail', 'left','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_optimal_preference_random

y = [median(cs_optimal), median(cs_optimized_preference_kss), median(cs_optimized_preference_random), median(cs_optimized_E_TS),median(cs_optimized_E_random)];
X = 0:numel(y)-1; %categorical({'Naive', 'Optimal', 'KSS', 'Random'});
fig.Name = 'Median CS comparison KSS/E/random';

fig=figure('units','points','outerposition',[0 0 426/2 2/3*426]);
fig.Color =  [1 1 1];
h =bar(X,y,'Facecolor', barcol); hold on
xticklabels({'Optimal', 'KSS', 'Random', 'E TS', 'E Random'})
box off
ylabel('Contrast sensitivity')
i=0;
scatter(i*ones(1,numel(cs_optimal)),cs_optimal, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(cs_optimized_preference_kss)),cs_optimized_preference_kss, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(cs_optimized_preference_random)),cs_optimized_preference_random, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(cs_optimized_E_TS)),cs_optimized_E_TS, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(cs_optimized_E_random)),cs_optimized_E_random, markersize, 'k', 'filled'); hold off;
xlim([-offset,numel(y)-offset])


y = [mean(acuity_optimal), mean(acuity_optimized_preference_kss), mean(acuity_optimized_preference_random), mean(acuity_optimized_E_TS),mean(acuity_optimized_E_random)];
X = 0:numel(y)-1; %categorical({'Naive', 'Optimal', 'KSS', 'Random'});

fig=figure('units','points','outerposition',[0 0 426/2 2/3*426]);
fig.Color =  [1 1 1];
fig.Name = 'Mean VA comparison KSS/E/random';

h =bar(X,y,'Facecolor', barcol); hold on
xticklabels({'Optimal', 'KSS', 'Random', 'E TS', 'E Random'})
box off
ylabel('Visual acuity (log(MAR))')
i=0;
scatter(i*ones(1,numel(acuity_optimal)),acuity_optimal, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(acuity_optimized_preference_kss)),acuity_optimized_preference_kss, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(acuity_optimized_preference_random)),acuity_optimized_preference_random, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(acuity_optimized_E_TS)),acuity_optimized_E_TS, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(acuity_optimized_E_random)),acuity_optimized_E_random, markersize, 'k', 'filled'); hold on;
% i=i+1;
% scatter(i*ones(1,numel(acuity_optimized_pPBOTS)),acuity_optimized_pPBOTS, markersize, 'k', 'filled'); hold off;
xlim([-offset,numel(y)-offset])

fig=figure('units','points','outerposition',[0 0 426/2 2/3*426]);
fig.Color =  [1 1 1];
fig.Name = 'Optimized vs Optimal VA';
scatter(acuity_optimal, acuity_optimized_preference_kss, markersize, 'filled'); hold on;
scatter(acuity_optimal, acuity_optimized_preference_random, markersize, 'filled'); hold on;
scatter(acuity_optimal, acuity_optimized_E_TS, markersize, 'filled'); hold on;
scatter(acuity_optimal, acuity_optimized_E_random, markersize, 'filled'); hold on;
% scatter(acuity_optimal, acuity_optimized_pPBOTS, markersize, 'filled'); hold off;
ylabel('Visual acuity (log(MAR))')
xlabel('Visual acuity (log(MAR)) with the optimal encoder')
legend({'KSS', 'Random', 'E TS', 'E Random'})
box off


fig=figure('units','points','outerposition',[0 0 426/2 2/3*426]);
fig.Color =  [1 1 1];
fig.Name = 'Optimized vs Optimal CS';
scatter(cs_optimal, cs_optimized_preference_kss, markersize, 'filled'); hold on;
scatter(cs_optimal, cs_optimized_preference_random, markersize, 'filled'); hold on;
scatter(cs_optimal, cs_optimized_E_TS, markersize, 'filled'); hold on;
scatter(cs_optimal, cs_optimized_E_random, markersize, 'filled'); hold on;
% scatter(cs_optimal, cs_optimized_pPBOTS, markersize, 'filled'); hold off;
ylabel('Contrast sensitivity')
xlabel('Contrast sensitivity with the optimal encoder')
legend({'KSS', 'Random', 'E TS', 'E Random'})
box off
% xlim([-offset,numel(y)-offset])



fig=figure('units','points','outerposition',[0 0 426/2 2/3*426]);
fig.Color =  [1 1 1];
subplot(1,4,1)
scatter(acuity_optimized_preference_kss, cs_optimized_preference_kss, markersize, 'filled');
xlabel('Visual acuity')
ylabel('Contrast sensitivity')
title('KSS')
box off
pbaspect([1,1,1])

subplot(1,4,2)
scatter(acuity_optimized_preference_random, cs_optimized_preference_random, markersize, 'filled'); 
title('Non-adaptive pref.')
xlabel('Visual acuity')
ylabel('Contrast sensitivity')
box off
pbaspect([1,1,1])

subplot(1,4,3)
scatter(acuity_optimized_E_TS, cs_optimized_E_TS, markersize, 'filled');
title('E TS')
xlabel('Visual acuity')
ylabel('Contrast sensitivity')
box off
pbaspect([1,1,1])

subplot(1,4,4)
scatter(acuity_optimized_E_random, cs_optimized_E_random, markersize, 'filled'); 
title('E Random')
xlabel('Visual acuity')
ylabel('Contrast sensitivity')
box off
pbaspect([1,1,1])

% %%
% y = [mean(acuity_optimal), mean(acuity_optimized_preference_kss), mean(acuity_optimized_preference_random), mean(acuity_optimized_preference_kss_misspecification), mean(acuity_optimal_misspecification), mean(acuity_optimized_E_TS), mean(acuity_optimized_E_random)];
% X = 0:numel(y)-1;
% fig=figure('units','points','outerposition',[0 0 426/2 2/3*426]);
% fig.Color =  [1 1 1];
% h =bar(X,y,'Facecolor', barcol); hold on
% xticklabels({'Optimal', 'KSS', 'Random', 'Optimized misspecified', 'Optimal misspecified', 'E TS', 'E Random'})
% box off
% ylabel('VA')



% [h1,p1,ci,stats]  = ttest2(acuity_optimized_preference_kss,acuity_naive_preference_kss, 'tail', 'left','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_naive_preference_kss
[h2,p2,ci,stats]  = ttest2(acuity_optimal,acuity_optimized_preference_kss, 'tail', 'both','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is different from acuity_optimal
[h3,p3,ci,stats]  = ttest2(acuity_optimized_preference_kss,acuity_optimized_preference_random, 'tail', 'left','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_optimal_preference_random
% 
markers = {'n.s.','*'};
%y = [mean(acuity_naive_preference_kss), mean(acuity_optimal), mean(acuity_optimized_preference_kss), mean(acuity_optimized_preference_random)];
y = [mean(acuity_optimal), mean(acuity_optimized_preference_kss), mean(acuity_optimized_preference_random), mean(acuity_optimized_preference_kss_misspecification),mean(acuity_optimal_misspecification), mean(acuity_optimized_E_TS), mean(acuity_optimized_E_random)];
X = 0:numel(y)-1;
% fig=figure('units','normalized','outerposition',[0 0 1 1]);
fig=figure('units','points','outerposition',[0 0 426/2 2/3*426]);
fig.Color =  [1 1 1];
fig.Name = 'mean VA';
h =bar(X,y,'Facecolor', barcol); hold on
% scatter(0*ones(1,numel(acuity_naive_preference_kss)),acuity_naive_preference_kss, markersize, 'k', 'filled'); hold on;
i=0;
scatter(i*ones(1,numel(acuity_optimal)),acuity_optimal, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(acuity_optimized_preference_kss)),acuity_optimized_preference_kss, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(acuity_optimized_preference_random)),acuity_optimized_preference_random, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(acuity_optimized_preference_kss_misspecification)),acuity_optimized_preference_kss_misspecification, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(acuity_optimal_misspecification)),acuity_optimal_misspecification, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(acuity_optimized_E_TS)),acuity_optimized_E_TS, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(acuity_optimized_E_random)),acuity_optimized_E_random, markersize, 'k', 'filled'); hold on;
% i=i+1;
% scatter(i*ones(1,numel(acuity_optimized_pPBOTS)),acuity_optimized_pPBOTS, markersize, 'k', 'filled'); hold off;
xticklabels({'Optimal', 'KSS', 'Random','Optimized misspecified', 'Optimal misspecified','E TS', 'E Random'})
xlim([-offset,numel(y)-offset])

box off
ylabel('logMAR')
m=ylim;
m=m(2);
plot([X(1),X(3)],[m,m],'linewidth', linewidth, 'color', linecol)
% plot((X(3)+X(1))/2,4+0.2,'*', 'color', linecol, 'MarkerSize', 25, 'LineWidth',linewidth)
text((X(3)+X(1))/2,m*(1+0.01),markers{h1+1},'HorizontalAlignment','center')
shift= 0.03;
plot([X(2),X(3)],[m*(1+0.08),m*(1+0.08)],'linewidth', linewidth, 'color', linecol)
text((X(3)+X(2))/2,m*(1+0.08+shift),markers{h2+1},'HorizontalAlignment','center')

plot([X(3),X(4)],[m*(1+0.04),m*(1+0.04)],'linewidth', linewidth, 'color', linecol)
text((X(3)+X(4))/2,m*(1+0.04+shift),markers{h3+1},'HorizontalAlignment','center')
% xlim([-0.4,3.6])

savefig(fig, [figures_folder,'/acuity_comparisons.fig'])
exportgraphics(fig, [figures_folder,'/acuity_comparisons.eps'])
exportgraphics(fig, [figures_folder,'/acuity_comparisons.pdf'])


% y = [median(acuity_naive_preference_kss), median(acuity_optimal), median(acuity_optimized_preference_kss), median(acuity_optimized_preference_random), median(acuity_optimized_preference_kss_misspecification),median(acuity_optimal_misspecification), median(acuity_optimized_E_TS), mean(acuity_optimized_E_random), median(acuity_optimized_pPBOTS)];
y = [median(acuity_optimal), median(acuity_optimized_preference_kss), median(acuity_optimized_preference_random), median(acuity_optimized_preference_kss_misspecification),median(acuity_optimal_misspecification), median(acuity_optimized_E_TS), mean(acuity_optimized_E_random)];

X = 0:numel(y)-1;
% fig=figure('units','normalized','outerposition',[0 0 1 1]);
fig=figure('units','points','outerposition',[0 0 426/2 2/3*426]);
fig.Color =  [1 1 1];
fig.Name = 'Median VA';

h =bar(X,y,'Facecolor', barcol); hold on
i=0;
scatter(i*ones(1,numel(acuity_optimal)),acuity_optimal, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(acuity_optimized_preference_kss)),acuity_optimized_preference_kss, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(acuity_optimized_preference_random)),acuity_optimized_preference_random, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(acuity_optimized_preference_kss_misspecification)),acuity_optimized_preference_kss_misspecification, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(acuity_optimal_misspecification)),acuity_optimal_misspecification, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(acuity_optimized_E_TS)),acuity_optimized_E_TS, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,numel(acuity_optimized_E_random)),acuity_optimized_E_random, markersize, 'k', 'filled'); hold on;
% i=i+1;
% scatter(i*ones(1,numel(acuity_optimized_pPBOTS)),acuity_optimized_pPBOTS, markersize, 'k', 'filled'); hold off;
xticklabels({'Optimal', 'KSS', 'Random','Optimized misspecified', 'Optimal misspecified','E TS', 'E Random'})
xlim([-offset,numel(y)-offset])

box off
ylabel('logMAR')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y = [mean(acuity_optimized_preference_kss'-acuity_optimal'), ...
    mean(acuity_optimized_preference_random'-acuity_optimal'), mean(acuity_optimized_E_TS'-acuity_optimal'), ...
    mean(acuity_optimized_E_random'-acuity_optimal')];
X = 0:(numel(y)-1);

[h1,p1,ci,stats]  = ttest2(acuity_optimized_preference_kss-acuity_optimal,acuity_optimized_preference_random-acuity_optimal, 'tail', 'left','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_naive_preference_kss
[h2,p2,ci,stats]  = ttest2(acuity_optimized_E_TS-acuity_optimal,acuity_optimized_E_random-acuity_optimal, 'tail', 'both','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is different from acuity_optimal
% [h3,p3,ci,stats]  = ttest2(acuity_optimized_preference_kss-acuity_optimal,acuity_optimized_pPBOTS-acuity_optimal, 'tail', 'left','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_optimal_preference_random
[h4,p4,ci,stats]  = ttest2(acuity_optimized_preference_kss-acuity_optimal,acuity_optimized_E_TS-acuity_optimal, 'tail', 'left','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_optimal_preference_random

fig=figure('units','points','outerposition',[0 0 426/2 2/3*426]);
fig.Color =  [1 1 1];
fig.Name = 'Mean log(MAR ratio)';
h =bar(X,y,'Facecolor', barcol); hold on
n = 5;
i=0;
scatter(i*ones(1,n),acuity_optimized_preference_kss-acuity_optimal, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),acuity_optimized_preference_random-acuity_optimal, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),acuity_optimized_E_TS-acuity_optimal, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),acuity_optimized_E_random-acuity_optimal, markersize, 'k', 'filled'); hold on;
% i=i+1;
% scatter(i*ones(1,n),acuity_optimized_pPBOTS-acuity_optimal, markersize, 'k', 'filled'); hold on;
xticklabels({'KSS', 'Random', 'E TS', 'E Random'});%'Misspecification optimized', 'Misspecification optimal'})
box off
ylabel('Log(MAR ratio)')
m=ylim;
m=m(2);
plot([X(1),X(2)],[m,m],'linewidth', linewidth, 'color', linecol)
text((X(2)+X(1))/2,m+0.05,markers{h1+1},'HorizontalAlignment','center')
plot([X(3),X(4)],[m+0.05,m+0.05],'linewidth', linewidth, 'color', linecol)
text((X(3)+X(4))/2,m+0.1,markers{h2+1},'HorizontalAlignment','center')
% plot([X(1),X(5)],[m+0.12,m+0.12],'linewidth', linewidth, 'color', linecol)
% text((X(1)+X(5))/2,m+0.17,markers{h4+1},'HorizontalAlignment','center')
xlim([-offset,numel(y)-offset])


savefig(fig, [figures_folder,'/acuity_comparisons.fig'])
exportgraphics(fig, [figures_folder,'/acuity_comparisons.eps'])
exportgraphics(fig, [figures_folder,'/acuity_comparisons.pdf'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù

y = [median(acuity_optimized_preference_kss'-acuity_optimal'), ...
    median(acuity_optimized_preference_random'-acuity_optimal'), median(acuity_optimized_E_TS'-acuity_optimal'), ...
    median(acuity_optimized_E_random'-acuity_optimal')];
X = 0:(numel(y)-1);

fig=figure('units','points','outerposition',[0 0 426/2 2/3*426]);
fig.Color =  [1 1 1];
fig.Name = 'Median log(MAR ratio)';

h =bar(X,y,'Facecolor', barcol); hold on
n = numel(acuity_optimal);
i=0;
scatter(i*ones(1,n),acuity_optimized_preference_kss-acuity_optimal, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),acuity_optimized_preference_random-acuity_optimal, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),acuity_optimized_E_TS-acuity_optimal, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),acuity_optimized_E_random-acuity_optimal, markersize, 'k', 'filled'); hold on;
% i=i+1;
% scatter(i*ones(1,n),acuity_optimized_pPBOTS-acuity_optimal, markersize, 'k', 'filled'); hold on;
xticklabels({'KSS', 'Random', 'E TS', 'E Random'});%'Misspecification optimized', 'Misspecification optimal'})
box off
ylabel('Log(MAR ratio)')
xlim([-offset,numel(y)-offset])

% figure();
% scatter(misspecification,acuity_optimized_preference_kss_misspecification - acuity_optimal_misspecification);
% 
% figure();
% scatter(acuity_optimal-acuity_optimal_misspecification,acuity_optimized_preference_kss_misspecification - acuity_optimal_misspecification);

% 
% %%
% for i=1:numel(indices_preference_kss)
%     index = indices_preference_kss(i);
%     filename = [data_directory,'/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
%     load(filename, 'experiment');
%     UNPACK_STRUCT(experiment.VA_CS_measure_optimized, false);
% 
%     %x=0:701;
%     x= x_norm.*(bounds(:,2)-bounds(:,1))+bounds(:,1);
%     xcm = x(1,:)./experiment.dpcm;
%     xtrain_cm = xtrain./experiment.dpcm;
%     fig = figure();
%     fig.Color = [1 1 1];
%     
%     fitresult = glmfit(xtrain', ctrain', 'binomial','link','probit');
%     pred_fit = glmval(fitresult, x, 'probit');
%     
%     plot(xcm, pred_fit, 'linewidth', 1.5); hold on;
%     
%     
%     xtrain = experiment.xtrain_acuity_naive;
%     ctrain =experiment.ctrain_acuity_naive;
%     fitresult = glmfit(xtrain, ctrain', 'binomial','link','probit');
%     pred_fit = glmval(fitresult, x, 'probit');
%     
%     plot(xcm, pred_fit, 'linewidth', 1.5); hold on;
%     
%     xtrain = experiment.xtrain_acuity_optimal;
%     ctrain =experiment.ctrain_acuity_optimal;
%     fitresult = glmfit(xtrain, ctrain', 'binomial','link','probit');
%     pred_fit = glmval(fitresult, x, 'probit');
%     
%     plot(xcm, pred_fit, 'linewidth', 1.5); hold off;
%     
%     ylim([0,1])
%     box off
%     legend({'Optimized','Naive', 'Optimal'})
% end
% 
% savefig(fig, [figures_folder,'/acuity_measurement.fig'])
% exportgraphics(fig, [figures_folder,'/acuity_measurement.eps'])
% exportgraphics(fig, [figures_folder,'/acuity_measurement.pdf'])



% x = -30:0.1:30;
% 
% pred_fit = glmval([0; acuity(1)], x, 'probit');
% 
% fig = figure();
% fig.Color = [1 1 1];
% plot(x, pred_fit, 'linewidth', 4, 'color', barcol); hold on;
% xlabel('Offset')
% ylabel('Probability of a response to the right')
% box off
% 
% 
data_directory = '/home/tfauvel/Desktop/optim_retina/Data';
subject = 'TF';

seeds = 2:6;
n_seeds = numel(seeds);
kss_vs_random_results = zeros(1,n_seeds);
kss_vs_E_results = zeros(1,n_seeds);
optimal_vs_kss_results = zeros(1,n_seeds);
E_TS_vs_E_random_results = zeros(1,n_seeds);
kss_vs_E_results = zeros(1,n_seeds);
kss_vs_pBO_results = zeros(1,n_seeds);

for i = 1:n_seeds
    seed = seeds(i);
    load([data_directory, '/c_kss_vs_random_',subject, '_', num2str(seed),'.mat'],'kss_vs_random');
    kss_vs_random_results(i) = kss_vs_random;
    load([data_directory,'/c_kss_vs_E_',subject, '_',num2str(seed),'.mat'],'kss_vs_E');
    kss_vs_E_results(i) = kss_vs_E;
    load([data_directory,'/c_optimal_vs_kss_',subject, '_',num2str(seed),'.mat'],'optimal_vs_kss');
    optimal_vs_kss_results(i) = optimal_vs_kss;
    load([data_directory,'/c_E_TS_vs_E_random_',subject,'_',num2str(seed),'.mat'],'E_TS_vs_E_random');
    E_TS_vs_E_random_results(i) = E_TS_vs_E_random;
    load([data_directory,'/c_kss_vs_E_',subject, '_',num2str(seed),'.mat'],'kss_vs_E');
    kss_vs_E_results(i) = kss_vs_E;
    load([data_directory,'/c_kss_vs_pBO_',subject, '_',num2str(seed),'.mat'],'kss_vs_pBO');
    kss_vs_pBO_results(i) = kss_vs_pBO;
end

fig=figure('units','points','outerposition',[0 0 426/2 2/3*426]);
fig.Color =  [1 1 1];
scatter(1-optimal_vs_kss_results, acuity_optimized_preference_kss-acuity_optimal, markersize, 'k', 'filled'); hold off;
xlabel('Preference for KSS vs optimal')
ylabel('log(MAR ratio) KSS/optimal')

fig=figure('units','points','outerposition',[0 0 426/2 2/3*426]);
fig.Color =  [1 1 1];
scatter(1-optimal_vs_kss_results, cs_optimized_preference_kss-cs_optimal, markersize, 'k', 'filled'); hold off;
xlabel('Preference for KSS vs optimal')
ylabel('Contrast sensitivity ratio KSS/optimal')