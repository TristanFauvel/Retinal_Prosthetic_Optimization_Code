function elements_of_figure4(id)

%% Plot the results of the preference-based optimization

add_directories
graphics_style_paper;

data_directory = [experiment_path,'/Data'];
figures_folder = [experiment_path,'/Figures'];
reload = 0;
VA= load_VA_results(reload, data_directory, data_table_file);
p  = load_preferences(reload,data_directory, data_table_file);

val = load_values_evolution_combined_data(reload);

boxp = 1;

VA_scale_E= [min([VA.VA_E_optimized_preference_acq,VA.VA_E_optimized_preference_random,VA.VA_E_control]), max([VA.VA_E_optimized_preference_acq,VA.VA_E_optimized_preference_random,VA.VA_E_control])];
VA_scale_Snellen=[min([VA.VA_Snellen_optimized_preference_acq,VA.VA_Snellen_optimized_preference_random,VA.VA_Snellen_control]), max([VA.VA_Snellen_optimized_preference_acq,VA.VA_Snellen_optimized_preference_random,VA.VA_Snellen_control])];

VA_scale = [min(VA_scale_E(1), VA_scale_Snellen(1)),max(VA_scale_E(2), VA_scale_Snellen(2))];
VA_scale = [VA_scale;VA_scale];

VA_scale_E = [VA_scale_E;VA_scale_E];
VA_scale_Snellen = [VA_scale_Snellen;VA_scale_Snellen];

pref_scale = [0,1;0,1];

%%
T = load(data_table_file).T;
T= T(T.Acquisition == 'maxvar_challenge' & T.Misspecification == 0, :);
index = 7;
filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];

load(filename, 'experiment')
exp = experiment;
filename_base = [exp.task,'_', exp.subject, '_', exp.acquisition_fun_name,'_',num2str(exp.index)];

add_directories;
figure_directory = [data_directory, '/Data_Experiment_p2p_',exp.task,'/',exp.subject,'/Figures/'];

if ~exist(figure_directory,'dir')
    mkdir(figure_directory)
end

if strcmp(exp.implant_name, 'Argus II')
    im_ny = floor(0.9*exp.ny);
    im_nx = floor(0.9*exp.nx);
elseif strcmp(exp.implant_name, 'PRIMA')
    im_ny = floor(0.5*exp.ny);
    im_nx = floor(0.5*exp.nx);
end
image_size = [im_ny, im_nx];


Stimuli_folder =  [Stimuli_folder,'/letters'];
S = load_stimuli_letters(experiment)
    
best_params = exp.model_params*ones(1,exp.maxiter);
best_params(exp.ib,:) = exp.x_best(exp.ib,:);
g = @(x, optimal_magnitude) loss_function(exp.M, x, S, experiment, 'optimal_magnitude', optimal_magnitude);
[~,p_after_optim] = g(best_params(:,end), []);
[~,p_opt] = g(exp.model_params, 1);

%% Compute the naive encoder
Wi=  naive_encoder(experiment);

range = [2.^(1:floor(log2(exp.maxiter))), exp.maxiter];
nk = numel(range);
percept= [];

for k = 1:nk
    [~,p_optimized] = g(best_params(:,range(k)), []);
    percept = [percept,p_optimized(:,1)];
end

nl = 10;
p = vision_model(exp.M,Wi,S);
graphics_style_paper;

%%
letter2number = @(c)1+lower(c)-'a';
range = [2.^(1:floor(log2(exp.maxiter))), exp.maxiter];
nk = numel(range);
p1= [];
p2= [];
popt = [];
for k = 1:nk
    xm = exp.model_params;
    xm(exp.ib) = exp.xtrain(1:exp.d,range(k));
    [~,percept] = g(xm, []);
    letter = letter2number(experiment.displayed_stim{k});
    p1 = [p1, percept(:,letter)];
    xm = exp.model_params;
    xm(exp.ib) = exp.xtrain((exp.d+1):end,range(k));
    
    [~,percept] = g(xm, []);
    p2 = [p2, percept(:,letter)];
    
     [~,percept] = g(exp.x_best(:, range(k)), []);

%     [~,percept] = g(x_best_unknown_hyps(:, range(k)));
    popt = [popt, percept(:,1)];
end

letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
%%
mr = 6;
mc = 3;

fig=figure('units','centimeters','outerposition',1+[0 0 16 1.5/2*16]);
fig.Color =  [1 1 1];
fig.Name = 'Fraction preferred';
layout1 = tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','compact');
nt=3;
c = 0;
s=1;
i=0;
ny = exp.ny;
nx = exp.nx;
for k = 1:nk
    c=c+1;
    img1 = reshape(p1(:,k),ny,nx);
    rgbImage1 = cat(3, img1, img1, img1)./255;
    img2 = reshape(p2(:,k),ny,nx);
    rgbImage2 = cat(3, img2, img2, img2)./255;

    if exp.ctrain(range(k))
        rgbImage1= addborder(rgbImage1, 3,[1,0,0], 'center');
    else
        rgbImage2= addborder(rgbImage2, 3,[1,0,0], 'center');
    end
            h = nexttile(layout1, 1+(c-1)*nt);

        hi = imshow(rgbImage1);
    set(gca,'xtick',[],'ytick',[],'title',[]); 
    set(gca,'dataAspectRatio',[1 1 1])
    h.CLim = [0, 255];

    if k==1
        text(-0.525641025641026, 1.14553014553015,'Iteration','Units','normalized','Fontsize', letter_font)
    end
    %     title(range(k));
    ylabel(num2str(range(k)));
    hYLabel = get(gca,'YLabel');
    set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')

    h = nexttile(layout1,2+(c-1)*nt);

            imshow(rgbImage2);
    axis off
    set(gca,'dataAspectRatio',[1 1 1])
    h.CLim = [0, 255];
    
     h = nexttile(layout1,3+(c-1)*nt);
    imshow(reshape(popt(:,k),ny,nx));
    axis off
    set(gca,'dataAspectRatio',[1 1 1])
    h.CLim = [0, 255];
   
  
end
colormap('gray')

folder = [paper_figures_folder,'Figure_',num2str(id),'/'];
if ~isdir(folder)
    mkdir(folder)
end

figname  = ['Figure',num2str(id),'_1'];
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);


%
s_index = 7; %7 11 13
T = load(data_table_file).T;
[p_after_optim, p_opt, p_control, p_after_optim_rand, nx,ny] = encoders_comparison(s_index, T);
mr = 2;
mc = 4;
k = 1;
fig=figure('units','centimeters','outerposition',1+[0 0 16 1.5/2*16]);
fig.Color =  [1 1 1];
fig.Name = 'Fraction preferred';
layout3 = tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','compact');

h = nexttile(layout3);
i=i+1;
% h = subplot(mr,mc,[1,3])
imagesc(reshape(p_opt(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
set(gca,'dataAspectRatio',[1 1 1])
h.CLim = [0, 255];
title('Ground truth')
% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

h = nexttile(layout3);
i=i+1;
% h = subplot(mr,mc,[4,6])
imagesc(reshape(p_after_optim(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
set(gca,'dataAspectRatio',[1 1 1])
h.CLim = [0, 255];
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
title('MaxVarChallenge')
% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

h = nexttile(layout3);
i=i+1;
% h = subplot(mr,mc,[10,12])
imagesc(reshape(p_after_optim_rand(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
set(gca,'dataAspectRatio',[1 1 1])
h.CLim = [0, 255];
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
title('Random')
% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

h =nexttile(layout3);
i=i+1;
% h = subplot(mr,mc,[13,15])
imagesc(reshape(p_control(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
set(gca,'dataAspectRatio',[1 1 1])
h.CLim = [0, 255];
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
title('Control')
colormap('gray')
% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

figname  = ['Figure',num2str(id),'_2'];
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);

%%
i = 0;
fig=figure('units','centimeters','outerposition',1+[0 0 0.5*16 0.5*16]);
fig.Color =  [1 1 1];
options.handle = fig;
options.alpha = 0.2;
options.error= 'std';
options.line_width = linewidth;
options.color_area = C(1,:);%./255;    % Blue theme
options.color_line = C(1,:);%./255;
h1=plot_areaerrorbar(val.optimized_preference_acq_evolution_combined', options); hold on;
options.color_area = C(2,:);%./255;    % Orange theme
options.color_line = C(2,:);%./255;
h2=plot_areaerrorbar(val.optimized_preference_random_evolution_combined', options); hold on;
legendstr={'Challenge','', 'Random', '', 'Challenge miss.', ''};
legend([h1 h2], 'Challenge', 'Random', 'Challenge miss.', 'location', 'northwest');
box off
xlabel('Iteration')
ylabel('Value');
legend box off
figname  = ['Figure',num2str(id),'_3'];
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);


%%

fig=figure('units','centimeters','outerposition',1+[0 0 0.5*16 height(1)]);
fig.Color =  [1 1 1];
fig.Name = 'Fraction preferred';
xlabels = {'Control', 'Random','Ground truth'};
ylabels = {'Fraction preferred',''};

layout = tiledlayout(1,2, 'TileSpacing', 'tight', 'padding','compact');
h = nexttile();
i=i+1;
x = p.acq_vs_random_training;
y = p.acq_vs_random_test;
tail = 'both';
scatter_plot(x,y, tail,'Optimization set', 'Transfer set',pref_scale, 'title_str', 'Random');  %H1 : x – y come from a distribution with median different than 0
text(-0.18,1.15,['$\bf{', letters(i), '}$'], 'Units','normalized','Fontsize', letter_font)

nexttile()
i=i+1;
x =p.acq_vs_opt_training;
y= p.acq_vs_opt_test;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Optimization set', '',pref_scale,'title_str', 'Ground truth'); % H1: x – y come from a distribution with greater than 0
    text(-0.18,1.15,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

figname  = ['Figure',num2str(id),'_5'];
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);

%%
i = 0;
fig=figure('units','centimeters','outerposition',1+[0 0 0.5*16 1/2*16]);
fig.Color =  [1 1 1];
fig.Name = 'Fraction preferred';
xlabels = {'Naive','Control','Random','Ground truth'};
ylabels = {'Fraction preferred',''};

Y = {p.optimized_vs_naive_training, p.acq_vs_control_training, p.acq_vs_random_training, p.acq_vs_opt_training};

scatter_bar(Y, xlabels, ylabels{1},'boxp', boxp,'stat', 'median', 'pval', 'ineq');
 i=i+1;
text(-1.22,1.05,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize',letter_font) %with compact margins

figname  = ['Figure',num2str(id),'_3'];
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);
