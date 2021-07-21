graphics_style_paper
add_modules
add_directories

filename = "C:\Users\tfauvel\Documents\Retinal_prosthetic_optimization\Data\Dataset_E_seed_6_4.mat";

load(filename,'experiment')
UNPACK_STRUCT(experiment, false)

% filename = "C:\Users\tfauvel\Documents\ktheta.mat";
% save(filename,'ktheta')

ndata = numel(ctrain);
p = randperm(ndata);
x_train_data = xtrain(:,p);
x_train_norm_data = xtrain_norm(:,p);
c_train_data = ctrain(p);

% training_set = 1:floor(0.5*ndata);
% test_set = setdiff(1:ndata, training_set);
K = 10;
data_partition = cvpartition(numel(c_train_data),'KFold',K);

kernel_list = {'ARD', 'RQ', 'Matern52', 'Matern32', 'Polynomial'};

modeltype = 'exp_prop';
maxiter = experiment.maxiter;
update_theta = 1;

loading = 0;
saving = 1-loading;

if loading
    filename = "C:\Users\tfauvel\Documents\Retinal_prosthetic_optimization\Data\Dataset_E_seed_6_theta.mat";
    load(filename,'ktheta')
    
else
    
    for i = 1:numel(kernel_list)
        kernelname = kernel_list{i};
        switch kernelname
            case 'RQ'
                theta = [-7.5347, 9.9733,-8.9900]; %RQ
                kernelname = 'RQ';
                kernelfun = @Rational_Quadratic_kernelfun;
            case 'Matern52'
                theta = [-0.3544;1.6781]; % Matern 5/2
                kernelname = 'Matern52';
                kernelfun = @Matern52_kernelfun;
            case 'Matern32'
                kernelfun = @Matern32_kernelfun;
                kernelname = 'Matern32';
                theta = [-0.0843;2.0791]; % Matern 3/2
            case 'Polynomial'
                theta  =[ -0.4043; 1.1637];
                kernelname = 'Polynomial';
                kernelfun = @polynomial_kernelfun;
            case 'ARD'
                kernelfun = @ARD_kernelfun;
                theta = [-0.0995, -4.8518,-10.0000,0.6491,-0.9257,0.5564,-10.0000,-0.1287,0.3135];
                kernelname = 'ARD';
        end
        
        init_guess = theta;
        theta_lb = -10*ones(size(init_guess));
        theta_ub = 10*ones(size(init_guess));
        options_theta = experiment.options_theta;
        
        if update_theta
            theta = multistart_minConf(@(hyp)negloglike_bin(hyp, x_train_norm_data, c_train_data, kernelfun, 'modeltype', modeltype), theta_lb, theta_ub,10, init_guess, options_theta);
        end
        ktheta{i} = theta;
    end
    if saving
        filename = "C:\Users\tfauvel\Documents\Retinal_prosthetic_optimization\Data\Dataset_E_seed_6_theta.mat";
        save(filename,'ktheta')
    end
    
end

update_theta = 0;
for k =1:K
    training_set = training(data_partition,k);
    test_set = test(data_partition,k);
    
    for i = 1:numel(kernel_list)
        kernelname = kernel_list{i};
        switch kernelname
            case 'RQ'
                kernelname = 'RQ';
                kernelfun = @Rational_Quadratic_kernelfun;
            case 'Matern52'
                kernelname = 'Matern52';
                kernelfun = @Matern52_kernelfun;
            case 'Matern32'
                kernelfun = @Matern32_kernelfun;
                kernelname = 'Matern32';
            case 'Polynomial'
                kernelname = 'Polynomial';
                kernelfun = @polynomial_kernelfun;
            case 'ARD'
                kernelfun = @ARD_kernelfun;
                kernelname = 'ARD';
        end
        theta = ktheta{i};
        
        init_guess = theta;
        theta_lb = -10*ones(size(init_guess));
        theta_ub = 10*ones(size(init_guess));
        options_theta = experiment.options_theta;
        
        if update_theta
            theta = multistart_minConf(@(hyp)negloglike_bin(hyp, x_train_norm_data(:, training_set), c_train_data(:, training_set), kernelfun, 'modeltype', modeltype), theta_lb, theta_ub,10, init_guess, options_theta);
        end
        
        [mu_c,  mu_y, ~, Sigma2_y] = prediction_bin_preference(theta, x_train_norm_data(:, training_set), c_train_data(training_set), x_train_norm_data, kernelfun, 'modeltype', modeltype);
        mu_c = mu_c';
        % Compute the confusion matrix and accuracy training/test set
        data_set = test_set;
        
        brier_score(k,i) = mean((mu_c(data_set) - c_train_data(data_set)).^2);
        rmse(k,i)  = sqrt(mean((mu_c(data_set) - c_train_data(data_set)).^2));
        
        TP(k,i) = mean(mu_c(data_set)>0.5 & c_train_data(data_set) ==1);
        TN(k,i) = mean(mu_c(data_set)<0.5 & c_train_data(data_set) ==0);
        FP(k,i) = mean(mu_c(data_set)>0.5 & c_train_data(data_set) ==0);
        FN(k,i) = mean(mu_c(data_set)<0.5 & c_train_data(data_set) ==1);
        accuracy(k,i) = (TP(k,i)+ TN(k,i))/(FP(k,i)+ FN(k,i) + TP(k,i) + TN(k,i));
        
    end
end

mean(rmse,1)
mean(brier_score,1)
p_1= zeros(1,K);
for k = 1:K
    test_set = test(data_partition,k);
    p_1(k) = mean(c_train_data(test_set));
end

TP = mean(TP,1);
TN = mean(TN,1);
FP = mean(FP,1);
FN = mean(FN,1);

accuracy= (TP+ TN)./(FP+ FN + TP + TN);
precision = TP./(TP+FP);
sensitivity = TP./(TP+FN);
specificity = TN./(TN+FP);
g_mean = sqrt(precision .* sensitivity);
p_correct = TP.*p_1(:) + TN.*(1-p_1(:));
p_correct = mean(p_correct,1);


TP = mean(TP,1);
TN = mean(TN,1);
FP = mean(FP,1);
FN = mean(FN,1);
accuracy= (TP+ TN)./(FP+ FN + TP + TN);


X = categorical(kernel_list);
X = reordercats(X, {'ARD', 'RQ', 'Matern52', 'Matern32', 'Polynomial'});

figure()
bar(X, mean(accuracy,1))
ylabel('Accuracy')

figure()
bar(X, mean(rmse,1))
ylabel('RMSE')

% % Evolution of performance as a function of theta changes (using the whole training
% % set).
% rmse_train = NaN(1,maxiter);
% rmse_test = NaN(1,maxiter);
%
% for i = 1:maxiter
%     theta_i = experiment.hyps(i,:);
%     [mu_c,  mu_y, ~, Sigma2_y] = prediction_bin_preference(theta_i, x_train_norm_data(:, training_set), c_train_data(training_set), x_train_norm_data, kernelfun, kernelname, 'modeltype', modeltype);
%     data_set = training_set;
%     rmse_train(i) = sqrt(mean((mu_c(data_set) - c_train_data(data_set)).^2));
%     data_set = test_set;
%     rmse_test(i) = sqrt(mean((mu_c(data_set) - c_train_data(data_set)).^2));
% end
%
% fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
% fig.Color =  [1 1 1];
% fig.Name = 'RMSE with varying hyperparameters';
% plot(rmse_test, 'linewidth', linewidth); hold on ;
% plot(rmse_train, 'linewidth', linewidth); hold off
% legend({'Test set', 'Training set'});
% xlabel('Iteration')
% ylabel('RMSE')
% box off

% Evolution of performance as a function of the number of data points (using the 'correct' theta).
rmse_train = NaN(1,numel(training_set));
rmse_test = NaN(1,numel(training_set));

for i = 1:numel(training_set)
    [mu_c,  mu_y, ~, Sigma2_y] = prediction_bin_preference(theta, x_train_norm_data(:, training_set(1:i)), c_train_data(training_set(1:i)), x_train_norm_data, kernelfun, kernelname, 'modeltype', modeltype);
    data_set = training_set;
    rmse_train(i) = sqrt(mean((mu_c(data_set) - c_train_data(data_set)).^2));
    data_set = test_set;
    rmse_test(i) = sqrt(mean((mu_c(data_set) - c_train_data(data_set)).^2));
end

fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
fig.Color =  [1 1 1];
fig.Name = 'RMSE with varying number of points with the correct theta';
plot(rmse_test, 'linewidth', linewidth); hold on ;
plot(rmse_train, 'linewidth', linewidth); hold off
legend({'Test set', 'Training set'});
xlabel('Iteration')
ylabel('RMSE')
box off

% Evolution of performance as a function of the number of data points (using the 'correct' theta).
rmse_train = NaN(1,maxiter);
rmse_test = NaN(1,maxiter);

for i = 1:maxiter
    [mu_c,  mu_y, ~, Sigma2_y] = prediction_bin_preference(theta, experiment.xtrain_norm(:, 1:i), experiment.ctrain(1:i), x_train_norm_data, kernelfun, kernelname, 'modeltype', modeltype);
    data_set = training_set;
    rmse_train(i) = sqrt(mean((mu_c(data_set) - c_train_data(data_set)).^2));
    data_set = test_set;
    rmse_test(i) = sqrt(mean((mu_c(data_set) - c_train_data(data_set)).^2));
end

fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
fig.Color =  [1 1 1];
fig.Name = 'RMSE with varying number of points with the correct theta';
plot(rmse_test, 'linewidth', linewidth); hold on ;
plot(rmse_train, 'linewidth', linewidth); hold off
legend({'Test set', 'Training set'});
xlabel('Iteration')
ylabel('RMSE')
box off


% Evolution of performance as a function of the number of data points
rmse_train = NaN(1,maxiter);
rmse_test = NaN(1,maxiter);

for i = 1:maxiter
    theta_i = experiment.hyps(i,:);
    [mu_c,  mu_y, ~, Sigma2_y] = prediction_bin_preference(theta_i, experiment.xtrain_norm(:, 1:i), experiment.ctrain(1:i), x_train_norm_data, kernelfun, kernelname, 'modeltype', modeltype);
    data_set = training_set;
    rmse_train(i) = sqrt(mean((mu_c(data_set) - c_train_data(data_set)).^2));
    data_set = test_set;
    rmse_test(i) = sqrt(mean((mu_c(data_set) - c_train_data(data_set)).^2));
end

fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
fig.Color =  [1 1 1];
fig.Name = 'RMSE with varying number of points with the correct theta';
plot(rmse_test, 'linewidth', linewidth); hold on ;
plot(rmse_train, 'linewidth', linewidth); hold off
legend({'Test set', 'Training set'});
xlabel('Iteration')
ylabel('RMSE')
box off

fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
fig.Color =  [1 1 1];
fig.Name = 'RMSE with varying number of points with the correct theta';
plot(experiment.hyps, 'linewidth', linewidth);
box off;

% Impact of frequent theta update

rmse_train = NaN(1,maxiter);
rmse_test = NaN(1,maxiter);

for i = 1:maxiter
    theta_i = multistart_minConf(@(hyp)negloglike_bin(hyp, experiment.xtrain_norm(:, 1:i), experiment.ctrain(1:i), kernelfun, 'modeltype', modeltype), theta_lb, theta_ub,10, init_guess, options_theta);
    [mu_c,  mu_y, ~, Sigma2_y] = prediction_bin_preference(theta_i, experiment.xtrain_norm(:, 1:i), experiment.ctrain(1:i), x_train_norm_data, kernelfun, kernelname, 'modeltype', modeltype);
    data_set = training_set;
    rmse_train(i) = sqrt(mean((mu_c(data_set) - c_train_data(data_set)).^2));
    data_set = test_set;
    rmse_test(i) = sqrt(mean((mu_c(data_set) - c_train_data(data_set)).^2));
end

fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
fig.Color =  [1 1 1];
fig.Name = 'RMSE with varying number of points with the correct theta';
plot(rmse_test, 'linewidth', linewidth); hold on ;
plot(rmse_train, 'linewidth', linewidth); hold off
legend({'Test set', 'Training set'});
xlabel('Iteration')
ylabel('RMSE')
box off

%Generalization of theta to other models?
subject = 'TF';
T = load(data_table_file).T;
T = T(13:end,:);
T = T(T.Subject == subject & T.Task == 'preference' & T.Acquisition == 'kernelselfsparring' & T.Misspecification == 0, :);
Tr =  load(data_table_file).T;
Tr = Tr(13:end,:);

Tr = Tr(Tr.Subject == subject & Tr.Task == 'preference' & Tr.Acquisition == 'random', :);

rmse_exp_theta = NaN(size(T,1),maxiter);
rmse_true_theta = NaN(size(T,1),maxiter);

for k = 1:size(Tr,1)
    task = cellstr(Tr(k,:).Task);
    task = task{1};
    acquisition_fun_name = cellstr(Tr(k,:).Acquisition);
    acquisition_fun_name = acquisition_fun_name{1};
    index = Tr(k,:).Index;
    filenames{k} = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
    
    index = T(T.Seed == Tr(k,:).Seed,:).Index;
    filename_kss = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', 'kernelselfsparring', '_experiment_',num2str(index)];
    load(filename_kss, 'experiment');
    xtest =  experiment.xtrain_norm;
    ctest = experiment.ctrain;
    filename = filenames{k};
    load(filename, 'experiment');
    
    for i = 1:maxiter
        [mu_c,  mu_y, ~, Sigma2_y] = prediction_bin_preference(theta_true, experiment.xtrain_norm(:, 1:i), experiment.ctrain(1:i),xtest, kernelfun, kernelname, 'modeltype', modeltype);
        rmse_true_theta(k,i) = sqrt(mean((mu_c - ctest(:)).^2));
        theta_i = multistart_minConf(@(hyp)negloglike_bin(hyp, experiment.xtrain_norm(:, 1:i), experiment.ctrain(1:i), kernelfun, 'modeltype', modeltype), theta_lb, theta_ub,10, init_guess, options_theta);
        [mu_c,  mu_y, ~, Sigma2_y] = prediction_bin_preference(theta_i, experiment.xtrain_norm(:, 1:i), experiment.ctrain(1:i),xtest, kernelfun, kernelname, 'modeltype', modeltype);
        rmse_exp_theta(k,i) = sqrt(mean((mu_c - ctest(:)).^2));
    end
end
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
fig.Color =  [1 1 1];
fig.Name = 'RMSE over the course of learning';
plot(rmse_exp_theta')
% legend({'Test set', 'Training set'});
xlabel('Iteration')
ylabel('RMSE')
box off

fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
fig.Color =  [1 1 1];
fig.Name = 'RMSE over the course of learning with fixed theta';
plot(rmse_true_theta')
legend({'Test set', 'Training set'});
xlabel('Iteration')
ylabel('RMSE')
box off


fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
fig.Color =  [1 1 1];
% fig.Name = 'RMSE with varying number of points with the correct theta';
plot(rmse_exp_theta(Tr.Seed ~= 6, :)' -  rmse_true_theta(Tr.Seed ~= 6,:)')
% plot(rmse_exp_theta(T.Acquisition == 'kernelselfsparring',:)' -  rmse_true_theta(T.Acquisition == 'kernelselfsparring',:)')
legend({'Test set', 'Training set'});
xlabel('Iteration')
ylabel('RMSE')
box off


%%
T = load(data_table_file).T;
T = T(T.Subject == subject & T.Seed == 7 & T.Acquisition == 'random', :);
for k = 1:size(T,1)
    task = cellstr(T(k,:).Task);
    task = task{1};
    acquisition_fun_name = cellstr(T(k,:).Acquisition);
    acquisition_fun_name = acquisition_fun_name{1};
    index = T(k,:).Index;
    filename = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
    filenames{k} = filename;
    load(filename, 'experiment');
    xtrain_rand = experiment.xtrain_norm;
    ctrain_rand = experiment.ctrain;
end
T = load(data_table_file).T;
T = T(T.Subject == subject & T.Seed == 7 & T.Acquisition == 'kernelselfsparring', :);
for k = 1:size(T,1)
    task = cellstr(T(k,:).Task);
    task = task{1};
    acquisition_fun_name = cellstr(T(k,:).Acquisition);
    acquisition_fun_name = acquisition_fun_name{1};
    index = T(k,:).Index;
    filename = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
    filenames{k} = filename;
    load(filename, 'experiment');
    xtrain_kss = experiment.xtrain_norm;
    ctrain_kss= experiment.ctrain;
    
end
rmse = NaN(1,80);

for i = 1:80
    [mu_c,  mu_y, ~, Sigma2_y] = prediction_bin_preference(theta, xtrain_kss(:,1:i),ctrain_kss(:,1:i), xtrain_rand, kernelfun, kernelname, 'modeltype', modeltype);
    rmse(i) = sqrt(mean((mu_c- ctrain_rand(:)).^2));
end

fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
fig.Color =  [1 1 1];
fig.Name = 'RMSE with varying number of points with the correct theta';
plot(rmse, 'linewidth', linewidth); hold on ;
xlabel('Iteration')
ylabel('RMSE')
box off

