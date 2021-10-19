function [x_best, values] = compute_GP_max_combined_data(filenames, compute_all)
% I use this function to compute the dynamics of the value max estimate (not considering changes in hyperparameters).

maxiters = zeros(1,numel(filenames));
xtrain_combined = [];
xtrain_norm_combined = [];
ctrain_combined = [];
for k = 1:numel(filenames)
    results = load(filenames{k});
    UNPACK_STRUCT(results.experiment, false)
    xtrain_combined = [xtrain_combined,xtrain];
    xtrain_norm_combined = [xtrain_norm_combined,xtrain_norm];
    ctrain_combined = [ctrain_combined, ctrain];
    maxiters(k) = maxiter;
end

xtrain_norm = xtrain_norm_combined;
xtrain = xtrain_combined;
ctrain = ctrain_combined;
% theta = multistart_minConf(@(hyp)negloglike_bin(hyp, xtrain_norm, ctrain, model), hyp_lb, hyp_ub,10, init_guess, options_theta);
theta = theta_init;

maxiter= sum(maxiters);

add_directories;
cd([code_directory,'/Experiment_p2p_preference'])

nd = d;
    
options.method = 'sd';
options.verbose = 1;
ncandidates= 10;
post = [];
regularization = 'nugget';
modeltype = 'exp_prop';
if compute_all
    %% Compute the estimates of the best parameters (this is done in the analysis part to save time during the experiment)
    x_best = NaN(nd,maxiter);       
    x_best_norm = NaN(nd,maxiter);    
    wbar = waitbar(0,'Computing best parameters...');
    
    if strcmp(task, 'preference')
        for i=1:maxiter
            if i == 1
                init_guess = [];
            else
                init_guess = x_best_norm(:,i-1);
            end
            x_best_norm(:,i) = multistart_minConf(@(x)to_maximize_value_function(theta, xtrain_norm(:,1:i), ctrain(1:i), x, kernelfun,kernelname, x0,modeltype), model.lb_norm, model.ub_norm, ncandidates,init_guess, options);
            waitbar(i/maxiter,wbar,'Computing best parameters...');
            
        end
        [~, values] = model.prediction(theta, xtrain_norm, ctrain, [x_best_norm; x0.*ones(d,size(x_best_norm,2))], kernelfun, kernelname, modeltype, post, regulzarization);
        
    else
        for i=1:maxiter
            if i == 1
                init_guess = [];
            else
                init_guess = x_best_norm(:,i-1);
            end
            x_best_norm(:,i) = multistart_minConf(@(x)to_maximize_mean_GP(theta, xtrain_norm(:,1:i), ctrain(1:i), x,model), lb_norm, ub_norm, ncandidates, init_guess,options);
            waitbar(i/maxiter,wbar,'Computing best parameters...');
        end
        [mu_c, mu_y, ~,~] =model.prediction(theta, xtrain_norm, ctrain, x_best_norm, post);
        values = mu_y;
    end
    
else
    %% Compute the estimates of the best parameters (this is done in the analysis part to save time during the experiment)
    
    if strcmp(task, 'preference')
        init_guess = [];
        x_best_norm = multistart_minConf(@(x)to_maximize_value_function(theta, xtrain_norm, ctrain, x, kernelfun, x0,modeltype), model.lb_norm, model.ub_norm, ncandidates,init_guess, options);
        
        [~, values] = model.prediction(theta, xtrain_norm, ctrain, [x_best_norm; x0.*ones(d,size(x_best_norm,2))], kernelfun, kernelname, modeltype, post, regularization);
    elseif strcmp(task, 'LandoltC') || strcmp(task, 'Vernier') || strcmp(task, 'E')
        init_guess = [];
        x_best_norm = multistart_minConf(@(x)to_maximize_mean_GP(theta, xtrain_norm, ctrain, x,model), lb_norm, ub_norm, ncandidates, init_guess,options);
        [values, mu_y, ~,~] =model.prediction(theta, xtrain_norm, ctrain, x_best_norm, post);
       
    end
end
if ~strcmp(task, 'preference')
    x_best_norm  = x_best_norm(1:d,:);
end
p = x_best_norm.*(ub'-lb') + lb';
x_best = model_params*ones(1,maxiter);
x_best(ib,:) = p;

x_best = reshape(x_best,numel(filenames),[]);
values = reshape(values,numel(filenames),[]);

return

N= 1000;
figure();
for k=1:6
    [mu_c, mu_y, ~,~] =model.prediction(theta, xtrain_norm, ctrain, [ones(k-1,N); linspace(0,1,N); ones(6-k,N)], post);
    subplot(6,1,k)
    plot(linspace(0,1,N), mu_y)
end


if strcmp(acquisition_fun_name, 'accessvar_TS')
    theta = multistart_minConf(@(hyp)negloglike_bin(hyp, xtrain_norm, ctrain, model), hyp_lb, hyp_ub,40, theta, options_theta);
else
    theta = multistart_minConf(@(hyp)negloglike_bin(hyp, xtrain_norm, ctrain, model), hyp_lb, hyp_ub,10, init_guess, options_theta);
    
end

[a,b] = negloglike_bin(theta, xtrain_norm, ctrain, post);
mu_c = model.prediction(theta, xtrain_norm, ctrain, [xtrain_norm(1:d,:);ones(1,maxiter)], kernelfun, kernelname, modeltype, post, regularization);
figure(); plot(mu_c)


x_best_norm = (x_best - min_x)./(max_x-min_x);
N=100;
xtest = x_best_norm(:,end)*ones(1,N);
xtest(1,:) = linspace(0,1,N)
[~, mu_y, ~,~] =model.prediction(theta, xtrain_norm, ctrain, xtest, post);
figure();
plot(xtest(1,:), mu_y)




[~, values] = model.prediction(theta, xtrain_norm, ctrain, [x_best_norm(:,1:i); x0.*ones(d,i)], kernelfun, kernelname, modeltype, post, regularization);
figure()
plot(values)