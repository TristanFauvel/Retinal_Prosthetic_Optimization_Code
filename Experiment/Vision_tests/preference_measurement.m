function  preference_measure = preference_measurement(experiment, M, W1, W2, test, screen)
add_directories;

display_size = experiment.display_size;

%%
 window = screen.window;
[width, height]=Screen('WindowSize', window,[]);
dpcm = get(0,'ScreenPixelsPerInch')/2.54; % number of pixels per centimeter
viewing_distance = [height, width/2]./(2*tan(0.5*experiment.visual_field_size*pi/180));
viewing_distance = min(viewing_distance/dpcm)/100; % Viewing distance, in cm;
 display_size = 2*viewing_distance*tan(0.5*experiment.visual_field_size*pi/180); % Size of the image on screen (in m)
display_size = floor(display_size*100*dpcm) ; % Size of the image on screen (in pixels)
%%
close all;

graphics_style_paper;
task = 'preference';
letter2number = @(c)1+lower(c)-'a';
letters = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];

if strcmp(experiment.task, 'preference')
    %stim  = unique(char(experiment.displayed_stim{:}));
     stim = letters(experiment.letters_range);
    if strcmp(test, 'training')
        letters_range = intersect(letters, stim);
    elseif strcmp(test, 'test')
        letters_range = setdiff(letters, stim);
    end
    letters_range = letter2number(letters_range);
else
    letters_range = 1:26;
end

max_iter = 13; %numel(letters_range);
ctrain = NaN(1,max_iter);

letter_range= letters_range(:); %;letters_range(:)];

i=0;
S = load_stimuli_letters(experiment);
S= S';
letter_range = randsample(letter_range, max_iter,'false');

while i<max_iter
    i=i+1;
    letter = letter_range(i);
    sw=randsample(0:1,1);
    if sw ==1
        W{1} = W2;
        W{2} = W1;
        [c, ~] = query_response_task(M, W, reshape(S(letter,:), experiment.ny, experiment.nx), display_size, experiment, task, letters(letter));
        c=1-c;
    else
         W{1} = W1;
        W{2} = W2;
        [c, ~] = query_response_task(M, W, reshape(S(letter,:), experiment.ny, experiment.nx), display_size, experiment, task, letters(letter));
    end
    if isnan(c)
        i=max(i-2,0);
    else
        ctrain(i) = c;
    end
end
pref = mean(ctrain);

preference_measure.ctrain = ctrain;
preference_measure.letters_range = letters_range;
preference_measure.stim = stim;
preference_measure.maxiter = max_iter;
preference_measure.pref = pref;
return
