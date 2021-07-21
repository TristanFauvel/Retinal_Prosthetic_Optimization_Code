clear all
use_ptb3=1; %Wether to use PTB3 or not
subject = 'TF one letter Matern52'; %'TF one letter'; 
% subject = 'TF one letter'; 

add_directories

p2p_version = 'latest';
cd([code_directory,'/Experiment_p2p_preference'])

load('subject_seeds_table.mat', 'subject_table')

implant_name = 'Argus II';

screen_setup;
% Measure preference between random and kss
T = load(data_table_file);
T= T.T;
T = T(T.Subject == subject,:);
T = T(end-1:end,:)
% T = T(13:end,:);
%T = T(7:end,:);

Tp = T(T.Task =='preference' & T.Misspecification ==0,:);
seeds = unique(T.Seed);
n_seeds = numel(seeds);
task = 'preference';
c_kss_vs_random = zeros(1,n_seeds);

type = {'test', 'training'};
for j =1:numel(type)
    for k = 1:n_seeds
        seed = seeds(k);
        Ta=Tp(Tp.Seed == seed,:);
        
        acquisition_fun_name = 'kernelselfsparring';
        index = Ta(Ta.Acquisition == acquisition_fun_name,:).Index;
        index = index(1);
        filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
        load(filename)
        W{1} = encoder(experiment.x_best(:,end), experiment, 1);
        
        acquisition_fun_name = 'random';
        index = Ta(Ta.Acquisition == acquisition_fun_name,:).Index;
        index = index(1);
        filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
        load(filename)
        W{2} = encoder(experiment.x_best(:,end), experiment, 1);
        
        preference_measure = preference_measurement(experiment, W{1}, W{2}, type{j});
        kss_vs_random = preference_measure.pref; % Preference of the kss encoders compared to the random.
        c_kss_vs_random(k) = kss_vs_random;
        save([data_directory, '/c_kss_vs_random_',type{j}, '_',subject, '_', num2str(seed),'.mat'],'kss_vs_random')
    end
    save([data_directory, '/c_kss_vs_random_',type{j}, '_', subject,'.mat'],'c_kss_vs_random')
end


% Measure preference between random and DTS
n_seeds = numel(unique(Tp.Seed));
task = 'preference';
c_DTS_vs_random = zeros(1,n_seeds);
p2p_version = 'latest';

for k = 1:n_seeds
    seed = seeds(k);
    Ta=Tp(Tp.Seed == seed,:);
    
    acquisition_fun_name = 'DTS';
    index = Ta(Ta.Acquisition == acquisition_fun_name,:).Index; 
    filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
    load(filename)
    W{1} = encoder(experiment.x_best(:,end), experiment, 1);
    
    acquisition_fun_name = 'random';
    index = Ta(Ta.Acquisition == acquisition_fun_name,:).Index; 
    filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
    load(filename)
    W{2} = encoder(experiment.x_best(:,end), experiment, 1);
    
    preference_measure = preference_measurement(experiment, W{1}, W{2});
    DTS_vs_random = preference_measure.pref; % Preference of the DTS encoders compared to the random.
    c_DTS_vs_random(k) = DTS_vs_random;
    save([data_directory, '/c_DTS_vs_random_',subject, '_', num2str(seed),'.mat'],'DTS_vs_random')
end
save([data_directory, '/c_DTS_vs_random_',subject,'.mat'],'c_DTS_vs_random')


Tp = T((T.Acquisition == 'kernelselfsparring' & T.Misspecification ==0) | (T.Acquisition == 'TS_binary' & T.Task == 'E'),:);

c_kss_vs_E = zeros(1,n_seeds);

for k = 1:n_seeds
    seed = seeds(k);
    Ta=Tp(Tp.Seed == seed,:);

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

    preference_measure = preference_measurement(experiment, W{1}, W{2});
    kss_vs_E = preference_measure.pref; % Preference of the kss encoders compared to the E.
    save([data_directory,'/c_kss_vs_E_',subject, '_',num2str(seed),'.mat'],'kss_vs_E')
    c_kss_vs_E(k) = kss_vs_E; 
end
save([data_directory,'/c_kss_vs_E_',subject, '.mat'],'c_kss_vs_E')

%% Measure preference between kss and optimal
Tp= T(T.Misspecification == 0 & T.Acquisition == 'kernelselfsparring',:);
c_optimal_vs_kss= zeros(1,n_seeds);

for k = 1:n_seeds
    seed = seeds(k);
    Ta=Tp(Tp.Seed == seed,:);
    for j = 1:size(Ta,1)
        task = cellstr(Ta(j,:).Task);
        task = task{1};
        acquisition_fun_name = cellstr(Ta(j,:).Acquisition);
        acquisition_fun_name = acquisition_fun_name{1};
        index = Ta(j,:).Index;
        
        filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
        load(filename)
        
        W{1} =encoder(experiment.model_params, experiment, 1);
        W{2} = encoder(experiment.x_best(:,end), experiment, 1);
        
        preference_measure = preference_measurement(experiment, W{1}, W{2});
    end
    optimal_vs_kss = preference_measure.pref;
    c_optimal_vs_kss(k) = optimal_vs_kss; % Preference of the optimal encoders compared to the kss.
    save([data_directory,'/c_optimal_vs_kss_',subject, '_',num2str(seed),'.mat'],'optimal_vs_kss')
end
save([data_directory,'/c_optimal_vs_kss_',subject,'.mat'],'c_optimal_vs_kss')

%% Measure preference between E_TS and E_random
Tp= T(T.Task == 'E',:);
c_E_TS_vs_E_random = zeros(1,n_seeds);
task = 'E';
 
for k = 1:n_seeds   
    seed= seeds(k);
    Ta=Tp(Tp.Seed == seed,:);
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
    preference_measure = preference_measurement(experiment, W{1}, W{2});
    E_TS_vs_E_random = preference_measure.pref;
    save([data_directory,'/c_E_TS_vs_E_random_',subject,'_',num2str(seed),'.mat'],'E_TS_vs_E_random')

    c_E_TS_vs_E_random(k) =E_TS_vs_E_random;  % Preference of the TS encoders compared to the E.
end
save([data_directory,'/c_E_TS_vs_E_random_',subject,'.mat'],'c_E_TS_vs_E_random')


Tp = T((T.Acquisition == 'kernelselfsparring' & T.Misspecification ==0) | (T.Acquisition == 'TS_binary' & T.Task == 'E'),:);

c_kss_vs_E = zeros(1,n_seeds);

for k = 1:n_seeds
    seed = seeds(k);
    Ta=Tp(Tp.Seed == seed,:);

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

    preference_measure = preference_measurement(experiment, W{1}, W{2});
    kss_vs_E = preference_measure.pref; % Preference of the kss encoders compared to the E.
    save([data_directory,'/c_kss_vs_E_',subject, '_',num2str(seed),'.mat'],'kss_vs_E')
    c_kss_vs_E(k) = kss_vs_E; 
end
save([data_directory,'/c_kss_vs_E_',subject, '.mat'],'c_kss_vs_E')


if use_ptb3 ==1
    Screen('CloseAll'); %closes the window
end

graphics_style_paper;