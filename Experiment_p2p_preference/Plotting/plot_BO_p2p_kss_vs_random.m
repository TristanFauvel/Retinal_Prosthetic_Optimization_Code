function plot_BO_p2p_kss_vs_random(seed, subject)
add_directories;

% seed = 5;
% subject = 'TF';
T= load(data_table_file).T;
T=T(T.Seed== seed & T.Subject== subject,:);
T=[T(end-8,:);T(end-3:end,:)];
% T=T([6,7],:);

filenames = [];
for k = 1:size(T,1)
    task = cellstr(T(k,:).Task);
    task = task{1};
    acquisition_fun_name = cellstr(T(k,:).Acquisition);
    acquisition_fun_name = acquisition_fun_name{1};
    index = T(k,:).Index;
    filenames{k} = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
    
    if strcmp(acquisition_fun_name, 'random') && strcmp(task,'preference')
        filename_random = filenames{k};
    elseif strcmp(acquisition_fun_name, 'random') && strcmp(task,'E')
        filename_E_random = filenames{k};
    elseif strcmp(acquisition_fun_name, 'TS_binary') && strcmp(task,'E')
        filename_E_TS = filenames{k};        
    elseif strcmp(acquisition_fun_name, 'kernelselfsparring')
        filename_kss = filenames{k};
    elseif strcmp(acquisition_fun_name, 'Brochu_EI')
        filename_bei = filenames{k};
    end
end

acuity = [];
load(filename_random)
UNPACK_STRUCT(experiment, false)
x_best_random = experiment.x_best(:,end);
rmse_random = experiment.rmse;
values_random = experiment.values;
acuity = [acuity, acuity_E_optimized];

load(filename_kss)
UNPACK_STRUCT(experiment, false)
x_best_kss = experiment.x_best(:,end);
rmse_kss = experiment.rmse;
values_kss = experiment.values;
acuity = [acuity, acuity_E_optimized];

load(filename_bei)
UNPACK_STRUCT(experiment, false)
x_best_bei = experiment.x_best(:,end);
rmse_bei = experiment.rmse;
values_bei = experiment.values;
acuity = [acuity, acuity_E_optimized];

load(filename_E_TS)
UNPACK_STRUCT(experiment, false)
x_best_E_TS = experiment.x_best(:,end);
rmse_E_TS = experiment.rmse;
values_E_TS = experiment.values;
acuity = [acuity, acuity_E_optimized];

load(filename_E_random)
UNPACK_STRUCT(experiment, false)
x_best_E_random = experiment.x_best(:,end);
rmse_E_random = experiment.rmse;
values_E_random = experiment.values;
acuity = [acuity, acuity_E_optimized];

acuity = log10(10./acuity);

figure()
plot(values_random); hold on;
plot(values_kss); hold off;
legend('kss','random')


% graphics_paper;
figure();
plot(rmse_kss); hold on;
plot(rmse_random); hold off
legend('kss','random')

cmap = gray(256);

letter_folder =  Stimuli_folder;
S = load_stimuli_letters(experiment);

W1 = encoder(x_best_kss, experiment,ignore_pickle);
p_kss = vision_model(M,W1,S(:,1));
percept_kss = reshape(p_kss, ny,nx);
percept_kss = imresize(percept_kss, display_size,  'method', 'bilinear');

W2 = encoder(x_best_random, experiment,ignore_pickle);
p_random = vision_model(M,W2,S(:,1));
percept_random = reshape(p_random, ny,nx);
percept_random = imresize(percept_random, display_size,  'method', 'bilinear');

clims = [0,255];
fig1= figure(1);
fig1.Color =  [0 0 0];
subplot(1,2,1)
imagesc(percept_kss,clims)
colormap(cmap);
title('kss')
set(gca,'XColor', 'none','YColor','none')
daspect([1 1 1])
subplot(1,2,2)
imagesc(percept_random,clims)
colormap(cmap);
set(gca,'XColor', 'none','YColor','none')
daspect([1 1 1])
    
    
[x_best, values] = compute_GP_max_combined_data(filenames, 1);    

figure()
plot(values(1,:)); hold on;
    plot(values(2,:)); hold on;
legend('kss','random')