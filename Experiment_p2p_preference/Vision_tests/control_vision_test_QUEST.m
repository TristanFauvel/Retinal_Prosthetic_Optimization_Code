%% Control QUEST in its different settings

%% Setting 1
add_directories;
task  = 'Snellen';
test = 'VA';
T = load(data_table_file).T;
i = 1;
filename = [data_directory, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
load(filename, 'experiment');


% Visual acuity measurement using Snellen test and active learning.
% Task = 'E' or 'Snellen'
% global pathname

add_directories;

rng(experiment.seed)
% Uncomment this when I run the final experiment
switch task
    case 'E'
        nalt = 4;
        Stimuli_folder =  [Stimuli_folder,'/E'];
        ne = 50;
        e_range=linspace(0,0.1,ne); %error rate range
        threshold = 0.8;
        maxNTrials = 50;
    case 'Eneg'
        nalt = 4;
        Stimuli_folder =  [Stimuli_folder,'/E'];
        ne = 50;
        e_range=linspace(0,0.1,ne); %error rate range
        threshold = 0.8;
        maxNTrials = 50;
    case 'Snellen'
        nalt = 26;
        Stimuli_folder =  [Stimuli_folder,'/letters'];
        threshold = 0.5;
        maxNTrials = 80;
end

b = norminv(1/nalt,0,1);
stim_res = 255;

switch test
    case 'CS'
        bounds = [0,1];
        %         param_ub = log10((norminv(threshold)-b)*stim_res); % Maxmum slope it is possible to measure given min stimulus intensity
        %         param_lb = log10((norminv(threshold)-b)/bounds(2)); % Minimum slope it is possible to measure given max stimulus intensity
        param_ub = (norminv(threshold)-b)*stim_res; % Maxmum slope it is possible to measure given min stimulus intensity
        param_lb = (norminv(threshold)-b)/bounds(2); % Minimum slope it is possible to measure given max stimulus intensity
        a_range = linspace(param_lb,param_ub,2000);
        
    case 'VA'
        stim_var = 'angular_diameter';
        %         bounds = [0.01, display_size(1)]; %size range for the letter (in px)
        %         param_ub = log10((norminv(threshold)-b)/bounds(1)); % Maxmum slope it is possible to measure given min stimulus intensity
        %         param_lb = log10((norminv(threshold)-b)/bounds(2)); % Minimum slope it is possible to measure given max stimulus intensity
        bounds = [10/60, min(experiment.visual_field_size)]; %size range for the letter
        param_ub = (norminv(threshold)-b); % Maxmum slope it is possible to measure given min stimulus intensity
        param_lb = -3; % Minimum slope it is possible to measure given max stimulus intensity
        a_range = logspace(param_lb,log10(param_ub),2000);
        
        
end

lb = bounds(1);
ub = bounds(2);
x = linspace(lb,ub,stim_res);
stimDomain = x;
respDomain = [0 1];

if strcmp(task,'Snellen')
    F = @(x,a)([1-(normcdf(a.*x+b)),normcdf(a.*x+b)])';
    paramDomain = {a_range};
    y1 = unifpdf(paramDomain{1},param_lb,param_ub);
    y1 = y1./sum(y1);
    priors = {y1};
    
else
    F = @(x,a,e)([1-((1-e)*normcdf(a.*x+b)+e/nalt),(1-e)*normcdf(a.*x+b)+e/nalt])';
    paramDomain = {a_range, e_range};
    y1 = unifpdf(paramDomain{1},param_lb,param_ub);
    y1 = y1./sum(y1);
    y2 = betapdf(paramDomain{2},1,20);
    y2 = y2./sum(y2);
    priors = {y1, y2};
end

stop_rule = 'entropy';
stop_criterion = 2.5;
minNTrials = 10;

% x_norm = (x-lb)./(ub-lb);

if strcmp(task,'Snellen')
    VA_range =  3.8;%linspace(3,5,30); % linspace(0.5,5,30);
    e_range = zeros(1);
    [p,q] = ndgrid(VA_range, e_range);
    v = [p(:), q(:)];
else
    VA_range = 3.8; linspace(0.5,4,10);
     e_range = zeros(1,5);
     [p,q] = ndgrid(VA_range, e_range);
    v = [p(:), q(:)];
end
result_VA = NaN(1,size(v,1));
result_e = NaN(1,size(v,1));
    
for i = 1:size(v,1)
    kj = 0;

    VA = v(i,1);
    e = v(i,2);
    try
        load([experiment_directory, '/QPlikelihoods_', task, '_', test], 'QP');
    catch
        QP = QuestPlus(F, stimDomain, paramDomain, respDomain, stop_rule, stop_criterion, minNTrials, maxNTrials);
        %initialise (with default, uniform, prior)
        QP.initialise(priors);
        save([experiment_directory, '/QPlikelihoods_', task, '_', test], 'QP');
    end
    
    %% Initialize the experiment
    new_x= randsample(x,1);
    base_stim_size = 0.8*min(experiment.visual_field_size);
    base_contrast = 1;
    stim_size = base_stim_size;
    contrast = base_contrast;
    display_height = display_size(1);
    display_width = display_size(2);
    
    correct_response = [];
    slope = 60/(5*10^VA)*(norminv((threshold-e/nalt)/(1-e))-b);
    
%     while ~QP.isFinished()
    while kj < 2000
        kj = kj + 1; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        again =1;
        while again
            new_x =  QP.getTargetStim();
            
            switch test
                case 'CS'
                    contrast = new_x;
                    stim_size = base_stim_size;
                case 'VA'
                    contrast = base_contrast;
                    stim_size = new_x;
            end
            
            if strcmp(task,'Snellen')
                p = F(new_x,slope);
                c = p(2)>rand;
            else
                p = F(new_x,slope,e);
                c = p(2)>rand;
            end
            if ~isnan(c)
                again = 0;
            end
        end
        QP.update(new_x, c);
    end
    
    
    p = QP.getParamEsts('mean');
    if strcmp(task,'E')
        e_estimate = p(2);
    else
        e_estimate = 0;
    end
    slope_estimate = p(1);
    
    threshold_computation = @(a) (norminv((threshold-e_estimate/nalt)/(1-e_estimate)) - b)./a;% compute the threshold from the slope
    
    if strcmp(test, 'VA')
        threshold_intercept = threshold_computation(slope_estimate);
        va_conversion = @(a) log10(0.2*60*a); %the 0.2 factor corresponds to the fact that details are 1/5 of the size of the letter.
        max_val = va_conversion(max(min(experiment.visual_field_size)));
        visual_performance = va_conversion(threshold_intercept);
    elseif strcmp(test, 'CS')
        threshold_intercept = threshold_computation(slope_estimate);
        visual_performance=threshold_intercept;
        max_val =  1;
    end
    result_VA(i) = visual_performance;
    result_e(i) = e_estimate;
end

    max_val2 = va_conversion(threshold_computation(max(paramDomain{1})));
        min_val2 = va_conversion(threshold_computation(min(paramDomain{1})));

figure();
scatter(v(:,1),result_VA, 25, 'k', 'filled'); hold on;
plot([0,5], [0,5]); hold off
xlim([0,5])
ylim([0,5])
pbaspect([1,1,1])

figure();
scatter(v(:,2),result_e, 25, 'k', 'filled')
plot([0,0.2], [0,0.2]); hold off
xlim([0,0.2])
ylim([0,0.2])
pbaspect([1,1,1])

va= log10(0.2*60*threshold_computation(a_range)); %the 0.2 factor corresponds to the fact that details are 1/5 of the size of the letter.
figure()
scatter(a_range, va)


figure(); 
test = F(QP.stimDomain', slope_estimate);
plot(QP.stimDomain, test(2,:));