function elements_of_figure5(id)
%% Plot the results of the preference-based optimization

add_modules;

id = 5;
data_directory = [experiment_path,'/Data'];
figures_folder = [experiment_path,'/Figures'];
reload = 0;
VA = load_VA_results(reload, data_directory, data_table_file);
%[Pref_vs_E_training, Pref_vs_E_test, pref.acq_vs_random_training, pref.acq_vs_random_test, pref.acq_vs_opt_training, pref.acq_vs_opt_test, optimized_misspecified_vs_optimized_training, optimized_misspecified_vs_optimized_test,optimized_miss_vs_opt_miss_test, optimized_miss_vs_opt_miss_training, pref.acq_vs_control_test, pref.acq_vs_control_training]  = load_preferences(reload);
pref= load_preferences(reload, data_directory, data_table_file);

boxp = 1;

VA_scale_E= [min([VA.VA_E_optimized_preference_acq,VA.VA_E_optimized_preference_random,VA.VA_E_control]), max([VA.VA_E_optimized_preference_acq,VA.VA_E_optimized_preference_random,VA.VA_E_control])];
VA_scale_Snellen=[min([VA.VA_Snellen_optimized_preference_acq,VA.VA_Snellen_optimized_preference_random,VA.VA_Snellen_control]), max([VA.VA_Snellen_optimized_preference_acq,VA.VA_Snellen_optimized_preference_random,VA.VA_Snellen_control])];

VA_scale = [min(VA_scale_E(1), VA_scale_Snellen(1)),max(VA_scale_E(2), VA_scale_Snellen(2))];
VA_scale = [VA_scale;VA_scale];

VA_scale_E = [VA_scale_E;VA_scale_E];
VA_scale_Snellen = [VA_scale_Snellen;VA_scale_Snellen];

pref_scale = [0,1;0,1];

letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

mr = 1;
mc = 3;
legend_pos = [-0.18,1.15];
graphics_style_paper;

fig=figure('units','centimeters','outerposition',1+[0 0 16 7.5]);
fig.Color =  [1 1 1];
fig.Name = 'Fraction preferred';


i=2;
layout1 = tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','compact');
k=1;

folder = [paper_figures_folder,'Figure_',num2str(id),'/'];
if ~isdir(folder)
    mkdir(folder)
end

I = imread([folder,'/Snellen_chart_and_TumblingE_tasks.png']);
% h = nexttile([1,mc]);
% i=i+1;
% 
% image(I)
% axis image
% axis off

%%%%%%%%%%%%%%%%%%%%%%
% nexttile()
% i=i+1;
% x = pref.acq_vs_control_training;
% y = pref.acq_vs_control_test;
% tail = 'both';
% scatter_plot(x,y, tail,['Fraction preferred ' newline '(Opt. set)'], ['Fraction preferred' newline '(Trans. set)'],pref_scale, 'title_str', 'Control');  %H1 : x – y come from a distribution with median different than 0
% text(-0.18,1.15,['$\bf{', letters(i), '}$'], 'Units','normalized','Fontsize', letter_font)
% 
% nexttile()
% i=i+1;
% x = pref.acq_vs_random_training;
% y = pref.acq_vs_random_test;
% tail = 'both';
% scatter_plot(x,y, tail,['Fraction preferred' newline '(Opt. set)'], '',pref_scale, 'title_str', 'Random');  %H1 : x – y come from a distribution with median different than 0
% text(-0.18,1.15,['$\bf{', letters(i), '}$'], 'Units','normalized','Fontsize', letter_font)
% 
% nexttile()
% i=i+1;
% x =pref.acq_vs_opt_training;
% y= pref.acq_vs_opt_test;
% tail = 'both'; %'right';
% scatter_plot(x,y, tail,['Fraction preferred' newline '(Opt. set)'], '',pref_scale,'title_str', 'Ground truth'); % H1: x – y come from a distribution with greater than 0
% text(-0.18,1.15,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

nexttile()
i=i+1;
x = [pref.acq_vs_control_training, pref.acq_vs_random_training, pref.acq_vs_opt_training];
y = [pref.acq_vs_control_test, pref.acq_vs_random_test, pref.acq_vs_opt_test];
tail = 'both'; %'right';
scatter_plot(x,y, tail, ['Fraction preferred' newline '(Opt. set)'], ['Fraction preferred' newline '(Trans. set)'], pref_scale,'title_str', ''); % H1: x – y come from a distribution with greater than 0
text(-0.18,1.15,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)
% X = {pref.acq_vs_control_training, pref.acq_vs_random_training, pref.acq_vs_opt_training};
% Y = {pref.acq_vs_control_test, pref.acq_vs_random_test, pref.acq_vs_opt_test};
% tail = 'both'; %'right';
% scatter_plot_combined(X,Y, tail, ['Fraction preferred' newline '(Opt. set)'], ['Fraction preferred' newline '(Trans. set)'], pref_scale,'title_str', '', 'categories', {'Control', 'Random', 'Ground truth'}, 'color', C); % H1: x – y come from a distribution with greater than 0
% text(-0.18,1.15,['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

% nexttile()
% % h = subplot(mr,mc,[7,9;16,19])
% i=i+1;
% tail = 'both'; %'right';
% Y{1} = VA.VA_E_optimized_preference_acq;
% X{1} = VA.VA_E_control;
% [h,hleg] = scatter_plot_combined(X,Y, tail, ['LogMAR' newline '(control)'], ['LogMAR' newline '(challenge)'],VA_scale_E, 'categories', {'E'}, 'color', C(1,:));  %H1 : x – y come from a distribution with median greater than 0
% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)
% 
% % nexttile(layout1, (mr/2*mc)+mc/2+1, [mr/2,mc/4])
% nexttile()
% i=i+1;
% Y{1} = VA.VA_Snellen_optimized_preference_acq;
% X{1} = VA.VA_Snellen_control;
% [h,hleg] = scatter_plot_combined(X,Y, tail, ['LogMAR' newline '(control)'],['LogMAR' newline '(challenge)'],VA_scale_Snellen, 'categories', {'Snellen'}, 'color', C(2,:));  %H1 : x – y come from a distribution with median greater than 0
% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)
% 
% nexttile()
% i=i+1;
% tail = 'both'; %'right';
% Y{1} = VA.VA_E_optimized_preference_acq;
% X{1} = VA.VA_E_optimized_preference_random;
% [h,hleg] = scatter_plot_combined(X,Y, tail,['LogMAR' newline '(random)'],['LogMAR' newline '(challenge)'],VA_scale_E, 'categories', {'E'}, 'color', C(1,:));  %H1 : x – y come from a distribution with median greater than 0
% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

% nexttile()
% i=i+1;
% Y{1} = VA.VA_Snellen_optimized_preference_acq;
% X{1} = VA.VA_Snellen_optimized_preference_random;
% [h,hleg] = scatter_plot_combined(X,Y, tail,['LogMAR' newline '(random)'],['LogMAR' newline '(challenge)'],VA_scale_Snellen, 'categories', {'Snellen'}, 'color', C(2,:));  %H1 : x – y come from a distribution with median greater than 0
% text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

clear('X', 'Y')
nexttile()
i=i+1;
Y{1} = VA.VA_E_optimized_preference_acq;
X{1} = VA.VA_E_control;
Y{2} = VA.VA_Snellen_optimized_preference_acq;
X{2} = VA.VA_Snellen_control;
scatter_plot_combined(X,Y, tail,['LogMAR' newline '(control)'],['LogMAR' newline '(challenge)'],VA_scale, 'categories', {'E','Snellen'}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

nexttile()
i=i+1;
Y{1} = VA.VA_E_optimized_preference_acq;
X{1} = VA.VA_E_optimized_preference_random;
Y{2} = VA.VA_Snellen_optimized_preference_acq;
X{2} = VA.VA_Snellen_optimized_preference_random;
scatter_plot_combined(X,Y, tail,['LogMAR' newline '(random)'],['LogMAR' newline '(challenge)'],VA_scale, 'categories', {'E','Snellen'}, 'color', C);  %H1 : x – y come from a distribution with median greater than 0
text(legend_pos(1), legend_pos(2),['$\bf{', letters(i), '}$'],'Units','normalized','Fontsize', letter_font)

figname  = ['Figure',num2str(id),'_2'];

savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);

