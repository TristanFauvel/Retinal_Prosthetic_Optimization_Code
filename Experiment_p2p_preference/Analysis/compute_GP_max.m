function [x_best, values, x_best_norm] = compute_GP_max(filename, compute_all,unknown_theta)
% I use this function to compute the dynamics of the value max estimate (not considering changes in hyperparameters).

load(filename, 'experiment');
UNPACK_STRUCT(experiment, false)

regularization = 'nugget';
if ~strcmp(task, 'preference')
    kernelfun = @(theta, x,xp,training, regularization) base_kernelfun(theta, x(1:d,:),xp(1:d,:),training, regularization);
else
    kernelfun = @(theta,xi,xj,training, regularization) preference_kernelfun(theta,base_kernelfun,xi,xj,training, regularization);
end

nd = d;

init_guess = theta;
if unknown_theta
    theta = multistart_minConf(@(hyp)negloglike_bin(hyp, xtrain_norm, ctrain, kernelfun, 'modeltype', modeltype), theta_lb, theta_ub,30, init_guess, options_theta);
else
    theta = theta_init;
end

options.method = 'lbfgs';
options.verbose = 1;
ncandidates= 10;
x0 = 0.5*ones(nd,1);

if compute_all %% We do not want to recompute the inferred best encoder at the end of the experiment if it has already been computed.
    if ~any(isnan(x_best_norm(:,end)))
        imax = maxiter-1;
    else
        imax = maxiter;
    end
else
    imax = maxiter;
end
post = [];
regularization = 'nugget';

if compute_all
    %% Compute the estimates of the best parameters (this is done in the analysis part to save time during the experiment)
    x_best = experiment.x_best; %x_best.*ones(numel(model_params),maxiter);
    x_best_norm = experiment.x_best_norm; %x_best_norm.*ones(nd,maxiter);
%     wbar = waitbar(0,'Computing best parameters...');
    
    if strcmp(task, 'preference')
        for i=1:imax
            if ~unknown_theta
                if isfield(experiment, 'hyps')
                    theta = experiment.hyps(i,:)';
                else
                    if (mod(i, update_period) ==1 && i>1) || i == imax
                        %theta_old = [theta_old, theta];
                        init_guess = theta;
                        theta = multistart_minConf(@(hyp)negloglike_bin(hyp, xtrain_norm(:,1:i), ctrain(1:i), kernelfun, 'modeltype', modeltype), theta_lb, theta_ub,10, init_guess, options_theta);
                    end
                end
            end
            
            if i == 1
                init_guess = [];
            else
                init_guess = x_best_norm(:,i-1);
            end
            post = prediction_bin(theta, xtrain_norm(:,1:i), ctrain(1:i), [], kernelfun, modeltype, [], regularization);

            x_best_norm(:,i) = multistart_minConf(@(x)to_maximize_value_function(theta, xtrain_norm(:,1:i), ctrain(1:i), x, kernelfun, x0,modeltype, post), lb_norm, ub_norm, ncandidates,init_guess, options);
            
%             waitbar(i/imax,wbar,'Computing best parameters...');
            
        end
        %         theta = multistart_minConf(@(hyp)negloglike_bin(hyp, xtrain_norm, ctrain, kernelfun, 'modeltype', modeltype), theta_lb, theta_ub,30, theta, options_theta);
        
        [~, values] = prediction_bin(theta, xtrain_norm, ctrain, [x_best_norm; x0.*ones(d,size(x_best_norm,2))], kernelfun, modeltype, [], regularization);
   
%         [~,test] = prediction_bin(theta, xtrain_norm(:,1:i), ctrain(1:i), [linspace(0,1,25); x0.*ones(d,size(x_best_norm,2))], kernelfun, kernelname, modeltype, post, regularization);
% figure(); plot(test)
    else
        for i=1:imax
            if ~unknown_theta
                if isfield(experiment, 'hyps')
                    theta = experiment.hyps(i,:)';
                else
                    if mod(i, update_period) ==0
                        %theta_old = [theta_old, theta];
                        init_guess = theta;
                        theta = multistart_minConf(@(hyp)negloglike_bin(hyp, xtrain_norm(:, 1:i), ctrain(1:i), kernelfun, 'modeltype', modeltype), theta_lb, theta_ub,10, init_guess, options_theta);
                    end
                end
            end
            if i == 1
                init_guess = [];
            else
                init_guess = x_best_norm(:,i-1);
            end
            post = prediction_bin(theta, xtrain_norm(:,1:i), ctrain(1:i), [], kernelfun, modeltype, [], regularization);

            x_best_norm(:,i) = multistart_minConf(@(x)to_maximize_mean_bin_GP(theta, xtrain_norm(:,1:i), ctrain(1:i), x, kernelfun, modeltype, post), lb_norm, ub_norm, ncandidates, init_guess,options);
%             waitbar(i/imax,wbar,'Computing best parameters...');
        end        
        [~, values] = prediction_bin(theta, xtrain_norm, ctrain, x_best_norm, kernelfun, modeltype, [], regularization);
    end
    
else
    %% Compute the estimates of the best parameters (this is done in the analysis part to save time during the experiment)
    
    if strcmp(task, 'preference')
        init_guess = [];
        post = prediction_bin(theta, xtrain_norm, ctrain,[], kernelfun, modeltype, [], regularization);
        x_best_norm = multistart_minConf(@(x)to_maximize_value_function(theta, xtrain_norm, ctrain, x, kernelfun, x0,modeltype, post), lb_norm, ub_norm, ncandidates,init_guess, options);
        [~, values] = prediction_bin(theta, xtrain_norm, ctrain, [x_best_norm; x0.*ones(d,size(x_best_norm,2))], kernelfun, modeltype, post, regularization);
    elseif strcmp(task, 'LandoltC') || strcmp(task, 'Vernier') || strcmp(task, 'E')
        init_guess = [];
        post = prediction_bin(theta, xtrain_norm, ctrain,[], kernelfun, modeltype, [], regularization);
        x_best_norm = multistart_minConf(@(x)to_maximize_mean_bin_GP(theta, xtrain_norm, ctrain, x, kernelfun, modeltype, post), lb_norm, ub_norm, ncandidates, init_guess,options);
        [values, mu_y] =prediction_bin(theta, xtrain_norm, ctrain, x_best_norm, kernelfun, modeltype, post, regularization);
        
    end
end
if ~strcmp(task, 'preference')
    x_best_norm  = x_best_norm(1:d,:);
end
p = x_best_norm.*(ub'-lb') + lb';

if compute_all
    x_best(ib,:) = p;
else
    x_best = model_params;
    x_best(ib) = p;
    
end
return
