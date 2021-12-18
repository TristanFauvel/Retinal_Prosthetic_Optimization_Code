function barplot_groups(X, Y, xlabels, ylabels, groups, varargin)

opts = namevaluepairtostruct(struct( ...
    'scatter_points', 0, ...
    'stat', 'mean'...
    ), varargin);

UNPACK_STRUCT(opts, false)

Ny = numel(Y);
Nx = numel(X);

graphics_style_paper;
y = NaN(1,Ny);
x = NaN(1,Nx);

ny = NaN(1,Ny);
nx = NaN(1,Nx);

sem_y = NaN(1,Ny);
sem_x = NaN(1,Nx);

for i = 1:Ny
    data = Y{i};
    data = data(~isnan(data));
    Y{i} = data;
    ny(i) = numel(data);
    if strcmp(stat, 'mean')
        y(i) = mean(data);
        sem_y(i) = sqrt(var(data)/ny(i));
    elseif strcmp(stat, 'median')
        y(i) = median(data);
        sem_y(i) = 0 ;
    end
end


for i = 1:Nx
    data = X{i};
    data = data(~isnan(data));
    X{i} = data;
    nx(i) = numel(data);
    if strcmp(stat, 'mean')
        x(i) = mean(data);
        sem_x(i) = sqrt(var(data)/nx(i));
    elseif strcmp(stat, 'median')
        x(i) = median(data);
        sem_x(i) = 0 ;
    end
end

data = [x',y'];
sem = [sem_x', sem_y'];

xx= 0:numel(y)-1;


barcol = [1,1,1];
linecol= [0,0,0];
offset = 0.5;
h =bar(data); hold on

box off
ylabel(ylabels)

xticklabels(xlabels)

angle = 35;
xtickangle(angle);

% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(data);
% Get the x coordinate of the bars
e = nan(nbars, ngroups);
for i = 1:nbars
    e(i,:) = h(i).XEndPoints;
end
% Plot the errorbars
errorbar(e',data, sem,'k','linestyle','none');
hold off

set(h, {'DisplayName'}, groups')
l = legend();
l.String = l.String(1:2);
legend boxoff

pvalsy = zeros(1,Ny);
pvalsx = zeros(1,Nx);
test = 'Bayes';
Ncomp = 13;
plot_N = true;
rotation = 45;
 for i = 1:Nx
    if strcmp(test, 'Mann-Whitney')
        px  = ranksum(X{i}, 0.5*ones(1,numel(X{i})));
        py  = ranksum(Y{i}, 0.5*ones(1,numel(Y{i})));
    elseif strcmp(test, 'Bayes')
        px = BayesFactor(X{i}, Ncomp*ones(1, numel(X{i})));
        py = BayesFactor(Y{i}, Ncomp*ones(1, numel(Y{i})));
    end
    pvalsx(i) = px;
    pvalsy(i) = py;
    [stars_x{i},~]= disp_p(px, 'test', test, 'n', nx(i), 'plot_N', plot_N);
    [stars_y{i},~]= disp_p(py, 'test', test, 'n', ny(i), 'plot_N', plot_N);

    offset= 0.05 ;
        text(e(1,i), min(offset + x(i) + sem_x(i), 1+offset), stars_x{i}, 'HorizontalAlignment', 'center', 'Fontsize', Fontsize, 'Rotation', rotation);

    text(e(2,i), min(offset + y(i) + sem_y(i), 1+offset), stars_y{i}, 'HorizontalAlignment', 'center', 'Fontsize', Fontsize, 'Rotation', rotation);
end
 


 


% 
% 
% if scatter_points
%     if colorized
%         c = linspace(0,255,n);
%     else
%         c = 'k';
%     end
%     for i = 1:Nx
%         scatter((i-1)*ones(1,n) + linspace(-0.2,0.2,n),Y{i}, markersize, c, 'filled'); hold on;
%     end
% end
% 
% pvals = zeros(1,N);
% 
% f = 1;
% for i = 1:N
%     data = Y{i};
%     data = data(~isnan(data));
%     [p, ~]  = ranksum(data, 0.5*ones(1,numel(data)));%signrank(Y{i}-0.5);
%     pvals(i) = p;
%     offset = 0.05;
%     [disp_p, offset] = disp_p(p);
%     text(xx(i), 1 + offset, stars, 'HorizontalAlignment', 'center');
% end
