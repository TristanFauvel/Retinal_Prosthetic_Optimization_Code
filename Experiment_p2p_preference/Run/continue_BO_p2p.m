function  filename =continue_BO_p2p(experiment, new_maxiter)
add_modules;
UNPACK_STRUCT(experiment, false)

if exist('s')
    rng(s)
end
if strcmp(task, 'E')
xtrain = xtrain(1:(end-1),:);
new_x = new_x(1:end-1);
ub = ub(1:end-1);
lb = lb(1:end-1);

end

access_param =504;
for i=(maxiter+1):new_maxiter
    disp(i)
    
    if strcmp(task, 'preference')
        
        xtrain = [xtrain, new_duel];
        x_duel = model_params; %(ia);
        x_duel(ib) = x_duel1;
        x_duel1 = x_duel;
        
        x_duel(ib) = x_duel2;
        x_duel2 = x_duel;
        
        %% Normalize data so that the bound of the search space are 0 and 1.
        xtrain_norm = (xtrain - [lb, lb]')./([ub, ub]'- [lb, lb]');
        
        if experiment.parallel==1
            job1 = batch(@encoder,1,{x_duel1,experiment});
            job2 = batch(@encoder,1,{x_duel2,experiment});
            
            while strcmp(job1.State,'running') || strcmp(job2.State,'running')
                x_duel1_r = rand_acq();
                x_duel2_r = rand_acq();
                new_duel= [x_duel1_r; x_duel2_r];
                x_duel = model_params; %(ia);
                x_duel(ib) = x_duel1_r;
                x_duel1_r = x_duel_r;
                x_duel(ib) = x_duel2_r;
                x_duel2_r = x_duel;
                Wr{1} = encoder(x_duel1_r, experiment);
                Wr{2} = encoder(x_duel2_r, experiment);
                x_rand = [x_rand, new_duel];
                c_rand = [c_rand, query_response_task(M, Wr, S, display_size, experiment, task)];
            end
            A = fetchOutputs(job1(1));
            W{1} = A{1};
            A = fetchOutputs(job2(1));
            W{2} = A{1};
        else
            W{1} = encoder(x_duel1, experiment);
            W{2} = encoder(x_duel2, experiment);
        end
        [c,rti] = query_response_task(M, W, S, display_size, experiment, task);
        rt = [rt, rti];
    else
        xtrain = [xtrain, new_x];
        %% Normalize data so that the bound of the search space are 0 and 1.
        xtrain_norm = (xtrain - lb')./(ub'- lb');
        
        if experiment.parallel==1
            job = batch(@encoder,1,{new_x(1:d),experiment});
            while strcmp(job.State,'running')
                access_param = rand_interval(bounds(1), bounds(2));
                new_x_r = [rand_acq(); access_param];
                x_rand = [x_rand, new_x_r];
                Wr = encoder(new_x_r(1:d), experiment);
                [S.S,S.correct_response] = compute_stimulus(task,access_param, display_size, Stimuli_folder, contrast);
                c_rand = [c_rand, query_response_task(M, Wr, S, display_size, experiment, task)];
            end
            W = fetchOutputs(job(1));
            W= W{1};
        else
            W= encoder(new_x(1:d),experiment);
        end
        %access_param = rand_interval(bounds(1), bounds(2));
        [S.S,S.correct_response] = compute_stimulus(task,access_param, display_size, Stimuli_folder, experiment.contrast);
        
        c = query_response_task(M, W, S, display_size, experiment, task);
    end
    
    ctrain = [ctrain, c];
    if i > nopt
        %Optimization of hyperparameters
        if mod(i, update_period) ==0
            %theta_old = [theta_old, theta];
            init_guess = theta;
            theta = multistart_minConf(@(hyp)negloglike_bin(hyp, xtrain_norm, ctrain, model), theta_lb, theta_ub,10, init_guess, options_theta);
        end
        if strcmp(task, 'preference')
            [x_duel1, x_duel2, new_duel] = acquisition_fun(theta, xtrain_norm, ctrain, kernelfun, kernelname, modeltype,max_x, min_x, lb_norm, ub_norm, x0);
        else
            
            if min_x(end) == max_x(end) %correspond to a constant control variable for the acuity task
                new_x = acquisition_fun(theta, xtrain_norm(1:end-1,:), ctrain, kernelfun, kernelname, modeltype,max_x(1:end-1), min_x(1:end-1), lb_norm(1:end-1), ub_norm(1:end-1));
                new_x  = [new_x;max_x(end)];
            else
                new_x = acquisition_fun(theta, xtrain_norm, ctrain, kernelfun, kernelname, modeltype,max_x, min_x, lb_norm, ub_norm);
                
            end
        end
        
    else %When we have not started to train the GP classification model, the acquisition is random
        if strcmp(task, 'preference')
            x_duel1 = rand_acq();
            x_duel2 = rand_acq();
            new_duel= [x_duel1; x_duel2];
        else
            new_x = [rand_acq(); rand_interval(bounds(1), bounds(2))];
        end
    end    
end

init_guess = theta;
theta = multistart_minConf(@(hyp)negloglike_bin(hyp, xtrain_norm, ctrain, model), theta_lb, theta_ub,10, init_guess, options_theta);

            
if ~strcmp(task, 'preference')
    if min_x(end) == max_x(end) %correspond to a constant control variable for the acuity task
        xtrain_norm = xtrain_norm(1:end-1,:);
        max_x = max_x(1:end-1);
        min_x = min_x(1:end-1);
        lb_norm = lb_norm(1:end-1);
        ub_norm = ub_norm(1:end-1);
    end
end

close all

w = whos;
close all
for a = 1:length(w)
    if ~strcmp(w(a).name, 'experiment')
        experiment.(w(a).name) = eval(w(a).name);
    end
end

filename = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
save(filename, 'experiment')
save([data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/index.mat'], 'index')

experiment.x_best(:,end) = compute_GP_max(filename, 0);



if strcmp(task, 'preference')
    x_duel1 = experiment.x_best(:,end);
    x_duel2 = model_params;
    
    x_duel = model_params; %(ia);
    x_duel(ib) = x_duel1;
    x_duel1 = x_duel;
    x_duel(ib) = x_duel2;
    x_duel2 = x_duel;
    
    if ~strcmp(subject, 'computer')
        %         c = query_preference(M, x_duel1, x_duel2, S, display_size, experiment);
        W{1} = encoder(x_duel1, experiment);
        W{2} = encoder(x_duel2, experiment);
        c = query_response_task(M, W, S, display_size, experiment, task);
    else
        c = link(fx*(g(x_duel1)-g(x_duel2)))>rand;
    end
    experiment.query_optimized_vs_optima = c;
end
save(filename, 'experiment')
