% acquisition_fun_name = 'kernelselfsparring';
% task = 'preference';

task = 'preference';

subject = 'TF one letter';
add_directories

T = load(data_table_file).T;
% T= T(13:end,:);
T = T(T.Subject == 'TF one letter', : );
T = T(7:end, :);
acquisition_fun_name = 'kernelselfsparring';
indices_preference_kss = 1:size(T,1);
indices_preference_kss = indices_preference_kss(T.Task == task & T.Subject== subject & T.Acquisition==acquisition_fun_name & T.Misspecification == 0);

acquisition_fun_name = 'random';
indices_preference_random = 1:size(T,1);
indices_preference_random = indices_preference_random(T.Task == task & T.Subject== subject & T.Acquisition==acquisition_fun_name & T.Misspecification == 0);

maxiter = 80;
d= 8;
values_random = NaN(numel(indices_preference_random), maxiter);
values_kss = NaN(numel(indices_preference_kss), maxiter);

unknown_hyp = 0;
post = [];
regularization = 'nugget';

% for j = 1:numel(indices_preference_kss)
%     i = indices_preference_kss(j);
%     filename = [experiment_path, '/Data/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
%     load(filename,'experiment')
%     if unknown_hyp == 1
%         x_best_norm = (experiment.x_best_unknown_hyp(experiment.ib,:) - experiment.lb')./(experiment.ub'- experiment.lb');
%     else
%         x_best_norm = (experiment.x_best(experiment.ib,:) - experiment.lb')./(experiment.ub'- experiment.lb');
%     end
%     if isnan(sum(x_best_norm(:)))
%         analyze_experiment(filename)
%     end
% end
for j = 1:numel(indices_preference_kss)
    i = indices_preference_kss(j);
    filename = [experiment_path, '/Data/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
    load(filename,'experiment')
    if unknown_hyp == 1
        x_best_norm = (experiment.x_best_unknown_hyp(experiment.ib,:) - experiment.lb')./(experiment.ub'- experiment.lb');
    else
        x_best_norm = (experiment.x_best(experiment.ib,:) - experiment.lb')./(experiment.ub'- experiment.lb');
    end
    switch task
        case 'preference'
            [~, value_opt, ~,~] = prediction_bin(experiment.theta, experiment.xtrain_norm, experiment.ctrain, [x_best_norm; experiment.x0.*ones(d,maxiter)], experiment.kernelfun, experiment.kernelname, 'modeltype', experiment.modeltype);
        case 'E'
            [~, value_opt, ~,~] = prediction_bin(experiment.theta, experiment.xtrain_norm, experiment.ctrain, x_best_norm, experiment.kernelfun, experiment.modeltype, post, regularization);
    end
    values_kss(j,:) = value_opt;
end

for j = 1:numel(indices_preference_random)
    i = indices_preference_random(j);
    filename = [experiment_path, '/Data/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
    load(filename,'experiment')
    if unknown_hyp == 1
        x_best_norm = (experiment.x_best_unknown_hyp(experiment.ib,:) - experiment.lb')./(experiment.ub'- experiment.lb');
    else
        x_best_norm = (experiment.x_best(experiment.ib,:) - experiment.lb')./(experiment.ub'- experiment.lb');
    end
    switch task
        case 'preference'
            [~, value_opt, ~,~] = prediction_bin(experiment.theta, experiment.xtrain_norm, experiment.ctrain, [x_best_norm; experiment.x0.*ones(d,maxiter)], experiment.kernelfun, experiment.kernelname, experiment.modeltype, post, regularization);
        case 'E'
            [~, value_opt, ~,~] = prediction_bin(experiment.theta, experiment.xtrain_norm, experiment.ctrain, x_best_norm, experiment.kernelfun, experiment.modeltype, post, regularization);
    end
    values_random(j,:) = value_opt;
end

acuity_optimized_kss = [];
acuity_optimal = [];
cs_optimized_kss = [];
cs_optimal = [];
for i =1:numel(indices_preference_kss)
    index = indices_preference_kss(i);
    filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    load(filename, 'experiment');
    
    acuity_optimized_kss= [acuity_optimized_kss, experiment.E_VA_optimized];
%     cs_optimized_kss = [cs_optimized, experiment.E_CS_optimized];
%         acuity_optimal = [acuity_optimal, experiment.E_VA_optimal];
%         cs_optimal = [cs_optimal, experiment.E_CS_optimal];
end

acuity_optimized_random = [];
cs_optimized_random = [];
for i =1:numel(indices_preference_random)
    index = indices_preference_random(i);
    filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    load(filename, 'experiment');
    
    acuity_optimized_random = [acuity_optimized_random, experiment.E_VA_optimized];
end

legcell = cellstr(num2str(cs_optimized_kss', '%-d'));
graphics_style_paper;

fig=figure();
fig.Color =  [1 1 1];
plot(1:maxiter, values_kss, 'linewidth', linewidth);
box off
xlabel('Iteration')
ylabel('Value of the inferred optimum')
set(gca,'xlim',[1,maxiter])
title("Value")
% legend(legcell)

fig=figure();
fig.Color =  [1 1 1];
plot(1:maxiter, (values_kss-values_kss(:,1)), 'linewidth', linewidth);
box off
xlabel('Iteration')
ylabel('Value of the inferred optimum')
set(gca,'xlim',[1,maxiter])
title("Value")

fig=figure();
fig.Color =  [1 1 1];
subplot(1,2,1);
scatter(values_kss(:,end),cs_optimized_kss, markersize, 'k', 'filled');
pbaspect([1,1,1]);
xlabel('Value')
ylabel('CS')
subplot(1,2,2);
scatter(values_kss(:,end),acuity_optimized_kss, markersize, 'k', 'filled');
xlabel('Value')
ylabel('VA')
pbaspect([1,1,1]);

fig=figure();
fig.Color =  [1 1 1];
subplot(1,2,1);
scatter(values_kss(:,end) -values_kss(:,1),cs_optimized_kss, markersize, 'k', 'filled');
xlabel('Value')
ylabel('CS')
pbaspect([1,1,1]);
subplot(1,2,2);
scatter(values_kss(:,end) -values_kss(:,1),acuity_optimized_kss, markersize, 'k', 'filled');
xlabel('Value')
ylabel('VA')
pbaspect([1,1,1]);


fig=figure();
fig.Color =  [1 1 1];
plot(1:maxiter, values_kss - values_random, 'linewidth', linewidth);
box off
xlabel('Iteration')
ylabel('Value of the inferred optimum')
set(gca,'xlim',[1,maxiter])
title("Value KSS - value random")


fig=figure();
fig.Color =  [1 1 1];
scatter_plot(values_random(:,end)', values_kss(:,end)', 'both', 'Value random', 'Value kss', []);



fig=figure();
fig.Color =  [1 1 1];
scatter_plot(values_kss(:,end)' - values_random(:,end)', acuity_optimized_kss - acuity_optimized_random, 'both', 'Value kss - value random', 'VA KSS - VA random', []);
