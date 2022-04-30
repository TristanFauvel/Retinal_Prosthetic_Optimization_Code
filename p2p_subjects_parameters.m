add_modules
add_directories
graphics_style_paper;
folder = paper_figures_folder;
data_directory = [code_directory,'/Data'];
figures_folder = [code_directory,'/Figures'];
graphics_style_paper;

Stimuli_folder =  Letters_folder;

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


%[~, ~, experiment.nx,experiment.ny] = encoder(true_model_params, experiment,ignore_pickle, 0, 'pymod', pymod, 'xrange', xrange, 'yrange', yrange, 'save_encoder', 0);
%[Wopt, M] = encoder(true_model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod, 'xrange', xrange, 'yrange', yrange, 'save_encoder', 0);



% 'subject_id': 'S2', 'implant_type_str': 'ArgusII', 'implant_x': -1761, ...
% 'implant_y': -212, 'implant_rot': -0.188, 'loc_od_x': 15.4,'loc_od_y': 1.86,
% 'xmin': -30, 'xmax': 30, 'ymin': -22.5,'ymax': 22.5

% 'subject_id': 'S3', 'implant_type_str': 'ArgusII','implant_x': -799, ...
% 'implant_y': 93,'implant_rot': -1.09,'loc_od_x': 15.7, 'loc_od_y': 0.75,
% 'xmin': -32.5, 'xmax': 32.5, 'ymin': -24.4, 'ymax': 24.4

% 'subject_id': 'S4','implant_type_str': 'ArgusII', 'implant_x': -1230,
% 'implant_y': 415, 'implant_rot': -0.457,'loc_od_x': 15.9,'loc_od_y': 1.96,
% 'xmin': -32, 'xmax': 32, 'ymin': -24, 'ymax': 24

% By default, 'loc_od_x': 15.5,'loc_od_y': 1.5,

xrange = [-13, 10];
yrange = [-7, 7];

xrange = [-18, 16];
yrange = [-11, 11];
ignore_pickle = 1;
%subject= [rho, lambda, rot, center_x, center_y, magnitude_factor, beta_sup, beta_inf, loc_od_x, loc_od_y];
subject2 = [315,500,-0.188, -1761, -212,175.8257,-1.9,0.5,0, 15.4, 1.86];
xrange2 = [-30,30];
yrange2 = [-22.5,22.50];
experiment2 = experiment;
[W2, M2, experiment2.nx, experiment2.ny] = encoder_v2(subject2, experiment, ignore_pickle , 0, 'xrange', xrange, 'yrange', yrange, 'save_encoder', 0);
fig = matrix_visualization(W2,experiment2)

figname  = 'M2';
folder = figures_folder;
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);


%%
subject3 = [144,1414,-1.09,-799, 93, 175.8257,-1.9,0.5,0, 15.7, 0.75];
xrange3 = [-32.5,32.5];
yrange3 = [-24.4,24.4];
experiment3 = experiment;
[W3, M3, experiment3.nx, experiment3.ny] = encoder_v2(subject3, experiment, ignore_pickle , 0, 'xrange', xrange, 'yrange', yrange, 'save_encoder', 0);
fig = matrix_visualization(W3,experiment3)

figname  = 'M3';
folder = figures_folder;
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);

%%
subject4 = [437,1420, -0.457,-1230, 415, 175.8257,-1.9,0.5,0, 15.9, 1.96];
xrange4 = [-32,32];
yrange4 = [-24,24];
experiment4 = experiment;
[W4, M4, experiment4.nx, experiment4.ny] = encoder_v2(subject4, experiment4, ignore_pickle , 0, 'xrange', xrange, 'yrange', yrange,'save_encoder', 0);
fig = matrix_visualization(W4,experiment4)

figname  = 'M4';
folder = figures_folder;
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);



%%
N = 3;
mr =  2;
mc = N;
i = 0;
k=49;

h=figure('units','centimeters','outerposition',1+[0 0 16 0.5*16]);

tiledlayout(mr,mc, 'TileSpacing', 'compact', 'padding','compact');

h.Color =  [1 1 1];
h.Name = 'Receptive fields';

for i = 1:N

    if i ==1
        W = W2';
        experiment = experiment2;
    elseif i ==2
        W = W3';
        experiment = experiment3;
    elseif i == 3
        W = W4';
        experiment = experiment4;
    end

    bottom=min(min(W));
    top=max(max(W));
    if bottom<0 && 0<top
        a=max(abs(bottom),top);
        Clim=[-a,a];
    else
        Clim=[bottom,top];
    end

    nexttile(i);
    imagesc(imresize(reshape(W(:,k), experiment.ny, experiment.nx), [57,93]), Clim)
    set(gca,'YDir','normal')
    colormap('gray')
    set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[],'dataAspectRatio',[1 1 1])
    title(['Subject ', num2str(i+1)])

end


task = 'Snellen';
contrast = 1;

for i = 1:3
    hi = nexttile;
     if i ==1
        W = W2;
        M = M2;
        experiment = experiment2;
    elseif i ==2
        W = W3;
        M = M3;
        experiment = experiment3;
    elseif i == 3
        W = W4;
        M = M4;
        experiment = experiment4;
    end

    S = compute_stimulus(experiment, task, 1*display_size(1), display_width, display_height, Stimuli_folder, contrast,'stim', 'A');
    S = imresize(S, [experiment.ny, experiment.nx], 'method', 'bilinear');
    S=S(:);
    p = vision_model(M,W ,S);
    %p = p*(max(p)/255);
    imagesc(reshape(p,experiment.ny,experiment.nx));
    set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[],'dataAspectRatio',[1 1 1], 'Fontsize', Fontsize),
    hi.CLim = [0, 255];
    hYLabel = get(gca,'YLabel');
    %set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
    %title({'Optimal $W$', ['RMSE = ' num2str(sqrt(mse(popt,S)))]})
    colormap('gray')
 
end

figname  = 'optimal_encoders_comparison';
folder = figures_folder;
savefig(h, [folder,'/', figname, '.fig'])
exportgraphics(h, [folder,'/' , figname, '.pdf']);
exportgraphics(h, [folder,'/' , figname, '.png'], 'Resolution', 300);



