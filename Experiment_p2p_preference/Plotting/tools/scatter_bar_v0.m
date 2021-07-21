function scatter_bar(Y, xlabels, ylabels, varargin)

opts = namevaluepairtostruct(struct( ...
    'boxp', 0, ...
    'stat', 'median'...
    ), varargin);

UNPACK_STRUCT(opts, false)


graphics_style_paper;
N = numel(Y);
y = NaN(1,N);
n = NaN(1,N);

g = [];


for i = 1:N
    data = Y{i};
    data = data(~isnan(data));
    Y{i} = data;
    n(i) = numel(data);
    
    if strcmp(stat, 'mean')
        y(i) = mean(data);
        sem(i) = sqrt(var(data)/n(i));
        % phat= betafit(Y{i});
        % y(i) = phat(1)/(phat(1)+phat(2));
        
    elseif strcmp(stat, 'median')
        y(i) = median(data);
        sem(i) = 0;
    end
    g = [g;repmat(xlabels(i),n(i),1)];
end
barcol = [1,1,1];
linecol= [0,0,0];
offset = 0.5;

colorized = 0;
if boxp
    x= 1:N;
    h = boxplot(cell2mat(Y')', g,'PlotStyle','compact');
else
    x= 0:N-1;
    h =bar(x,y,'Facecolor',barcol); hold on
    xlim([-offset,N-offset])
    xticklabels(xlabels)
    
    for i = 1:N
        if colorized
            c = linspace(0,255,n(i));
        else
            c = 'k';
        end
        % scatter((i-1)*ones(1,n),Y{i}, markersize, c, 'filled'); hold on;
        scatter((i-1)*ones(1,n(i)) + linspace(-0.2,0.2,n(i)),Y{i}, markersize, c, 'filled'); hold on;
        
    end
    % hold off;
end
box off
ylabel(ylabels)

angle = 35;
xtickangle(angle);

pvals = zeros(1,N);

f = 1;
for i = 1:N
    [p, ~]  = ranksum(Y{i}, 0.5*ones(1,numel(Y{i}))); % signtest(Y{i}-0.5);%signrank(Y{i}-0.5);
    pvals(i) = p;
    offset = 0.05;
    if p<=1E-3
        stars='***';
    elseif p<=1E-2
        stars='**';
    elseif p<=0.05
        stars='*';
    elseif isnan(p)
        stars='nan';
        offset=offset  + f*0.005;
        
    else
        stars='n.s.';
        offset= offset  + f*0.035;
    end
    text(x(i), 1 + offset, stars, 'HorizontalAlignment', 'center');
    
end

% groups={[0,1],[2,3]};
% pvals = [p0,p1];
% hb=sigstar(groups,pvals); hold off;
%

