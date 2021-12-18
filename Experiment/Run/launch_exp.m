function launch_exp(acquisition_fun, acquisition_fun_name, task, misspecification, use_ptb3, window, screen, text_size, visual_field_size, viewing_distance, Stimuli_folder, instruct, training, maxiter, subject, model_seed, seed, implant_name, p2p_version)

if instruct && use_ptb3==1
    if strcmp(task, 'E')
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
    elseif strcmp(task, 'preference')
        Screen('TextSize', window, text_size);
        DrawFormattedText(window, preference_instructions,...
            'center', 'center', white);
    end
    screen.vbl = Screen('Flip', window);
    RestrictKeysForKbCheck(KbName('Return'));
    KbWait([], 2)
    screen.vbl = Screen('Flip', window);
    if training
        training_session(task, visual_field_size, viewing_distance, Stimuli_folder);
    end
end
BO_p2p(task,maxiter, subject, acquisition_fun, acquisition_fun_name, model_seed, seed,visual_field_size, viewing_distance, misspecification,implant_name, Stimuli_folder, use_ptb3,p2p_version);




 


 