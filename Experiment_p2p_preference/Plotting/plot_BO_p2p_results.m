function plot_BO_p2p_results(filename)



showall = 'yes';
load(filename)
UNPACK_STRUCT(experiment, false)

filename_base = [task,'_', subject, '_', acquisition_fun_name,'_',num2str(index)];
add_directories;
figure_directory = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/Figures/'];

if ~exist(figure_directory,'dir')
    mkdir(figure_directory)
end


Stimuli_folder =  [Stimuli_folder,'/letters'];
S = load_stimuli_letters(experiment);

best_params = model_params*ones(1,maxiter);
best_params(ib,:) = x_best(ib,:);
g = @(x, optimal_magnitude) loss_function(M, x, S, experiment,'optimal_magnitude',optimal_magnitude);
[~,p_after_optim] = g(best_params(:,end), []);
[~,p_opt] = g(model_params, 1);

%% Compute the naive encoder
Wi=  naive_encoder(experiment);

% matrix_visualization(Wi, experiment)

%%
% nk = 8;
% range = floor(linspace(1, maxiter, nk));
range = [2.^(1:floor(log2(maxiter))), maxiter];
nk = numel(range);
percept= [];

for k = 1:nk
    [~,p_optimized] = g(best_params(:,range(k)), []);
    percept = [percept,p_optimized(:,1)];
end


nl = 10;
l = sort(randsample(26,nl));
letters = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];



p = vision_model(M,Wi,S);
percept_i = p;


params_names = {'$\rho$','$\lambda$','$\theta$','$x$', '$y$', 'Magnitude', '$\beta_{+}$','$\beta_{-}$','z'};

graphics_style_paper;

if d ==2 && strcmp(to_update{1},'rho') && strcmp(to_update{2}, 'lambda')
    %     rho_range = sqrt(mm_to_dva(unique(sort([200:10:400, 315]))/1000)); %I include the true optimum
    %     lambda_range =  sqrt(mm_to_dva(unique(sort([400:10:600, 505]))/1000));
    % ntest = numel(rho_range);
    ntest = 22;
    rho_range = linspace(lb(1), ub(1), ntest);
    lambda_range = linspace(lb(2), ub(2), ntest);
    ntest = numel(rho_range);
    [p,q] = meshgrid(rho_range, lambda_range);
    x = [p(:),q(:)]';
    
    x_norm = (x - min_x(1:d))./(max_x(1:d)-min_x(1:d));
    
    [~,  value, ~,~] = model.prediction(theta, xtrain_norm, ctrain, [x_norm; x0.*ones(d,size(x_norm,2))], kernelfun, kernelname, modeltype, post, regularization);
    colo= othercolor('GnBu7');
    cmap = gray(256);
    fig=figure('units','normalized','outerposition',[0 0 1 1]);
    fig.Color =  [1 1 1];
    fig.Name = 'Value function';
    imagesc(rho_range, lambda_range, reshape(value, ntest, ntest)); hold on;
    scatter(model_params(1), model_params(2), 30,'k', 'filled'); hold on;
    scatter(xtrain(1,ctrain==1), xtrain(2,ctrain==1), 30,'r','*'); hold on;
    scatter(xtrain(1,ctrain==0),xtrain(2,ctrain==0), 30,'k','*'); hold off;
    xlabel('rho','Fontsize',Fontsize)
    ylabel('lambda','Fontsize',Fontsize)
    set(gca,'YDir','normal')
    pbaspect([1 1 1])
    h = colorbar;
    h.TickLabelInterpreter = 'latex';
end

if strcmp(showall, 'yes')
    
    fig1 =figure('units','normalized','outerposition',[0 0 1 1]);
    fig1.Color = [1,1,1];
    
    subplot(1,3,1)
    imagesc(reshape(percept_i(:,1),ny,nx)); hold on;
    box off
    axis off
    set(gca,'dataAspectRatio',[1 1 1])
    title('Naive encoder')
    
    subplot(1,3,2)
    imagesc(reshape(p_after_optim(:,1),ny,nx)); hold on;
    box off
    axis off
    set(gca,'dataAspectRatio',[1 1 1])
    title('After optimization')
    subplot(1,3,3)
    imagesc(reshape(p_opt(:,1),ny,nx)); hold off;
    title('Optimal')
    set(gca,'dataAspectRatio',[1 1 1])
    box off
    axis off
    colormap('gray');
    
    fig2 = figure('units','normalized','outerposition',[0 0 1 1]);
    fig2.Color = [1,1,1];
    for  k = 1:nl
        t = l(k);
        subplot(3,nl,k)
        imagesc(reshape(percept_i(:,t),ny,nx));
        title(letters(t))
        set(gca,'dataAspectRatio',[1 1 1])
        if k==1
            ylabel('Naive encoder')
            set(gca,'YTick',[])
            set(gca,'XTick',[])
        else
            axis off
        end
        
        subplot(3,nl,k+nl)
        imagesc(reshape(p_after_optim(:,t),ny,nx));
        title(letters(t))
        set(gca,'dataAspectRatio',[1 1 1])
        if k==1
            ylabel('After optimization')
            set(gca,'YTick',[])
            set(gca,'XTick',[])
        else
            axis off
        end
        
        subplot(3,nl,k+2*nl)
        imagesc(reshape(p_opt(:,t),ny,nx));
        set(gca,'dataAspectRatio',[1 1 1])
        if k==1
            ylabel('Optimal')
            set(gca,'YTick',[])
            set(gca,'XTick',[])
        else
            axis off
            
        end
    end
    colormap('gray');
    
    fig3 = figure('units','normalized','outerposition',[0 0 1 1]);
    fig3.Color = [1,1,1];
    for k = 1:nk
        subplot(1,nk,k)
        imagesc(reshape(percept(:,k),ny,nx));
        title(range(k))
        axis off
        set(gca,'dataAspectRatio',[1 1 1])
    end
    colormap('gray');
end


% fig4 = figure();
% fig4.Color = [1,1,1];
%
% subplot(2,3,1)
% imagesc(reshape(perceptA1(:,1),41,61)); hold on;
% box off
% axis off
% set(gca,'dataAspectRatio',[1 1 1])
% title('Before optimization')
% subplot(2,3,2)
% imagesc(reshape(p(:,1),41,61));
% title('After optimization')
% axis off
% set(gca,'dataAspectRatio',[1 1 1])
% subplot(2,3,3)
% imagesc(reshape(p_opt(:,1),41,61)); hold off;
% title('Optimal')
% set(gca,'dataAspectRatio',[1 1 1])
% box off
% axis off
%
% subplot(2,3,4)
% imagesc(reshape(perceptA1(:,15),41,61));
% title('Before optimization')
% axis off
% set(gca,'dataAspectRatio',[1 1 1])
% subplot(2,3,5)
% imagesc(reshape(p(:,15),41,61));
% title('After optimization')
% axis off
% set(gca,'dataAspectRatio',[1 1 1])
% subplot(2,3,6)
% imagesc(reshape(p_opt(:,15),41,61));
% title('Optimal')
% axis off
% set(gca,'dataAspectRatio',[1 1 1])


% fig4 = figure('units','normalized','outerposition',[0 0 1 1]);
fig4 = figure('units','centimeters','outerposition',[0 0 9 9]);
fig4.Color = [1,1,1];
subplot(2,3,1)
imagesc(reshape(percept_i(:,1),ny,nx));
title('Naive encoder')
axis off
set(gca,'dataAspectRatio',[1 1 1])
subplot(2,3,4)
imagesc(reshape(percept_i(:,15),ny,nx)); hold off;
title('Naive encoder')
set(gca,'dataAspectRatio',[1 1 1])
box off
axis off
subplot(2,3,2)
imagesc(reshape(p_after_optim(:,1),ny,nx));
title('After optimization')
axis off
set(gca,'dataAspectRatio',[1 1 1])
subplot(2,3,3)
imagesc(reshape(p_opt(:,1),ny,nx)); hold off;
title('Optimal')
set(gca,'dataAspectRatio',[1 1 1])
box off
axis off
subplot(2,3,5)
imagesc(reshape(p_after_optim(:,15),ny,nx));
title('After optimization')
axis off
set(gca,'dataAspectRatio',[1 1 1])
subplot(2,3,6)
imagesc(reshape(p_opt(:,15),ny,nx));
title('Optimal')
axis off
set(gca,'dataAspectRatio',[1 1 1])
colormap('gray');

savefig(fig4, [figure_directory,filename_base , '_experiment_optimized_transfer.fig'])
exportgraphics(fig4, [figure_directory,filename_base ,'_experiment_optimized_transfer.png'])
exportgraphics(fig4, [figure_directory,filename_base, '_experiment_optimized_transfer.eps'])
 
 %%
if strcmp(showall, 'yes')
    
    fig5=figure('units','normalized','outerposition',[0 0 1 1]);
    fig5.Color =  [1 1 1];
    fig5.Name = 'Optimal parameters';
    for k = 1:numel(ib)
        subplot(1,numel(ib),k)
        plot(x_best(ib(k),:), 'linewidth', linewidth); hold on;
        %     yline(sqrt(rho), 'linewidth', linewidth, 'color', 'r'); hold off
        set(gca,'FontSize',Fontsize)
        yline(model_params(ib(k)), 'linewidth', linewidth, 'color', 'r'); hold off
        ylabel(['Optimal ', params_names{ib(k)}],'Fontsize',Fontsize)
        xlabel('Iteration')
        %     ylim([lb(ib(k)), ub(ib(k))])
        pbaspect([1 1 1])
        xlim([1, maxiter])
        box off
    end
    savefig(fig5, [figure_directory,filename_base , '_experiment_optimized_parameters_evolution.fig'])
    exportgraphics(fig5, [figure_directory,filename_base , '_experiment_optimized_parameters_evolution.png'])
    exportgraphics(fig5, [figure_directory,filename_base , '_experiment_optimized_parameters_evolution.eps'])
     fig6=figure('units','normalized','outerposition',[0 0 1 1]);
    
    fig6.Color =  [1 1 1];
    fig6.Name = 'Explored parameters';
    for k = 1:numel(ib)
        if strcmp(task, 'preference')
            subplot(1,numel(ib),k)
            plot(xtrain(k,:), 'linewidth', linewidth); hold on;
            plot(xtrain(k+numel(ib),:), 'linewidth', linewidth); hold on;
            set(gca,'FontSize',Fontsize)
            yline(model_params(ib(k)), 'linewidth', linewidth, 'color', 'r'); hold off
            ylabel(params_names{ib(k)},'Fontsize',Fontsize)
            xlabel('Iteration')
            pbaspect([1 1 1])
            xlim([1, maxiter])
            box off
        else
            subplot(1,numel(ib),k)
            plot(xtrain(k,:), 'linewidth', linewidth, 'color', 'b'); hold on;
            set(gca,'FontSize',Fontsize)
            yline(model_params(ib(k)), 'linewidth', linewidth, 'color', 'r'); hold off
            ylabel(params_names{ib(k)},'Fontsize',Fontsize)
            xlabel('Iteration')
            pbaspect([1 1 1])
            xlim([1, maxiter])
            box off
        end
    end
end

if strcmp(subject, 'computer')
    for j = 1:d
        ntest = 50;
        range = linspace(lb(j), ub(j), ntest);
        
        x_test =  model_params.*ones(1,ntest);
        x_test(j,:)= range;
        %min_max normalization
        %         x_test_norm = (x_test-min_x(1:d))./(max_x(1:d)-min_x(1:d));
        % Normalization :
        x_test_norm =  (x_test - lb')./(ub'- lb');
        
        
        [~, mu_y, ~,~] = model.prediction(theta, xtrain_norm, ctrain, [x_test_norm; x0.*ones(d,size(x_test_norm,2))], kernelfun, kernelname, modeltype, post, regularization);
        y= NaN(1,ntest);
        for i=1:ntest
            new_x = range(i);
            x = model_params;
            x(ib(j)) = new_x;
            new_x = x;
            y(i) = g(new_x, []);
        end
        
        Fontsize = 14;
        fig7 = figure('units','normalized','outerposition',[0 0 1 1]);
        fig7.Color =  [1 1 1];
        plot(range, mu_y - mean(mu_y), 'linewidth', linewidth); hold on;
        plot(range, fx*(y - mean(y)), 'linewidth', linewidth); hold on;
        set(gca,'FontSize',Fontsize)
        vline(model_params(j)); hold off;
        legend('Regression function', 'True function', 'Data');
        xlabel(params_names(j),'Fontsize',Fontsize)
        ylabel('loss','Fontsize',Fontsize)
        
        fig8=figure('units','normalized','outerposition',[0 0 1 1]);
        fig8.Color =  [1 1 1];
        subplot(1,2,1)
        imagesc(range, range, y-y'); hold on;
        set(gca,'YDir','normal')
        title('True function')
        scatter(xtrain(j,ctrain==1), xtrain(j+d,ctrain==1), markersize, 'y', 'filled'); hold on;
        scatter(xtrain(j,ctrain==0), xtrain(j+d,ctrain==0), markersize, 'b', 'filled'); hold off;
        pbaspect([1,1,1])
        xlabel(params_names(j),'Fontsize',Fontsize)
        ylabel(params_names(j),'Fontsize',Fontsize)
        
        subplot(1,2,2)
        set(gca,'YDir','normal')
        imagesc(range, range, mu_y'-mu_y); hold off;
        set(gca,'YDir','normal')
        title('Posterior mean')
        pbaspect([1,1,1])
        xlabel(params_names(j),'Fontsize',Fontsize)
        ylabel(params_names(j),'Fontsize',Fontsize)
    end
elseif strcmp(subject, 'human')
    fig=figure('units','normalized','outerposition',[0 0 1 1]);
    fig.Color =  [1 1 1];
    plot(1:maxiter, values, 'linewidth', linewidth);
    box off
    xlabel('Iteration')
    set(gca,'xlim',[1,maxiter])
    if strcmp(task, 'preference')
        ylabel('Value of the current estimate of the optimum')
     elseif strcmp(task, 'LandoltC')
        ylabel('Probability of correct response')
     end
end


% %% Evolution over time
% 
% % fig = figure('PaperOrientation', 'portrait', 'Units', 'inches'); %,  'PaperUnits', 'centimeters', 'PaperPosition',0.8*[0, 29.7, 21, 29.7]);
% fig=figure('units','normalized','outerposition',[0 0 1 1]);
% 
% fig.Color = [1,1,1];
% % % AR = fig.Position(4)/fig.OuterPosition(3);
% % AR = 2/5;
% % px_cm = 1920/37.6;
% % cm_px = 37.6/1920;
% % % fig.Position =[0, 0, AR*29.7, 21]*px_cm;
% % % fig.Position = 0.8*[0, 0, 21, AR*29.7]*px_cm;
% 
% subplot(4,5,[5,10])
% plot(1:maxiter, values, 'linewidth', linewidth)
% set(gca,'FontSize',Fontsize)
% box off
% xlim([1,maxiter])
% xlabel('Time step','Fontsize',Fontsize)
% if strcmp(task, 'preference')
%     ylabel('Value','Fontsize',Fontsize)
% elseif strcmp(task, 'LandoltC')
%     ylabel('Probability of correct response')
% end
% pbaspect([1 1 1])
% 
% % 'Optimal parameters';
% for k = 1:numel(ib)
%     subplot(4,5,[2*5+k,3*5+k])
%     plot(x_best(ib(k),:), 'linewidth', linewidth); hold on;
%     set(gca,'FontSize',Fontsize)
%     %     yline(sqrt(rho), 'linewidth', linewidth, 'color', 'r'); hold off
%     yline(model_params(ib(k)), 'linewidth', linewidth, 'color', 'r'); hold off
%     ylabel(['Optimal ', params_names{ib(k)}],'Fontsize',Fontsize)
%     xlabel('Iteration','Fontsize',Fontsize)
%     %     ylim([lb(ib(k)), ub(ib(k))])
%     pbaspect([1 1 1])
%     xlim([1, maxiter])
%     box off
% end
% 
% for k = 1:nk
%     if 5>k
%         subplot(4,5,k)
%     else
%         subplot(4,5,6+k-5)
%     end
%     imagesc(reshape(percept(:,k),ny,nx));
%     title(range(k), 'Fontsize', Fontsize)
%     axis off
%     set(gca,'dataAspectRatio',[1 1 1])
%     colormap('gray')
% end
% 
% savefig(fig, [figure_directory,filename_base, '_experiment_evolution.fig'])
% exportgraphics(fig, [figure_directory,filename_base, '_experiment_evolution.png'])
% exportgraphics(fig, [figure_directory,filename_base, '_experiment_evolution.eps'])
 
%% Plot value as a function of RMSE
x_best_norm  = NaN(d,maxiter);
x_best_norm = (x_best(ib,:) - lb')./(ub'- lb');

[~, value_opt, ~,~] = model.prediction(theta, xtrain_norm, ctrain, [x_best_norm; x0.*ones(d,size(x_best_norm,2))], kernelfun, kernelname, modeltype, post, regularization);

fig=figure('units','normalized','outerposition',[0 0 1 1]);
fig.Color =  [1 1 1];
plot(1:maxiter, value_opt, 'linewidth', linewidth);
box off
xlabel('Iteration')
ylabel('Value of the inferred optimum')
set(gca,'xlim',[1,maxiter])
% fig=figure('units','normalized','outerposition',[0 0 1 1]);
% fig.Color =  [1 1 1];
% plot(1:maxiter, rmse, 'linewidth', linewidth);
% box off
% xlabel('Iteration')
% ylabel('RMSE for the inferred optimum')
% set(gca,'xlim',[1,maxiter])
% 
% [p,S] = polyfit(-rmse,values,1);
% 
% rmse_range = linspace(min(-rmse),max(-rmse), 100);
% fig = figure();
% fig.Color = [1,1,1];
% scatter(-rmse, values, 25, '','filled'); hold on;
% plot(rmse_range, p(1)*rmse_range + p(2),'linewidth', linewidth)
% xlabel('RMSE','Fontsize',Fontsize)
% ylabel('Value','Fontsize',Fontsize)
% pbaspect([1 1 1])
% xlim([min(-rmse), max(-rmse)])
% h = plot(NaN,NaN,'ok');
% legend(h, ['a = ', num2str(p(1)), ' b = ', num2str(p(2))]);



post = [];
regularization = 'nugget';

%% This is to test the ability of the model to predict preferences
if strcmp(task, 'preference')
    k = 10;
    n= maxiter;
    nset = randperm(n);
    setsize = n/k;
    
    predictions = NaN(k, setsize);
    observations = NaN(k, setsize);
    
    delta_val=NaN(k, setsize);
    for i = 1:k
        idtest= nset(((i-1)*setsize+1):i*setsize);
        idtrain =setdiff(1:n,idtest);
        if strcmp(task, 'preference')
            [mu_c, mu_y] =  model.prediction(theta, xtrain_norm(:, idtrain), ctrain(idtrain), xtrain_norm(:,idtest), kernelfun, kernelname,modeltype, post, regularization);
        elseif strcmp(task, 'LandoltC')
            [mu_c, mu_y] =  model.prediction(theta, xtrain_norm(:, idtrain), ctrain(idtrain), xtrain_norm(:,idtest), post);
            
        end
        predictions(i,:)= mu_c;
        observations(i,:) = ctrain(idtest);
        delta_val(i,:) = mu_y;
    end
    delta_val= delta_val(:);
    [delta_val,s] = sort(delta_val);
    predictions= predictions(:);
    predictions = predictions(s);
    observations = observations(:);
    observations = observations(s);
    
    
    experiment.Kfold_validation_score = mean(abs(observations-predictions));
    
    %     mean(abs(observations-(predictions>0.5)))
    
    if strcmp(task, 'preference')
        
        delta_val = [delta_val;-delta_val];
        predictions = [predictions; 1-predictions];
        observations = [observations; 1-observations];
    end
    % Plot a logistic regression fit.
    % B = mnrfit(delta_val, 1+observations) ;
    % logreg_preds = mnrval(B,delta_val);
    % logreg_preds  =logreg_preds(:,2);
    %
    b  =glmfit(delta_val,observations,'binomial','link', 'probit');
    yfit = glmval(b,delta_val,'probit');
    
    
    [fitresult, gof] = sigmoid_fit(delta_val, predictions)
    pred_fit = fitresult(delta_val);
    
    fig=figure('units','normalized','outerposition',[0 0 1 1]);
    fig.Color =  [1 1 1];
    scatter(delta_val, predictions, 15, 'r', 'filled'); hold on;
    scatter(delta_val, observations, 15, 'b', 'filled'); hold on;
    plot(delta_val, pred_fit, 'r', 'linewidth', linewidth); hold on;
    plot(delta_val, yfit, 'b', 'linewidth', linewidth); hold on;
    %      plot(delta_val, normcdf(delta_val), 'k', 'linewidth', linewidth); hold off;
    if strcmp(task, 'preference')
        xlabel('Value difference')
        ylabel('Probability of preference')
    else
        xlabel('Value difference')
        ylabel('Probability of preference')
        
    end
    legend('Predictions', 'Observations', 'Logistic regression fit to the observations','Sigmoid fit to the predictions')
    savefig(fig, [figure_directory,filename_base, '_model_accuracy.fig'])
    exportgraphics(fig, [figure_directory,filename_base, '_model_accuracy.png'])
    exportgraphics(fig, [figure_directory,filename_base, '_model_accuracy.eps'])
     
end

% drange = 1:10:200;
% drange = drange(10:end);
p_duels1 = NaN(numel(range), ny, nx);
p_duels2 = NaN(numel(range), ny, nx);
p_best = NaN(numel(range), ny, nx);

k=0;

% if strcmp(task,'preference')
%     xtrain_complete = model_params*ones(1,size(xtrain,2));
% xtrain_complete = repmat(xtrain_complete,2,1);
% nd = 9;
% xtrain_complete(ib,:) = xtrain(1:d,:);
% xtrain_complete(nd+ib,:) =  xtrain(d+(1:d),:);
%         figure('units','points')      
% 
%     for i = range
%         k=k+1;
%         [~,p1] = g(xtrain_complete(1:nd,i));
%         p_duels1(k,:,:) = reshape(p1(:,1),ny,nx);
%         [~,p2] = g(xtrain_complete((d+1):end,i));
%         p_duels2(k,:,:) =reshape(p2(:,1),ny,nx);
%         [~,p] = g(x_best(:,i));
%         p_best(k,:,:) =reshape(p(:,1),ny,nx);
%         
%         %fig=figure('units','normalized','outerposition',[0 0 1 1]);
% %         fig=figure('units','points','outerposition',[0 0 426/2 2/3*426]);
% %         fig.Color =  [1 1 1];
% %         subplot(1,3,1)
% %         imagesc(p_duels1);
% %         axis off
% %         set(gca,'dataAspectRatio',[1 1 1])
% %         
% %         subplot(1,3,2)
% %         imagesc(p_duels2);
% %         axis off
% %         set(gca,'dataAspectRatio',[1 1 1])
% %         
% %         subplot(1,3,3)
% %         imagesc(p_best);
% %         axis off
% %         set(gca,'dataAspectRatio',[1 1 1])
% %         colormap('gray')
% %         
% %         savefig(fig, [figure_directory,filename_base, '_duel',num2str(i),'.fig'])
% %         exportgraphics(fig, [figure_directory,filename_base, '_duel',num2str(i),'.png'])
% %         exportgraphics(fig, [figure_directory,filename_base, '_duel',num2str(i),'.eps'])
% %         close all
%         ax1 = subplot(numel(range),3,k,'Units', 'points');
%         imagesc(squeeze(p_duels1(k,:,:)));
%         set(gca,'dataAspectRatio',[1 1 1])
%         colormap('gray')
%         axis off
%         pos = [0,0,89.6304 23.9433];
%         set(ax1, 'Position', pos)
%         
%         ax2 = subplot(numel(range),3,k+1,'Units', 'points');
%         imagesc(squeeze(p_duels2(k,:,:)));
%         set(gca,'dataAspectRatio',[1 1 1])
%         colormap('gray')
%         axis off
%         pos = [pos(3),0,89.6304 23.9433];
%         set(ax2, 'Position', pos)
%          
%         ax3 = subplot(numel(range),3,k+2,'Units', 'points');
%         imagesc(squeeze(p_best(k,:,:)));
%         set(gca,'dataAspectRatio',[1 1 1])
%         colormap('gray')
%         axis off
%         
%         pos = [2*pos(3),0,89.6304 23.9433];
% 
%         set(ax3, 'Position', pos)
%         
%         %%
%         subplot(numel(range),3,k)
%         imagesc(squeeze(p_duels1(k,:,:)));
%         set(gca,'dataAspectRatio',[1 1 1])
%         colormap('gray')
%         axis off       
%                
%         subplot(numel(range),3,k+1)
%         ax2 = imagesc(squeeze(p_duels2(k,:,:)));
%         set(gca,'dataAspectRatio',[1 1 1])
%         colormap('gray')
%         axis off
%         
%         subplot(numel(range),3,k+2)
%         ax3 = imagesc(squeeze(p_best(k,:,:)));
%         set(gca,'dataAspectRatio',[1 1 1])
%         colormap('gray')
%         axis off
%     end
% end
% 
if ~any(isnan(rt))
    [mu_c, mu_y] =  model.prediction(theta, xtrain_norm, ctrain, xtrain_norm, kernelfun, kernelname, modeltype, post, regularization);
    
    figure()
    scatter(rt,abs(mu_c-0.5))
        
end

%%

range = [2.^(1:floor(log2(maxiter))), maxiter];
nk = numel(range);
p1= [];
p2= [];

for k = 1:nk
    xm = model_params;
    xm(ib) = xtrain(1:d,range(k));
    [~,percept] = g(xm, []);
    p1 = [p1, percept];
    xm = model_params;
    xm(ib) = xtrain((d+1):end,range(k));

    [~,percept] = g(xm, []);
    p2 = [p2, percept];

end



fig3 = figure('units','normalized','outerposition',[0 0 1 1]);
fig3.Color = [1,1,1];
width = 0.0871;
height = 0.8150;
xpositions = zeros(nk,2);
ypositions = zeros(nk,2);

yoffset = 3*0.2/nk;
xoffset = 2*0.2/nk;

yoffsets =0.5 -(0:(nk-1))*yoffset;
xoffsets = 0.3+(0:(nk-1))*xoffset;
xpositions(:,1) = xoffsets;
xpositions(:,2) = xoffsets+ 0.1;
ypositions(:,1) = yoffsets;
ypositions(:,2) = yoffsets;

c = 0;
for k = 1:nk
    c=c+1;
    h =subplot(nk,2,c);
    imagesc(reshape(percept(:,k),ny,nx));
    title(range(k))
    axis off
    set(gca,'dataAspectRatio',[1 1 1])
    posnew = [xpositions(k,1), ypositions(k,1), width, height];    
    set(h, 'Position', posnew)
    c=c+1;
    
    h =subplot(nk,2,c);
    imagesc(reshape(percept(:,k),ny,nx));
    title(range(k))
    axis off
    set(gca,'dataAspectRatio',[1 1 1])
    posnew = [xpositions(k,2), ypositions(k,2), width, height];
    set(h, 'Position', posnew)
    
end

fig3 = figure('units','pixels');
fig3.Color = [1,1,1];
width = 0.3347;
height = 0.0873;
xpositions = zeros(nk,2);
ypositions = zeros(nk,2);

yoffset = 3*0.2/nk;
xoffset = 2*0.2/nk;

yoffsets =0.5 -(0:(nk-1))*yoffset;
xoffsets = 0.3+(0:(nk-1))*xoffset;
xpositions(:,1) = xoffsets;
xpositions(:,2) = xoffsets+ 0.1;
ypositions(:,1) = yoffsets;
ypositions(:,2) = yoffsets;

c = 0;
for k = 1:nk
    c=c+1;
    h =subplot(nk,2,c);
    imagesc(reshape(percept(:,k),ny,nx));
    title(range(k))
    axis off
    set(gca,'dataAspectRatio',[1 1 1])
    posnew = [xpositions(k,1), ypositions(k,1), width, height];    
    set(h, 'Position', posnew)
    c=c+1;
    
    h =subplot(nk,2,c);
    imagesc(reshape(percept(:,k),ny,nx));
    title(range(k))
    axis off
    set(gca,'dataAspectRatio',[1 1 1])
    posnew = [xpositions(k,2), ypositions(k,2), width, height];
    set(h, 'Position', posnew)
    
end

