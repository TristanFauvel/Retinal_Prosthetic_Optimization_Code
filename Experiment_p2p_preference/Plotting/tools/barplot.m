function barplot(Y, xlabels, ylabels, varargin)

opts = namevaluepairtostruct(struct( ...
    'scatter_points', 0, ...
    'stat', 'median'...
    ), varargin);

UNPACK_STRUCT(opts, false)

N = numel(Y);

graphics_style_paper;
y = NaN(1,N);
n = NaN(1,N);
sem = NaN(1,N);

for i = 1:N
        data = Y{i};
    data = data(~isnan(data));

    n(i) = numel(data);
    if strcmp(stat, 'mean')

        y(i) = mean(data);
        sem(i) = sqrt(var(data)/n(i));
        % phat= betafit(Y{i});
        % y(i) = phat(1)/(phat(1)+phat(2));
        
    elseif strcmp(stat, 'median')
        y(i) = median(data);
        sem(i) = 0 ;
    end
end


x= 0:numel(y)-1;
n = min(n);
barcol = [1,1,1];
linecol= [0,0,0];
offset = 0.5;
h =bar(x,y,'Facecolor',barcol); hold on
err = errorbar(x,y,sem); hold on

err.Color = linecol;
err.LineStyle = 'none';

box off
ylabel(ylabels)
xlim([-offset,N-offset])

xticklabels(xlabels)

angle = 35;
xtickangle(angle);


if scatter_points
    n = min(n);
     if colorized
c = linspace(0,255,n);
        else
            c = 'k';
        end

    for i = 1:N
        % scatter((i-1)*ones(1,n),Y{i}, markersize, c, 'filled'); hold on;
        scatter((i-1)*ones(1,n) + linspace(-0.2,0.2,n),Y{i}, markersize, c, 'filled'); hold on;
        
    end
end

%
% BF_10  = zeros(1,N);
%
% for i = 1:N
%     BF_10(i) =  BayesFactor(26,Y{i});
%     p = BF_10(i);
%     offset = 0.05;
%     if p>100
%         stars='***';
%     elseif p>sqrt(10)
%         stars='**';
%     elseif p>1
%         stars='*';
%     elseif isnan(p)
%         stars='nan';
%         offset=offset  + f*0.005;
%     else
%         stars='n.s.';
%         offset= offset  + f*0.035;
%     end
%     text(x(i), 1 + offset, stars, 'HorizontalAlignment', 'center');
% end


pvals = zeros(1,N);

f = 1;
for i = 1:N
        data = Y{i};
    data = data(~isnan(data));

    [p, ~]  = ranksum(data, 0.5*ones(1,numel(data)));%signrank(Y{i}-0.5);
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
