clear all
add_directories

Data_folder = [experiment_path,'/Data'];
figures_folder = [experiment_path,'/Figures'];

acquisition_name = 'maxvar_challenge';
graphics_style_paper;


reload =1;
[slope_E_optimized_preference_acq, slope_Snellen_optimized_preference_acq, slope_E_optimal,slope_Snellen_optimal, slope_E_optimized_preference_random,slope_Snellen_optimized_preference_random, slope_E_optimized_preference_acq_misspecification, slope_Snellen_optimized_preference_acq_misspecification, slope_E_optimal_misspecification,slope_Snellen_optimal_misspecification, slope_E_optimized_E_TS,slope_Snellen_optimized_E_TS, slope_E_control,slope_Snellen_control] = load_slopes(reload);

T = load(data_table_file).T;
i = 1;
filename = [Data_folder, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
load(filename, 'experiment');


for i = 1:21
fig=figure();
fig.Name = num2str(i);
fig.Color =  [1 1 1];
nalt = 26;
exp = experiment.VA_E_QUEST_optimized;
N = numel(slope_Snellen_optimized_preference_acq);
a1 = slope_E_optimized_preference_acq(i);
plot(exp.QP.stimDomain, normcdf(a1*exp.QP.stimDomain + norminv(1/nalt)), 'linewidth', linewidth); hold on;
a2 = slope_E_optimized_preference_random(i);
plot(exp.QP.stimDomain, normcdf(a2*exp.QP.stimDomain + norminv(1/nalt)), 'linewidth', linewidth); hold on;
a3 = slope_E_optimal(i);
plot(exp.QP.stimDomain, normcdf(a3*exp.QP.stimDomain + norminv(1/nalt)), 'linewidth', linewidth); hold on;
a4 = slope_E_control(i);
plot(exp.QP.stimDomain, normcdf(a4*exp.QP.stimDomain + norminv(1/nalt)), 'linewidth', linewidth); hold on;
hold off;
box off
xlabel('Size (in degrees of visual angle)')
ylabel('Probability of correct response')
xlim([0,max(exp.QP.stimDomain)])
ylim([0,1])
title('Tumbling E')
pbaspect([1 1 1])
legend({'MaxVarChallenge','Random','Ground truth', 'Control'})
end
%%

fig=figure();
fig.Color =  [1 1 1];
mr = 1;
mc = 2;
subplot(mr,mc,2)
nalt = 26;
exp = experiment.VA_Snellen_QUEST_optimized;
N = numel(slope_Snellen_optimized_preference_acq);
for i = 1:N
    a = slope_Snellen_optimized_preference_acq(i);
    plot(exp.QP.stimDomain, normcdf(a*exp.QP.stimDomain + norminv(1/nalt)), 'linewidth', linewidth); hold on;
end
hold off;
box off
xlabel('Size (in degrees of visual angle)')
ylabel('Probability of correct response')
xlim([0,max(exp.QP.stimDomain)])
ylim([0,1])
title('Snellen')
pbaspect([1 1 1])


exp.QP

subplot(mr,mc,1)
exp = experiment.VA_E_QUEST_optimized;
    nalt = 4;
N = numel(slope_Snellen_optimized_preference_acq);
for i = 1:N
    a = slope_E_optimized_preference_acq(i);
    plot(exp.QP.stimDomain, normcdf(a*exp.QP.stimDomain + norminv(1/nalt)), 'linewidth', linewidth); hold on;
end
hold off;
box off
xlabel('Size (in degrees of visual angle)')
ylabel('Probability of correct response')
xlim([0,max(exp.QP.stimDomain)])
pbaspect([1 1 1])
ylim([0,1])
title('Tumbling E')



%%
T = load(data_table_file).T;
T = T(T.Subject == 'TF',:);
% 
% for i = 1:size(T,1)
%     filename = [Data_folder, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
%     load(filename, 'experiment');
%     a = experiment.CS_E_QUEST_optimized.endGuess_mean(1);
%     fig=figure();
%     fig.Color =  [1 1 1];
%     plot(experiment.CS_E_QUEST_optimized.x, normcdf(a*experiment.CS_E_QUEST_optimized.x + norminv(0.25))); hold on;
%     scatter(experiment.CS_E_QUEST_optimized.QP.history_stim,experiment.CS_E_QUEST_optimized.QP.history_resp, markersize, 'k', 'filled'); hold off;
%     box off
%     xlabel('Contrast')
% 
% end
% 
% 
% 
for i = 1:size(T,1)
    filename = [Data_folder, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
    load(filename, 'experiment');
    exp = experiment.VA_Snellen_QUEST_optimized;
    a = exp.endGuess_mean(1);
    fig=figure();
    fig.Color =  [1 1 1];
    nalt = 26;
    plot(exp.QP.stimDomain, normcdf(a*exp.QP.stimDomain + norminv(1/nalt))); hold on;
    scatter(exp.QP.history_stim,exp.QP.history_resp, markersize, 'k', 'filled'); hold off;
    box off
    xlabel('Size')

end

for i = 1:size(T,1)
    filename = [Data_folder, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
    load(filename, 'experiment');
    exp = experiment.VA_E_QUEST_optimized;
    a = exp.endGuess_mean(1);
    fig=figure();
    fig.Color =  [1 1 1];
    plot(exp.QP.stimDomain, normcdf(a*exp.QP.stimDomain + norminv(0.25))); hold on;
    scatter(exp.QP.history_stim,exp.QP.history_resp, markersize, 'k', 'filled'); hold off;
    box off
    xlabel('Size')

end

% nalt = 4;
% T = load(data_table_file).T;
% T = T(T.Subject == 'TF',:);
% T = T(13:end,:);
% T = T(T.Acquisition == 'kernelselfsparring' & T.Misspecification == 0,:);
% for i = 1:size(T,1)
%     filename = [Data_folder, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
%     load(filename, 'experiment');
%     a = experiment.CS_E_QUEST_optimal.endGuess_mean(1);
%     fig=figure();
%     fig.Color =  [1 1 1];
%     plot(experiment.CS_E_QUEST_optimal.x, normcdf(a*experiment.CS_E_QUEST_optimal.x + norminv(1/experiment.CS_E_QUEST_optimal.nalt))); hold on;
%     scatter(experiment.CS_E_QUEST_optimal.QP.history_stim,experiment.CS_E_QUEST_optimal.QP.history_resp, markersize, 'k', 'filled'); hold off;
%     box off
%     xlabel('Contrast')
% 
% end

T = load(data_table_file).T;
T = T(T.Subject == 'TF',:);
T = T(T.Acquisition == acquisition_name,: );


for i = 1:size(T,1)
    filename = [Data_folder, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
    load(filename, 'experiment');
    measure =experiment.VA_E_QUEST_optimal;
    a = measure.endGuess_mean(1);
    fig=figure();
    fig.Color =  [1 1 1];
    plot(measure.x, normcdf(a*measure.x + norminv(1/measure.nalt))); hold on;
    scatter(measure.QP.history_stim,measure.QP.history_resp, markersize, 'k', 'filled'); hold off;
    box off
    xlabel('Angular diameter')

end
