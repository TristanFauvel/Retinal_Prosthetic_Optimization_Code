function  preference_measure = preference_measurement(experiment, W1, W2, test)
add_directories;
% 
% nx = experiment.nx;
% ny = experiment.ny;

display_size = floor(experiment.display_size);


% Stimuli_folder =  [Stimuli_folder,'/letters'];

close all;

graphics_style_paper;
task = 'preference';
M = experiment.M;
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
