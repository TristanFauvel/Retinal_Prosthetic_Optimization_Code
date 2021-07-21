function contrast_sensitivity = compute_CS(experiment,CS_measure)

UNPACK_STRUCT(CS_measure, false)
add_directories;

threshold = 0.8;
[a b c d lp] = gp(hyp, inf_func, meanfunc, covfunc, likfunc, xtrain_norm', (2*ctrain-1)', x_norm', ones(size(x,2),1));
mu_y = c;
sigma2_y =d;

mu_c = exp(lp);

tfn_output = NaN(numel(mu_c),1);
for i= 1:numel(mu_c)
    tfn_output(i) = tfn(mu_y(i)./sqrt(1+sigma2_y(i)), 1./sqrt(1+2*sigma2_y(i)));
end
var_muc = (mu_c - 2*tfn_output) - mu_c.^2;

var_muc(sigma2_y==0) = 0;


if max(mu_c)<threshold
   contrast_sensitivity = 1; 
else
    [~,id] = min(abs(mu_c-threshold));%smallest letter size for which the succeess rate was above 80%, in px 
    contrast_sensitivity = contrast_range(id);
end

% if strcmp(char(inf_func{2}), 'infLaplace')
%     disp('stop')
% end


graphics_style_paper;
fig = figure();
fig.Color =  [1 1 1];
% subplot(2,1,1)
plot(x,mu_c, 'linewidth', linewidth); hold on;
scatter(xtrain, ctrain, markersize, 'k', 'filled');
% subplot(2,1,2)
% errorshaded(x,mu_y,sqrt(sigma2_y))
xlabel('Contrast')
ylabel('Probability of correct response')
box off

return
