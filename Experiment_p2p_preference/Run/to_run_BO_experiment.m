
clear all
rng('default')
cd('/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Retinal_Prosthetic_Optimization_Code') 
% cd('/media/sf_Documents/Retinal_Prosthetic_Optimization/Retinal_Prosthetic_Optimization_Code') %/Experiment_p2p_preference/Run')
use_ptb3=1; %Wether to use PTB3 or not 
p2p_version = 'latest';

maxiter = 60; %Number of iterations in the BO loop. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subject = 'test';

add_modules;
beep off
load('subject_seeds_table.mat', 'subject_table')
model_seeds = subject_table(ismember(subject_table.Name,subject),:).Seeds;
model_seeds = 13;
seeds = 13;
%% 

if model_seeds== 6 || model_seeds== 7
    error('Do not use 6 or 7 as the model seed, as it was used to compute the hyperparameters')
end
implant_name = 'Argus II'; %'PRIMA'

screen_setup;

instruct_preference = 1;
instruct_E = 1;
instruct_Snellen = 1;

training_preference = 1;
training_E = 1;
training_Snellen = 1;

nexp =4; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for model_seed = model_seeds
    for seed = seeds       
        rng(seed)
        experiments_order  = randperm(nexp);
        for k=1:nexp %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if experiments_order(k) ==1
                acquisition_fun = @maxvar_challenge;
                acquisition_fun_name = 'maxvar_challenge';
                task = 'preference';
                misspecification = 0;
                if instruct_preference
                    %                     DrawFormattedText(window, preference_instructions,...
                    %                         'center', screen.screenYpixels * 0.25, white);
                    Screen('TextSize', window, text_size);
                    DrawFormattedText(window, preference_instructions,...
                        'center', 'center', white);
                    screen.vbl = Screen('Flip', window);
                    RestrictKeysForKbCheck(KbName('Return'));
                    KbWait([], 2)
                    screen.vbl = Screen('Flip', window);
                    % instruct_preference = 0;
                    if training_preference
                        training_session(task, visual_field_size, viewing_distance, Stimuli_folder);
                        training_preference = 0;
                    end
                end
                
                BO_p2p(task,maxiter, subject, acquisition_fun, acquisition_fun_name, model_seed, seed, visual_field_size, viewing_distance, misspecification,implant_name, Stimuli_folder, use_ptb3,p2p_version);
            elseif experiments_order(k) ==2
                acquisition_fun = @random_acquisition_pref;
                acquisition_fun_name = 'random';
                task = 'preference';
                misspecification = 0;
                if instruct_preference
                    %                     DrawFormattedText(window, preference_instructions,...
                    %                         'center', screen.screenYpixels * 0.25, white);
                    Screen('TextSize', window, text_size);
                    DrawFormattedText(window, preference_instructions,...
                        'center', 'center', white);
                    screen.vbl = Screen('Flip', window);
                    RestrictKeysForKbCheck(KbName('Return'));
                    KbWait([], 2)
                    screen.vbl = Screen('Flip', window);
                    % instruct_preference = 0;
                    if training_preference
                        training_session(task, visual_field_size, viewing_distance, Stimuli_folder);
                        training_preference = 0;
                    end
                end
                
                BO_p2p(task,maxiter, subject, acquisition_fun, acquisition_fun_name, model_seed, seed,visual_field_size, viewing_distance, misspecification,implant_name, Stimuli_folder, use_ptb3,p2p_version);
            elseif experiments_order(k) ==3
                acquisition_fun = @maxvar_challenge;
                acquisition_fun_name = 'maxvar_challenge';
                task = 'preference';
                misspecification = 1;
                if instruct_preference
                    Screen('TextSize', window, text_size);
                    DrawFormattedText(window, preference_instructions,...
                        'center', 'center', white);
                    %                     DrawFormattedText(window, preference_instructions,...
                    %                         'center', screen.screenYpixels * 0.25, white);
                    screen.vbl = Screen('Flip', window);
                    RestrictKeysForKbCheck(KbName('Return'));
                    KbWait([], 2)
                    screen.vbl = Screen('Flip', window);
                    %  instruct_preference = 0;
                    if training_preference
                        training_session(task, visual_field_size, viewing_distance, Stimuli_folder);
                        training_preference = 0;
                    end
                    
                end
                
                
                BO_p2p(task,maxiter, subject, acquisition_fun, acquisition_fun_name, model_seed, seed, visual_field_size, viewing_distance, misspecification,implant_name, Stimuli_folder, use_ptb3,p2p_version);
            elseif experiments_order(k) == 4
                task = 'E';
                if instruct_E
                    
                    E_display_size = 2*viewing_distance*tan(0.5*visual_field_size*pi/180); % Size of the image on screen (in m)
                    E_display_size = 0.3*100*E_display_size*dpcm; %206.3960  288.0000
                    [width, height]=Screen('WindowSize',window) ;%1920         975
                    m = floor((width-E_display_size(2))/2);
                    M = floor((height-E_display_size(1))/2);
                    %                     DrawFormattedText(window, E_instructions_v1,...
                    %                         'center', screen.screenYpixels * 0.25, white);
                    Screen('TextSize', window, text_size);
                    DrawFormattedText(window, E_instructions_v1,...
                        'center', [], white);
                    I = imread([code_directory, '/Experiment_p2p_preference/Run/instructions.png']);
                    imageTexture = Screen('MakeTexture', window, I);
                    image_size = floor(0.3*window_size(4));
                    Position = [m,M,m+E_display_size(2), M+E_display_size(1)];
                    Screen('DrawTexture', window, imageTexture, [],Position, 0);
                    screen.vbl = Screen('Flip', window);
                    RestrictKeysForKbCheck(KbName('Return'));
                    KbWait([], 2)
                    screen.vbl = Screen('Flip', window);
                    %  instruct_E = 0;
                    if training_E
                        training_session(task, visual_field_size, viewing_distance, Stimuli_folder);
                        training_E = 0;
                    end
                end
                acquisition_fun = @TS_binary;
                acquisition_fun_name = 'TS_binary';
                
                misspecification = 0;
                BO_p2p(task,maxiter, subject, acquisition_fun, acquisition_fun_name, model_seed, seed, visual_field_size, viewing_distance, misspecification,implant_name, Stimuli_folder, use_ptb3,p2p_version);
                
            elseif experiments_order(k) ==5
                task = 'E';
                if instruct_E
                    
                    E_display_size = 2*viewing_distance*tan(0.5*visual_field_size*pi/180); % Size of the image on screen (in m)
                    E_display_size = 0.3*100*E_display_size*dpcm;
                    [width, height]=Screen('WindowSize',window) ; %1920         975
                    m = floor((width-E_display_size(2))/2);
                    M = floor((height-E_display_size(1))/2);
                    Screen('TextSize', window, text_size);
                    DrawFormattedText(window, E_instructions_v1,...
                        'center', [], white);
                    I = imread([code_directory, '/Experiment_p2p_preference/Run/instructions.png']);
                    imageTexture = Screen('MakeTexture', window, I);
                    image_size = floor(0.3*window_size(4));
                    Position = [m,M,m+E_display_size(2), M+E_display_size(1)];
                    Screen('DrawTexture', window, imageTexture, [],Position, 0);
                    screen.vbl = Screen('Flip', window);
                    RestrictKeysForKbCheck(KbName('Return'));
                    KbWait([], 2)
                    screen.vbl = Screen('Flip', window);
                    %instruct_E = 0;
                    if training_E
                        training_session(task, visual_field_size, viewing_distance, Stimuli_folder);
                        training_E = 0;
                    end
                    
                end
                acquisition_fun = @random_acquisition_binary;
                acquisition_fun_name = 'random';
                
                misspecification = 0;
                BO_p2p(task,maxiter, subject, acquisition_fun, acquisition_fun_name, model_seed, seed, visual_field_size, viewing_distance, misspecification,implant_name, Stimuli_folder, use_ptb3,p2p_version);
                
            end
        end
    end
end

T = load(data_table_file);
T= T.T;
T = T(T.Subject == subject,:);
nexp = numel(seeds)*numel(model_seeds)*nexp;
T=T(end-nexp+1:end,:);

for k = 1:size(T,1)
    task = cellstr(T(k,:).Task);
    task = task{1};
    acquisition_fun_name = cellstr(T(k,:).Acquisition);
    acquisition_fun_name = acquisition_fun_name{1};
    index = T(k,:).Index;
    filenames{k} = [raw_data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
end

filename1 = filenames{T.Task == 'preference' & T.Acquisition ~= 'random' & T.Misspecification ==0};
filename2 = filenames{T.Task == 'preference' & T.Acquisition == 'random'};
filename3 = filenames{T.Task == 'E' & T.Acquisition ~= 'random'};
filename4 = filenames{T.Task == 'preference' & T.Acquisition ~= 'random' & T.Misspecification ==1};
% 
measure_pref_btw_optimized_encoders(filename1,filename2, 'random')
measure_pref_btw_optimized_encoders(filename1,[], 'optimal')
measure_pref_btw_optimized_encoders(filename1,[], 'control')
% measure_pref_btw_optimized_encoders(filename1,[], 'naive')
measure_pref_btw_optimized_encoders(filename1,filename3, 'E')
measure_pref_btw_optimized_encoders(filename4,filename1, 'misspecified')

nexp = numel(filenames);
rng(1)
experiments_order  = randperm(nexp);
test_task = 'E';
measured_var = {'VA'}; %measured_var = {'VA', 'CS'};

if instruct_E
    
    E_display_size = 2*viewing_distance*tan(0.5*visual_field_size*pi/180); % Size of the image on screen (in m)
    E_display_size = 0.3*100*E_display_size*dpcm;
    
    if use_ptb3
    [width, height]=Screen('WindowSize',window) ; %1920         975
    m = floor((width-E_display_size(2))/2);
    M = floor((height-E_display_size(1))/2);
    Screen('TextSize', window, text_size);
    DrawFormattedText(window, E_instructions_v2,...
        'center', [], white);
    I = imread([code_directory, '/Experiment_p2p_preference/Run/instructions.png']);
    imageTexture = Screen('MakeTexture', window, I);
    image_size = floor(0.3*window_size(4));
    Position = [m,M,m+E_display_size(2), M+E_display_size(1)];
    Screen('DrawTexture', window, imageTexture, [],Position, 0);
    screen.vbl = Screen('Flip', window);
    RestrictKeysForKbCheck(KbName('Return'));
    KbWait([], 2)
    screen.vbl = Screen('Flip', window);
    instruct_E = 0;
    if training_E
        training_session(test_task, visual_field_size, viewing_distance, Stimuli_folder);
        training_E = 0;
    end
    end
end

for k= 1:nexp 
    filename = filenames{experiments_order(k)};
    measure_vision_QUEST(filename, test_task, measured_var, 'short_version', 3)
end

if instruct_Snellen
    if use_ptb3
    Screen('TextSize', window, text_size);
    DrawFormattedText(window, Snellen_instructions,...
        'center', 'center', white);
    screen.vbl = Screen('Flip', window);
    RestrictKeysForKbCheck(KbName('Return'));
    KbWait([], 2)
    
    screen.vbl = Screen('Flip', window);
    instruct_E = 0;
    training_session('Snellen', visual_field_size, viewing_distance,Stimuli_folder);
    end
end

test_task = 'Snellen';
for k=1:nexp 
    filename = filenames{experiments_order(k)};
    measure_vision_QUEST(filename, test_task, measured_var, 'short_version', 1)
end

Screen('TextSize', window, text_size);
DrawFormattedText(window, ['Thank you !'],...
    'center', 'center', white);
screen.vbl = Screen('Flip', window);
RestrictKeysForKbCheck(KbName('Return'));
KbWait([], 2)
screen.vbl = Screen('Flip', window);

% if use_ptb3 ==1
%     Screen('CloseAll'); %closes the window
% end
% !shutdown -h now
