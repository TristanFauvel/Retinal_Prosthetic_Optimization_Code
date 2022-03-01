graphics_style_paper;

add_directories
graphics_style_paper;
folder = paper_figures_folder;
data_directory = [experiment_directory,'/Data'];
figures_folder = [experiment_directory,'/Figures'];

T = load(data_table_file).T;
% s_index = find(T.Subject == 'PC', :)
s_index = 2;
T = T(T.Subject == 'PC', :);

filename = [data_directory, '/Data_Experiment_p2p_',char(T(s_index,:).Task),'/', char(T(s_index,:).Subject), '/', char(T(s_index,:).Subject), '_', char(T(s_index,:).Acquisition), '_experiment_',num2str(T(s_index,:).Index)];
graphics_style_paper;
load(filename)
UNPACK_STRUCT(experiment, false)
 
add_directories;

filename_base = [task,'_', subject, '_', acquisition_fun_name,'_',num2str(s_index)];
figure_directory = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/Figures/'];

if ~exist(figure_directory)
    mkdir(figure_directory)
end

Stimuli_folder =  '/home/tfauvel/Documents/Retinal_Prosthetic_Optimization/Retinal_Prosthetic_Optimization_Code/Stimuli/letters';
% S = load_stimuli_letters(experiment);
% S = S(:,1);

 
% rho = xparams(1);
% axlambda = xparams(2);
% rot = xparams(3);
% center_x = xparams(4);
% center_y = xparams(5);
% magnitude_factor = xparams(6);
% beta_sup = xparams(7);
% beta_inf = xparams(8);
% z = xparams(9);
% true_model_params = 1.0e+03 *[0.410,1.190, 0, 0,0,0.2873,-0.0013, 0.0013,0];
% true_model_params = [410,1190,0,0,0,175.8257,-2.5,0.1,0];

true_model_params = [410,1190,0,0,0,175.8257,-1.9,0.5,0];
xrange = [-13, 10];
    yrange = [-7, 7];

experiment.n_ax_segments = int64(600);
experiment.n_axons= int64(1000);
experiment.xystep= 0.25;

 
pymod = [];
ignore_pickle=1; % Wether to use a precomputed axon map (0) or not (1)
optimal_magnitude = 1;

[~, ~, experiment.nx,experiment.ny] = encoder(true_model_params, experiment,ignore_pickle, 0, 'pymod', pymod, 'xrange', xrange, 'yrange', yrange, 'save_encoder', 0);
[Wopt, M] = encoder(true_model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod, 'xrange', xrange, 'yrange', yrange, 'save_encoder', 0);

S = compute_stimulus(experiment, task, 1*display_size(1), display_width, display_height, Stimuli_folder, contrast,'stim', 'A');
S = imresize(S, [experiment.ny, experiment.nx], 'method', 'bilinear');
S=S(:);

p = vision_model(M,Wopt ,S);
p = p*(max(p)/255);
matrix_visualization(M,experiment)
%%
mr = 1;
mc = 2;
i = 0;
k=1;
fig=figure('units','centimeters','outerposition',1+[0 0 16 0.5*16]);
fig.Color =  [1 1 1];
tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','compact');

h =  nexttile;
i=i+1;
imagesc(reshape(255*S,experiment.ny,experiment.nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[],'dataAspectRatio',[1 1 1], 'Fontsize', Fontsize),
h.CLim = [0, 255];
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
title('Stimulus')
colormap('gray')
% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize',letter_font) %with compact margins

h =  nexttile;
i=i+1;
imagesc(reshape(p,experiment.ny,experiment.nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[],'dataAspectRatio',[1 1 1], 'Fontsize', Fontsize),
h.CLim = [0, 255];
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
title({'Optimal $W$', ['RMSE = ' num2str(sqrt(mse(popt,S)))]})
colormap('gray')
 

%%
fun = @(a) sqrt(mse(vision_model_amplitudes(M,a),S));
x0 = pinv(M)*S;
options.Display = 'iter';
[x, fval, exitflag, output] = fminunc(fun,x0, options);


 popt = vision_model_amplitudes(M,x);


mr = 1;
mc = 3;
i = 0;
k=1;
fig=figure('units','centimeters','outerposition',1+[0 0 16 0.5*16]);
fig.Color =  [1 1 1];
tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','compact');

h =  nexttile;
i=i+1;
imagesc(reshape(255*S,experiment.ny,experiment.nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[],'dataAspectRatio',[1 1 1], 'Fontsize', Fontsize),
h.CLim = [0, 255];
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
title('Stimulus')
colormap('gray')
% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize',letter_font) %with compact margins

h =  nexttile;
i=i+1;
imagesc(reshape(255*popt,experiment.ny,experiment.nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[],'dataAspectRatio',[1 1 1], 'Fontsize', Fontsize),
h.CLim = [0, 255];
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
title({'Optimal $W$', ['RMSE = ' num2str(sqrt(mse(popt,S)))]})
colormap('gray')
% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize',letter_font) %with compact margins

h = nexttile;
i=i+1;
imagesc(reshape(p,experiment.ny,experiment.nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[],'dataAspectRatio',[1 1 1], 'Fontsize', Fontsize)
h.CLim = [0, 255];
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
title({'$W = M^\dagger_\phi$', ['RMSE = ', num2str(sqrt(mse(p/255,S)))]})
colormap('gray')
% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize',letter_font) %with compact margins

figname  = 'Optimality';
folder = '/home/tfauvel/Documents/PhD/Figures/Paper_figures/';
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);

