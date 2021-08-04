function  [visual_performance, max_val, threshold_intercept, slope, QP, measure] = threshold_computation_QUEST(filename, test, measure)

load(filename, 'experiment');
plotting = 1;
recompute_QP = 1;
add_directories;

switch measure.task
    case 'Snellen'
        nalt = 26;
    case 'E'
        nalt = 4;
end
gamma = 1/nalt;

if recompute_QP
    x = measure.QP.history_stim;
    y = measure.QP.history_resp;
    b = measure.b;%
    param_lb = [0,-10];
    param_ub = [1, 0];
    a_range = linspace(param_lb(1), param_ub(1), 200);
    b_range = linspace(param_lb(2), param_ub(2),200);
    c = @(b) (gamma-normcdf(b))./(1-normcdf(b));
    %     ne = 50;
    %     e_range=linspace(0,0.1,ne); %error rate range
    
    %     param_lb = 10.^param_lb;
    %       param_ub = 10.^param_ub;
end

% switch measure.task
%     case 'Snellen'
if recompute_QP ==1
    p = @(x,a,b) c(b) + (1-c(b))*normcdf(a*x+b);
    F = @(x,a, b)([1-p(x,a, b), p(x,a, b)])';
    paramDomain = {a_range,b_range};
    ya = unifpdf(paramDomain{1},param_lb(1),param_ub(1));
    ya = ya./sum(ya);
    yb = unifpdf(paramDomain{2},param_lb(2),param_ub(2));
    yb = yb./sum(yb);
    priors = {ya, yb};
    % initialise (with default, uniform, prior)
    try
        load([experiment_path, '/QPlikelihoods_', measure.task, '_', test], 'QP');
        
    catch
        stop_rule = 'entropy';
        stop_criterion = 2.5;
        
        QP = QuestPlus(F, measure.QP.stimDomain, paramDomain, measure.QP.respDomain, stop_rule, stop_criterion, measure.QP.minNTrials, measure.QP.maxNTrials);
        % initialise (with default, uniform, prior)
        QP.initialise(priors);
        
        save([experiment_path, '/QPlikelihoods_', measure.task, '_', test], 'QP');
        %QP.saveLikelihoods([experiment_directory, '/QPlikelihoods_', task, '_', test, '_QP'])
    end
    
    for i = 1:size(x,2)
        new_x =  x(i);
        c = y(i);
        QP.update(new_x, c);
    end
else
    QP = measure.QP;
end
p =QP.getParamEsts('mean');
a = p(1);
b = p(2);
%     case 'E'
%         if recompute_QP
%
%             p = @(x,a,b,e) c(b) + (1-c(b)-e)*normcdf(a*x+b);
%             F = @(x,a, b)([1-p(x,a, b), p(x,a, b)])';
%             paramDomain = {a_range, b_range, e_range};
%             ya = unifpdf(paramDomain{1},param_lb(1),param_ub(1));
%             ya = ya./sum(ya);
%             yb = unifpdf(paramDomain{2},param_lb(2),param_ub(2));
%             yb = yb./sum(yb);
%             ye = betapdf(paramDomain{3},1,20);
%             ye = ye./sum(ye);
%             priors = {ya, yb, ye};
%             stop_rule = 'entropy';
%                 stop_criterion = 2.5;
%             try
%                 load([experiment_path, '/QPlikelihoods_', measure.task, '_', test], 'QP');
%             catch
%                 QP = QuestPlus(F, measure.QP.stimDomain, paramDomain, measure.QP.respDomain, stop_rule, stop_criterion, measure.QP.minNTrials, measure.QP.maxNTrials);
%                 % initialise (with default, uniform, prior)
%                 QP.initialise(priors);
%
%                 save([experiment_path, '/QPlikelihoods_', measure.task, '_', test], 'QP');
%             endc(b)
%
%             for i = 1:size(x,2)
%                 new_x =  x(i);
%                 c = y(i);
%                 QP.update(new_x, c);
%             end
%         else
%             QP  = measure.QP;
%         end
% p = QP.getParamEsts('mean');
% a = p(1);
% b = p(2);


% threshold_computation = @(a) (norminv((threshold-e/nalt)/(1-e)) - b)./a;% compute the threshold from the slope
    c = @(b) (gamma-normcdf(b))./(1-normcdf(b));

va_computation = @(a,b) (1/a)*(norminv(0.5*(1+normcdf(b)))-b);
if strcmp(test, 'VA')
    threshold_intercept = va_computation(a,b);% -b/a;%threshold_computation(slope);
    %% Plot the corresponding VA in log(MAR)
    %% THE THRESHOLD IS AN ANGULAR DIAMTER (IN RAD)
    %      va_conversion = @(a) log10(0.2*180/pi*60*a); %the 0.2 factor corresponds to the fact that details are 1/5 of the size of the letter.
    va_conversion = @(a) log10(0.2*60*a); %the 0.2 factor corresponds to the fact that details are 1/5 of the size of the letter.
    max_val = va_conversion(max(min(experiment.visual_field_size)));
    visual_performance = va_conversion(threshold_intercept);
elseif strcmp(test, 'CS')
    threshold_intercept = threshold_computation(slope);
    visual_performance=threshold_intercept;
    max_val =  1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if recompute_QP

measure.a_range = a_range;
measure.b_range = b_range;

measure.param_lb = param_lb;
measure.param_ub = param_ub;
measure.QP = QP;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plotting=0
if plotting
    graphics_style_paper;
    c = @(b) (gamma-normcdf(b))./(1-normcdf(b));
    p = @(x,a,b) c(b) + (1-c(b))*normcdf(a*x+b);
    F = @(x,a, b)([1-p(x,a, b), p(x,a, b)])';
    fig=figure(1);
    fig.Color =  [1 1 1];
    out =  p(measure.QP.stimDomain, a,b);
    plot(measure.QP.stimDomain,out); hold on;
    scatter(measure.QP.history_stim,measure.QP.history_resp, markersize, 'k', 'filled'); hold off;
    box off
%     title([filename(91:end), ' VA : ', num2str(visual_performance), 'e :', num2str(e)])
    ylim([0,1])
    drawnow
end
disp(['a: ',num2str(a)])
disp(['b: ',num2str(b)])
disp(['visual perf: ',num2str(visual_performance)])

%
% if plotting
%     graphics_style_paper;
%     f = @(x,a) normcdf(a.*x+measure.b);
%     fig=figure();
%     fig.Color =  [1 1 1];
%     plot(measure.QP.stimDomain, f(measure.QP.stimDomain, slope)); hold on;
%     scatter(measure.QP.history_stim,measure.QP.history_resp, markersize, 'k', 'filled'); hold off;
%     box off
%     title([filename(91:end), ' VA : ', num2str(visual_performance), 'e :', num2str(e)])
%     ylim([0,1])
%
% end