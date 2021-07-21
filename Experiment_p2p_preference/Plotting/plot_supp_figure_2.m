%% Transfer set set vs training set
fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
mr= 2;
mc = 2;
fig.Color =  [1 1 1];
subplot(mr, mc,1)
x =acq_vs_opt_training;
y= acq_vs_opt_test;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Optimization set', 'Transfer set',[]); % H1: x – y come from a distribution with greater than 0
text(-0.18,1.15,'A','Units','normalized','Fontsize', letter_font,'FontWeight', 'Bold')
title('Challenge vs Ground truth')

subplot(mr,mc,2)
x = acq_vs_random_training;
y = acq_vs_random_test;
tail = 'both';
scatter_plot(x,y, tail,'Optimization set', '',[]);  %H1 : x – y come from a distribution with median different than 0
text(-0.18,1.15,'B','Units','normalized','Fontsize', letter_font,'FontWeight', 'Bold')
title('Challenge vs Random')

subplot(mr,mc,3)
x = Pref_vs_E_training;
y = Pref_vs_E_test;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Optimization set', '',[]); %H1 : x – y come from a distribution with median greater than 0
text(-0.18,1.15,'C','Units','normalized','Fontsize', letter_font,'FontWeight', 'Bold')
title('Challenge vs TS')

subplot(mr,mc,4)
x = 1-optimized_misspecified_vs_optimized_training;
y = 1-optimized_misspecified_vs_optimized_test;
tail = 'both'; %'right';
scatter_plot(x,y, tail,'Optimization set', '',[]); %H1 : x – y come from a distribution with median greater than 0
title('Ground truth vs misspecified')
text(-0.18,1.15,'D','Units','normalized','Fontsize', letter_font,'FontWeight', 'Bold')
