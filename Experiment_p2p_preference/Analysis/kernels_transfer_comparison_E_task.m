graphics_style_paper
add_modules
add_directories

loading = 1;
saving = 0;

filename1 = "C:\Users\tfauvel\Documents\Retinal_prosthetic_optimization\Data\Dataset_E_seed_6_4.mat";
load(filename1,'experiment')
exp1 = experiment;

filename2 = "C:\Users\tfauvel\Documents\Retinal_prosthetic_optimization\Data\Dataset_E_seed_99.mat";
load(filename2,'experiment')
exp2 = experiment;

% UNPACK_STRUCT(experiment, false)

% filename = "C:\Users\tfauvel\Documents\ktheta.mat";
% save(filename,'ktheta')
ndata = numel(exp1.ctrain);
p = randperm(ndata);
x_train_data = exp1.xtrain(:,p);
x_train_norm_data = exp1.xtrain_norm(:,p);
c_train_data = exp1.ctrain(p);

p = randperm(ndata);
x_test_data = exp2.xtrain(:,p);
x_test_norm_data = exp2.xtrain_norm(:,p);
c_test_data = exp2.ctrain(p);

kernel_list = {'ARD', 'RQ', 'Matern52', 'Matern32', 'Polynomial'};

modeltype = 'exp_prop';
maxiter = experiment.maxiter;
update_theta = 1;

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
                base_kernelfun = @Rational_Quadratic_kernelfun;
            case 'Matern52'
                theta = [-0.3544;1.6781]; % Matern 5/2
                kernelname = 'Matern52';
                base_kernelfun = @Matern52_kernelfun;
            case 'Matern32'
                base_kernelfun = @Matern32_kernelfun;
                kernelname = 'Matern32';
                theta = [-0.0843;2.0791]; % Matern 3/2
            case 'Polynomial'
                theta  =[ -0.4043; 1.1637];
                kernelname = 'Polynomial';
                base_kernelfun = @polynomial_kernelfun;
            case 'ARD'
                base_kernelfun = @ARD_kernelfun;
                theta = [-0.0995, -4.8518,-10.0000,0.6491,-0.9257,0.5564,-10.0000,-0.1287,0.3135];
                kernelname = 'ARD';
        end
        kernelfun = @base_kernelfun;
        
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


for i = 1:numel(kernel_list)
    kernelname = kernel_list{i};
    switch kernelname
        case 'RQ'
            kernelname = 'RQ';
            base_kernelfun = @Rational_Quadratic_kernelfun;
        case 'Matern52'
            kernelname = 'Matern52';
            base_kernelfun = @Matern52_kernelfun;
        case 'Matern32'
            base_kernelfun = @Matern32_kernelfun;
            kernelname = 'Matern32';
        case 'Polynomial'
            kernelname = 'Polynomial';
            base_kernelfun = @polynomial_kernelfun;
        case 'ARD'
            base_kernelfun = @ARD_kernelfun;
            kernelname = 'ARD';
    end
    theta = ktheta{i};
    kernelfun = base_kernelfun;
    
    [mu_c,  mu_y, ~, Sigma2_y] = prediction_bin(theta, x_train_norm_data, c_train_data, x_test_norm_data, kernelfun, 'modeltype', modeltype);
    mu_c = mu_c';
    
    brier_score(i) = mean((mu_c - c_test_data).^2);
    rmse(i)  = sqrt(mean((mu_c - c_test_data).^2));
    
    TP(i) = mean(mu_c>0.5 & c_test_data ==1);
    TN(i) = mean(mu_c<0.5 & c_test_data ==0);
    FP(i) = mean(mu_c>0.5 & c_test_data ==0);
    FN(i) = mean(mu_c<0.5 & c_test_data ==1);
    accuracy(i) = (TP(i)+ TN(i))/(FP(i)+ FN(i) + TP(i) + TN(i));
    
end

mean(c_test_data)
mean(c_train_data)

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
