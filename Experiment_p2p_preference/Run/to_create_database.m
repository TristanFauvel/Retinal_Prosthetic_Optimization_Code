
clear all
rng('default')
use_ptb3=1; %Wether to use PTB3 or not
p2p_version = 'latest';

maxiter = 400; %Number of iterations in the BO loop.
subject = 'TF_database';

add_modules_VM;

load('subject_seeds_table.mat', 'subject_table')
model_seeds = subject_table(ismember(subject_table.Name,subject),:).Seeds;
model_seeds = 99;
seeds = 99;

implant_name = 'Argus II'; %'PRIMA'


screen_setup;

instruct_preference = 1;
instruct_E = 1;
instruct_Snellen = 1;

training_preference = 1;
training_E = 1;
training_Snellen = 1;
%
nexp = 2;
%
for model_seed = model_seeds
    for seed = seeds
        rng(seed)
        experiments_order  = randperm(nexp);
        for k=1:nexp
            if experiments_order(k) ==0
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
            elseif experiments_order(k) == 1
                task = 'E';
                if instruct_E
                    
                    E_display_size = 2*viewing_distance*tan(0.5*visual_field_size*pi/180); % Size of the image on screen (in m)
                    E_display_size = 0.3*100*E_display_size*dpcm; %206.3960  288.0000
                    [width, height]=Screen('WindowSize',window) ;%1920         975
                    m = floor((width-E_display_size(2))/2);
                    M = floor((height-E_display_size(1))/2);
                    %                     DrawFormattedText(window, E_instructions,...
                    %                         'center', screen.screenYpixels * 0.25, white);
                    Screen('TextSize', window, text_size);
                    DrawFormattedText(window, E_instructions,...
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
                acquisition_fun = @random_acquisition_binary;
                acquisition_fun_name = 'random';
                
                misspecification = 0;
                BO_p2p(task,maxiter, subject, acquisition_fun, acquisition_fun_name, model_seed, seed, visual_field_size, viewing_distance, misspecification,implant_name, Stimuli_folder, use_ptb3,p2p_version);
            end
        end
    end
end

if use_ptb3 ==1
    Screen('CloseAll'); %closes the window
end

