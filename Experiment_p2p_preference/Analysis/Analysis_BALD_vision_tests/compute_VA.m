function logMAR = compute_VA(experiment,VA_measure)

UNPACK_STRUCT(VA_measure, false)
add_directories;

threshold = 0.8;
[a b c d lp] = gp(hyp, inf_func, meanfunc, covfunc, likfunc, xtrain_norm', (2*ctrain-1)', x_norm', ones(size(x,2),1));
mu_y = c;
sigma2_y =d;

mu_c = exp(lp);

% tfn_output = NaN(numel(mu_c),1);
% for i= 1:numel(mu_c)
%     tfn_output(i) = tfn(mu_y(i)./sqrt(1+sigma2_y(i)), 1./sqrt(1+2*sigma2_y(i)));
% end
% var_muc = (mu_c - 2*tfn_output) - mu_c.^2;
% 
% var_muc(sigma2_y==0) = 0;
if max(mu_c(end,:))<threshold
    s = max(size_range);
else
[~,id] = min(abs(mu_c-threshold));%smallest letter size for which the succeess rate was above 80%, in px 
s = size_range(id);
end
s_m = 0.01*s./experiment.dpcm; %smallest letter size for which the succeess rate was above 80%, in cm 
a = 2*atan(0.5*s_m/viewing_distance); %smallest letter size for which the succeess rate was above 80%, in dva
a= a*180/pi; %convert in degrees;
MAR= 60*a; %convert in minute of arc
acuity = 0.2*10./MAR; %we assume that if  a =1', VA = 10/10, the 0.2 factor corresponds to the fact that details are 1/5 of the size of the letter.
logMAR = log10(MAR);
if acuity == Inf
    error('MAR cannot be zero')
end


% graphics_style_paper;
% fig = figure();
% fig.Color =  [1 1 1];
% % subplot(2,1,1)
% plot(x,mu_c, 'linewidth', linewidth); hold on;
% scatter(xtrain, ctrain, markersize, 'k', 'filled');
% % subplot(2,1,2)
% % errorshaded(x,mu_y,sqrt(sigma2_y))
% xlabel('Letter size (in px)')
% ylabel('Probability of correct response')
% box off
return


