function plot_figure_E_Snellen(id)
%% Plot the comparisons between Snellen VA and Tumbling E VA.
reload = 0;
add_directories;

VA = load_VA_results(reload,data_directory, data_table_file);

graphics_style_paper;
letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
i = 0;
mr = 1;
mc = 4;
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','tight')
nexttile();
i = i+1;
x = VA.VA_E_control;
y= VA.VA_Snellen_control;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Tumbling E', 'Snellen',[], 'equal_axes', 0, 'linreg', 1,'title_str', 'Control'); % H1: x – y come from a distribution with greater than 0
text(-0.18,1.15,'$\bf{A}$','Units','normalized','Fontsize',  letter_font)

nexttile();
i = i+1;
x = VA.VA_E_optimal;
y = VA.VA_Snellen_optimal;
tail = 'both';
scatter_plot(x,y, tail,'Tumbling E', '', [], 'equal_axes', 0, 'linreg', 1, 'title_str', 'Ground truth'); %H1 : x – y come from a distribution with median different than 0*
text(-0.18,1.15,'$\bf{B}$','Units','normalized','Fontsize',  letter_font)

nexttile();
i = i+1;
x = VA.VA_E_optimized_preference_random;
y = VA.VA_Snellen_optimized_preference_random;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Tumbling E', '', [], 'equal_axes', 0,  'linreg', 1,'title_str', 'Random');  %H1 : x – y come from a distribution with median greater than 0
text(-0.18,1.15,'$\bf{C}$','Units','normalized','Fontsize',  letter_font)

nexttile();
i = i+1;
x = VA.VA_E_optimized_preference_acq;
y= VA.VA_Snellen_optimized_preference_acq;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Tumbling E', 'Snellen', [], 'equal_axes', 0,  'linreg', 1,'title_str', 'Challenge');  % H1: x – y come from a distribution with greater than 0
text(-0.18,1.15,'$\bf{D}$','Units','normalized','Fontsize',  letter_font)

fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
fig.Color =  [1 1 1];fig.Name = 'VA Snellen vs E';
subplot(mr,mc,2)
VA.VA_E = [VA.VA_E_optimized_preference_acq,  VA.VA_E_optimal, VA.VA_E_optimized_preference_random, VA.VA_E_optimized_preference_acq_misspecification, VA.VA_E_optimal_misspecification, VA.VA_E_optimized_E_TS, VA.VA_E_control];
VA_S = [VA.VA_Snellen_optimized_preference_acq,  VA.VA_Snellen_optimal, VA.VA_Snellen_optimized_preference_random, VA.VA_Snellen_optimized_preference_acq_misspecification, VA.VA_Snellen_optimal_misspecification, VA.VA_Snellen_optimized_E_TS, VA.VA_Snellen_control];
x  = VA.VA_E;
y = VA_S;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Tumbling E', 'Snellen',[], 'equal_axes', 0, 'linreg', 1); % H1: x – y come from a distribution with greater than 0


figname  = ['Figure',num2str(id)];
folder = [paper_figures_folder,'Figure_',num2str(id),'/'];
if ~isdir(folder)
    mkdir(folder)
end
savefig(fig, [folder,'/', figname, '.fig'])
exportgraphics(fig, [folder,'/' , figname, '.pdf']);
exportgraphics(fig, [folder,'/' , figname, '.png'], 'Resolution', 300);
