function new_measure = convert_measure(experiment, measure)
test = 'VA';
viewing_distance = 0.4900;
dpcm = get(0,'ScreenPixelsPerInch')/2.54; % number of pixels per centimeter

measure.viewing_distance = 0.49; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
display_size = 2*measure.viewing_distance*tan(0.5*experiment.visual_field_size*pi/180); % Size of the image on screen (in m)
display_size = floor(display_size*100*dpcm) ; % Size of the image on screen (in pixels)

angle_to_pixels = @(angle) floor(tan(angle*pi/180/2)*viewing_distance*100*dpcm);
stim_var = 'angular_diameter';
bounds = [1/60, min(experiment.visual_field_size)]; %size range for the letter 
nalt = 4;
Stimuli_folder =  [measure.Stimuli_folder,'/E'];
ne = 50;
e_range=linspace(0,0.1,ne); %error rate range
b = norminv(1/nalt,0,1);
stim_res = 255;
threshold = 0.8;
param_ub = log10((norminv(threshold)-b)/bounds(1)); % Maxmum slope it is possible to measure given min stimulus intensity
param_lb = log10((norminv(threshold)-b)/bounds(2)); % Minimum slope it is possible to measure given max stimulus intensity
lb = bounds(1);
ub = bounds(2);

x = linspace(lb,ub,stim_res);
stimDomain = x;

a_range = logspace(param_lb,param_ub,200);

paramDomain = {a_range, e_range};
respDomain = [0 1];

y1 = unifpdf(paramDomain{1},10^param_lb,10^param_ub);
y1 = y1./sum(y1);
y2 = betapdf(paramDomain{2},1,20);
y2 = y2./sum(y2);
priors = {y1, y2};

stop_rule = 'entropy';
stop_criterion = 2.5;
minNTrials = 25;
maxNTrials = 80;

F = measure.F;
add_directories;
task  ='E';

pixels_to_angle = @(px) 2*atan(px./(2*viewing_distance*100*dpcm));

stimDomain = unique(sort([stimDomain, pixels_to_angle(measure.QP.history_stim)]));
    QP = QuestPlus(F, stimDomain, paramDomain, respDomain, stop_rule, stop_criterion, minNTrials, maxNTrials);
    % initialise (with default, uniform, prior)
    QP.initialise(priors);

% run
M = experiment.M;
base_stim_size = 0.8*min(experiment.visual_field_size);
base_contrast = 1;
stim_size = base_stim_size;
contrast = base_contrast;
display_height = display_size(1);
display_width = display_size(2);

for i = 1:size(measure.QP.history_stim,2)
    new_x = measure.QP.history_stim(i);  
    new_x = pixels_to_angle(new_x);
    c =  measure.QP.history_resp(i);
    QP.update(new_x, c);
end


        
        
w = whos;
close all
for a = 1:length(w)
    if ~strcmp(w(a).name, 'experiment')
        new_measure.(w(a).name) = eval(w(a).name);
    end
end


return


