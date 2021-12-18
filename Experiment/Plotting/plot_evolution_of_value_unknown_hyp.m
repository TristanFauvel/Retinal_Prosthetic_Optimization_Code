lo

legcell = cellstr(num2str(cs_optimized', '%-d'));
graphics_style_paper;

fig=figure();
fig.Color =  [1 1 1];
plot(1:maxiter, values, 'linewidth', linewidth);
box off
xlabel('Iteration')
ylabel('Value of the inferred optimum')
set(gca,'xlim',[1,maxiter])
title("Value")
% legend(legcell)

fig=figure();
fig.Color =  [1 1 1];
plot(1:maxiter, (values-values(:,1)), 'linewidth', linewidth);
box off
xlabel('Iteration')
ylabel('Value of the inferred optimum')
set(gca,'xlim',[1,maxiter])
title("Value")

zval = zscore(values,0,2);

fig=figure();
fig.Color =  [1 1 1];
plot(1:maxiter, zval-zval(:,1), 'linewidth', linewidth);
box off
xlabel('Iteration')
ylabel('Value of the inferred optimum')
set(gca,'xlim',[1,maxiter])
title("Z-scored value")
% legend(legcell)


fig=figure();
fig.Color =  [1 1 1];
subplot(1,2,1);
scatter(values(:,end),cs_optimized, markersize, 'k', 'filled');
pbaspect([1,1,1]);
xlabel('Value')
ylabel('CS')
subplot(1,2,2);
scatter(values(:,end),acuity_optimized, markersize, 'k', 'filled');
xlabel('Final value')
ylabel('VA')
pbaspect([1,1,1]);

fig=figure();
fig.Color =  [1 1 1];
subplot(1,2,1);
scatter(values(:,end) -values(:,1),cs_optimized, markersize, 'k', 'filled');
xlabel('Value')
ylabel('CS')
pbaspect([1,1,1]);
subplot(1,2,2);
scatter(values(:,end) -values(:,1),acuity_optimized, markersize, 'k', 'filled');
xlabel('Final value - Initial value')
ylabel('VA')
pbaspect([1,1,1]);



fig=figure();
fig.Color =  [1 1 1];
plot(1:maxiter, (values-min(values')')./(max(values')'-min(values')'), 'linewidth', linewidth);
box off
xlabel('Iteration')
ylabel('Minmax normalized value of the inferred optimum')
set(gca,'xlim',[1,maxiter])
title("Value")

fig=figure();
fig.Color =  [1 1 1];
plot(1:maxiter, (values-values(:,1))./(values(:,end)-values(:,1)), 'linewidth', linewidth);
box off
xlabel('Iteration')
ylabel('Normalized value of the inferred optimum')
set(gca,'xlim',[1,maxiter])
title("Value")

% zval = zscore(values,0,2)-min(zscore(values,0,2)')';
% fig=figure();
% fig.Color =  [1 1 1];
% subplot(1,2,1);
% scatter(zval(:,end),cs_optimized, markersize, 'k', 'filled');
% xlabel('Value')
% ylabel('CS')
% pbaspect([1,1,1]);
% subplot(1,2,2);
% scatter(zval(:,end),acuity_optimized, markersize, 'k', 'filled');
% xlabel('Value')
% ylabel('CS')
% pbaspect([1,1,1]);
xbest = NaN(numel(indices_preference_kss), 9, 80);
xparams = NaN(numel(indices_preference_kss), 9);

for i =1:numel(indices_preference_kss)
    index = indices_preference_kss(i);
    filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    load(filename, 'experiment');
    
    xbest(i, : ,:) = experiment.x_best_unknown_hyps;
    xparams(i, :) = experiment.model_params;
end

