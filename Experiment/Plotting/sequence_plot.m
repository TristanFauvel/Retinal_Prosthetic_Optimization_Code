function sequence_plot(filename)

showall = 'yes';
load(filename)
UNPACK_STRUCT(experiment, false)

filename_base = [task,'_', subject, '_', acquisition_fun_name,'_',num2str(index)];
add_directories;
figure_directory = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/Figures/'];

if ~exist(figure_directory,'dir')
    mkdir(figure_directory)
end

if strcmp(implant_name, 'Argus II')
    im_ny = floor(0.9*ny);
    im_nx = floor(0.9*nx);
elseif strcmp(implant_name, 'PRIMA')
    im_ny = floor(0.5*ny);
    im_nx = floor(0.5*nx);
end
image_size = [im_ny, im_nx];


Stimuli_folder =  [Stimuli_folder,'/letters'];
S = load_stimuli_letters(experiment);

best_params = model_params*ones(1,maxiter);
best_params(ib,:) = x_best(ib,:);
g = @(x, optimal_magnitude) loss_function(M, x, S, experiment, 'optimal_magnitude', optimal_magnitude);
[~,p_after_optim] = g(best_params(:,end), []);
[~,p_opt] = g(model_params, 1);

%% Compute the naive encoder
Wi=  naive_encoder(experiment);

range = [2.^(1:floor(log2(maxiter))), maxiter];
nk = numel(range);
percept= [];

for k = 1:nk
    [~,p_optimized] = g(best_params(:,range(k)), []);
    percept = [percept,p_optimized(:,1)];
end

nl = 10;
p = vision_model(M,Wi,S);
graphics_style_paper;

%%
letter2number = @(c)1+lower(c)-'a';
range = [2.^(1:floor(log2(maxiter))), maxiter];
nk = numel(range);
p1= [];
p2= [];
popt = [];
for k = 1:nk
    xm = model_params;
    xm(ib) = xtrain(1:d,range(k));
    [~,percept] = g(xm, []);
    letter = letter2number(experiment.displayed_stim{k});
    p1 = [p1, percept(:,letter)];
    xm = model_params;
    xm(ib) = xtrain((d+1):end,range(k));
    
    [~,percept] = g(xm, []);
    p2 = [p2, percept(:,letter)];
    
     [~,percept] = g(x_best(:, range(k)), []);

%     [~,percept] = g(x_best_unknown_hyps(:, range(k)));
    popt = [popt, percept(:,1)];
end

fig3 = figure('units','pixels');
fig3.Color = [1,1,1];
width = 0.3347;
height = 0.0873;
xpositions = zeros(nk,2);
ypositions = zeros(nk,2);

yoffset = 0.06; %0.0857;
xoffset = 0.04; %0.0571;

yoffsets =0.9 -(0:(nk-1))*yoffset;
xoffsets = 0.1+(0:(nk-1))*xoffset;
xpositions(:,1) = xoffsets;
xpositions(:,2) = xoffsets+ 0.07;
ypositions(:,1) = yoffsets;
ypositions(:,2) = yoffsets;

c = 0;
for k = 1:nk
    c=c+1;
    img1 = reshape(p1(:,k),ny,nx);
    rgbImage1 = cat(3, img1, img1, img1)./255;
    img2 = reshape(p2(:,k),ny,nx);
    rgbImage2 = cat(3, img2, img2, img2)./255;

    if ctrain(range(k))
        rgbImage1= addborder(rgbImage1, 3,[1,0,0], 'center');
    else
        rgbImage2= addborder(rgbImage2, 3,[1,0,0], 'center');
    end
    
        h =subplot(nk,2,c);
        imshow(rgbImage1);
    set(gca,'xtick',[],'ytick',[],'title',[]); 
    set(gca,'dataAspectRatio',[1 1 1])
    posnew = [xpositions(k,1), ypositions(k,1), width, height]; 
    
    set(h, 'Position', posnew)
    h.CLim = [0, 255];
    
    %     title(range(k));
    ylabel(num2str(range(k)));
    hYLabel = get(gca,'YLabel');
    set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
    c=c+1;
    
    h =subplot(nk,2,c);
            imshow(rgbImage2);
    axis off
    set(gca,'dataAspectRatio',[1 1 1])
    posnew = [xpositions(k,2), ypositions(k,2), width, height];
    set(h, 'Position', posnew)
    h.CLim = [0, 255];
   

end
colormap('gray')
disp('next')


savefig(fig3, [figure_directory,filename_base , '_comparisons_sequence.fig'])

fig = figure('units','pixels');
fig.Color = [1,1,1];

c = 0;
for k = 1:nk
    c=c+1;
    h =subplot(nk,1,c);
    imagesc(reshape(popt(:,k),ny,nx));
    set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
    set(gca,'dataAspectRatio',[1 1 1])
    posnew = [xpositions(k,1), ypositions(k,1), width, height];
    set(h, 'Position', posnew)
    h.CLim = [0, 255];
    ylabel(num2str(range(k)));
    hYLabel = get(gca,'YLabel');
    set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
end
colormap('gray')

fig = figure('units','pixels');
fig.Color = [1,1,1];

c = 0;
for k = 1:nk
    c=c+1;
    h =subplot(nk,1,c);
    imagesc(reshape(popt(:,k),ny,nx));
    set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
    set(gca,'dataAspectRatio',[1 1 1])
    posnew = [xpositions(k,1), ypositions(k,1), width, height];
%     set(h, 'Position', posnew)
    h.CLim = [0, 255];
    ylabel(num2str(range(k)));
    hYLabel = get(gca,'YLabel');
    set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
end
colormap('gray')


