clear all
add_directories;

 letter_font = 0.01;%12
task = 'preference';
data_directory = [experiment_path,'/Data'];
figures_folder = [experiment_path,'/Figures'];
alpha =0.01;

[VA_E_optimized_preference_acq, VA_Snellen_optimized_preference_acq, VA_E_optimal,VA_Snellen_optimal, VA_E_optimized_preference_random,VA_Snellen_optimized_preference_random, VA_E_optimized_preference_acq_misspecification, VA_Snellen_optimized_preference_acq_misspecification, VA_E_optimal_misspecification,VA_Snellen_optimal_misspecification, VA_E_optimized_E_TS,VA_Snellen_optimized_E_TS, VA_E_control,VA_Snellen_control] = load_VA_results(0); 

test_name = '/E_test_'; 

n = 5;

barcol = [1,1,1];
linecol= [0,0,0];
offset = 0.4;
angle = 35;


graphics_style_paper;
mr= 2;
mc= 3;

VA_scale_E = [];
VA_scale_Snellen = [];

fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
subplot(mr, mc,1)
x = VA_E_control;
y= VA_E_optimized_preference_acq;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Control', 'Adaptive pref.',VA_scale_E); % H1: x – y come from a distribution with greater than 0
text(-0.18,1.15,'A','Units','normalized','Fontsize', letter_font,'FontWeight', 'Bold')

subplot(mr,mc,2)
x = VA_E_optimal;
y = VA_E_optimized_preference_acq;
tail = 'both'; 
scatter_plot(x,y, tail,'Ground truth', '',VA_scale_E);  %H1 : x – y come from a distribution with median different than 0
text(-0.18,1.15,'B','Units','normalized','Fontsize', letter_font,'FontWeight', 'Bold')

subplot(mr,mc,3)
x = VA_E_optimized_preference_random;
y = VA_E_optimized_preference_acq;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Non-adaptive pref.', '',VA_scale_E); %H1 : x – y come from a distribution with median greater than 0 
text(-0.18,1.15,'C','Units','normalized','Fontsize',  letter_font,'FontWeight', 'Bold')

% VA_scale = [];
subplot(mr, mc,4)
x = VA_Snellen_control;
y= VA_Snellen_optimized_preference_acq;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Control', 'Adaptive pref.',VA_scale_Snellen); % H1: x – y come from a distribution with greater than 0
text(-0.18,1.15,'C','Units','normalized','Fontsize',  letter_font,'FontWeight', 'Bold')

subplot(mr,mc,5)
x = VA_Snellen_optimal;
y = VA_Snellen_optimized_preference_acq;
tail = 'both'; 
scatter_plot(x,y, tail,'Ground truth', '',VA_scale_Snellen);  %H1 : x – y come from a distribution with median different than 0
text(-0.18,1.15,'D','Units','normalized','Fontsize',  letter_font,'FontWeight', 'Bold')

subplot(mr,mc,6)
x = VA_Snellen_optimized_preference_random;
y = VA_Snellen_optimized_preference_acq;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Non-adaptive pref.', '',VA_scale_Snellen); %H1 : x – y come from a distribution with median greater than 0 
text(-0.18,1.15,'F','Units','normalized','Fontsize',  letter_font,'FontWeight', 'Bold')


% savefig(fig, [figures_folder,test_name, 'scatter_visual_performance.fig'])
% exportgraphics(fig, [figures_folder,test_name, 'scatter_visual_performance.eps'])
% exportgraphics(fig, [figures_folder,test_name, 'scatter_visual_performance.pdf'])
% exportgraphics(fig, [figures_folder,test_name, 'scatter_visual_performance.png'])
% print([figures_folder,test_name, 'scatter_visual_performance.png'],'-dpng')
% 

%%
mr = 2;
mc = 2;
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
fig.Color =  [1 1 1];
fig.Name = 'Ground truth vs misspecified';

subplot(mr,mc,1)
x = VA_E_optimal;
y = VA_E_optimal_misspecification;
scatter_plot(x,y, tail,'Ground truth','Misspecified', VA_scale_E); %H1 : x – y come from a distribution with median less than 0
subplot(mr,mc,2)
y = VA_E_optimized_preference_acq_misspecification;
x = VA_E_optimized_preference_acq;
tail = 'both'; %'right';
scatter_plot(x,y,tail,'Challenge Misspecified','Adaptive pref.',VA_scale_E); %H1 : x – y come from a distribution with median greater than 0 
subplot(mr,mc,3)
x = VA_Snellen_optimal;
y = VA_Snellen_optimal_misspecification;
scatter_plot(x,y, tail,'Ground truth','Misspecified', VA_scale_Snellen); %H1 : x – y come from a distribution with median less than 0
subplot(mr,mc,4)
y = VA_Snellen_optimized_preference_acq_misspecification;
x = VA_Snellen_optimized_preference_acq;
tail = 'both'; %'right';
scatter_plot(x,y,tail,'Challenge Misspecified','Adaptive pref.',VA_scale_Snellen); %H1 : x – y come from a distribution with median greater than 0 

savefig(fig, [figures_folder,test_name, 'scatter_misspecification.fig'])
exportgraphics(fig, [figures_folder,test_name, 'scatter_misspecification.eps'])
exportgraphics(fig, [figures_folder,test_name, 'scatter_misspecification.pdf'])
exportgraphics(fig, [figures_folder,test_name, 'scatter_misspecification.png'])
% print([figures_folder,test_name, 'scatter_misspecification.png'],'-dpng')

% %%
% mr= 2;
% mc= 3;
% 
% 
% fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
% fig.Color =  [1 1 1];
% fig.Name = 'E task';
% i=1;
% subplot(mr,mc,i)
% x = VA_E_optimized_preference_acq;
% y = VA_E_optimized_E_TS;
% scatter_plot(x,y, tail,'Adaptive pref.','Performance-based'); %H1 : x – y come from a distribution with median different than 0
% i=i+1;
% 
% subplot(mr,mc,i)
% x = VA_E_optimal;
% y = VA_E_optimized_E_TS;
% scatter_plot(x,y, tail,'Ground truth','Performance-based'); %H1 : x – y come from a distribution with median different than 0
% 
% i=i+1;
% subplot(mr, mc, i)
% x = VA_E_optimized_E_random;
% y = VA_E_optimized_E_TS;
% scatter_plot(x,y, tail,'Random','Performance-based');  %H1 : x – y come from a distribution with median greater than 0 
% i=i+1;
% 
% subplot(mr,mc,i)
% x = VA_Snellen_optimized_preference_acq;
% y = VA_Snellen_optimized_E_TS;
% scatter_plot(x,y, tail,'Ground truth','Performance-based'); %H1 : x – y come from a distribution with median different than 0
% 
% i=i+1;
% subplot(mr,mc,i)
% x = VA_Snellen_optimal;
% y = VA_Snellen_optimized_E_TS;
% scatter_plot(x,y, tail,'Ground truth','Performance-based'); %H1 : x – y come from a distribution with median different than 0
% 
% i=i+1;
% subplot(mr,mc,i)
% x = VA_Snellen_optimized_E_random;
% y = VA_Snellen_optimized_E_TS;
% scatter_plot(x,y, tail,'Random','Performance-based');  %H1 : x – y come from a distribution with median greater than 0 
% 
% print([figures_folder,test_name, 'scatter_visual_performance_E_TS.png'],'-dpng')
% 
%% Comparison with a performance-based  task 

mr = 2;
mc = 2;
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
fig.Color =  [1 1 1];
fig.Name = 'Optimization with E task';

subplot(mr,mc,1)
x = VA_E_optimal;
y = VA_E_optimized_E_TS;
scatter_plot(x,y, tail,'Ground truth','TS',VA_scale_E);  %H1 : x – y come from a distribution with median different than 0 

subplot(mr,mc,2)
x = VA_E_optimized_E_TS;
y = VA_E_optimized_preference_acq;
scatter_plot(x,y, tail, 'Performance-based','Adaptive pref.',VA_scale_E);  %H1 : x – y come from a distribution with median greater than 0 

subplot(mr,mc,3)
x = VA_Snellen_optimal;
y = VA_Snellen_optimized_E_TS;
scatter_plot(x,y, tail,'Ground truth','TS',VA_scale_E);  %H1 : x – y come from a distribution with median different than 0 

subplot(mr,mc,4)
x = VA_Snellen_optimized_E_TS;
y = VA_Snellen_optimized_preference_acq;
scatter_plot(x,y, tail, 'Performance-based','Adaptive pref.',VA_scale_E);  %H1 : x – y come from a distribution with median greater than 0 

savefig(fig, [figures_folder,test_name, 'task_comparison_scatter_visual_performance.fig'])
exportgraphics(fig, [figures_folder,test_name, 'task_comparison_scatter_visual_performance.eps'])
exportgraphics(fig, [figures_folder,test_name, 'task_comparison_scatter_visual_performance.pdf'])
exportgraphics(fig, [figures_folder,test_name, 'task_comparison_scatter_visual_performance.png'])
print([figures_folder,test_name, 'task_comparison_scatter_visual_performance.png'],'-dpng')


figure()
x = VA_E_optimized_preference_acq - VA_E_optimal;
y =  VA_E_optimized_preference_random - VA_E_optimal;
mdl = fitlm(x,y);
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
fig.Color =  [1 1 1];
fig.Name = 'KSS vs random';
scatter(x,y, markersize, 'k', 'filled'); hold on;
plot(x, mdl.predict(x'), 'color', linecol, 'linewidth', linewidth/4, 'linestyle','--'); hold on; %mdl.Coefficients.Estimate(1)+mdl.Coefficients.Estimate(2)*x
pbaspect([1 1 1])
xlabel('$VA_{acq} - VA_{opt}$')
ylabel( '$VA_{rabd} - VA_{opt}$')
box off
title(['$R^2 =', num2str(mdl.Rsquared.Ordinary),'$'])


linewidth = 4;
linecol = [0,0,0];
markersize= 20;

x = VA_E_optimized_preference_acq - VA_E_optimal;
y = VA_E_optimized_preference_acq - VA_E_optimized_preference_random;
mdl = fitlm(x,y);
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
fig.Color =  [1 1 1];
fig.Name = 'KSS vs random';
scatter(x,y, markersize, 'k', 'filled'); hold on;
plot(x, mdl.predict(x'), 'color', linecol, 'linewidth', linewidth/4, 'linestyle','--'); hold on; %mdl.Coefficients.Estimate(1)+mdl.Coefficients.Estimate(2)*x
pbaspect([1 1 1])
xlabel('$VA_{acq} - VA_{opt}$')
ylabel( '$VA_{acq} - VA_{rand}$')
box off
title(['$R^2 =', num2str(mdl.Rsquared.Ordinary),'$'])


%% VA Snellen vs VA E
mr = 1;
mc = 4;
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
subplot(mr, mc,1)
x = VA_E_control;
y= VA_Snellen_control;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'E', 'Snellen',[], 'equal_axes', 0, 'linreg', 1); % H1: x – y come from a distribution with greater than 0
title('Random $\phi
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
title('Non-adaptive pref.')
text(-0.18,1.15,'C','Units','normalized','Fontsize',  letter_font,'FontWeight', 'Bold')

% VA_scale = [];
subplot(mr, mc,4)
x = VA_E_optimized_preference_acq;
y= VA_Snellen_optimized_preference_acq;
tail = 'both'; %'right';
)
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
title('Non-adaptive pref.')
text(-0.18,1.15,'C','Units','normalized','Fontsize',  letter_font,'FontWeight', 'Bold')

% VA_scale = [];
subplot(mr, mc,4)
x = VA_E_optimized_preference_acq;
y= VA_Snellen_optimized_preference_acq;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'E', 'Snellen', [], 'equal_axes', 0,  'linreg', 1);  % H1: x – y come from a distribution with greater than 0
title('Adaptive pref.')
text(-0.18,1.15,'C','Units','normalized','Fontsize',  letter_font,'FontWeight', 'Bold')

%%
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
x = [VA_E_control, VA_E_optimal, VA_E_optimized_preference_random, VA_E_optimized_preference_acq];
y = [VA_Snellen_control, VA_Snellen_optimal, VA_Snellen_optimized_preference_random, VA_Snellen_optimized_preference_acq];
tail = 'both'; %'right';
scatter_plot(x,y, tail,'E', 'Snellen',[], 'equal_axes', 0, 'linreg', 1); % H1: x – y come from a distribution with greater than 0
title('Random $\phi

)

