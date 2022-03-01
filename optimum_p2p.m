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



%true_model_params = [410,1190,0,0,0,175.8257,-1.9,0.5,0];
%xrange = [-13, 10];
%    yrange = [-7, 7];
xrange = [-18, 16];
yrange = [-11, 11];
% experiment.n_ax_segments = int64(600);
% experiment.n_axons= int64(1000);
% experiment.xystep= 0.25;

pymod = [];
ignore_pickle=1; % Wether to use a precomputed axon map (0) or not (1)
optimal_magnitude = 1;

[~, ~, experiment.nx,experiment.ny] = encoder(true_model_params, experiment,ignore_pickle, 0, 'pymod', pymod, 'xrange', xrange, 'yrange', yrange, 'save_encoder', 0);

S = compute_stimulus(experiment, task, 0.8*display_size(1), display_width, display_height, Stimuli_folder, contrast,'stim', 'A');
S = imresize(S, [experiment.ny, experiment.nx], 'method', 'bilinear');
S=S(:);

nsamples = 1000;
E = NaN(1,nsamples);
E_approx = NaN(1,nsamples);
E_num = NaN(1,nsamples);

options.StepTolerance = 1e-4;
options.OptimalityTolerance = 1e-5;
    options.Display = 'iter';

for i =1:nsamples
    [rho,lambda, rot, center_x, center_y, magnitude, ~, ~,z, lb, ub, model_lb, model_ub] = sample_perceptual_model(to_update, default_values, rho_range,lambda_range,rot_range,center_x_range,center_y_range,beta_sup_range,beta_inf_range,z_range,magnitude_range);
    beta_sup = beta_sup_range(2);
    beta_inf = beta_inf_range(2);
    true_model_params = [rho,lambda, rot, center_x, center_y, magnitude, beta_sup, beta_inf,z]';
    experiment.true_model_params = true_model_params;
    [Wopt, M] = encoder(true_model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod, 'xrange', xrange, 'yrange', yrange, 'save_encoder', 0);
    papprox = vision_model(M,Wopt ,S);
    papprox = papprox*255./max(papprox);

    fun = @(a) sqrt(mse(vision_model_amplitudes(M,a)/255,S));
    x0 = pinv(M)*S;
    [x, fval, exitflag, output] = fminunc(fun,x0, options);
    pnum = vision_model_amplitudes(M,x);

    E(i) = sqrt(mse(papprox/255,pnum/255));
    E_num(i) = sqrt(mse(pnum/255,S));
    E_approx(i)= sqrt(mse(papprox/255,S));
end

graphics_style_paper;
mr = 1;
mc = 2;
 fig=figure('units','centimeters','outerposition',1+[0 0 16 0.5*16]);
fig.Color =  [1 1 1];
tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','compact');
h =  nexttile;
scatter(E_num, E_approx, markersize, C(1,:) , 'filled'); hold on;
xlim([min([E_num, E_approx]), max([E_num, E_approx])])
ylim([min([E_num, E_approx]), max([E_num, E_approx])])
xlabel('RMSE(stimulus, percept with $M_\phi^\dagger$)', 'Interpreter','latex')
ylabel('RMSE(stimulus, percept with $W_\phi$)', 'Interpreter','latex')
nexttile()
histogram(E, 'FaceColor', C(1,:))
xlabel('RMSE between percepts with $M_\phi^\dagger$ and $W_\phi$', 'Interpreter','latex')
box off


figname  = 'Optimality';
folder = '/home/tfauvel/Documents/PhD/Figures/Paper_figures/';
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);




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

    h =  nexttile;
    i=i+1;
    imagesc(reshape(papprox*255/max(papprox),experiment.ny,experiment.nx));
    set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[],'dataAspectRatio',[1 1 1], 'Fontsize', Fontsize),
    h.CLim = [0, 255];
    hYLabel = get(gca,'YLabel');
    set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')   
    colormap('gray')
    title('$M_\phi^\dagger$')

    h = nexttile;
    i=i+1;
    imagesc(reshape(pnum,experiment.ny,experiment.nx));
    set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[],'dataAspectRatio',[1 1 1], 'Fontsize', Fontsize)
    h.CLim = [0, 255];
    hYLabel = get(gca,'YLabel');
    set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
    colormap('gray')
    title('$W_\phi$')
    figname  = 'Optimality_percepts';
folder = '/home/tfauvel/Documents/PhD/Figures/Paper_figures/';
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);
