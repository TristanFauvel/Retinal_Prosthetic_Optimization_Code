% acquisition_fun_name = 'kernelselfsparring';
% task = 'preference';
task = 'preference';

maxiter = 60; %Number of iterations in the BO loop.
% subject = 'TF one letter rho x magnitude betap betam'; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subject = 'TF one letter rho lambda theta x y'; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
maxiter = 80; %Number of iterations in the BO loop.
subject = 'TF one letter'; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d= 8; %8
subject = 'TF one letter rho lambda theta x y betap betam amplitude'; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d= 8; %8

maxiter = 80; %Number of iterations in the BO loop.
subject =  'TF one letter rho magnitude betap betam'; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subject = 'TF one letter rho lambda x y betap betam amplitude';
subject = 'TF one letter rho lambda theta x y betap betam';
subject = 'TF one letter rho lambda theta x y betap betam larger search space';
subject = 'TF one letter rho lambda theta x y betap betam much larger search space';

d= 7; %8


add_directories
graphics_style_paper

T = load(data_table_file).T;
T = T(T.Subject == subject, :);
nexp = 1;% numel(seeds)*numel(model_seeds)*2;
T=T(end-nexp+1:end,:);
T= T(1,:);
% T= T(7:end,:);
% T= T(T.Seed == 7,:);

acquisition_fun_name = 'kernelselfsparring';
% acquisition_fun_name = 'random';

indices_preference_kss = 1:size(T,1);
indices_preference_kss = indices_preference_kss(T.Task == task & T.Subject== subject & T.Acquisition==acquisition_fun_name & T.Misspecification == 0);

nparams = 9;
xbest = NaN(numel(indices_preference_kss), nparams, maxiter);
xparams = NaN(numel(indices_preference_kss), nparams);

for i =1:numel(indices_preference_kss)
    index = indices_preference_kss(i);
    filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    load(filename, 'experiment');
    
    xbest(i, : ,:) = experiment.x_best; %_unknown_hyps;
    xparams(i, :) = experiment.model_params;
end

params_names = {'$\rho  (\mu m)$','$\lambda  (\mu m)$','$\theta  (rad)$','$x  (\mu m)$', '$y  (\mu m)$', 'Magnitude', '$\beta_{+}$','$\beta_{-}$','z'};

fig=figure('units','normalized','outerposition',[0 0 1 1]);
fig.Color =  [1 1 1];
fig.Name = 'Optimal parameters';
mc = 8;

for k = 1:mc
    subplot(2,mc/2,k)
    plot(squeeze(mean(sqrt((xbest(:,k,:)- xparams(:,k)).^2))), 'linewidth', linewidth); 
    %     yline(sqrt(rho), 'linewidth', linewidth, 'color', 'r'); hold off
    set(gca,'FontSize',Fontsize)
    ylabel([params_names{k}],'Fontsize',Fontsize)
    xlabel('Iteration')
%     ylim([0, experiment.ub(k)-experiment.lb(k)])
    pbaspect([1 1 1])
    xlim([1, maxiter])
    box off
end

%%

% task = 'preference';

% 
% T = load(data_table_file).T;
% T =T(T.Subject == subject,:);
% % T= T(7:end,:);
% % 
% % T= T(T.Seed == 6,:);
% 
% indices_preference_kss = 1:size(T,1);
% indices_preference_kss = indices_preference_kss(T.Task == task & T.Subject== subject & T.Acquisition== 'kernelselfsparring'& T.Misspecification == 0);

xbest = NaN(numel(indices_preference_kss), 9, maxiter);
xparams = NaN(numel(indices_preference_kss), 9);

for i =1:numel(indices_preference_kss)
    index = indices_preference_kss(i);
    filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    load(filename, 'experiment');
    
    xbest(i, : ,:) = experiment.x_best; %_unknown_hyps;
    xparams(i, :) = experiment.model_params;
end
fig=figure('units','normalized','outerposition',[0 0 1 1]);
fig.Color =  [1 1 1];
fig.Name = 'Optimal parameters';

mc = 8;
i=0;
for k = 1:mc
    if ~strcmp(params_names{k}, 'Magnitude')
        i=i+1;
    end
    subplot(2,mc/2,k)
    plot(squeeze(xbest(:,k,:))', 'linewidth', linewidth); hold on; 
    plot(squeeze(xparams(:,k)*ones(1, maxiter))', 'linewidth', linewidth); hold off; 
    
    %     yline(sqrt(rho), 'linewidth', linewidth, 'color', 'r'); hold off
    set(gca,'FontSize',Fontsize)
    ylabel([params_names{k}],'Fontsize',Fontsize)
    xlabel('Iteration')
    ylim([experiment.lb(i), experiment.ub(i)])
    pbaspect([1 1 1])
    xlim([1, maxiter])
    box off
end
% savefig(fig, [figure_directory,filename_base , '_experiment_optimized_parameters_evolution.fig'])
% exportgraphics(fig, [figure_directory,filename_base , '_experiment_optimized_parameters_evolution.png'])
% exportgraphics(fig, [figure_directory,filename_base , '_experiment_optimized_parameters_evolution.eps'])
% 
