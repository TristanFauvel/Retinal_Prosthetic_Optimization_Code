add_modules;

cd([code_directory, '/modified_P2P_stable'])
flag = int32(bitor(2, 8)); %To avoid memory allocation erros
py.sys.setdlopenflags(flag);
pymod = py.importlib.import_module('perceptual_model');
cd([code_directory,'/Experiment'])

graphics_style_paper;


T = load(data_table_file).T;
subject = 'TF';
id = find(T.Subject== subject)';
xi=  [];
for i = id
    task = cellstr(T(i,:).Task);
    task = task{1};
    index = T(i,:).Index;
    acquisition_fun_name = cellstr(T(i,:).Acquisition);
    acquisition_fun_name = acquisition_fun_name{1};
    subject = cellstr(T(i,:).Subject);
    subject = subject{1};
    filename = [data_directory, '/Data_Experiment_p2p_', task,'/',subject, '/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
    
    load(filename)
    
    xi = [xi; experiment.xtrain(1,1:5)];
%     theta = [theta,experiment.theta];
%     end
%     analyze_experiment(filename)    
end

for i = id
    task = cellstr(T(i,:).Task);
    task = task{1};
    index = T(i,:).Index;
    acquisition_fun_name = cellstr(T(i,:).Acquisition);
    acquisition_fun_name = acquisition_fun_name{1};
    subject = cellstr(T(i,:).Subject);
    subject = subject{1};
    filename = [data_directory, '/Data_Experiment_p2p_', task,'/',subject, '/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
    plot_BO_p2p_results(filename)
end
% 
% task = 'preference';
% acquisition_fun_name = 'random';
% n = 50;
% indices = T(T.Task==task & T.Subject== subject & T.Acquisition== acquisition_fun_name,:).Index;
% 
% for i = 1:numel(indices)
%     index = indices(i);
%     filename = [data_directory, '/Data_Experiment_p2p_', task,'/',subject, '/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
%     measure_acuities(filename, 'E', n)
% end
% 
% 
% %% Compute visual acuity
% 
% acuity_naive = [];
% acuity_optimized = [];
% acuity_optimal = [];
% cs_naive = [];
% cs_optimized = [];
% cs_optimal = [];
% cs_optimized_random = [];
% acuity_optimized_random= [];
% acuity_naive_misspecification= [];
% acuity_optimized_misspecification= [];
% acuity_optimal_misspecification= [];
% cs_naive_misspecification= [];
% cs_optimized_misspecification= [];
% cs_optimal_misspecification= [];
% cs_optimized= [];
% acuity_optimized= [];
% for i =1:size(T,1)
%     task = cellstr(T(i,:).Task);
%     task = task{1};
%     index = T(i,:).Index;
%     acquisition_fun_name = cellstr(T(i,:).Acquisition);
%     acquisition_fun_name = acquisition_fun_name{1};
%     subject = cellstr(T(i,:).Subject);
%     subject = subject{1};
%     filename = [data_directory, '/Data_Experiment_p2p_', task,'/',subject, '/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
%     load(filename, 'experiment');
%     if strcmp(acquisition_fun_name, 'kernelselfsparring') && T(i,:).Misspecification ==0
%         acuity_naive = [acuity_naive, experiment.acuity_E_naive];
%         acuity_optimized = [acuity_optimized, experiment.(['acuity_E',num2str(experiment.maxiter)])];
%         acuity_optimal = [acuity_optimal, experiment.acuity_E_optimal];
%         cs_naive = [cs_naive, experiment.cd_E_naive];
%         cs_optimized = [cs_optimized, experiment.(['cs_E',num2str(experiment.maxiter)])];
%         cs_optimal = [cs_optimal, experiment.cs_E_optimal];
%     elseif strcmp(acquisition_fun_name, 'random')
%         cs_optimized_random = [cs_optimized_random, experiment.(['cs_E',num2str(experiment.maxiter)])];
%         acuity_optimized_random = [acuity_optimized_random, experiment.(['acuity_E',num2str(experiment.maxiter)])];
%     elseif strcmp(acquisition_fun_name, 'kernelselfsparring') && T(i,:).Misspecification ==1
%         acuity_naive_misspecification = [acuity_naive_misspecification , experiment.acuity_E_naive];
%         acuity_optimized_misspecification = [acuity_optimized_misspecification , experiment.(['acuity_E',num2str(experiment.maxiter)])];
%         acuity_optimal_misspecification = [acuity_optimal_misspecification , experiment.acuity_E_optimal];
%         cs_naive_misspecification = [cs_naive_misspecification , experiment.cd_E_naive];
%         cs_optimized_misspecification = [cs_optimized_misspecification , experiment.(['cs_E',num2str(experiment.maxiter)])];
%         cs_optimal_misspecification = [cs_optimal_misspecification , experiment.cd_E_optimal];
%     elseif strcmp(task, 'E')
%         cs_optimized = [cs_optimized, experiment.(['cs_E',num2str(experiment.maxiter)])];
%         acuity_optimized = [acuity_optimized, experiment.(['acuity_E',num2str(experiment.maxiter)])];
%     end
% end
% 
% acuities = [acuity_naive; acuity_optimized; acuity_optimal];
% acuities = acuities(:);
% type= char('Naive code', 'Optimized code', 'Optimal code');
% type= repmat(type, numel(indices),1);
% 
% fig=figure('units','normalized','outerposition',[0 0 1 1]);
% fig.Color =  [1 1 1];
% h = boxplot(acuities, type);
% set(h,{'linew'},{2})
% box off
% ylabel('Acuity')
% 
% 
% %% Contrast sensitivity
% 
% cs_naive = [];
% cs_optimized = [];
% cs_optimal = [];
% for i =1:n
%     task = cellstr(T(i,:).Task);
%     task = task{1};
%     index = T(i,:).Index;
%     acquisition_fun_name = cellstr(T(i,:).Acquisition);
%     acquisition_fun_name = acquisition_fun_name{1};
%     subject = cellstr(T(i,:).Subject);
%     subject = subject{1};
%     filename = [data_directory, '/Data/Data_Experiment_p2p_', task,'/',subject, '/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
%     load(filename, 'experiment');
%     cs_naive = [cs_naive, experiment.cs_naive];
%     cs_optimized = [cs_optimized, experiment.cs];
%     cs_optimal = [cs_optimal, experiment.cs_optimal];
% end
% 
% cs = [cs_naive; cs_optimized; cs_optimal];
% cs = cs(:);
% type= char('Naive code', 'Optimized code', 'Optimal code');
% type= repmat(type, numel(indices),1);
% 
% fig=figure('units','normalized','outerposition',[0 0 1 1]);
% fig.Color =  [1 1 1];
% h = boxplot(acuities, type);
% set(h,{'linew'},{2})
% box off
% ylabel('Contrast sensitivity')
% 
% 
% measure_contrast_sensitivity(filename, 'E',50)
