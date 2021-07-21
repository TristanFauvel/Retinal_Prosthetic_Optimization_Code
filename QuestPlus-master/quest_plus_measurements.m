clear all
respDomain = [0 1];
stim_res = 255;
bounds = [0,1];
lb = bounds(1);
ub = bounds(2);
x = linspace(lb,ub,stim_res);
stimDomain = x;

a = 5;
n= 3;
nseeds = 100;
mistakes = 1:3:25;
niter = NaN(n,nseeds,numel(mistakes));
estimates = NaN(n,nseeds,numel(mistakes));

seeds =1:nseeds;
nalts = [4, 10,100];
threshold = 0.8;
for i=1:n
    nalt = nalts(i);
    b = norminv(1/nalt,0,1);
    F = @(x,a)normcdf(a.*x+b);

%     F = @(x,a)([1-normcdf(a.*x+b),normcdf(a.*x+b)])';
    % Ftrue = @(x,a,e)([1-((1-e)*normcdf(a.*x+b)+e/nalt),(1-e)*normcdf(a.*x+b)+e/nalt])';
    param_ub = (norminv(threshold)-b)*stim_res; % Maxmum slope it is possible to measure given min stimulus intensity
    param_lb = (norminv(threshold)-b)/bounds(2); % Minimum slope it is possible to measure given max stimulus intensity
    
    a_range = linspace(param_lb, param_ub,500);
    
    paramDomain = {a_range};
    
    y1 = unifpdf(paramDomain{1},param_lb,param_ub);
    y1 = y1./sum(y1);
    priors = {y1};
    
    stop_rule = 'entropy';
    stop_criterion = 2.5;
    minNTrials = 25;
    maxNTrials = 200;
    
    x_norm = (x-lb)./(ub-lb);
    clear('QP')
    QP = QuestPlus(F, stimDomain, paramDomain, respDomain, stop_rule, stop_criterion, minNTrials, maxNTrials);
    % initialise (with default, uniform, prior)
    QP.initialise(priors);
    save('QPlikelihoods_robustess_to_mistakes', 'QP');
    
    for j = 1:numel(mistakes)
        mistake_i = mistakes(j);
        for k = 1:nseeds
            seed = seeds(k);
            rng(seed)
            
            load('QPlikelihoods_robustess_to_mistakes', 'QP');
            
            new_x= randsample(x,1);
            it = 0;
            while ~QP.isFinished()
                it = it + 1;
                new_x =  QP.getTargetStim();
                
                c = F(new_x,a)>rand;
                if it == mistake_i
                    c = 1/nalt>rand ;
                end
                QP.update(new_x, c);
            end
            endGuess_mean = QP.getParamEsts('mean');
            estimates(i,k,j) = endGuess_mean;
            niter(i,k,j) = it;
            
        end
    end
end
close all;
graphics_style_paper;

figure()
for i =1:n
    subplot(1,n,i)
    v = niter(i,:,:);
    hist(v(:))
end

figure()
k = 0;
for i =1:n
    for j=1:numel(mistakes)
        k =k+1;
        subplot(n,numel(mistakes),k)
        v = estimates(i,:,j);
        hist(v(:))
    end
end

figure()
for i =1:n
    subplot(1,n,i)
    v = estimates(i,:,:);
    hist(v(:))
end

figure()
for i =1:n
    subplot(1,n,i)
    v = estimates(i,:,:);
    bar(squeeze(mean(v))); hold on;
    errorbar(x,y,err); hold off
end

