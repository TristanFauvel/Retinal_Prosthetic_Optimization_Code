%% To add iterations to a previous experiment

clear all
add_directories

T = load(data_table_file);
T= T.T;

maxiter = 100; %Number of iterations in the BO loop.
subject = 'TF';

T = T(T.Subject == subject,:);

for k = 1:size(T,1)
    task = cellstr(T(k,:).Task);
    task = task{1};
    acquisition_fun_name = cellstr(T(k,:).Acquisition);
    acquisition_fun_name = acquisition_fun_name{1};
    index = T(k,:).Index;
    filenames{k} = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
end


use_ptb3=1; %Wether to use PTB3 or not

cd([code_directory,'/Experiment_p2p_preference'])

visual_field_size = [21,29]; % size of the visual field, in dva.  (height, width)

instructions;

KbName('UnifyKeyNames');

% try
if use_ptb3
    % Abort script if it isn't executed on Psychtoolbox-3:
    AssertOpenGL;
    %Keyboard setup
    KbName('UnifyKeyNames');
    
    set(0,'units','pixels')  
    screen_size = get(0,'screensize');
    window_size = [0,0,screen_size(3), screen_size(4)];%[1920, 0, 1920+2560,1440];
    screen = expscreen_class(window_size);
    
    commandwindow;
    global window
    window=screen.window;
    color=screen.white*[0 1 0]'; %'parameters_file.mat'
    background_luminance=screen.grey;
    screen.vbl = Screen('Flip', window);
    Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    white = WhiteIndex(window);
    Screen('TextSize', window, 30);
    DrawFormattedText(window, [instructions_l1 instructions_l2],...
        'center', screen.screenYpixels * 0.25, white);
    screen.vbl = Screen('Flip', window);
    KbWait([], 2)
    screen.vbl = Screen('Flip', window);
end

for i =16:numel(filenames)
    filename = filenames{i};
    load(filename, 'experiment');
    
    acquisition_fun = experiment.acquisition_fun;
    acquisition_fun_name = experiment.acquisition_fun_name;
    task = experiment.task;
    misspecification = experiment.misspecification;
    
%     continue_BO_p2p(experiment, maxiter);
%     measure_sight_restoration(filename, 'E')
end

if use_ptb3 ==1
    Screen('CloseAll'); %closes the window
end

for i = 1:numel(filenames)
    filename = filenames{i};
    compute_sight_restoration(filename)
end

