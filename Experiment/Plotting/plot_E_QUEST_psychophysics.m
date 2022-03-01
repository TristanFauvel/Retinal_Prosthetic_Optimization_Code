clear all
add_directories
Data_folder = [experiment_directory,'/Data'];
figures_folder = [experiment_directory,'/Figures'];
nalt = 4;
b = norminv(1/nalt,0,1);
F = @(x,a)([1-normcdf(a.*x+b),normcdf(a.*x+b)])';

graphics_style_paper;

Ta = load(data_table_file).T;

% Ta = Ta(end-3:end,:);
% T = T(T.Subject == 'TF',:);
% T = T(13:end,:);
% 
% for i = 1:size(T,1)
%     filename = [Data_folder, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
%     load(filename, 'experiment');
%    slope = experiment.E_slope_optimized;

%     fig=figure();
%     fig.Color =  [1 1 1];
%     plot(experiment.CS_E_QUEST_optimized.x, normcdf(slope*experiment.CS_E_QUEST_optimized.x + norminv(1/nalt))); hold on;
%     scatter(experiment.CS_E_QUEST_optimized.QP.history_stim,experiment.CS_E_QUEST_optimized.QP.history_resp, markersize, 'k', 'filled'); hold off;
%     box off
%     xlabel('Contrast')
% 
% end
% 
% 
% 
% for i = 1:size(T,1)
%     filename = [Data_folder, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
%     load(filename, 'experiment');
%     a = experiment.VA_E_QUEST_optimized.endGuess_mean(1);
%     fig=figure();
%     fig.Color =  [1 1 1];
%     plot(experiment.VA_E_QUEST_optimized.x, normcdf(a*experiment.VA_E_QUEST_optimized.x + norminv(1/nalt))); hold on;
%     scatter(experiment.VA_E_QUEST_optimized.QP.history_stim,experiment.VA_E_QUEST_optimized.QP.history_resp, markersize, 'k', 'filled'); hold off;
%     box off
%     xlabel('Size')
% 
% end


% T = T(T.Subject == 'TF',:);
% T = T(13:end,:);
% T = T(T.Acquisition == 'kernelselfsparring' & T.Misspecification == 0,:);
% for i = 1:size(T,1)
%     filename = [Data_folder, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
%     load(filename, 'experiment');
%     a = experiment.CS_E_QUEST_optimal.endGuess_mean(1);
%     fig=figure();
%     fig.Color =  [1 1 1];
%     plot(experiment.CS_E_QUEST_optimal.x, normcdf(a*experiment.CS_E_QUEST_optimal.x + norminv(1/nalt))); hold on;
%     scatter(experiment.CS_E_QUEST_optimal.QP.history_stim,experiment.CS_E_QUEST_optimal.QP.history_resp, markersize, 'k', 'filled'); hold off;
%     box off
%     xlabel('Contrast')
% 
% end
% 
% 
% for i = 1:size(T,1)
%     filename = [Data_folder, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
%     load(filename, 'experiment');
%     a = experiment.VA_E_QUEST_optimal.endGuess_mean(1);
%     fig=figure();
%     fig.Color =  [1 1 1];
%     plot(experiment.VA_E_QUEST_optimal.x, normcdf(a*experiment.VA_E_QUEST_optimal.x + norminv(1/nalt))); hold on;
%     scatter(experiment.VA_E_QUEST_optimal.QP.history_stim,experiment.VA_E_QUEST_optimal.QP.history_resp, markersize, 'k', 'filled'); hold off;
%     box off
%     xlabel('Size')
% 
% end

% for i = 1:size(T,1)
%     filename = [Data_folder, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
%     load(filename, 'experiment');
%     measure= experiment.CS_E_QUEST_optimal;
%     a = experiment.E_CS_optimal;
%     cs = F(measure.x',a);
%     fig=figure();
%     fig.Color =  [1 1 1];
%     plot(measure.x, cs(2,:)); hold on;
%     scatter(measure.QP.history_stim, measure.QP.history_resp, markersize, 'k', 'filled'); hold off;
%     box off
%     xlabel('Contrast')    
% end
% 
% T = Ta;
% T = T(T.Acquisition == 'MUC' & T.Misspecification == 0,:);
% for i = 1:size(T,1)
%     filename = [Data_folder, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
%     load(filename, 'experiment');
%     measure= experiment.VA_E_QUEST_optimal;
%         slope = experiment.E_slope_optimal;
% 
%     va = F(measure.x',slope);
%     fig=figure();
%     fig.Color =  [1 1 1];
%     plot(measure.x, va(2,:)); hold on;
%     scatter(measure.QP.history_stim, measure.QP.history_resp, markersize, 'k', 'filled'); hold off;
%     box off
%     xlabel('Size')    
%     measure.QP
% end

% T = Ta;
% for i = 1:size(T,1)
%     filename = [Data_folder, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
%     load(filename, 'experiment');
%     measure= experiment.CS_E_QUEST_optimized;
%     p = measure.QP.getParamEsts('mean');
%     cs = F(measure.x',p);
%     fig=figure();
%     fig.Color =  [1 1 1];
%     plot(measure.x, cs(2,:)); hold on;
%     scatter(measure.QP.history_stim, measure.QP.history_resp, markersize, 'k', 'filled'); hold off;
%     box off
%     xlabel('Contrast')    
% end


T = Ta;
for i = 1:size(T,1)
    filename = [Data_folder, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
    load(filename, 'experiment');
    measure= experiment.VA_E_QUEST_optimized;
    p = measure.QP.getParamEsts('mean');
    slope = experiment.E_VA_slope_optimized;
    va = F(measure.x',slope);
    fig=figure();
    fig.Color =  [1 1 1];
    plot(measure.x, va(2,:)); hold on;
    scatter(measure.QP.history_stim, measure.QP.history_resp, markersize, 'k', 'filled'); hold off;
    box off
    xlabel('Size')  
    measure.QP
end



T = Ta;
for i = 1:size(T,1)
    filename = [Data_folder, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
    load(filename, 'experiment');
    measure= experiment.VA_E_QUEST_optimized;
    p = measure.QP.getParamEsts('mean');
    slope = experiment.E_VA_slope_optimized;
    va = F(measure.x',slope);
    fig=figure();
    fig.Color =  [1 1 1];
    plot(measure.x, va(2,:)); hold on;
    scatter(measure.QP.history_stim, measure.QP.history_resp, markersize, 'k', 'filled'); hold off;
    box off
    xlabel('Size')  
    measure.QP
end




%%%%%%%%%%%%%%%%%%%%%%%ù

T = Ta;
T = T(T.Acquisition == 'MUC' & T.Misspecification == 0,:);
for i = 1:size(T,1)
    filename = [Data_folder, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
    load(filename, 'experiment');
    measure1= experiment.VA_E_QUEST_optimal;
    measure2= experiment.VA_E_QUEST_optimized;
    slope_1 = experiment.E_slope_VA_optimized;
    threshold_intercept_1 = experiment.E_VA_threshold_intercept_optimized;
    va1 = F(measure1.x',slope_1);
    slope_2 = experiment.E_slope_VA_optimal;
    threshold_intercept_2 = experiment.E_VA_threshold_intercept_optimal;
    va2 = F(measure2.x',slope_2);

    fig=figure();
    fig.Color =  [1 1 1];
    plot(measure1.x, va1(2,:)); hold on;
    scatter(measure1.QP.history_stim, measure1.QP.history_resp, markersize, 'r', 'filled'); hold on;
    plot(measure2.x, va2(2,:)); hold on;
    scatter(measure2.QP.history_stim, measure2.QP.history_resp, markersize, 'b', 'filled'); hold on;
    vline(threshold_intercept_1);
%     F(threshold_intercept_1,slope_1)
    vline(threshold_intercept_2);
%     F(threshold_intercept_2,slope_2)
    box off
    xlabel('Size')    
end


b = glmfit(measure1.QP.history_stim', measure1.QP.history_resp','binomial','Link','probit','Constant','off', 'Offset', measure1.b*ones(size(measure1.QP.history_resp')));
yfit = glmval(b,measure1.x','probit','Constant','off', 'Offset', measure1.b*ones(size(measure1.x')));
fig=figure();
fig.Color =  [1 1 1];
plot(measure1.x, yfit); hold on;
scatter(measure1.QP.history_stim, measure1.QP.history_resp, markersize, 'r', 'filled'); hold on;



  