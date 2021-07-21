clear all
use_ptb3=1; %Wether to use PTB3 or not
maxiter = 80; %Number of iterations in the BO loop.
subject = 'TF';
viewing_distance = 0.4; % viewing distance in m;
add_modules;

cd([code_directory,'/Experiment_p2p_preference'])

visual_field_size = [21,29]; % size of the visual field, in dva.  (height, width)

load('subject_seeds_table.mat', 'subject_table')
% seeds =subject_table(ismember(subject_table.Name,subject),:).Seeds;
seeds = 2:6;
n_seeds = numel(seeds);

implant_name = 'Argus II';


test = 'prediction';
% Measure preference between random and kss
T = load(data_table_file);
T= T.T;
T = T(13:end,:);

T = T(T.Subject == subject,:);
T = T(T.Task =='preference' & T.Misspecification ==0,:);
% n_seeds = numel(unique(T.Seed));
task = 'preference';
preference_prediction_kss_kssvsrandom = zeros(1,n_seeds);
preference_prediction_random_kssvsrandom = zeros(1,n_seeds);

for k = 1:n_seeds
    seed = seeds(k);
    Ta=T(T.Seed == seed,:);
    
    acquisition_fun_name = 'kernelselfsparring';
    index = Ta(Ta.Acquisition == acquisition_fun_name,:).Index; 
    filename_1  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
    
    acquisition_fun_name = 'random';
    index = Ta(Ta.Acquisition == acquisition_fun_name,:).Index; 
    filename_2  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
    
    load(filename_1)
    x1 = experiment.x_best(:,end);
    x1_norm = (x1(experiment.ib)- experiment.lb')./(experiment.ub' - experiment.lb');
    
    load(filename_2)    
    x2 = experiment.x_best(:,end);
    x2_norm = (x2(experiment.ib)- experiment.lb')./(experiment.ub' - experiment.lb');

  
    load(filename_1)
    preference_prediction_kss_kssvsrandom(k) =  prediction_bin_preference(experiment.theta, experiment.xtrain_norm, experiment.ctrain, [x1_norm;x2_norm], experiment.kernelfun, experiment.kernelname, 'modeltype', experiment.modeltype);
    load(filename_2)
    preference_prediction_random_kssvsrandom(k) =  prediction_bin_preference(experiment.theta, experiment.xtrain_norm, experiment.ctrain, [x1_norm;x2_norm], experiment.kernelfun, experiment.kernelname, 'modeltype', experiment.modeltype);

end
save([data_directory, '/prediction_kss_vs_random_',subject,'.mat'],'preference_prediction_kss_kssvsrandom','preference_prediction_random_kssvsrandom'); 


% Measure preference between random and DTS
% T = load(data_table_file);
% T= T.T;
% T = T(T.Subject == subject,:);
% T =T(end-9:end,:);
% T = T(T.Task =='preference' & T.Misspecification ==0,:);
% n_seeds = numel(unique(T.Seed));
% task = 'preference';
% prediction_DTS_vs_random = zeros(1,n_seeds);
% p2p_version = 'latest';
% 
% for k = 1:n_seeds
%     seed = seeds(k);
%     Ta=T(T.Seed == seed,:);
%     
%     acquisition_fun_name = 'DTS';
%     index = Ta(Ta.Acquisition == acquisition_fun_name,:).Index; 
%     filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
%     load(filename)
%  
%     
%     acquisition_fun_name = 'random';
%     index = Ta(Ta.Acquisition == acquisition_fun_name,:).Index; 
%     filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
%     load(filename)
%  
%     
%  
%     DTS_vs_random = preference_measure.pref; % Preference of the DTS encoders compared to the random.
%     prediction_DTS_vs_random(k) = DTS_vs_random;
%     save([data_directory, '/prediction_DTS_vs_random_',subject, '_', num2str(seed),'.mat'],'DTS_vs_random')
% end
% save([data_directory, '/prediction_DTS_vs_random_',subject,'.mat'],'prediction_DTS_vs_random')


% 
% T = load(data_table_file);
% T= T.T;
% T = T(13:end,:);
% 
% T = T(T.Subject == subject,:);
% T = T((T.Acquisition == 'kernelselfsparring' & T.Misspecification ==0) | (T.Acquisition == 'TS_binary' & T.Task == 'E'),:);
% 
% preference_prediction_kss_kssvs = zeros(1,n_seeds);
% preference_prediction_E_kssvs = zeros(1,n_seeds);
% 
% for k = 1:n_seeds
%     seed = seeds(k);
%     Ta=T(T.Seed == seed,:);
% 
%     task = 'preference';
%     index = Ta(Ta.Task == task,:).Index; 
%     filename_1  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', 'kernelselfsparring', '_experiment_',num2str(index)];
%     load(filename_1)
%       x1 = experiment.x_best(:,end);
%     x1_norm = (x1(experiment.ib)- experiment.lb')./(experiment.ub' - experiment.lb');
% 
%     task = 'E';
%     index = Ta(Ta.Task == task,:).Index; 
%     filename_2  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_','TS_binary', '_experiment_',num2str(index)];
%     load(filename_2)
%     x2 = experiment.x_best(:,end);
%     x2_norm = (x2(experiment.ib)- experiment.lb')./(experiment.ub' - experiment.lb');
% 
%     load(filename_1)
%     preference_prediction_kss_kssvsE(k) =  prediction_bin_preference(experiment.theta, experiment.xtrain_norm, experiment.ctrain, [x1_norm;x2_norm], experiment.kernelfun, experiment.kernelname, 'modeltype', experiment.modeltype);
%     load(filename_2)
%     preference_prediction_E_kssvsE(k) =  prediction_bin_preference(experiment.theta, experiment.xtrain_norm, experiment.ctrain, [x1_norm;x2_norm], experiment.kernelfun, experiment.kernelname, 'modeltype', experiment.modeltype);
% 
% 
% end
% save([data_directory,'/prediction_kss_vs_E_',subject, '.mat'],'prediction_kss_vs_E')
% 
%% Measure preference between kss and optimal
T = load(data_table_file);
T= T.T;
T = T(13:end,:);

T = T(T.Subject == subject,:);
T= T(T.Misspecification == 0 & T.Acquisition == 'kernelselfsparring',:);
prediction_optimal_vs_kss= zeros(1,n_seeds);

for k = 1:n_seeds
    seed = seeds(k);
    Ta=T(T.Seed == seed,:);
    for j = 1:size(Ta,1)
        task = cellstr(Ta(j,:).Task);
        task = task{1};
        acquisition_fun_name = cellstr(Ta(j,:).Acquisition);
        acquisition_fun_name = acquisition_fun_name{1};
        index = Ta(j,:).Index;
        
        filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
        load(filename)
        
        x1 = experiment.model_params(experiment.ib);
        x1_norm = (x1(experiment.ib)- experiment.lb')./(experiment.ub' - experiment.lb');
        
        x2 = experiment.x_best(:,end);
        x2_norm = (x2(experiment.ib)- experiment.lb')./(experiment.ub' - experiment.lb');
        
        prediction_optimal_vs_kss(k) = prediction_bin_preference(experiment.theta, experiment.xtrain_norm, experiment.ctrain, [x1_norm;x2_norm], experiment.kernelfun, experiment.kernelname, 'modeltype', experiment.modeltype);
        
    end
end
save([data_directory,'/prediction_optimal_vs_kss_',subject,'.mat'],'prediction_optimal_vs_kss')



graphics_style_paper;


% 
% T = load(data_table_file);
% T= T.T;
% T = T(13:end,:);
% 
% T = T(T.Subject == subject,:);
% T = T((T.Acquisition == 'kernelselfsparring' & T.Misspecification ==0) | T.Acquisition == 'pBOTS' ,:);
% 
% prediction_kss_vs_pBO = zeros(1,n_seeds);
% 
% for k = 1:n_seeds
%     seed = seeds(k);
%     Ta=T(T.Seed == seed,:);
% 
%     task = 'preference';
%     index = Ta(Ta.Acquisition == 'kernelselfsparring',:).Index; 
%     filename_1  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', 'kernelselfsparring', '_experiment_',num2str(index)];
%     load(filename_1)
%      x1 = experiment.x_best(:,end);
%     x1_norm = (x1(experiment.ib)- experiment.lb')./(experiment.ub' - experiment.lb');
% 
%     
%     index = Ta(Ta.Acquisition  == 'pBOTS',:).Index; 
%     filename_2  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_','pBOTS', '_experiment_',num2str(index)];
%     load(filename_2)
%      x2 = experiment.x_best(:,end);
%     x2_norm = (x2(experiment.ib)- experiment.lb')./(experiment.ub' - experiment.lb');
% 
% 
%  
%     load(filename_1)
%     preference_prediction_kss_kssvsrandom(k) =  prediction_bin_preference(experiment.theta, experiment.xtrain_norm, experiment.ctrain, [x1_norm;x2_norm], experiment.kernelfun, experiment.kernelname, 'modeltype', experiment.modeltype);
%     load(filename_2)
%     preference_prediction_random_kssvsrandom(k) =  prediction_bin_preference(experiment.theta, experiment.xtrain_norm, experiment.ctrain, [x1_norm;x2_norm], experiment.kernelfun, experiment.kernelname, 'modeltype', experiment.modeltype);
% 
% 
%     kss_vs_pBO = preference_measure.pref; % Preference of the kss encoders compared to the E.
%     save([data_directory,'/prediction_kss_vs_pBO_',subject, '_',num2str(seed),'.mat'],'kss_vs_pBO')
%     prediction_kss_vs_pBO(k) = kss_vs_pBO; 
% end
% save([data_directory,'/prediction_kss_vs_pBO_',subject, '.mat'],'prediction_kss_vs_pBO')
% 
% y = [mean(prediction_kss_vs_random),mean(prediction_kss_vs_E),mean(prediction_E_TS_vs_E_random),mean(prediction_optimal_vs_kss)];
% X= 0:numel(y)-1;
% fig=figure('units','points','outerposition',[0 0 426/2 2/3*426]);
% fig.Color =  [1 1 1];
% h =bar(X,y,'Facecolor', colo(end,:)); hold on
% xticklabels({'KSS/random', 'Preference/Binary', 'Binary TS/Binary random', 'Optimal/KSS'})
% box off
% 
% figures_folder = [experiment_path,'/Figures'];
% savefig(fig, [figures_folder,'/preferences.fig'])
% exportgraphics(fig, [figures_folder,'/preferences.eps'])
% exportgraphics(fig, [figures_folder,'/preferences.pdf'])
% 


