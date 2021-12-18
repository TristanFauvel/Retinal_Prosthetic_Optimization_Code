function h = scatter_bar(Yp, xlabels, ylabels, varargin)

opts = namevaluepairtostruct(struct( ...
    'boxp', 1, ...
    'stat', 'median',...
    'pval', 1, ...
    'rotation', 0, ...
    'colorized',false, ...
    'test', 'Bayes', ... %Mann-Whitney
    'Ncomp', [], ...
    'pba', [1,1,1], ...
    'plot_N', true ...
    ), varargin);

UNPACK_STRUCT(opts, false)

stat = 'mean';
graphics_style_paper;
N = numel(Yp);
M = numel(Yp{1});
y = NaN(1,N);
n = NaN(1,N);

g = [];


groups = [];

for i = 1:N
    data = Yp{i};
    data = data(~isnan(data));
    Y{i} = data;
    n(i) = numel(data);
    if colorized
        colors{i} = linspace(0,1,n(i));
        ax = gca;
        colormap(ax, jet)
    else
        colors{i}= 'k';        
    end
    if strcmp(stat, 'mean')
        y(i) = mean(data);
        sem(i) = sqrt(var(data)/n(i));
         
    elseif strcmp(stat, 'median')
        y(i) = median(data);
        sem(i) = 0;
    end
    g = [g;repmat(xlabels(i),M,1)];
    groups = [groups; repmat(xlabels(i),numel(data),1)];
end
barcol = [1,1,1];
linecol= [0,0,0];
offset = 0.5;
angle = 35;

if boxp
    ax1 = gca;
    h = boxplot(cell2mat(Y)',groups, 'Symbol', '', 'Widths', 0.3, 'Colors', 'k'); hold on;
    set(h,{'linew'},{1})
    set(h,  {'LineStyle'}, {'-'})
    box off
    ylim([0,1])
    xl = xlim();
     pbaspect(pba)
    ylabel(ylabels)

    set(gca,'FontSize', Fontsize,'TickLabelInterpreter', 'latex')
    xtickangle(rotation)
    ax2 = axes('Position',ax1.Position,'Color','none', 'XLim', ax1.XLim, 'YLim', ax1.YLim);
    
    for i = 1:N
        col = colors{i};
    scatter(i*ones(1,n(i)) + linspace(-0.1,0.1,n(i)),Y{i}, markersize, col, '+', 'Parent',ax2);hold on
    end
    ax2.Color = 'none';
     set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
     set(gca,'XColor', 'none','YColor','none')
     ax2.XLim = ax1.XLim;
          pbaspect(pba)
    ylim([0,1])
        plot([xl(1), xl(2)], [0.5,0.5],'linestyle', ':','linewidth', 2, 'color', 'k')
    
else
    x= 0:N-1;
    h =bar(x,y,'Facecolor',barcol); hold on
    xlim([-offset,N-offset])
    xticklabels(xlabels)
    
    for i = 1:N
       
        scatter((i-1)*ones(1,n(i)) + linspace(-0.2,0.2,n(i)),Y{i}, markersize, colors{i}, '+'); hold on;
        
    end
    xtickangle(angle);
    ylabel(ylabels)

end
box off
ylim([0,1])

pvals = zeros(1,N);
axes(ax1)
for i = 1:N
    if strcmp(test, 'Mann-Whitney')
    p  = ranksum(Y{i}, 0.5*ones(1,numel(Y{i}))); % signtest(Y{i}-0.5);%signrank(Y{i}-0.5);
    elseif strcmp(test, 'Bayes')
        p = BayesFactor(Y{i}, Ncomp*ones(1, numel(Y{i})));
    end
    pvals(i) = p;
    [stars,~]= disp_p(p, 'test', test, 'n', n(i), 'plot_N', plot_N);
    offset= 0.1+ 0.005*rotation;
    text(i, min(offset + mean(Y{i}) + 2*std(Y{i}), 1+offset), stars, 'HorizontalAlignment', 'center', 'Fontsize', Fontsize, 'Rotation', rotation);

end
ax1.Color = 'none';

