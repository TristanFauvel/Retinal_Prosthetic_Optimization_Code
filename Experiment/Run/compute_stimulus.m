function [S,correct_response] = compute_stimulus(experiment, task, stim_size, display_width, display_height, Stimuli_folder, contrast, varargin)

opts = namevaluepairtostruct(struct( ...
    'previous_stim', [], ...
    'stim', [] ...
    ), varargin);

UNPACK_STRUCT(opts, false)

switch task
    case 'E'
        types = [8,6,2,4];
    case 'Eneg'
        types = [8,6,2,4];
    case 'Snellen'
        %         types = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
        types = ['C','D','E','F','H','K','N','P','R','U','V','Z'];
        types = setdiff(types, previous_stim);
    case 'preference'
        types = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
        types = types(experiment.letters_range);
end

if ~isempty(stim)
    types = stim;
end
correct_response = randsample(types, 1);

switch task
    case 'LandoltC'
        S = load_landolt_C(correct_response, stim_size, display_width, display_height, Stimuli_folder);
        
    case 'E'
        S =  load_E(correct_response, stim_size, display_width, display_height, Stimuli_folder);
    case 'Eneg'
        S = load_E(correct_response, stim_size, display_width, display_height, Stimuli_folder);
        contrast = -contrast;
    case 'Snellen'
        S = load_Snellen(display_width, display_height, Stimuli_folder, stim_size, correct_response);
    case 'preference'
        S = load_Snellen(display_width, display_height, Stimuli_folder, stim_size, correct_response);
        
end
if contrast<0
    S = 1-S;
end
contrast = abs(contrast);
S = S*contrast;