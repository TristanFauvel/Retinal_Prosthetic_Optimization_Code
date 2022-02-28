 brightness = 100;
 if ispc
     command = ['(Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,',num2str(brightness), ')'];
      system(command);

 else
     try 
         command = ['xbacklight -set ', num2str(brightness)];
           system(command);
     catch
        error("Requires xbacklight to configure screen brightness : sudo apt-get install xbacklight")
     end
 end
visual_field_size = [21,29]; % size of the visual field, in dva.  (height, width)


cd([code_directory,'/Experiment'])
set(0,'units','pixels')
screen_size = get(0,'screensize');
%screen_size = [1, 1, 1920, 1080];
if use_ptb3
    KbName('UnifyKeyNames');

    %Abort script if it isn't executed on Psychtoolbox-3:
    AssertOpenGL;
    %Keyboard setup
    KbName('UnifyKeyNames');
    global window_size
    window_size = [0,0,screen_size(3), screen_size(4)]; %%%%%%%%%%%%%%%%%%%%%%%%%%%[1920, 0, 1920+2560,1440];
    
    screen = expscreen_class(window_size);
    
    commandwindow;
    global window
    window=screen.window;
    color=screen.white*[0 1 0]'; %'parameters_file.mat'
    background_luminance=screen.grey;
    screen.vbl = Screen('Flip', window);
    Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    global white 
    white = WhiteIndex(window);
    Screen('TextSize', window, 30);
        [width, height]=Screen('WindowSize', window,[]);
else
    instruct_preference = 0;
    width = screen_size(3); % Screen width (px)
    height = screen_size(4); % Screen height (px)
    screen = [];
    window = [];
end

global dpcm
dpcm = get(0,'ScreenPixelsPerInch')/2.54; % number of pixels per centimeter
global viewing_distance
viewing_distance = [height, width/2]./(2*tan(0.5*visual_field_size*pi/180));
viewing_distance = min(viewing_distance/dpcm)/100; % Viewing distance, in cm;

instructions;
if use_ptb3 == 0
    screensize = get(0,'screensize');
    width = screen_size(3); % Screen width (px)
    height = screen_size(4); % Screen height (px)
else
    DrawFormattedText(window, start_instructions,...
        'center', screen.screenYpixels * 0.25, white);
    screen.vbl = Screen('Flip', window);
    KbWait([], 2)
    screen.vbl = Screen('Flip', window);
    instruct_preference = 0;
end

text_size= 35;
