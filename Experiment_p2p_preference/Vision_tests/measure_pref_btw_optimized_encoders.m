function measure_pref_btw_optimized_encoders(filename1,filename2, control)
%The two experiments should correspond to the same perceptual model, the
%first one corresponds to the acquisition function to test, the second one
%to the random acquisition
exp1 = load(filename1, 'experiment');
exp1 = exp1.experiment;
W_optimized_1 = encoder(exp1.x_best(:, end), exp1,1,0);
W_opt = encoder(exp1.model_params, exp1,1,1);

    W_naive = naive_encoder(exp1);

if ~strcmp(control, 'misspecified')
    xparams = exp1.model_params;
    xparams(exp1.ib) = exp1.xtrain(exp1.ib,1);
    W_control = encoder(xparams, exp1,1,0);
end
if ~isempty(filename2)
    exp2 = load(filename2, 'experiment');
    exp2 = exp2.experiment;
    W_optimized_2 = encoder(exp2.x_best(:, end), exp2,1,0);
    
    if exp1.model_seed ~= exp2.model_seed
        error('The perceptual models are not the same')
    end    
    
    if strcmp(control, 'misspecified')
        xparams = exp2.model_params;
        xparams(exp2.ib) = exp2.xtrain(exp2.ib,1);
        W_control = encoder(xparams, exp2,1,0);
     end
end

add_directories;
experiment = exp1;
switch control
    case 'control'
        experiment.acq_vs_control_test = preference_measurement(exp1, W_optimized_1, W_control, 'test');
        experiment.acq_vs_control_training = preference_measurement(exp1, W_optimized_1, W_control, 'training');
        
        experiment.control_vs_naive_training = preference_measurement(exp1, W_control, W_naive, 'training');
    case 'random'
        experiment.acq_vs_random_test = preference_measurement(exp1, W_optimized_1, W_optimized_2, 'test');
        experiment.acq_vs_random_training = preference_measurement(exp1, W_optimized_1, W_optimized_2, 'training');
    case 'optimal'
        experiment.acq_vs_opt_test = preference_measurement(exp1, W_optimized_1, W_opt, 'test');
        experiment.acq_vs_opt_training = preference_measurement(exp1, W_optimized_1, W_opt, 'training');
    case 'E'
        experiment.Pref_vs_E_test = preference_measurement(exp1, W_optimized_1, W_optimized_2, 'test');
        experiment.Pref_vs_E_training = preference_measurement(exp1, W_optimized_1, W_optimized_2, 'training');
        
        experiment.E_vs_naive_training = preference_measurement(exp1, W_optimized_2, W_naive, 'training');
        
        experiment.E_vs_control_training = preference_measurement(exp1, W_optimized_2, W_control, 'training');

    case 'misspecified'
%         experiment.optimized_miss_vs_opt_miss_test = preference_measurement(exp1, W_optimized_1, W_opt, 'test');
        experiment.optimized_miss_vs_opt_miss_training = preference_measurement(exp1, W_optimized_1, W_opt, 'training');
        
%         experiment.optimized_miss_vs_control_test = preference_measurement(exp1, W_optimized_1, W_control, 'test');
        experiment.optimized_miss_vs_control_training = preference_measurement(exp1, W_optimized_1, W_control, 'training');
        
%         experiment.optimized_miss_vs_naive_test = preference_measurement(exp1, W_optimized_1, W_naive, 'test');
%         experiment.optimized_miss_vs_naive_training = preference_measurement(exp1, W_optimized_1, W_naive, 'training');
        experiment.opt_miss_vs_control_training = preference_measurement(exp1, W_opt, W_control, 'training');

%         experiment.optimized_misspecified_vs_optimized_test = preference_measurement(exp1, W_optimized_1, W_optimized_2, 'test');
        experiment.optimized_misspecified_vs_optimized_training = preference_measurement(exp1, W_optimized_1, W_optimized_2, 'training');

    case 'naive'
        experiment.optimized_vs_naive_test = preference_measurement(exp1, W_optimized_1, W_naive, 'test');
        experiment.optimized_vs_naive_training = preference_measurement(exp1, W_optimized_1, W_naive, 'training');
end

save(filename1, 'experiment')


