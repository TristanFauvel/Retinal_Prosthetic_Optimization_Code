function plot_figure12(id, varargin)
%% Plot the preference results with the misspecified encoder
add_modules;
add_directories;
 
load('subjects_to_remove.mat', 'subjects_to_remove') %remove data from participants who did not complete the experiment;
T = load(data_table_file).T;
T = T(all(T.Subject ~= subjects_to_remove,2),:);

if ~isempty(varargin)
    subjects_to_keep = varargin{1};
    T = T(any(T.Subject == subjects_to_keep,2),:);
end


T = T(T.Acquisition == 'MUC' & T.Misspecification == 1,:);

index = 2;
task = char(T(index,:).Task);
subject = char(T(index,:).Subject);
filename_base = [task,'_', subject, '_', subject,'_',num2str(T(index,:).Index)];
figure_directory = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/Figures/'];

filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
load(filename, 'experiment');
UNPACK_STRUCT(experiment, false)

add_modules;
add_directories;

optimal_magnitude = 1;
[Wopt, Mopt, nx,ny] = encoder(true_model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
[Wmiss, Mmiss, nx,ny] = encoder(model_params, experiment,ignore_pickle, optimal_magnitude, 'pymod', pymod);
[popt, pmax] = vision_model(M,Wopt,S);
[pmiss, pmax] = vision_model(M,Wmiss,S);

data_directory = [experiment_directory,'/Data'];
figures_folder = [experiment_directory,'/Figures'];
reload = 0;
[VA_E_optimized_preference_acq, VA_Snellen_optimized_preference_acq, VA_E_optimal,VA_Snellen_optimal, VA_E_optimized_preference_random,VA_Snellen_optimized_preference_random, VA_E_optimized_preference_acq_misspecification, VA_Snellen_optimized_preference_acq_misspecification, VA_E_optimal_misspecification,VA_Snellen_optimal_misspecification, VA_E_optimized_E_TS,VA_Snellen_optimized_E_TS, VA_E_control,VA_Snellen_control] = load_VA_results(reload);
[Pref_vs_E_training, Pref_vs_E_test, acq_vs_random_training, acq_vs_random_test, acq_vs_opt_training, acq_vs_opt_test, optimized_misspecified_vs_optimized_training, optimized_misspecified_vs_optimized_test]  = load_preferences(reload);
boxp = 1;

VA_scale_E= [min([VA_E_optimized_preference_acq,VA_E_optimized_preference_random,VA_E_control]), max([VA_E_optimized_preference_acq,VA_E_optimized_preference_random,VA_E_control])];
VA_scale_Snellen=[min([VA_Snellen_optimized_preference_acq,VA_Snellen_optimized_preference_random,VA_Snellen_control]), max([VA_Snellen_optimized_preference_acq,VA_Snellen_optimized_preference_random,VA_Snellen_control])];
VA_scale_E = [VA_scale_E;VA_scale_E];
VA_scale_Snellen = [VA_scale_Snellen;VA_scale_Snellen];
pref_scale = [0,1;0,1];

k = 1;

mr = 2;
mc = 4;

fig=figure('units','centimeters','outerposition',1+f*[0 0 16 2/3*16]);
fig.Color =  [1 1 1];
fig.Name = 'Ground truth vs misspecified';

tiledlayout(mr,mc, 'TileSpacing', 'tight')

nexttile()
xlabels = {'Optimization set','Transfer set'};
ylabels = {'Preference',''};
Y = {1-optimized_misspecified_vs_optimized_training, 1-optimized_misspecified_vs_optimized_test};
scatter_bar(Y, xlabels, ylabels{1},'boxp', boxp,'stat', 'median', 'pval', 'ineq');
text(-0.18,1.15,'$\bf{E}$','Units','normalized','Fontsize', letter_font)


figname  = ['Figure',num2str(id)];
folder = [[figures_folder, '/'],figname];
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);
