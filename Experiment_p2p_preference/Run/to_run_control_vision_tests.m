clear all
use_ptb3=1; %Wether to use PTB3 or not
maxiter = 80; %Number of iterations in the BO loop.
subject = 'TF'; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global pathname
% pathname = 'C:\Users\tfauvel\Documents\'; % C:\Users\tfauvel\Documents;
% pathname = '/home/tfauvel/Desktop/';
% pathname = '/media/sf_Documents/';

add_directories;
load('subject_seeds_table.mat', 'subject_table')
implant_name = 'Argus II'; %'PRIMA'
p2p_version = 'latest';

screen_setup;
T = load(data_table_file).T;
T = T(T.Subject == 'TF',:);
T = T(13:end,:);
T = T(T.Acquisition == 'kernelselfsparring' & T.Misspecification == 0,:);
test_task = 'E';

for i = 6:size(T,1)   
    filename = [data_directory, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
    load(filename, 'experiment');
    
    d = experiment.d;
    for j = 1:5
        xparams = experiment.model_params;
        xparams(experiment.ib) = experiment.xtrain(experiment.ib,j);
        W = encoder(xparams, experiment,1,0);
        
        measure = vision_test_QUEST(experiment, W, 'VA', test_task);
        experiment.VA_QUEST_control{2*j-1}= measure;
%         a = threshold_computation_QUEST(filename, 'VA', measure);
%         experiment.E_VA_control(2*j-1)= a;
        
        measure = vision_test_QUEST(experiment, W, 'CS', test_task);
        experiment.CS_QUEST_control{2*j-1}= measure;
%         a = threshold_computation_QUEST(filename, 'CS', measure);
%         experiment.E_CS_control(2*j-1)= a;
%         
        xparams = experiment.model_params;
        xparams(experiment.ib) = experiment.xtrain(d+experiment.ib,j);
        W = encoder(xparams, experiment,1,0);
        
        measure = vision_test_QUEST(experiment, W, 'VA', test_task);
        experiment.VA_QUEST_control{2*j}= measure;
%         a = threshold_computation_QUEST(filename, 'VA', measure);
%         experiment.E_VA_control(2*j)= a;
        
        measure = vision_test_QUEST(experiment, W, 'CS', test_task);
        experiment.CS_QUEST_control{2*j} = measure;
%         a = threshold_computation_QUEST(filename, 'CS', measure);
%         experiment.E_CS_control(2*j)= a;
        
    end
    save(filename, 'experiment')
end



if use_ptb3 ==1
    Screen('CloseAll'); %closes the window
end


for i = 1:size(T,1)   
    filename = [data_directory, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
    load(filename, 'experiment');
    %experiment.display_size
    experiment.viewing_distance
end