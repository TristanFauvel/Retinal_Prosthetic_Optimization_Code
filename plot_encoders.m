add_modules
add_directories
graphics_style_paper;
folder = paper_figures_folder;
data_directory = [experiment_directory,'/Data'];
figures_folder = [experiment_directory,'/Figures'];
graphics_style_paper;
 
Stimuli_folder =  Letters_folder;
 
true_model_params = [410,1190,0,0,0,175.8257,-1.9,0.5,0];

xrange = [-16, 16];
    yrange = [-11, 11];

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


figures_folder =  [code_directory, '/Figures'];

fig = matrix_visualization(M,experiment);
figname  = 'Projective_fields';
folder = figures_folder;
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);


fig = matrix_visualization(Wopt,experiment);
figname  = 'Receptive_fields';
folder = figures_folder;
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);


