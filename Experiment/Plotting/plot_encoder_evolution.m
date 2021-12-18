function plot_encoder_evolution(filename)
load(filename)
UNPACK_STRUCT(experiment, false)

filename_base = [task,'_', subject, '_', acquisition_fun_name,'_',num2str(index)];

add_directories;

graphics_style_paper;

% if ~exist(figure_directory,'dir')
%     mkdir(figure_directory)
% end


best_params = model_params*ones(1,size(x_best, 2));
best_params(ib,:) = x_best(ib,:);

k = 0;
for i = 1:10:maxiter
    k = k+1;
    We{k} = encoder(best_params(:,k), experiment, 1, 0);
end
n = numel(We);

% range = [2.^(1:floor(log2(maxiter))), maxiter];
e = 15;
mr = 1;
mc = n;
fig = figure();
fig.Color =  [1 1 1];
fig.Name = 'Projective fields';
for i = 1:numel(We)
    subplot(mr,mc,i)
    A = We{i};
    A = A';
    A = A(:,e);
    bottom=min(A);
    top=max(A);
    if bottom<0 && 0<top
        a=max(abs(bottom),top);
        Clim=[-a,a];
    else
        Clim=[bottom,top];
    end
    if Clim(1) == Clim(2)
        Clim(2) =Clim(1)+1;
    end
    imagesc(reshape(A, experiment.ny, experiment.nx),  Clim)
    set(gca,'YDir','normal')
    colormap('gray')
    daspect([1 1 1])
    box off
    set(gca,'XColor', 'none','YColor','none')
end
     
figure_directory = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/Figures/'];

if ~exist(figure_directory,'dir')
    mkdir(figure_directory)
end

savefig(fig, [figure_directory,filename_base, '_encoder_evolution.fig'])
% exportgraphics(fig, [figure_directory,filename_base, '_encoder_evolution.png'])
% exportgraphics(fig, [figure_directory,filename_base, '_encoder_evolution.eps'])
