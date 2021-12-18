function [W, Mest, nx, ny] = encoder(xparams, experiment, ignore_pickle, optimal_magnitude, varargin)

opts = namevaluepairtostruct(struct( ...
    'pymod', [], ...
    'xrange', [-18, 16], ...
    'yrange', [-11, 11], ...
    'save_encoder', 1 ...
    ), varargin);
UNPACK_STRUCT(opts, false)

if nargin ==2
    ignore_pickle = 1;
end
n_ax_segments = experiment.n_ax_segments;
n_axons= experiment.n_axons;
xystep= experiment.xystep;

add_directories;


rho = xparams(1);
axlambda = xparams(2);
rot = xparams(3);
center_x = xparams(4);
center_y = xparams(5);
magnitude_factor = xparams(6);
beta_sup = xparams(7);
beta_inf = xparams(8);
z = xparams(9);

try
    if strcmp(experiment.p2p_version, 'stable')
        perceptual_models_directory = stable_perceptual_models_directory;
        perceptual_model_table_file = stable_perceptual_model_table_file;
    elseif strcmp(experiment.p2p_version, 'latest')
        perceptual_models_directory = latest_perceptual_models_directory;
        perceptual_model_table_file = latest_perceptual_model_table_file;
    end
catch
    perceptual_models_directory = stable_perceptual_models_directory;
    perceptual_model_table_file = stable_perceptual_model_table_file;
end

perceptual_model_filename = [perceptual_models_directory, '/',experiment.implant_name, '_rho_',num2str(rho),'_lambda_', num2str(axlambda), '_rot_',num2str(rot),'_center_x_',num2str(center_x), '_center_y_', num2str(center_y),'_z_',num2str(z), '_beta_sup_',num2str(beta_sup), '_beta_inf_',num2str(beta_inf), '_naxons',num2str(n_axons),'_naxsegments', num2str(n_ax_segments),'.mat'];
% Check if the perceptual model has already been computed before

if save_encoder && isfile(perceptual_model_filename)
    M = load(perceptual_model_filename, 'M');
    M = M.M;
else
    cd([code_directory,'/Experiment'])
    if isempty(pymod)
        if strcmp(experiment.p2p_version, 'stable')
            pymod = py.importlib.import_module('perceptual_model');
        elseif strcmp(experiment.p2p_version, 'latest')
            pymod = py.importlib.import_module('perceptual_model_latest');
        end
    end
    py_xrange = py.list(xrange);
    py_yrange = py.list(yrange);

    kwargs = pyargs('rho', rho, 'axlambda', axlambda, 'x', center_x, 'y', center_y, 'z', z, 'rot', rot, 'eye','RE','xrange', py_xrange, 'yrange', py_yrange, 'xystep', xystep, 'n_ax_segments', n_ax_segments, 'n_axons', n_axons, 'beta_sup', beta_sup, 'beta_inf', beta_inf, 'ignore_pickle', ignore_pickle, 'implant_name', experiment.implant_name);

    M = double(pymod.Compute_perceptual_model(kwargs));

    save(perceptual_model_filename, 'M');

    implant = convertCharsToStrings(experiment.implant_name);

    T = table(implant, rho, axlambda, center_x, center_y, z, rot, beta_sup, beta_inf, xrange, yrange, xystep,n_ax_segments,n_axons);
    PModel_table = load(perceptual_model_table_file);
    T = [PModel_table.T;T];
    if save_encoder
    save(perceptual_model_table_file,'T')
    end
end
nx= size(M, 2);
ny = size(M,1);

Mest= reshape(M, [],experiment.n_electrodes);
W= pinv(Mest);

if nargin > 3 && optimal_magnitude == 1
    display_size = floor(experiment.display_size);
    Stimuli=  [Stimuli_folder, '/letters'];

    stim_size = floor(0.9*display_size(1));
    S = load_Snellen(experiment.display_width, experiment.display_height, Stimuli, stim_size , 'A');
    S = imresize(S, [experiment.ny, experiment.nx], 'method', 'bilinear');
    S=S(:);
    [P,pmax] = vision_model(Mest,W,S); %assumes we know the true model;

    magnitude_factor = 255/pmax;
end

W= magnitude_factor*W;

return
