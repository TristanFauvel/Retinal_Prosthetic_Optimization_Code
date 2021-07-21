clear all
use_ptb3=1; %Wether to use PTB3 or not
maxiter = 80; %Number of iterations in the BO loop.
subject = 'TF';
add_directories


cd([code_directory,'/Experiment_p2p_preference'])


load('subject_seeds_table.mat', 'subject_table')
% seeds =subject_table(ismember(subject_table.Name,subject),:).Seeds;
seeds = 7:8; %2:6;
n_seeds = numel(seeds);

implant_name = 'Argus II';
test = 'training';
screen_setup;

% Measure preference between random and kss
% T = load(data_table_file);
% T= T.T;
% % T = T(13:end,:);
% 
% T = T(T.Subject == subject,:);
% T = T(T.Task =='preference' & T.Misspecification ==0,:);
% n_seeds = numel(unique(T.Seed));
nexp = 8;
T = load(data_table_file);
T= T.T;
T=T(end-nexp+1:end,:);

T = T(T.Subject == subject,:);

task = 'preference';
training_kss_vs_random = zeros(1,n_seeds);

for k = 1:n_seeds
    seed = seeds(k);
    Ta=T(T.Seed == seed,:);
    
    acquisition_fun_name = 'kernelselfsparring';
    index = Ta(Ta.Acquisition == acquisition_fun_name & Ta.Task == task,:).Index; 
    filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
    load(filename)
    x1 = experiment.x_best(:,end);
    W{1} = encoder(x1, experiment, 1);
    
    acquisition_fun_name = 'random';
    index = Ta(Ta.Acquisition == acquisition_fun_name & Ta.Task == task,:).Index; 
    filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
    load(filename)
    x2 = experiment.x_best(:,end);

    W{2} = encoder(x2, experiment, 1);
    
    preference_measure = preference_measurement(experiment, W{1}, W{2}, test);
    
    kss_vs_random = preference_measure.pref; % Preference of the kss encoders compared to the random.
    training_kss_vs_random(k) = kss_vs_random;
    close all
    save([data_directory, '/training_kss_vs_random_',subject, '_', num2str(seed),'.mat'],'kss_vs_random')
end

save([data_directory, '/training_kss_vs_random_',subject,'.mat'],'training_kss_vs_random')

% 
% % Measure preference between random and DTS
% % T = load(data_table_file);
% % T= T.T;
% % T = T(T.Subject == subject,:);
% % T =T(end-9:end,:);
% % T = T(T.Task =='preference' & T.Misspecification ==0,:);
% % n_seeds = numel(unique(T.Seed));
% % task = 'preference';
% % training_DTS_vs_random = zeros(1,n_seeds);
% % p2p_version = 'latest';
% % 
% % for k = 1:n_seeds
% %     seed = seeds(k);
% %     Ta=T(T.Seed == seed,:);
% %     
% %     acquisition_fun_name = 'DTS';
% %     index = Ta(Ta.Acquisition == acquisition_fun_name,:).Index; 
% %     filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
% %     load(filename)
% %     W{1} = encoder(experiment.x_best(:,end), experiment, 1);
% %     
% %     acquisition_fun_name = 'random';
% %     index = Ta(Ta.Acquisition == acquisition_fun_name,:).Index; 
% %     filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
% %     load(filename)
% %     W{2} = encoder(experiment.x_best(:,end), experiment, 1);
% %     
% %     preference_measure = preference_measurement(experiment, W{1}, W{2}, test);
% %     DTS_vs_random = preference_measure.pref; % Preference of the DTS encoders compared to the random.
% %     training_DTS_vs_random(k) = DTS_vs_random;
% %     save([data_directory, '/training_DTS_vs_random_',subject, '_', num2str(seed),'.mat'],'DTS_vs_random')
% % end
% % save([data_directory, '/training_DTS_vs_random_',subject,'.mat'],'training_DTS_vs_random')
% 
% 
% 
T = load(data_table_file);
T= T.T;
T=T(end-nexp+1:end,:);

T = T(T.Subject == subject,:);
T = T((T.Acquisition == 'kernelselfsparring' & T.Misspecification ==0) | (T.Acquisition == 'TS_binary' & T.Task == 'E'),:);

training_kss_vs_E = zeros(1,n_seeds);

for k = 1:n_seeds
    seed = seeds(k);
    Ta=T(T.Seed == seed,:);

    task = 'preference';
    index = Ta(Ta.Task == task,:).Index; 
    filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', 'kernelselfsparring', '_experiment_',num2str(index)];
    load(filename)
    W{1} = encoder(experiment.x_best(:,end), experiment, 1);
    
    task = 'E';
    index = Ta(Ta.Task == task,:).Index; 
    filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_','TS_binary', '_experiment_',num2str(index)];
    load(filename)
    W{2} = encoder(experiment.x_best(:,end), experiment, 1);

    preference_measure = preference_measurement(experiment, W{1}, W{2}, test);
    kss_vs_E = preference_measure.pref; % Preference of the kss encoders compared to the E.
    save([data_directory,'/training_kss_vs_E_',subject, '_',num2str(seed),'.mat'],'kss_vs_E')
    training_kss_vs_E(k) = kss_vs_E; 
end
save([data_directory,'/training_kss_vs_E_',subject, '.mat'],'training_kss_vs_E')

%% Measure preference between kss and optimal
T = load(data_table_file);
T= T.T;
T=T(end-nexp+1:end,:);

T = T(T.Subject == subject,:);
T= T(T.Misspecification == 0 & T.Acquisition == 'kernelselfsparring',:);
training_optimal_vs_kss= zeros(1,n_seeds);

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
        
        W{1} =encoder(experiment.model_params, experiment, 1,1);
        W{2} = encoder(experiment.x_best(:,end), experiment, 1);
        
        preference_measure = preference_measurement(experiment, W{1}, W{2}, test);
    end
    optimal_vs_kss = preference_measure.pref;
    training_optimal_vs_kss(k) = optimal_vs_kss; % Preference of the optimal encoders compared to the kss.
    save([data_directory,'/training_optimal_vs_kss_',subject, '_',num2str(seed),'.mat'],'optimal_vs_kss')
end
save([data_directory,'/training_optimal_vs_kss_',subject,'.mat'],'training_optimal_vs_kss')

%% Measure preference between E_TS and E_random
nexp = 8;
T = load(data_table_file);
T= T.T;
T=T(end-nexp+1:end,:);

T = T(T.Subject == subject,:);
T= T(T.Task == 'E',:);
training_E_TS_vs_E_random = zeros(1,n_seeds);
task = 'E';
 
for k = 1:n_seeds   
    seed= seeds(k);
    Ta=T(T.Seed == seed,:);
    j=0;
    for i = 1:2
        j=j+1;
        index = Ta(j,:).Index;
        acquisition_fun_name = Ta(j,:).Acquisition;
        if acquisition_fun_name == 'TS_binary'
            filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', 'TS_binary', '_experiment_',num2str(index)];
            load(filename)
            W{1} = encoder(experiment.x_best(:,end), experiment, 1);
        elseif acquisition_fun_name == 'random'
            task = 'E';
            filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', 'random', '_experiment_',num2str(index)];
            load(filename)
            W{2} = encoder(experiment.x_best(:,end), experiment, 1);
        end
    end            
    preference_measure = preference_measurement(experiment, W{1}, W{2}, test);
    E_TS_vs_E_random = preference_measure.pref;
    save([data_directory,'/training_E_TS_vs_E_random_',subject,'_',num2str(seed),'.mat'],'E_TS_vs_E_random')

    training_E_TS_vs_E_random(k) =E_TS_vs_E_random;  % Preference of the TS encoders compared to the E.
end
save([data_directory,'/training_E_TS_vs_E_random_',subject,'.mat'],'training_E_TS_vs_E_random')


T = load(data_table_file);
T= T.T;
T=T(end-nexp+1:end,:);

T = T(T.Subject == subject,:);
T = T((T.Acquisition == 'kernelselfsparring' & T.Misspecification ==0) | (T.Acquisition == 'TS_binary' & T.Task == 'E'),:);

training_kss_vs_E = zeros(1,n_seeds);

for k = 1:n_seeds
    seed = seeds(k);
    Ta=T(T.Seed == seed,:);

    task = 'preference';
    index = Ta(Ta.Task == task,:).Index; 
    filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', 'kernelselfsparring', '_experiment_',num2str(index)];
    load(filename)
    W{1} = encoder(experiment.x_best(:,end), experiment, 1);
    
    task = 'E';
    index = Ta(Ta.Task == task,:).Index; 
    filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_','TS_binary', '_experiment_',num2str(index)];
    load(filename)
    W{2} = encoder(experiment.x_best(:,end), experiment, 1);

    preference_measure = preference_measurement(experiment, W{1}, W{2}, test);
    kss_vs_E = preference_measure.pref; % Preference of the kss encoders compared to the E.
    save([data_directory,'/training_kss_vs_E_',subject, '_',num2str(seed),'.mat'],'kss_vs_E')
    training_kss_vs_E(k) = kss_vs_E; 
end
save([data_directory,'/training_kss_vs_E_',subject, '.mat'],'training_kss_vs_E')


if use_ptb3 ==1
    Screen('CloseAll'); %closes the window
end

graphics_style_paper;



% T = load(data_table_file);
% T= T.T;
% T=T(end-nexp+1:end,:);
% 
% T = T(T.Subject == subject,:);
% T = T((T.Acquisition == 'kernelselfsparring' & T.Misspecification ==0) | T.Acquisition == 'pBOTS' ,:);
% 
% training_kss_vs_pBO = zeros(1,n_seeds);
% 
% for k = 1:n_seeds
%     seed = seeds(k);
%     Ta=T(T.Seed == seed,:);
% 
%     task = 'preference';
%     index = Ta(Ta.Acquisition == 'kernelselfsparring',:).Index; 
%     filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', 'kernelselfsparring', '_experiment_',num2str(index)];
%     load(filename)
%     W{1} = encoder(experiment.x_best(:,end), experiment, 1);
%     
%     index = Ta(Ta.Acquisition  == 'pBOTS',:).Index; 
%     filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_','pBOTS', '_experiment_',num2str(index)];
%     load(filename)
%     W{2} = encoder(experiment.x_best(:,end), experiment, 1);
% 
%     preference_measure = preference_measurement(experiment, W{1}, W{2}, test);
%     kss_vs_pBO = preference_measure.pref; % Preference of the kss encoders compared to the E.
%     save([data_directory,'/training_kss_vs_pBO_',subject, '_',num2str(seed),'.mat'],'kss_vs_pBO')
%     training_kss_vs_pBO(k) = kss_vs_pBO; 
% end
% save([data_directory,'/training_kss_vs_pBO_',subject, '.mat'],'training_kss_vs_pBO')
% 
% y = [mean(training_kss_vs_random),mean(training_kss_vs_E),mean(training_E_TS_vs_E_random),mean(training_optimal_vs_kss)];
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


