add_modules
add_directories
graphics_style_paper;
folder = paper_figures_folder;
data_directory = [code_directory,'/Data'];
figures_folder = [code_directory,'/Figures'];
graphics_style_paper;
 
Stimuli_folder =  Letters_folder;
 
true_model_params = [410,1190,0,0,0,175.8257,-1.9,0.5,0];

xrange = [-13, 10];
    yrange = [-7, 7];

experiment.n_ax_segments = int64(600);
experiment.n_axons= int64(1000);
experiment.xystep= 0.25;
experiment.implant_name = 'Argus II';
experiment.p2p_version = 'stable';
experiment.n_electrodes = 60;

use_ptb3 = 0;
screen_setup;
dpcm = get(0,'ScreenPixelsPerInch')/2.54; % number of pixels per centimeter
display_size = 2*viewing_distance*tan(0.5*visual_field_size*pi/180); % Size of the image on screen (in m)
display_size = floor(display_size*100*dpcm) ; % Size of the image on screen (in pixels)
display_width = display_size(2);
display_height = display_size(1);
experiment.display_size = display_size;
experiment.display_width = display_size(2);
experiment.display_height = display_size(1);
implant.array_shape = [6,10];
    nelectrodes = implant.array_shape(1)*implant.array_shape(2);
    experiment.implant_size = implant.array_shape;

pymod = [];
ignore_pickle=1; % Wether to use a precomputed axon map (0) or not (1)
optimal_magnitude = 1;


[~, ~, experiment.nx,experiment.ny] = encoder(true_model_params, experiment,ignore_pickle, 0, 'pymod', pymod, 'xrange', xrange, 'yrange', yrange, 'save_encoder', 0);
[Wopt, M] = encoder(true_model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod, 'xrange', xrange, 'yrange', yrange, 'save_encoder', 0);


matrix_visualization(M,experiment)

matrix_visualization(Wopt,experiment)


task = 'Snellen';
contrast = 1;
S = compute_stimulus(experiment, task, 1*display_size(1), display_width, display_height, Stimuli_folder, contrast,'stim', 'A');
S = imresize(S, [experiment.ny, experiment.nx], 'method', 'bilinear');
S=S(:);

p = vision_model(M,Wopt ,S);
p = p*(max(p)/255);
matrix_visualization(M,experiment)


fun = @(a) sqrt(mse(vision_model_amplitudes(M,a),S));
x0 = pinv(M)*S;
options.Display = 'iter';
[x, fval, exitflag, output] = fminunc(fun,x0, options);
popt = vision_model_amplitudes(M,x); % computes the predicted percept by taking the current amplitudes as input.

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
folder = figures_folder;
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);

