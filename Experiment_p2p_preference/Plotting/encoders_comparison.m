function [p_after_optim, p_opt, p_control, p_after_optim_rand, nx,ny] = encoders_comparison(s_index, T)
add_directories;

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

Stimuli_folder = [Stimuli_folder, '/letters'];
S = load_stimuli_letters(experiment);
best_params = model_params*ones(1,maxiter);
best_params(ib,:) = x_best(ib,:);
pymod = [];
ignore_pickle=1; % Wether to use a precomputed axon map (0) or not (1)
optimal_magnitude = 0;
[~, M, nx,ny] = encoder(true_model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
g = @(x, optimal_magnitude) loss_function(M, x, S, experiment, 'optimal_magnitude', optimal_magnitude);
[~,p_after_optim] = g(best_params(:,end), []);
[~,p_opt] = g(model_params, 1);
x_control = model_params;
x_control(ib) = xtrain(ib,1);
[~,p_control] = g(x_control, []);

%%
task = char(T(s_index,:).Task);
subject = char(T(s_index,:).Subject);
acquisition = 'random';
model_seed = T(s_index,:).Model_Seed;
j = T(T.Subject == subject & T.Task == task & T.Acquisition == acquisition & T.Misspecification == 0 & T.Model_Seed == model_seed,:).Index;
filename = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', 'random', '_experiment_',num2str(j)];
load(filename, 'experiment');
best_params_rand= experiment.model_params*ones(1,maxiter);
best_params_rand(ib,:) = experiment.x_best(ib,:);
% [~, M, nx,ny] = encoder(true_model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
% g = @(x) loss_function(M, x, S, experiment);
[~,p_after_optim_rand] = g(best_params_rand(:,end), []);

