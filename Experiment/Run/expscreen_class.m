classdef expscreen_class
    %This class contains all the screen properties
    
    properties
        white %value of a white pixel
        black %value of a white pixel
        grey %value of a white pixel
        screenXpixels %number of pixels along the X axis
        screenYpixels %number of pixels along the Y axis
        ifi %interframe interval
        waitframes
        x % X coordinates
        y % Y coordinates
        xCenter % X coordinate of the screen center
        yCenter % Y coordinate of the screen center
        vbl % vertical retrace (or vertical blank)
        lineWidthPix % line width of the fixation cross, in pixels.
        allCoords % coordinates of all the pixels
        window %window object
        n_frames % number of frames corresponding to the trial duration
    end
    methods
        function expscreen = expscreen_class(window_size)
            %screen_settings This function retrieves all the screen settings
            
            sca;
            close all;
                                 
            % Skip sync tests for demo purposes only
            PsychDefaultSetup(2);
            Screen('Preference', 'SkipSyncTests', 0); %0
            %Screen('Preference', 'SkipSyncTests', 1) %%%%%%%%%%%%%%%%%%BE CAREFUL, THIS SHOULD BE MODIFIED  Screen('Preference', 'SkipSyncTests', 0)
            
            % % Here we call some default settings for setting up Psychtoolbox
            
            % Get the screen numbers
            screens = Screen('Screens');
            
            % Draw to the external screen if avaliable
            screenNumber = max(screens);
            
            % Define black and white
            expscreen.white = WhiteIndex(screenNumber);
            expscreen.black = BlackIndex(screenNumber);
            expscreen.grey = WhiteIndex(screenNumber) / 2;
            % Open the screen
            [window, windowRect] = PsychImaging('OpenWindow', screenNumber, expscreen.grey, window_size);
            expscreen.window=window;
            % Flip to clear
            Screen('Flip', window);
            
            % Get the size of the on screen window
            [expscreen.screenXpixels, expscreen.screenYpixels] = Screen('WindowSize', window);
            
            % Query the frame duration
            expscreen.ifi = Screen('GetFlipInterval', window);
            
            % Get the center coordinate of the window
            [expscreen.xCenter, expscreen.yCenter] = RectCenter(windowRect);
            
            % Here we set the initial position of the mouse to be in the center of the
            % screen
            SetMouse(expscreen.xCenter, expscreen.yCenter, window);
            
            % Set the text size
            Screen('TextSize', window, 40);
            
            % Set the blend function for the screen
            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            
            % Sync us and get a time stamp
            expscreen.vbl = Screen('Flip', window);
            expscreen.waitframes = 1;
            
            [expscreen.x, expscreen.y] = meshgrid(1:1:expscreen.screenXpixels, 1:1:expscreen.screenYpixels);
            
            %----------------------------------------------------------------------
            %                        Fixation Cross
            %----------------------------------------------------------------------
            
            % Screen Y fraction for fixation cross
            crossFrac = 0.0167;
            
            % Here we set the size of the arms of our fixation cross
            fixCrossDimPix = windowRect(4) * crossFrac;
            
            % Now we set the coordinates (these are all relative to zero we will let
            % the drawing routine center the cross in the center of our monitor for us)
            xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
            yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
            expscreen.allCoords = [xCoords; yCoords];
            
            % Set the line width for our fixation cross
            expscreen.lineWidthPix = 4;
            
            HideCursor
        end        
    end
end
