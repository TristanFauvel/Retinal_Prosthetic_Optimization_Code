reload = 0;
[val_optimized_preference_acq_evolution, val_optimized_preference_random_evolution, val_optimized_preference_acq_misspecification_evolution, val_optimized_E_TS_evolution] = load_values_evolution(reload);
graphics_style_paper;

fig=figure('units','centimeters','outerposition',1+[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
options.handle = fig;
options.alpha = 0.2;
options.error= 'std';
options.line_width = linewidth;
options.color_area = C(1,:);
options.color_line = C(1,:);
h1=plot_areaerrorbar(val_optimized_preference_acq_evolution', options); hold on;
options.color_area = C(2,:);
options.color_line = C(2,:);
h2=plot_areaerrorbar(val_optimized_preference_random_evolution', options); hold on;
legendstr={'Adaptive pref.','', 'Non-adaptive pref.', '', 'Challenge miss.', ''};
legend([h1 h2], 'Adaptive pref.', 'Random', 'Challenge miss.');
box off
xlabel('Iteration')
ylabel('Value');


reload = 0;
[val_optimized_preference_acq_evolution_combined, val_optimized_preference_random_evolution_combined] = load_values_evolution_combined_data(reload);
graphics_style_paper;

fig=figure('units','centimeters','outerposition',1+[0 0 16 1/2*16]);
fig.Color =  [1 1 1];
options.handle = fig;
options.alpha = 0.2;
options.error= 'std';
options.line_width = linewidth;
options.color_area = C(1,:);
options.color_line = C(1,:);
h1=plot_areaerrorbar(val_optimized_preference_acq_evolution_combined', options); hold on;
options.color_area = C(2,:);
options.color_line = C(2,:);
h2=plot_areaerrorbar(val_optimized_preference_random_evolution_combined', options); hold on;
% options.color_area = [26, 127, 46]./255;    % Green theme
% options.color_line = [26, 127, 46]./255;
% h3=plot_areaerrorbar(val_optimized_preference_acq_misspecification_evolution(:,1:10)', options); hold on;
legendstr={'Adaptive pref.','', 'Non-adaptive pref.', '', 'Challenge miss.', ''};
legend([h1 h2], 'Adaptive pref.', 'Random', 'Challenge miss.', 'location', 'northwest');
box off
xlabel('Iteration')
ylabel('Value');
legend box off
