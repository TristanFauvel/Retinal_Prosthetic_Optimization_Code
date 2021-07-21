
% s_index = 7; %7 11 13
T = load(data_table_file).T;
indices = 1:size(T,1);
indices = indices(T.Misspecification == 0 & T.Acquisition == 'maxvar_challenge');
Ta = T(indices, :);
[a,b]= sort(Ta.Model_Seed);
indices = indices(b);
% Ta = T(T.Misspecification == 0 & T.Acquisition == 'maxvar_challenge',:);
nindices = numel(indices);
mr = nindices;
mc = 4;

fig=figure('units','centimeters'); %,'outerposition',1+[0 0 16 1.5/2*16]);
fig.Color =  [1 1 1];
fig.Name = 'Fraction preferred';
layout1 = tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','compact');

k=1;
for i = 1:nindices
    s_index =  indices(i);
[p_after_optim, p_opt, p_control, p_after_optim_rand, nx,ny] = encoders_comparison(s_index, T);


h = nexttile();
imagesc(reshape(p_opt(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
set(gca,'dataAspectRatio',[1 1 1])
h.CLim = [0, 255];
if i ==1
title('Ground truth')
end
h = nexttile();
imagesc(reshape(p_after_optim(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
set(gca,'dataAspectRatio',[1 1 1])
h.CLim = [0, 255];
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
if i ==1
title('MaxVarChallenge')
end

h = nexttile();
imagesc(reshape(p_after_optim_rand(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
set(gca,'dataAspectRatio',[1 1 1])
h.CLim = [0, 255];
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
if i ==1
title('Random')
end

h =nexttile();
imagesc(reshape(p_control(:,k),ny,nx));
set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
set(gca,'dataAspectRatio',[1 1 1])
h.CLim = [0, 255];
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
 if i ==1
title('Control')
    end
colormap('gray')
end