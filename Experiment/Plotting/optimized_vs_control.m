function optimized_vs_control(filenames)


add_directories;
graphics_style_paper;
for ij = 1:numel(filenames)
    filename = filenames{ij};
    load(filename)
    ny =  experiment.ny;
        nx =  experiment.nx;
    if ij ==1
        if strcmp(experiment.implant_name, 'Argus II')
            im_ny = floor(0.9*ny);
            im_nx = floor(0.9*nx);
        elseif strcmp(experiment.implant_name, 'PRIMA')
            im_ny = floor(0.5*ny);
            im_nx = floor(0.5*nx);
        end
        image_size = [im_ny, im_nx];
                Stimuli_folder =  [Stimuli_folder,'/letters'];

        
        S = load_stimuli_letters(experiment);
    end
    
    xparams = experiment.model_params;
    xparams(experiment.ib) = experiment.xtrain(experiment.ib,1);
    
    best_params = experiment.model_params*ones(1,experiment.maxiter);
    best_params(experiment.ib,:) = experiment.x_best(experiment.ib,:);
    g = @(x) loss_function(experiment.M, x, S, experiment);
    [~,p_after_optim{ij}] = g(best_params(:,end));
    [~,p_control{ij}] = g(xparams);
end

fig = figure('units','pixels');
fig.Color = [1,1,1];
nk  =numel(filenames);
for k = 1:nk
    h1 =subplot(2,nk,k);
    p1 = p_control{k};
    p1 = p1(:,1);
    imagesc(reshape(p1,ny,nx));
    set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
    set(gca,'dataAspectRatio',[1 1 1])
%     posnew = [xpositions(k,1), ypositions(k,1), width, height];
%         set(h, 'Position', posnew)
    h1.CLim = [0, 255];
    if k ==1
        ylabel('Control')
    end
    h2 =subplot(2,nk,k+nk);
    p2 = p_after_optim{k};
    p2 = p2(:,1);
    imagesc(reshape(p2,ny,nx));
    set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[]),
    set(gca,'dataAspectRatio',[1 1 1])
    posnew = h2.Position;
    posnew(2) = h1.Position(2)+0.1;
    set(h2, 'Position', posnew)
    h2.CLim = [0, 255];
    if k ==1
        ylabel('Optimized')
    end

end
colormap('gray')

return

T = load(data_table_file).T;
T = T(T.Acquisition == 'MUC' & T.Misspecification == 0,:); 
% [a,b] = sort(T.Model_Seed)
T = T(1:9,:);
clear('filenames')
for k = 1:size(T,1)
    task = char(T(k,:).Task);
    acquisition_fun_name = cellstr(T(k,:).Acquisition);
    acquisition_fun_name = acquisition_fun_name{1};
    subject = char(T(k,:).Subject);

    index = T(k,:).Index;
    filenames{k} = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
end
optimized_vs_control(filenames)