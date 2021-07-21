function [x_best, values, x_best_norm] = compute_GP_max(filename, compute_all,unknown_theta)
% I use this function to compute the dynamics of the value max estimate (not considering changes in hyperparameters).

load(filename, 'experiment');
UNPACK_STRUCT(experiment, false)

nd = d;
% if ~strcmp(task, 'preference')
%     nd = nd+1;
% end
init_guess = theta;
if unknown_theta
    theta = multistart_minConf(@(hyp)negloglike_bin(hyp, xtrain_norm, ctrain, kernelfun, 'modeltype', modeltype), theta_lb, theta_ub,30, init_guess, options_theta);
else
    theta = theta_init;
end

% %%% %%%%%%%%%%%%%
% base_kernelfun =  @ARD_kernelfun;%kernel used within the preference learning kernel, for subject = computer
% theta_init = [-0.1011,-10.0000,0.8080,-1.3494,-1.6468,1.6123,-1.7985,-0.2213,1.6397];
% theta = theta_init;
% kernelfun = @(theta, xi, xj, training) preference_kernelfun(theta, base_kernelfun, xi, xj, training);
% known_theta = 1
% %%%
options.method = 'sd';
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
            [~, ~, ~,~,~,~,~,~,~,~,post] = prediction_bin_preference(theta, xtrain_norm(:,1:i), ctrain(1:i), [x0.*ones(d,size(x_best_norm,2)); x0.*ones(d,size(x_best_norm,2))], kernelfun, 'modeltype', modeltype, 'post', []);

            x_best_norm(:,i) = multistart_minConf(@(x)to_maximize_value_function(theta, xtrain_norm(:,1:i), ctrain(1:i), x, kernelfun, x0,modeltype, post), lb_norm, ub_norm, ncandidates,init_guess, options);
            
%             waitbar(i/imax,wbar,'Computing best parameters...');
            
        end
        %         theta = multistart_minConf(@(hyp)negloglike_bin(hyp, xtrain_norm, ctrain, kernelfun, 'modeltype', modeltype), theta_lb, theta_ub,30, theta, options_theta);
        
        [~, values] = prediction_bin_preference(theta, xtrain_norm, ctrain, [x_best_norm; x0.*ones(d,size(x_best_norm,2))], kernelfun, 'modeltype', modeltype, 'post', []);
   
%         [~,test] = prediction_bin_preference(theta, xtrain_norm(:,1:i), ctrain(1:i), [linspace(0,1,25); x0.*ones(d,size(x_best_norm,2))], kernelfun, kernelname, 'modeltype', modeltype);
% figure(); plot(test)
    else
        for i=1:imax
            if ~unknown_theta
                if isfield(experiment, 'hyps')
                    theta = experiment.hyps(i,:)';
                else
                    if mod(i, update_period) ==1
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
            [~, ~,~,~,~,~,~,~,~,~,post] = prediction_bin(theta, xtrain_norm(:,1:i), ctrain(1:i), xtrain_norm(:,end), kernelfun, 'modeltype', modeltype);

            x_best_norm(:,i) = multistart_minConf(@(x)to_maximize_mean_bin_GP(theta, xtrain_norm(:,1:i), ctrain(1:i), x, kernelfun, modeltype, post), lb_norm, ub_norm, ncandidates, init_guess,options);
%             waitbar(i/imax,wbar,'Computing best parameters...');
        end
        theta = multistart_minConf(@(hyp)negloglike_bin(hyp, xtrain_norm, ctrain, kernelfun, 'modeltype', modeltype), theta_lb, theta_ub,30, theta, options_theta);
        
        [~, values] = prediction_bin(theta, xtrain_norm, ctrain, x_best_norm, kernelfun, 'modeltype', modeltype, 'post', []);
    end
    
else
    %% Compute the estimates of the best parameters (this is done in the analysis part to save time during the experiment)
    
    if strcmp(task, 'preference')
        init_guess = [];
        [~, ~,~,~,~,~,~,~,~,~,post] = prediction_bin_preference(theta, xtrain_norm, ctrain,xtrain_norm(:,end), kernelfun, 'modeltype', modeltype, 'post', post);
        x_best_norm = multistart_minConf(@(x)to_maximize_value_function(theta, xtrain_norm, ctrain, x, kernelfun, x0,modeltype, post), lb_norm, ub_norm, ncandidates,init_guess, options);
        [~, values] = prediction_bin_preference(theta, xtrain_norm, ctrain, [x_best_norm; x0.*ones(d,size(x_best_norm,2))], kernelfun, 'modeltype', modeltype, 'post', post);
    elseif strcmp(task, 'LandoltC') || strcmp(task, 'Vernier') || strcmp(task, 'E')
        init_guess = [];
        [~, ~,~,~,~,~,~,~,~,~,post] = prediction_bin(theta, xtrain_norm, ctrain,xtrain_norm(:,end), kernelfun, 'modeltype', modeltype, 'post', post);
        x_best_norm = multistart_minConf(@(x)to_maximize_mean_bin_GP(theta, xtrain_norm, ctrain, x, kernelfun, modeltype, post), lb_norm, ub_norm, ncandidates, init_guess,options);
        [values, mu_y] =prediction_bin(theta, xtrain_norm, ctrain, x_best_norm, kernelfun, 'modeltype', modeltype, 'post', post);
        
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


params_names = {'$\rho  (\mu m)$','$\lambda  (\mu m)$','$\theta  (rad)$','$x  (\mu m)$', '$y  (\mu m)$', 'Magnitude', '$\beta_{+}$','$\beta_{-}$','z'};

fig=figure('units','normalized','outerposition',[0 0 1 1]);
fig.Color =  [1 1 1];
fig.Name = 'Optimal parameters';
mc = 8;
graphics_style_paper;
for k = 1:mc
    subplot(2,mc/2,k)
    plot(x_best_norm(k,:), 'linewidth', linewidth); 
    set(gca,'FontSize',Fontsize)
    ylabel([params_names{k}],'Fontsize',Fontsize)
    xlabel('Iteration')
    pbaspect([1 1 1])
    xlim([1, imax])
    box off
end



N= 1000;
figure();
for k=1:6
    [mu_c, mu_y, ~,~] =prediction_bin(theta, xtrain_norm, ctrain, [ones(k-1,N); linspace(0,1,N); ones(6-k,N)], kernelfun, 'modeltype', modeltype, 'post', post);
    subplot(6,1,k)
    plot(linspace(0,1,N), mu_y)
end


if strcmp(acquisition_fun_name, 'accessvar_TS')
    theta = multistart_minConf(@(hyp)negloglike_bin(hyp, xtrain_norm, ctrain, kernelfun, 'modeltype', modeltype), theta_lb, theta_ub,40, theta, options_theta);
else
    theta = multistart_minConf(@(hyp)negloglike_bin(hyp, xtrain_norm, ctrain, kernelfun, 'modeltype', modeltype), theta_lb, theta_ub,10, init_guess, options_theta);
    
end

[a,b] = negloglike_bin(theta, xtrain_norm, ctrain, kernelfun, 'modeltype', modeltype);

mu_c = prediction_bin_preference(theta, xtrain_norm, ctrain, [xtrain_norm(1:d,:);ones(1,imax)], kernelfun, 'modeltype', modeltype,'post', post);
figure(); plot(mu_c)


x_best_norm = (x_best - min_x)./(max_x-min_x);
N=100;
xtest = x_best_norm(:,end)*ones(1,N);
xtest(1,:) = linspace(0,1,N)
[~, mu_y, ~,~] =prediction_bin(theta, xtrain_norm, ctrain, xtest, kernelfun, 'modeltype', modeltype, 'post', post);
figure();
plot(xtest(1,:), mu_y)




[~, values] = prediction_bin_preference(theta, xtrain_norm, ctrain, [x_best_norm(:,1:i); x0.*ones(d,i)], kernelfun, 'modeltype', modeltype);
figure()
plot(values)