function h = scatter_plot(x,y, tail,xlab,ylab, scale, varargin)

opts = namevaluepairtostruct(struct( ...
    'equal_axes', 1, ...
    'linreg', 0, ...
    'color', [0,0,0], ...
    'title_str', '' ...
    ), varargin);

UNPACK_STRUCT(opts, false)

graphics_style_paper;
remove = isnan(x+y);

x = x(~remove);
y = y(~remove);

% graphics_style_paper;
linecol= [0,0,0];
p = signrank(x,y, 'Tail',tail);
colorized = false;

n = numel(x);
if colorized
    c = linspace(0,255,n);
else
    c = color;
end
linecol = [0,0,0];
scatter(x,y, markersize, c, 'filled'); hold on;
pbaspect([1 1 1])
xlabel(xlab)
ylabel(ylab)
box off
if ~isempty(scale)
    xlim([scale(1,1),scale(1,2)]);
    ylim([scale(2,1),scale(2,2)]);
else
    if equal_axes
        xlim([min([x,y]), max([x,y])])
        ylim([min([x,y]), max([x,y])])
    end
end
    Xlim = xlim;
    Ylim = ylim;

if ~isempty(scale)
    rx= [scale(1,1),scale(1,2)];
    ry= [scale(2,1),scale(2,2)];
else
    %      rx= [min([x,y]), max([x,y])];
    %     ry= [min([x,y]), max([x,y])];
    rx= [Xlim(1),Xlim(2)];
    ry=  [Ylim(1),Ylim(2)];
    
end
stat_pos = [0.63, 0.091]; %0.63, 0.091

if linreg
    mdl = fitlm(x,y);
    [p,F,d] = coefTest(mdl);
    h = plot(linspace(Xlim(1),Xlim(2),100), mdl.predict(linspace(Xlim(1),Xlim(2),100)'), 'color', linecol, 'linewidth', linewidth/4, 'linestyle','--'); hold on; %mdl.Coefficients.Estimate(1)+mdl.Coefficients.Estimate(2)*x
    tp =  disp_p(p, 'test', 'F-test');
    printed_text= ['$R^2 =', num2str(round(mdl.Rsquared.Ordinary,3)),'$, ', tp];
    %stat_pos = [0.0295652173913043 -0.00395652173913044]; %0.36, 0.083
    %text(stat_pos(1), stat_pos(2),printed_text,'Units','normalized','Fontsize',Fontsize)
    % 'F-test'
    if strcmp(title_str,'')
        title_str =  printed_text;
    else
    title_str = [title_str, ', ', printed_text];
    end
else
    h = plot(rx,ry, 'color', 'k', 'linewidth', linewidth/4, 'linestyle','--'); hold on;
    %stat_pos = [0.63, 0.091]; %0.63, 0.091
    %text(stat_pos(1), stat_pos(2),disp_p(p, 'test','Wilcoxon signed-rank'),'Units','normalized','Fontsize', Fontsize) % 'Wilcoxon signed-rank'
%     title_str = [title_str, ', ', disp_p(p, 'test','Wilcoxon signed-rank')];
text(stat_pos(1), stat_pos(2),['N = ', num2str(numel(x)) newline disp_p(p, 'test','Wilcoxon signed-rank')],'Units','normalized','Fontsize', Fontsize) % 'Wilcoxon signed-rank'

end
title(title_str)

NumTicks = 3;
L = get(gca,'XLim');
set(gca,'XTick',linspace(L(1),L(2),NumTicks))
L = get(gca,'YLim');
set(gca,'YTick',linspace(L(1),L(2),NumTicks))
xtickformat('%.2f')
ytickformat('%.2f')


