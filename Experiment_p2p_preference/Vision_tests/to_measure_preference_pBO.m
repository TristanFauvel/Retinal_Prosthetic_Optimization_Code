clear all


use_ptb3=1; %Wether to use PTB3 or not

cd([code_directory,'/Experiment_p2p_preference'])

load('subject_seeds_table.mat', 'subject_table')
% seeds =subject_table(ismember(subject_table.Name,subject),:).Seeds;
seeds = 3;
n_seeds = numel(seeds);

implant_name = 'Argus II';

screen_setup;

seed = 4:6;
add_directories

task = 'preference';
subject = 'TF';

T = load(data_table_file);
T= T.T;

for i =1:numel(seed)
    Ta=T(T.Seed == seed & T.Acquisition == 'pBOTS',:);
    index = Ta.Index;
    filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', 'pBOTS', '_experiment_',num2str(index)];
    load(filename)
    W{1} = encoder(experiment.x_best(:,end), experiment, 1);
    W{2} = encoder(x_best_rand(:,end), experiment, 1);

end

% Tr =T(T.Seed == seed & T.Acquisition == 'kernelselfsparring' & T.Misspecification == 0,:);
% index  = Tr.Index(end);
% filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', 'kernelselfsparring', '_experiment_',num2str(index)];
% load(filename)




W{1} = encoder(experiment.x_best(:,end), experiment, 1);
W{2} = encoder(x_best_rand(:,end), experiment, 1);



%%

preference_measure = preference_measurement(experiment, W{1}, W{2});
pBOTS_vs_pBOrand = preference_measure.pref; % Preference of the kss encoders compared to the E.
save([data_directory,'/c_pBOTS_vs_pBOrand_',subject, '_',num2str(seed),'.mat'],'pBOTS_vs_pBOrand')


T = load(data_table_file);
T= T.T;
Tr =T(T.Seed == seed & T.Acquisition == 'random' & T.Task == 'preference',:);
index  = Tr.Index(end);
filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', 'random', '_experiment_',num2str(index)];
load(filename)
W{2} = encoder(experiment.x_best(:,end), experiment, 1);

preference_measure = preference_measurement(experiment, W{1}, W{2});
pBOTS_vs_GPrand = preference_measure.pref; % Preference of the kss encoders compared to the E.
save([data_directory,'/c_pBOTS_vs_GPrand_',subject, '_',num2str(seed),'.mat'],'pBOTS_vs_GPrand')



T = load(data_table_file);
T= T.T;
T = T(T.Subject == subject,:);
T = T((T.Acquisition == 'kernelselfsparring' & T.Misspecification ==0) | T.Acquisition == 'pBOTS' ,:);
Ta=T(T.Seed == seed,:);

task = 'preference';
index = Ta(Ta.Acquisition == 'kernelselfsparring' & Ta.Misspecification == 0,:).Index;
index = index(end);
filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', 'kernelselfsparring', '_experiment_',num2str(index)];
load(filename)
W{1} = encoder(experiment.x_best(:,end), experiment, 1);

index = Ta(Ta.Acquisition  == 'pBOTS',:).Index;
filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_','pBOTS', '_experiment_',num2str(index)];
load(filename)
W{2} = encoder(experiment.x_best(:,end), experiment, 1);

preference_measure = preference_measurement(experiment, W{1}, W{2});
kss_vs_pBO = preference_measure.pref; % Preference of the kss encoders compared to the E.
save([data_directory,'/c_kss_vs_pBO_',subject, '_',num2str(seed),'.mat'],'kss_vs_pBO')
c_kss_vs_pBO= kss_vs_pBO;

