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

P = NaN(Nx+Ny);
for i = 1:Nx
        [~, P(i, i+Nx)] = ttest2(X{i},Y{i});
         P(i+Nx, i) =  P(i, i+Nx);
end

barcol = [1,1,1];
linecol= [0,0,0];
offset = 0.5;
h =superbar(1:Nx, data, 'E', sem, 'P', P,'BarFaceColor', 'none','ErrorbarColor', [0,0,0], 'PStarColor', [0,0,0]); hold on
xticklabels(xlabels)

xlim([0.5,(Nx)+0.5])
for i = 1:size(data,2)
    set(h(:,i),'FaceColor', C(i, :), 'EdgeColor', 'none');
end

box off
ylabel(ylabels)

 
angle = 35;
xtickangle(angle);


 


