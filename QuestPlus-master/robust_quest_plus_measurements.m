nalt = 4;
b = norminv(1/nalt,0,1);
F = @(x,a,e)([1-((1-e)*normcdf(a.*x+b)+e/nalt),(1-e)*normcdf(a.*x+b)+e/nalt])';

% create QUEST+ object
stim_lb = 0;
stim_ub = 1;
stim_res = 255;
stimDomain = linspace(stim_lb, stim_ub, stim_res);

param_lb = 0;
param_ub = 1;
a_range = logspace(param_lb,param_ub,100);
e_range=linspace(0,0.2,100);

% 
% paramDomain = {a, b};
paramDomain = {a_range, e_range};
respDomain = [0 1];

a = 10;
e = 0;

y1 = unifpdf(paramDomain{1},10^param_lb,10^param_ub);
y1 = y1./sum(y1);
y2 = betapdf(paramDomain{2},1,20);
y2 = y2./sum(y2);
priors = {y1, y2};
                    
stop_rule = 'entropy';
stop_criterion = 2.5;
minNTrials = 25;
maxNTrials = 80;

QP = QuestPlus(F, stimDomain, paramDomain, respDomain, stop_rule, stop_criterion, minNTrials, maxNTrials);
% initialise (with default, uniform, prior)
QP.initialise(priors);
% run
startGuess_mean = QP.getParamEsts('mean');
startGuess_mode = QP.getParamEsts('mode');

t = 0; %%
while ~QP.isFinished()
    it = it+1; %%
    
     if it == 3 
        targ = QP.stimDomain(181);
        tmp = F(targ, a, e);
        pC = tmp(2);
        anscorrect = rand()<pC;
        
        anscorrect = 1-anscorrect;
    else    
        
        targ =  QP.getTargetStim();
        tmp = F(targ, a, 0);
        if e>rand
            tmp(2) = 0.25;
            tmp(1) = 1 - tmp(2);
        end
        pC = tmp(2);
        anscorrect = rand()<pC;
    end
   
    QP.update(targ, anscorrect);
end

% get final parameter estimates
endGuess_mean = QP.getParamEsts('mean');
endGuess_mode = QP.getParamEsts('mode');

x = linspace(0,1,1000)';
f = F(x,a, e);
fest = F(x,endGuess_mean(1),0);

graphics_style_paper;
fig=figure('units','points','outerposition',[0 0 426/2 2/3*426]);
fig.Color =  [1 1 1];
plot(x, f(2,:)); hold on;
plot(x, fest(2,:)); hold on;
scatter(QP.history_stim, QP.history_resp, markersize, 'k', 'filled'); hold off;
legend({'True function', 'Estimated function'})
ylim([0 1])



y1 = betapdf(x,1,20);
figure()
plot(x, y1)