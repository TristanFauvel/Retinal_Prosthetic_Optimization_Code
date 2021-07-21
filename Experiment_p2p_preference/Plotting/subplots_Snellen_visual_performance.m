clear all
add_directories
task = 'preference';
add_directories;
alpha =0.01;
f=2;

graphics_style_paper;

[VA_E_optimized_preference_acq, VA_Snellen_naive_preference_acq, VA_E_optimal,VA_Snellen_optimal, VA_E_optimized_preference_random,VA_Snellen_optimized_preference_random, VA_E_optimized_preference_acq_misspecification, VA_Snellen_optimized_preference_acq_misspecification, VA_E_optimal_misspecification,VA_Snellen_optimal_misspecification, VA_E_optimized_E_TS,VA_Snellen_optimized_E_TS, VA_E_control,VA_Snellen_control] = load_VA_results(0); 

barcol = [1,1,1];
linecol= [0,0,0];
offset = 0.4;
angle = 35;
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
fig.Color =  [1 1 1];

subplot(2,2,1)
y = [mean(acuity_naive'-acuity_optimal'), mean(acuity_optimized_preference_kss'-acuity_optimal'), ...
    mean(acuity_optimized_preference_random'-acuity_optimal'), mean(acuity_optimized_E_TS'-acuity_optimal'), ...
    mean(acuity_optimized_E_random'-acuity_optimal')];
X = 0:(numel(y)-1);
% 
% [h0,p0,ci,stats]  = ttest2(acuity_optimized_preference_kss-acuity_optimal,acuity_naive-acuity_optimal, 'tail', 'left','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_naive_preference_kss
% [h1,p1,ci,stats]  = ttest2(acuity_optimized_preference_kss-acuity_optimal,acuity_optimized_preference_random-acuity_optimal, 'tail', 'left','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_naive_preference_kss
% [h2,p2,ci,stats]  = ttest2(acuity_optimized_E_TS-acuity_optimal,acuity_optimized_E_random-acuity_optimal, 'tail', 'both','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is different from acuity_optimal
% [h3,p3,ci,stats]  = ttest2(acuity_optimized_preference_kss-acuity_optimal,acuity_optimized_E_TS-acuity_optimal, 'tail', 'left','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_optimal_preference_random

[p0,h0] = signrank(acuity_optimized_preference_kss-acuity_optimal,acuity_naive-acuity_optimal, 'tail', 'left');
[p1,h1] = signrank(acuity_optimized_preference_kss-acuity_optimal,acuity_optimized_preference_random-acuity_optimal, 'tail', 'left');
[p2,h2] = signrank(acuity_optimized_E_TS-acuity_optimal,acuity_optimized_E_random-acuity_optimal,'tail', 'both');
[p3,h3] = signrank(acuity_optimized_preference_kss-acuity_optimal,acuity_optimized_E_TS-acuity_optimal,'tail', 'left');

h =bar(X,y,'Facecolor', barcol); hold on
groups={[0,1],[1,2],[3,4],[1,3]};
pvals = [p0,p1,p2,p3];
i=0;
scatter(i*ones(1,n),acuity_naive-acuity_optimal, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),acuity_optimized_preference_kss-acuity_optimal, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),acuity_optimized_preference_random-acuity_optimal, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),acuity_optimized_E_TS-acuity_optimal, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),acuity_optimized_E_random-acuity_optimal, markersize, 'k', 'filled'); hold on;
h=sigstar(groups,pvals); hold off;
xticklabels({'Naive','KSS', 'Random', 'E TS', 'E Random'});%'Misspecification optimized', 'Misspecification optimal'})
xtickangle(angle)
box off
ylabel('Log(MAR ratio)')
xlim([0.5,6.5])
xlim([-offset,numel(y)-offset])

subplot(2,2,4)
% [h0,p0,ci,stats]  = ttest2(cs_optimal,cs_optimal_misspecification, 'tail', 'both','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is different from acuity_optimal
% [h1,p1,ci,stats]  = ttest2(cs_optimized_preference_kss, cs_optimized_preference_kss_misspecification, 'tail', 'both','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is different from acuity_optimal
[p0, h0]  = signrank(cs_optimal,cs_optimal_misspecification,'tail', 'both'); %alternative hypothesis : acuity_optimized_preference_kss is different from acuity_optimal
[p1, h1]  = signrank(cs_optimized_preference_kss, cs_optimized_preference_kss_misspecification,'tail', 'both'); %alternative hypothesis : acuity_optimized_preference_kss is different from acuity_optimal

groups={[0,1],[2,3]};
pvals = [p0,p1];


y = [mean(cs_optimal), mean(cs_optimal_misspecification), mean(cs_optimized_preference_kss), mean(cs_optimized_preference_kss_misspecification)];
X = 0:numel(y)-1; %categorical({'Naive', 'Optimal', 'KSS', 'Random'});
h =bar(X,y,'Facecolor', barcol); hold on
xticklabels({'Optimal',  'Misspecified', 'KSS', 'KSS misspecified'})
xtickangle(angle)
box off
ylabel('Contrast sensitivity')
i=0;
scatter(i*ones(1,n),cs_optimal, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),cs_optimal_misspecification, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),cs_optimized_preference_kss, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),cs_optimized_preference_kss_misspecification, markersize, 'k', 'filled'); hold on;
h=sigstar(groups,pvals); hold off;
xlim([-offset,numel(y)-offset])


subplot(2,2,2)

y = [mean(cs_naive), mean(cs_optimal), mean(cs_optimized_preference_kss), mean(cs_optimized_preference_random), mean(cs_optimized_E_TS),mean(cs_optimized_E_random)];
X = 0:numel(y)-1; 
% [h0,p0,ci,stats]  = ttest2(cs_optimal, cs_naive, 'tail', 'left','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_naive_preference_kss
% [h1,p1,ci,stats]  = ttest2(cs_optimal,cs_optimized_preference_kss, 'tail', 'left','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_naive_preference_kss
% [h2,p2,ci,stats]  = ttest2(cs_optimized_preference_kss,cs_naive, 'tail', 'left','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_naive_preference_kss
% [h3,p3,ci,stats]  = ttest2(cs_optimized_preference_kss,cs_optimized_preference_random, 'tail', 'left','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_naive_preference_kss
% [h4,p4,ci,stats]  = ttest2(cs_optimized_E_TS,cs_optimized_E_random, 'tail', 'both','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is different from acuity_optimal
% [h5,p5,ci,stats]  = ttest2(cs_optimized_preference_kss,cs_optimized_E_TS, 'tail', 'left','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_optimal_preference_random
[p0,h0]  = signrank(cs_optimal, cs_naive,'tail', 'left'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_naive_preference_kss
[p1,h0]  = signrank(cs_optimal,cs_optimized_preference_kss, 'tail', 'left'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_naive_preference_kss
[p2,h0]  = signrank(cs_optimized_preference_kss,cs_naive, 'tail', 'left'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_naive_preference_kss
[p3,h0]  = signrank(cs_optimized_preference_kss,cs_optimized_preference_random, 'tail', 'left'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_naive_preference_kss
[p4,h0]  = signrank(cs_optimized_E_TS,cs_optimized_E_random, 'tail', 'both'); %alternative hypothesis : acuity_optimized_preference_kss is different from acuity_optimal
[p5,h0]  = signrank(cs_optimized_preference_kss,cs_optimized_E_TS, 'tail', 'left'); %alternative hypothesis : acuity_optimized_preference_kss is lower than acuity_optimal_preference_random

h =bar(X,y,'Facecolor', barcol); hold on
groups={[0,1],[1,2],[0,2],[2,3],[4,5],[2,4]};
pvals = [p0,p1,p2,p3,p4,p5];

xticklabels({'Naive','Optimal', 'KSS', 'Random', 'E TS', 'E Random'})
xtickangle(angle)
box off
ylabel('Contrast sensitivity')
i=0;
scatter(i*ones(1,n),cs_naive, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),cs_optimal, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),cs_optimized_preference_kss, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),cs_optimized_preference_random, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),cs_optimized_E_TS, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),cs_optimized_E_random, markersize, 'k', 'filled'); hold on;
h=sigstar(groups,pvals); hold off;

xlim([-offset,numel(y)-offset])


subplot(2,2,3)
y = [mean(acuity_optimal), mean(acuity_optimal_misspecification), mean(acuity_optimized_preference_kss), mean(acuity_optimized_preference_kss_misspecification)];
% y = [mean(acuity_optimal_misspecification-acuity_optimal), mean(acuity_optimized_preference_kss-acuity_optimal), mean(acuity_optimized_preference_kss_misspecification-acuity_optimal)];
X = 0:numel(y)-1; 
% [h0,p0,ci,stats]  = ttest2(acuity_optimal,acuity_optimal_misspecification, 'tail', 'both','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is different from acuity_optimal
% [h1,p1,ci,stats]  = ttest2(acuity_optimized_preference_kss, acuity_optimized_preference_kss_misspecification, 'tail', 'both','Alpha',alpha, 'Vartype', 'unequal'); %alternative hypothesis : acuity_optimized_preference_kss is different from acuity_optimal
[p0,h0]  = signrank(acuity_optimal,acuity_optimal_misspecification, 'tail', 'both'); %alternative hypothesis : acuity_optimized_preference_kss is different from acuity_optimal
[p1,h1]  = signrank(acuity_optimized_preference_kss, acuity_optimized_preference_kss_misspecification, 'tail', 'both'); %alternative hypothesis : acuity_optimized_preference_kss is different from acuity_optimal

groups={[0,1],[2,3]};
pvals = [p0,p1];

subplot(2,2,3)
h =bar(X,y,'Facecolor', barcol); hold on
xticklabels({'Optimal', 'Misspecified','KSS', 'KSS misspecified'})
xtickangle(angle)
% xticklabels({'Misspecified','KSS', 'KSS misspecified'})
box off
% ylabel('Log(MAR ratio)')
ylabel('Log(MAR)')
i=0;
scatter(i*ones(1,n),acuity_optimal, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),acuity_optimal_misspecification, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),acuity_optimized_preference_kss, markersize, 'k', 'filled'); hold on;
i=i+1;
scatter(i*ones(1,n),acuity_optimized_preference_kss_misspecification, markersize, 'k', 'filled'); hold on;

% scatter(i*ones(1,n),acuity_optimal_misspecification-acuity_optimal, markersize, 'k', 'filled'); hold on;
% i=i+1;
% scatter(i*ones(1,n),acuity_optimized_preference_kss-acuity_optimal, markersize, 'k', 'filled'); hold on;
% i=i+1;
% scatter(i*ones(1,n),acuity_optimized_preference_kss_misspecification-acuity_optimal, markersize, 'k', 'filled'); hold on;
h=sigstar(groups,pvals); hold off;
xlim([-offset,numel(y)-offset])




savefig(fig, [figures_folder,'/Snellen_test_visual_performance.fig'])
exportgraphics(fig, [figures_folder,'/Snellen_test_visual_performance.eps'])
exportgraphics(fig, [figures_folder,'/Snellen_test_visual_performance.pdf'])
exportgraphics(fig, [figures_folder,'/Snellen_test_visual_performance.png'])

print([figures_folder,'/Snellen_test_visual_performance.png'],'-dpng')