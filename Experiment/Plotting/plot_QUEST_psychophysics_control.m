clear all
add_directories

Data_folder = [experiment_directory,'/Data'];
figures_folder = [experiment_directory,'/Figures'];

acquisition_name = 'MUC';
graphics_style_paper;


reload = 0;
[slope_E_optimized_preference_acq, slope_Snellen_optimized_preference_acq, slope_E_optimal,slope_Snellen_optimal, slope_E_optimized_preference_random,slope_Snellen_optimized_preference_random, slope_E_optimized_preference_acq_misspecification, slope_Snellen_optimized_preference_acq_misspecification, slope_E_optimal_misspecification,slope_Snellen_optimal_misspecification, slope_E_optimized_E_TS,slope_Snellen_optimized_E_TS, slope_E_control,slope_Snellen_control] = load_slopes(reload);

T = load(data_table_file).T;
T = T(T.Task == 'preference' & T.Acquisition == 'MUC' & T.Misspecification == 0, :);

i = 1;
filename = [Data_folder, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
load(filename, 'experiment');

exp = experiment.VA_E_QUEST_control;
x = exp.QP.stimDomain;
nalt = 26;

for i = 1:size(T,1)
    fig=figure();
    fig.Name = num2str(i);
    fig.Color =  [1 1 1];
    N = numel(slope_Snellen_optimized_preference_acq);
    a1 = slope_E_optimized_preference_acq(i);
    plot(x, normcdf(a1*x + norminv(1/nalt)), 'linewidth', linewidth); hold on;
    a2 = slope_E_optimized_preference_random(i);
    plot(x, normcdf(a2*x + norminv(1/nalt)), 'linewidth', linewidth); hold on;
    a3 = slope_E_optimal(i);
    plot(x, normcdf(a3*x + norminv(1/nalt)), 'linewidth', linewidth); hold on;
    a4 = slope_E_control(i);
    plot(x, normcdf(a4*x + norminv(1/nalt)), 'linewidth', linewidth); hold on;
    hold off;
    box off
    xlabel('Size (in degrees of visual angle)')
    ylabel('Probability of correct response')
    xlim([0,max(x)])
    ylim([0,1])
    title('Tumbling E')
    pbaspect([1 1 1])
    legend({'MaxVarChallenge','Random','Ground truth', 'Control'})
end

for i = 1:size(T,1)
    filename = [Data_folder, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
    load(filename, 'experiment');
    exp = experiment.VA_Snellen_QUEST_control;
    if ~isstruct(exp)
        exp = exp{1};
    end
    a = slope_Snellen_control(i);
    fig=figure();
    fig.Color =  [1 1 1];
    nalt = 26;
    plot(x, normcdf(a*x + norminv(1/nalt))); hold on;
    scatter(exp.QP.history_stim,exp.QP.history_resp, markersize, 'k', 'filled'); hold off;
    box off
    xlabel('Size')
    title(num2str(i))
end

[exp1.QP.history_stim; exp.QP.history_stim]
[exp1.QP.history_resp; exp.QP.history_resp]

[test1.VA_Snellen_QUEST_control{1}.QP.history_resp;test2.VA_Snellen_QUEST_control{1}.QP.history_resp]

for i = 1:size(T,1)
    filename = [Data_folder, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
    load(filename, 'experiment');
    exp = experiment.VA_E_QUEST_control{1};
    a = exp.endGuess_mean(1);
    fig=figure();
    fig.Color =  [1 1 1];
    plot(x, normcdf(a*x + norminv(0.25))); hold on;
    scatter(exp.QP.history_stim,exp.QP.history_resp, markersize, 'k', 'filled'); hold off;
    box off
    xlabel('Size')
    
end

