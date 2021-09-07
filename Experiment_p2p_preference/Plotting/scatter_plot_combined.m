function scatter_plot_combined(X,Y, tail,xlab,ylab, scale, varargin)

opts = namevaluepairtostruct(struct( ...
    'equal_axes', 1, ...
    'linreg', 0, ...
     'categories', [], ...
     'legend_position', 'north', ...
     'color',[], ...
     'test', 'Bayes' ... %Wilcoxon
    ), varargin);

UNPACK_STRUCT(opts, false)

graphics_style_paper;

if isempty(color)
    color = C;
end
N = numel(X);
p = zeros(1,N);
np = zeros(1,N);
for i =1:N
    x = X{i};
    y = Y{i};
    remove = isnan(x+y);
    x = x(~remove);
    y = y(~remove);
    X{i} = x;
    Y{i} = y;
    if strcmp(test, 'Wilcoxon')
    p(i) = signrank(x,y, 'Tail',tail);
     elseif strcmp(test, 'Bayes')
       p(i) = Bayes_factor_VA(x,y);        
    end 
     disp_stats = disp_p(p(i), 'test', test,'plot_N', false);
    leg{i} = [categories{i}, ', ', disp_stats];
    np(2*(i-1)+1) = numel(x);
    np(2*i) = numel(y);
end
% graphics_style_paper;
linecol = [0,0,0];
plots = [];
for i =1:N
    h(i) = scatter(X{i},Y{i}, markersize, 'filled'); hold on;
    h(i).CData = color(i,:);
    plots = [plots, h(i)];
end

pbaspect([1 1 1])
xlabel(xlab, 'Fontsize', Fontsize)
ylabel(ylab, 'Fontsize', Fontsize)
box off
if ~isempty(scale)
    xlim([scale(1,1),scale(1,2)]);
    ylim([scale(2,1),scale(2,2)]);
else
    if equal_axes
        m = min([cell2mat(X),cell2mat(Y)]);
        M = max([cell2mat(X),cell2mat(Y)]);
        xlim([m, M])
        ylim([m, M])
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

if linreg
    mdl = fitlm(x,y);
    [p,F,d] = coefTest(mdl);
    h2 = plot(linspace(Xlim(1),Xlim(2),100), mdl.predict(linspace(Xlim(1),Xlim(2),100)'), 'color', linecol, 'linewidth', linewidth/4, 'linestyle','--'); hold on; %mdl.Coefficients.Estimate(1)+mdl.Coefficients.Estimate(2)*x
    tp =  disp_p(p, 'test', 'F-test', 'plot_N', true);
    printed_text{1} = ['$R^2 =', num2str(round(mdl.Rsquared.Ordinary,3)),'$, ', tp{1}];
    printed_text{2} = tp{2};
    stat_pos = [0.0295652173913043 -0.00395652173913044]; %0.36, 0.083
    text(stat_pos(1), stat_pos(2),printed_text,'Units','normalized','Fontsize', Fontsize)
    % 'F-test'
else
    h2 = plot(rx,ry, 'color', linecol, 'linewidth', linewidth/4, 'linestyle','--'); hold on;
    %title(disp_p(p));
    stat_pos = [0.63, 0.091]; %0.63, 0.091
%     text(stat_pos(1), stat_pos(2),disp_p(p, 'test','Wilcoxon signed-rank'),'Units','normalized','Fontsize', 9,'FontWeight', 'Bold') % 'Wilcoxon signed-rank'
end


NumTicks = 3;
L = get(gca,'XLim');
set(gca,'XTick',linspace(L(1),L(2),NumTicks))
L = get(gca,'YLim');
set(gca,'YTick',linspace(L(1),L(2),NumTicks))
xtickformat('%.2f')
ytickformat('%.2f')


[hleg, icons] = legend(leg, 'Location', legend_position, 'FontSize' , Fontsize);
% rect = [0, 0.25, 1, 1];
% set(hleg, 'Position', rect)
M = findobj(icons,'type','patch'); % Find objects of type 'patch'
set(M,'MarkerSize', sqrt(markersize))
legend boxoff
pos = hleg.Position;
if strcmp(legend_position, 'north')
pos(2) = pos(2)+0.119;
pos(1) = pos(1) +0.05;
end
hleg.Position =pos;
hleg.ItemTokenSize(1) = -40;

text(0.75, 0.05, ['N=', num2str(unique(np))] ,'Units','normalized','Fontsize', letter_font)

% copy the objects
% ax = gca();
% hCopy = copyobj(h, ax); 
% % replace coordinates with NaN 
% % Either all XData or all YData or both should be NaN.
% for i = 1:N
% set(hCopy(i),'XData', NaN', 'YData', NaN)
% hCopy(1).SizeData = 2; 
% end
% % Note, these lines can be combined: set(hCopy,'XData', NaN', 'YData', NaN)
% % To avoid "Data lengths must match" warning, assuming hCopy is a handle array, 
% % use arrayfun(@(h)set(h,'XData',nan(size(h.XData))),hCopy)
% % Alter the graphics properties
% % Create legend using copied objects
% hleg= legend(hCopy, leg, 'Location', legend_position, 'FontSize' , Fontsize);
% rect = [0, 0.25, 1, 1];
% set(hleg, 'Position', rect)
% legend boxoff