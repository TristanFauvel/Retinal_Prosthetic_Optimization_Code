add_directories;
T = load(data_table_file).T;
T = T(T.Acquisition == 'MUC' & T.Misspecification == 1,:);

graphics_style_paper;

for index = 1:size(T,1)
    task = char(T(index,:).Task);
    subject = char(T(index,:).Subject);
    filename_base = [task,'_', subject, '_', subject,'_',num2str(T(index,:).Index)];
    figure_directory = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/Figures/'];
    
    filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    load(filename, 'experiment');
    UNPACK_STRUCT(experiment, false)
        
    add_directories;
    optimal_magnitude = 1;
    [Wopt, Mopt, nx,ny] = encoder(true_model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
    [Wmiss, Mmiss, nx,ny] = encoder(model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
    [popt, pmax] = vision_model(M,Wopt,S);
    [pmiss, pmax] = vision_model(M,Wmiss,S);
  
    
    
    k = 1;
    fig = figure();
    fig.Color = [1,1,1];
    h = subplot(1,2,1);
    imagesc(reshape(popt(:,k),ny,nx));
    set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
    set(gca,'dataAspectRatio',[1 1 1])
    h.CLim = [0, 255];
    colormap('gray')
    title('Ground truth')
    h = subplot(1,2,2);
    imagesc(reshape(pmiss(:,k),ny,nx));
    set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
    set(gca,'dataAspectRatio',[1 1 1])
    h.CLim = [0, 255];
    colormap('gray')
        title('Misspecified')
    savefig(fig, [figure_directory,filename_base , '_comparison_ground_truth_vs_misspecified.fig'])
    export_fig(fig, [figure_directory,filename_base , '_comparison_ground_truth_vs_misspecified.png'])
    close all
end