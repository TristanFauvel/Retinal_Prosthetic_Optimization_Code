% acquisition_fun_name = 'kernelselfsparring';
% task = 'preference';
task = 'preference';

% subject = 'TF one letter';
maxiter = 80; %Number of iterations in the BO loop.
subject =  'TF one letter rho magnitude betap betam'; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subject = 'TF one letter rho lambda x y betap betam amplitude';
subject = 'TF one letter rho lambda theta x y betap betam';
subject = 'TF one letter rho lambda theta x y betap betam larger space';
subject = 'TF one letter rho lambda theta x y betap betam larger search space';
subject = 'TF one letter rho lambda theta x y betap betam much larger search space';
d= 7; %8


add_directories


T = load(data_table_file).T;

% subject = 'TF one letter'; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T = load(data_table_file).T;
T = T(T.Subject == subject, :);

nexp = 1;% numel(seeds)*numel(model_seeds)*2;
T=T(end-nexp+1:end,:);
 T = T(1,:);

% T= T(7:end,:);
% T= T(T.Seed == 7,:);


indices_preference_kss = 1:size(T,1);
acquisition_fun_name = 'kernelselfsparring';
indices_preference_kss = indices_preference_kss(T.Task == task & T.Subject== subject & T.Acquisition==acquisition_fun_name & T.Misspecification == 0);

indices_preference_random = 1:size(T,1);
acquisition_fun_name = 'random';
indices_preference_random = indices_preference_random(T.Task == task & T.Subject== subject & T.Acquisition==acquisition_fun_name & T.Misspecification == 0);

values_kss = NaN(numel(indices_preference_kss), maxiter);
values_random = NaN(numel(indices_preference_random), maxiter);

mu_c_kss = NaN(numel(indices_preference_kss), maxiter);
mu_c_random = NaN(numel(indices_preference_random), maxiter);

unknown_hyp = 0;
post = [];
regularization = 'nugget';
for j = 1:numel(indices_preference_kss)
    i = indices_preference_kss(j);
    filename = [experiment_path, '/Data/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
    load(filename,'experiment')
    if unknown_hyp == 1
        x_best_norm = (experiment.x_best_unknown_hyp(experiment.ib,:) - experiment.lb')./(experiment.ub'- experiment.lb');
    else
        x_best_norm = (experiment.x_best(experiment.ib,:) - experiment.lb')./(experiment.ub'- experiment.lb');
    end
    [x_train_data, x_train_norm_data, c_train_data, theta_data] =  pool_data(char(T(i,:).Subject), T(i,:).Seed);
    switch task
        case 'preference'
            [mu_c_opt, value_opt, ~,~] = model.prediction(experiment.theta, x_train_norm_data, c_train_data, [x_best_norm; experiment.x0.*ones(d,maxiter)], experiment.kernelfun, experiment.kernelname, experiment.modeltype, oost, regularization);
        case 'E'
            [mu_c_opt, value_opt, ~,~] = model.prediction(experiment.theta, x_train_norm_data, c_train_data, x_best_norm, experiment.model, post);
    end
    values_kss(j,:) = value_opt;
    mu_c_kss(j,:) = mu_c_opt;
    x_best_norm_kss = x_best_norm;
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
    [x_train_data, x_train_norm_data, c_train_data, theta_data] =  pool_data(char(T(i,:).Subject), T(i,:).Seed);
    switch task
        case 'preference'
            [mu_c_opt, value_opt, ~,~] = model.prediction(experiment.theta, x_train_norm_data, c_train_data, [x_best_norm; experiment.x0.*ones(d,maxiter)], experiment.kernelfun, experiment.kernelname, 'modeltype', experiment.modeltype);
        case 'E'
            [mu_c_opt, value_opt, ~,~] = model.prediction(experiment.theta, x_train_norm_data, c_train_data, x_best_norm, experiment.kernelfun, 'modeltype', experiment.modeltype);
    end
    values_random(j,:) = value_opt;
    mu_c_random(j,:) = mu_c_opt;
    
    x_best_norm_rand = x_best_norm;

end


add_directories
acuity_optimized_kss = [];
acuity_optimal = [];
cs_optimized_kss = [];
cs_optimal = [];
acuity_optimized_random = [];
cs_optimized_random = [];

for i =1:numel(indices_preference_kss)
    index = indices_preference_kss(i);
    filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    load(filename, 'experiment');
    
    acuity_optimized_kss = [acuity_optimized_kss, experiment.E_VA_optimized];
    %     cs_optimized_kss = [cs_optimized_kss, experiment.E_CS_optimized];
    if strcmp(acquisition_fun_name, 'kernelselfsparring')
        acuity_optimal = [acuity_optimal, experiment.E_VA_optimal];
        %         cs_optimal = [cs_optimal, experiment.E_CS_optimal];
    end
end

for i =1:numel(indices_preference_random)
    index = indices_preference_random(i);
    filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    load(filename, 'experiment');
    
    acuity_optimized_random = [acuity_optimized_random, experiment.E_VA_optimized];
    %     cs_optimized_random = [cs_optimized_random, experiment.E_CS_optimized];
   
end

legcell = cellstr(num2str(cs_optimized_kss', '%-d'));
graphics_style_paper;

fig=figure();
fig.Color =  [1 1 1];
plot(1:maxiter, values_kss, 'linewidth', linewidth); hold on;
%plot(1:maxiter, values_random, 'linewidth', linewidth); hold on;
box off
xlabel('Iteration')
ylabel('Value of the inferred optimum')
set(gca,'xlim',[1,maxiter])
title("Value")
legend({'KSS', 'Random'})

fig=figure();
fig.Color =  [1 1 1];
plot(1:maxiter, mu_c_kss, 'linewidth', linewidth); hold on;
plot(1:maxiter, mu_c_random, 'linewidth', linewidth); hold on;
box off
xlabel('Iteration')
ylabel('Value of the inferred optimum')
set(gca,'xlim',[1,maxiter])
title("$\mu_c$")
legend({'KSS', 'Random'})


mu_c_opt = model.prediction(experiment.theta, x_train_norm_data, c_train_data, [x_best_norm_kss;x_best_norm_rand], experiment.kernelfun, experiment.kernelname, 'modeltype', experiment.modeltype);


fig=figure();
fig.Color =  [1 1 1];
plot(1:maxiter, mu_c_opt, 'linewidth', linewidth); hold on;
box off
xlabel('Iteration')
ylabel('Value of the inferred optimum')
set(gca,'xlim',[1,maxiter])
title("$\mu_c$ KSS vs rand")

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

params_names = {'$\rho  (\mu m)$','$\lambda  (\mu m)$','$\theta  (rad)$','$x  (\mu m)$', '$y  (\mu m)$', 'Magnitude', '$\beta_{+}$','$\beta_{-}$','z'};

n= 100;
varying_var = linspace(0,1,n);
fig=figure();
fig.Color =  [1 1 1];
mc = 8;
for di = 1:d
    subplot(1,d,di)
    
    x = x_best_norm(:,end)*ones(1,n);
    x(di,:) = varying_var;
    [~, value_opt, ~,~] = model.prediction(experiment.theta, x_train_norm_data, c_train_data, [x; experiment.x0.*ones(d,n)], experiment.kernelfun, experiment.kernelname, 'modeltype', experiment.modeltype);
    
    plot(varying_var(:), value_opt(:), 'linewidth', linewidth);
    
    %     yline(sqrt(rho), 'linewidth', linewidth, 'color', 'r'); hold off
    set(gca,'FontSize',Fontsize)
    title([params_names{di}],'Fontsize',Fontsize)
    xlabel('Normalized variable')
    ylabel('Value')
    
    %     ylim([experiment.lb(k), experiment.ub(k)])
    pbaspect([1 1 1])
    box off
end