clear all
use_ptb3=1; %Wether to use PTB3 or not
p2p_version = 'latest';

maxiter = 80; %Number of iterations in the BO loop.
subject = 'TF one letter'; %'TF one letter rho lambda theta x y betap betam';
add_directories


cd([code_directory,'/Experiment_p2p_preference'])

sca

load('subject_seeds_table.mat', 'subject_table')
% seeds =subject_table(ismember(subject_table.Name,subject),:).Seeds;
implant_name = 'Argus II';
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
T = T(T.Subject == subject,:);

Ta=T(T.Seed ==7,:);
task = 'preference';

acquisition_fun_name = 'maxvar_challenge';
%     acquisition_fun_name = 'kernelselfsparring';
index = Ta(Ta.Acquisition == acquisition_fun_name & Ta.Task == task,:).Index;
filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
load(filename)
x_best_kss = experiment.x_best;

acquisition_fun_name = 'random';
index = Ta(Ta.Acquisition == acquisition_fun_name & Ta.Task == task,:).Index;
index = 12; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename  = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
load(filename)
x_best_random= experiment.x_best;

preference_measure = NaN(1,maxiter);
for k = 1:maxiter
    k
    x1 = x_best_kss(:,k);
    W{1} = encoder(x1, experiment, 1);
    
   
    x2 = x_best_random(:,k);
    W{2} = encoder(x2, experiment, 1);
    
    measure = preference_measurement(experiment, W{1}, W{2}, 'training', 1);
    preference_measure(k) =  measure.c;
%     
%     kss_vs_random = preference_measure.pref; % Preference of the kss encoders compared to the random.
%     training_kss_vs_random(k) = kss_vs_random;
%     close all
%     save([data_directory, '/training_kss_vs_random_',subject, '_', num2str(seed),'.mat'],'kss_vs_random')
end
disp('stop')
% save([data_directory, '/training_kss_vs_random_',subject,'.mat'],'training_kss_vs_random')

figure()
scatter(1:k, preference_measure(1:k))