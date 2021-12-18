 function scatter_plot(x,y, tail,xlab,ylab, scale, varargin)

opts = namevaluepairtostruct(struct( ...
    'equal_axes', 1, ...
    'linreg', 0 ...
    ), varargin);

UNPACK_STRUCT(opts, false)

remove = isnan(x+y);

x = x(~remove);
y = y(~remove);

% graphics_style_paper;
linecol= [0,0,0];
p = signrank(x,y, 'Tail',tail);


n = numel(x);
colorized = 0;
 if colorized
c = linspace(0,255,n);
        else
            c = 'k';
        end
linewidth = 4;
linecol = [0,0,0];
markersize= 20;
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

if ~isempty(scale)
     rx= [scale(1,1),scale(1,2)];
    ry= [scale(2,1),scale(2,2)];    
else
    Xlim = xlim;
    Ylim = ylim;
%      rx= [min([x,y]), max([x,y])];
%     ry= [min([x,y]), max([x,y])];    
     rx= [Xlim(1),Xlim(2)];
    ry=  [Ylim(1),Ylim(2)];    

end

if linreg
    mdl = fitlm(x,y);
    [p,F,d] = coefTest(mdl);
    plot(linspace(Xlim(1),Xlim(2),100), mdl.predict(linspace(Xlim(1),Xlim(2),100)'), 'color', linecol, 'linewidth', linewidth/4, 'linestyle','--'); hold on; %mdl.Coefficients.Estimate(1)+mdl.Coefficients.Estimate(2)*x
    text(0.36, 0.083,['$R^2 =', num2str(round(mdl.Rsquared.Ordinary,3)),'$, ', disp_p(p)],'Units','normalized','Fontsize', 9,'FontWeight', 'Bold')
else    
    plot(rx,ry, 'color', linecol, 'linewidth', linewidth/4, 'linestyle','--'); hold on;
    %title(disp_p(p));  
    text(0.63, 0.091,disp_p(p),'Units','normalized','Fontsize', 9,'FontWeight', 'Bold')
end


NumTicks = 3;
L = get(gca,'XLim');
set(gca,'XTick',linspace(L(1),L(2),NumTicks))
L = get(gca,'YLim');
set(gca,'YTick',linspace(L(1),L(2),NumTicks))
xtickformat('%.2f')
ytickformat('%.2f')


