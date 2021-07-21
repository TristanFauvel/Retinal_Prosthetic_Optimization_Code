function  [visual_performance, max_val, threshold_intercept, slope, QP, measure] = threshold_computation_QUEST(filename, test, measure)

load(filename, 'experiment');
plotting = 1;
recompute_QP = 1;
switch measure.task
    case 'Snellen'
        nalt = 26;
        e= 0;
        threshold = 0.5;
        
        if recompute_QP
            x = measure.QP.history_stim;
            y = measure.QP.history_resp;
            b = measure.b;%
            param_ub = (norminv(threshold)-b); % Maxmum slope it is possible to measure given min stimulus intensity
            param_lb = -3; % Minimum slope it is possible to measure given max stimulus intensity
            a_range = logspace(param_lb,log10(param_ub),2000);
            
            F = @(x,a)([1-(normcdf(a.*x+b)),normcdf(a.*x+b)])';
            paramDomain = {a_range};
            
            y1 = unifpdf(paramDomain{1},param_lb,param_ub);
            y1 = y1./sum(y1);
            priors = {y1};
            
            add_directories;
            % initialise (with default, uniform, prior)
            try
                load([experiment_path, '/QPlikelihoods_', measure.task, '_', test], 'QP');

            catch
                stop_rule = 'entropy';
                stop_criterion = 2.5;

                QP = QuestPlus(F, measure.QP.stimDomain, paramDomain, measure.QP.respDomain, measure.stop_rule, measure.stop_criterion, measure.QP.minNTrials, measure.QP.maxNTrials);
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
            QP =  measure.QP;
        end
        slope =QP.getParamEsts('mean');
    case 'E'
        threshold = 0.8;
        nalt = 4;
        
        if recompute_QP
            ne = 50;
            e_range=linspace(0,0.1,ne); %error rate range
            
            b = measure.b;
            x = measure.QP.history_stim;
            y = measure.QP.history_resp;
            
            param_ub = (norminv(threshold)-b); % Maxmum slope it is possible to measure given min stimulus intensity
            param_lb = -3; % Minimum slope it is possible to measure given max stimulus intensity
            a_range = logspace(param_lb,log10(param_ub),2000);
            
            F = @(x,a,e)([1-((1-e)*normcdf(a.*x+b)+e/nalt),(1-e)*normcdf(a.*x+b)+e/nalt])';
            paramDomain = {a_range, e_range};
            y1 = unifpdf(paramDomain{1},param_lb,param_ub);
            y1 = y1./sum(y1);
            y2 = betapdf(paramDomain{2},1,20);
            y2 = y2./sum(y2);
            priors = {y1, y2};
            
            add_directories;
            % initialise (with default, uniform, prior)
            try
                load([experiment_path, '/QPlikelihoods_', measure.task, '_', test], 'QP');
            catch
                QP = QuestPlus(F, measure.QP.stimDomain, paramDomain, measure.respDomain, measure.stop_rule, measure.stop_criterion, measure.minNTrials, measure.maxNTrials);
                % initialise (with default, uniform, prior)
                QP.initialise(priors);
                
                save([experiment_path, '/QPlikelihoods_', measure.task, '_', test], 'QP');
                %QP.saveLikelihoods([experiment_directory, '/QPlikelihoods_', task, '_', test, '_QP'])
            end
            
            for i = 1:size(x,2)
                new_x =  x(i);
                [ka, kb]= min((x(i)-QP.stimDomain).^2); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if  ka>0
                    disp(ka)
                end
                new_x = QP.stimDomain(kb);
                c = y(i);
                QP.update(new_x, c);
            end
        else
            QP  = measure.QP;
        end
        p = QP.getParamEsts('mean');
        e = p(2);
        slope = p(1);
end
b = measure.b; % norminv(1/nalt,0,1);

% threshold_computation = @(a) min(max(measure.x),(norminv((threshold-e/nalt)/(1-e)) - b)./a);% compute the threshold from the slope
threshold_computation = @(a) (norminv((threshold-e/nalt)/(1-e)) - b)./a;% compute the threshold from the slope

if strcmp(test, 'VA')
    threshold_intercept = threshold_computation(slope);
    %% Plot the corresponding VA in log(MAR)
    
    %     viewing_distance = measure.viewing_distance;
    %     if measure.stim_var == 'angular_diameter'
    %         threshold_val =  @(a) a; % Value of the threshold (angular diameter)
    %     else %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %         threshold_val =  @(a) 0.01*a./measure.dpcm/viewing_distance;
    %     end
    %     va_conversion = @(a) log10(0.2*180/pi*60*2*atan(0.5*a)); %the 0.2 factor corresponds to the fact that details are 1/5 of the size of the letter.
    %     p = va_conversion(threshold_val(p));
    %     max_val =  va_conversion(threshold_val(threshold_computation(max(measure.x))));
    
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
measure.a_range = a_range;
measure.param_lb = param_lb;
measure.param_ub = param_ub;
measure.QP = QP;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if plotting
     graphics_style_paper;
%     figure()
%     scatter(x,y); hold on;
%     output = QP.F(QP.stimDomain(:), slope);
%     plot(QP.stimDomain, output(2,:));
    
    f = @(x,a) normcdf(a.*x+measure.b);
    fig=figure();
    fig.Color =  [1 1 1];
    plot(measure.QP.stimDomain, f(measure.QP.stimDomain, slope)); hold on;
    scatter(measure.QP.history_stim,measure.QP.history_resp, markersize, 'k', 'filled'); hold off;
    box off
    title([filename(91:end), ' VA : ', num2str(visual_performance), 'e :', num2str(e)])
    ylim([0,1])
    
%     if strcmp(test, 'VA')
%     figure()
%     scatter(a_range, va_conversion(threshold_computation(a_range)), 5, 'k', 'filled');
%     end
    
end