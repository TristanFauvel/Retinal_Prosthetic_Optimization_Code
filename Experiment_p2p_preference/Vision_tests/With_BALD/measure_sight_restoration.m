function measure_sight_restoration(filename, acuity_test)
load(filename, 'experiment');
add_directories

if strcmp(experiment.acquisition_fun_name, 'kernelselfsparring') %&& strcmp(experiment.task, 'preference') %&& experiment.misspecification ==0
    if experiment.misspecification ==0
    nmeasurements  = 3;
    else
        nmeasurements  = 2;
    end
    experiments_order  =randperm(nmeasurements);
    for k =1:nmeasurements
        if experiments_order(k) == 1
            W = encoder(experiment.x_best(:, end), experiment);
            experiment.VA_CS_measure_optimized= sight_restoration_measurement(experiment, W, acuity_test);
        elseif experiments_order(k) == 2
            W = encoder(experiment.model_params, experiment);
            experiment.VA_CS_measure_optimal= sight_restoration_measurement(experiment, W, acuity_test);
        elseif experiments_order(k) == 3
            W = naive_encoder(experiment);
            experiment.VA_CS_measure_naive= sight_restoration_measurement(experiment, W, acuity_test);
            
            %             [acuity_naive, cs_naive, experiment.('xtrain_acuity_naive'), experiment.('ctrain_acuity_naive')] = sight_restoration_measurement(experiment, W, acuity_test);
%          elseif experiments_order(k) == 4
%             W = naive_encoder(experiment);
%             experiment.VA_CS_measure_naive= sight_restoration_measurement(experiment, W, acuity_test);
%             
            %             [acuity_naive, cs_naive, experiment.('xtrain_acuity_naive'), experiment.('ctrain_acuity_naive')] = sight_restoration_measurement(experiment, W, acuity_test);
%           elseif experiments_order(k) == 5
%             W = encoder(experiment.x_best_random(:, experiment.maxiter), experiment);
%             experiment.VA_CS_measure_optimized_random= sight_restoration_measurement(experiment, W, acuity_test);
        end
    end
    
else
    W = encoder(experiment.x_best(:, end), experiment);
    experiment.VA_CS_measure_optimized= sight_restoration_measurement(experiment, W, acuity_test);
end

% switch acuity_test
%     case 'E'
%         experiment.(['acuity_E_', num2str(i)]) = acuity;
%         experiment.acuity_E_optimal = acuity_optimal;
%         experiment.acuity_E_naive = acuity_naive;
%         experiment.(['cs_E_', num2str(i)]) = cs;
%         experiment.cs_E_optimal = cs_optimal;
%         experiment.cs_E_naive = cs_naive;
%     case 'LandoltC'
%         experiment.acuity_LandoltC = acuity;
%         experiment.acuity_LandoltC_optimal = acuity_optimal;
%         experiment.acuity_LandoltC_naive = acuity_naive;
%         experiment.cs_LandoltC = cs;
%         experiment.cs_LandoltC_optimal = cs_optimal;
%         experiment.cs_LandoltC_naive = cs_naive;
%     case 'Vernier'
%         experiment.acuity_Vernier = acuity;
%         experiment.acuity_Vernier_optimal = acuity_optimal;
%         experiment.acuity_Vernier_naive = acuity_naive;
%         experiment.cs_Vernier = cs;
%         experiment.cs_Vernier_optimal = cs_optimal;
%         experiment.cs_Vernier_naive = cs_naive;
% end
save(filename, 'experiment')


% task = 'LandoltC';
% subject = 'human';
% indices = [10,11];
% acquisition_fun_name = 'TS_binary';
%
% for i =1:2
%     index = indices(i);
%     filename = ['../../Data/Data_Experiment_p2p_',task,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
%     load(filename, 'experiment');
%
%     W = encoder(experiment.x_best(:, end), experiment);
%     acuity = VA_measurement(experiment, W, 'Vernier');
%     experiment.acuity = acuity;
%
%     W = encoder(experiment.model_params, experiment);
%
%     acuity_optimal = VA_measurement(experiment, W, 'Vernier');
%     experiment.acuity_optimal = acuity_optimal;
%
%     W = naive_encoder(experiment);
%     acuity_naive = VA_measurement(experiment, W, 'Vernier');
%     experiment.acuity_naive = acuity_naive;
%
%     save(filename, 'experiment')
%
% end
%
%

