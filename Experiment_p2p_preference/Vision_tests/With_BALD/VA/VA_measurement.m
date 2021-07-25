function VA_measure = VA_measurement(experiment, W, test)
% Visual acuity measurement using landolt C test and active learning.

add_directories


acquisition_fun =@adaptive_sampling_binary_grid_gpml;

rng(experiment.seed)
nx = experiment.nx;
ny = experiment.ny;

viewing_distance = experiment.viewing_distance;
visual_field_size = experiment.visual_field_size;
display_size = floor(experiment.display_size);

switch test
    case 'LandoltC'
        bounds = [0, display_size(1)]; %size range for the C
        Stimuli_folder =  [Stimuli_folder,'/landoltC'];
    case 'Vernier'
        barwidth=10;
        b = 15; %margin
        bounds = [-15,15]; %[-(nx-barwidth)+30+b, nx-barwidth-30-b];
        maxiter = 80;
    case 'E'
        bounds = [0, display_size(1)]; %size range for the E
        Stimuli_folder =  [Stimuli_folder,'/E'];
        maxiter = 80;
end
lb = bounds(1);
ub = bounds(2);
update_period = 10;

size_range = linspace(lb,ub,1500);
x = size_range;
x_norm = (x-lb)./(ub-lb);

meanfunc = @meanConst; hyp.mean = norminv(0.25);
covfunc = {'covLINiso'};

hyp.cov = log(1);

likfunc = @likErf;
% We want to keep the constant mean hyperparameter fixed:
prior.mean = {@priorClamped};
inf_func = {@infPrior,@infEP,prior};


%% Initialize the experiment
new_x= randsample(x,1);
burnin = 5;
nopt = 20; % number of time steps before starting using the acquisition function

close all;


graphics_style_paper;
M = experiment.M;
xtrain =  NaN(size(new_x,1),maxiter);
ctrain = NaN(1,maxiter);

for i = 1:burnin
    switch test
        case 'LandoltC'
            correct_response = randsample([1,2,3,4,6,7,8,9], 1);
            S = load_landolt_C(correct_response, new_x, nx, ny, Stimuli_folder,1);
        case 'Vernier'
            offset = new_x;
            if numel(1+b+ceil((abs(offset) + barwidth)/2): (nx-b -floor((abs(offset)+barwidth)/2))) == 1
                center = 1+b+ceil((abs(offset) + barwidth)/2);
            else
                %center = randsample(1+ceil((abs(offset) + barwidth)/2): (nx -floor((abs(offset)+barwidth)/2)),1);
                if isempty(1+b+ceil((abs(offset) + barwidth)/2): (nx-b -floor((abs(offset)+barwidth)/2)))
                    center = floor(nx/2);
                else
                    center = randsample(1+b+ceil((abs(offset) + barwidth)/2): (nx-b -floor((abs(offset)+barwidth)/2)),1);
                end
            end
            correct_response = sign(offset);
            S = Vernier_frame(offset, nx, ny, barwidth, center,1);
        case 'E'
            correct_response = randsample([8,6,2,4], 1);
            S = load_E(correct_response, new_x, display_size(2), display_size(1), Stimuli_folder,1);
    end
    query_response_task(M, W, S, display_size, experiment, test)

    %query_response_VA_test(test, M, W, S, correct_response, display_size, experiment);
    idx = randsample(size(x,2),1);
    new_x= x(:,idx);
end

i=0;
while i<maxiter
    i=i+1;
    %     waitbar(i/maxiter,wbar,'Experiment complextion');
    switch test
        case 'LandoltC'
            correct_response = randsample([1,2,3,4,6,7,8,9], 1);
            S = load_landolt_C(correct_response, new_x, nx, ny, Stimuli_folder,1);
        case 'Vernier'
            offset = new_x;
            if numel(1+b+ceil((abs(offset) + barwidth)/2): (nx-b -floor((abs(offset)+barwidth)/2))) == 1
                center = 1+b+ceil((abs(offset) + barwidth)/2);
            else
                %center = randsample(1+ceil((abs(offset) + barwidth)/2): (nx -floor((abs(offset)+barwidth)/2)),1);
                if isempty(1+b+ceil((abs(offset) + barwidth)/2): (nx-b -floor((abs(offset)+barwidth)/2)))
                    center = floor(nx/2);
                else
                    center = randsample(1+b+ceil((abs(offset) + barwidth)/2): (nx-b -floor((abs(offset)+barwidth)/2)),1);
                end
            end
            correct_response = sign(offset);
            S = Vernier_frame(offset, nx, ny, barwidth, center,1);
        case 'E'
            correct_response = randsample([8,6,2,4], 1);
            S = load_E(correct_response, new_x, display_size(2), display_size(1), Stimuli_folder,1);
    end
    [c, response] = query_response_task(M, W, S, display_size, experiment, test);
%query_response_VA_test(test, M, W, S, correct_response, display_size, experiment);
    
    switch test
        case {'LandoltC','E'}
            ctrain(i) = c;
        case 'Vernier'
            ctrain(i) = response;
    end
    
    if isnan(c)
        i=i-2;
        new_x = xtrain(:, i+1);
    else
        
        %% Normalize data so that the bound of the search space are 0 and 1.
        xtrain(:,i) = new_x;
        xtrain_norm = (xtrain(:,1:i)-lb)./(ub-lb);
        
        if i > nopt
            inf_func{2} = @infEP;
            try
                if i== nopt+1 || mod(i, update_period) ==1
                    nd = numel(hyp.cov);
                    theta_ub = 10*ones(nd,1);
                    theta_lb = -10*ones(nd,1);
                    ncandidates= 5;
                    starting_points= NaN(nd,ncandidates);
                    for k = 1:nd
                        starting_points(k,:)= theta_lb(k)+(theta_ub(k)-theta_lb(k))*rand(1,ncandidates);
                    end
                    if nd ==2
                        starting_points = [starting_points(1,:);starting_points(1,:)];
                    end
                    
                    minval=inf;
                    for k = 1:ncandidates
                        hyp.cov = starting_points(:,k)';
                        hyp= minimize(hyp, @gp, -40, inf_func, meanfunc, covfunc, likfunc, xtrain_norm', (2*ctrain(1:i)-1)');
                        val = gp(hyp, inf_func, meanfunc, covfunc, likfunc, xtrain_norm', (2*ctrain(1:i)-1)');
                        if isnan(val)
                            inf_func{2} = @infLaplace;
                            hyp= minimize(hyp, @gp, -40, inf_func, meanfunc, covfunc, likfunc, xtrain_norm', (2*ctrain(1:i)-1)');
                            val = gp(hyp, inf_func, meanfunc, covfunc, likfunc, xtrain_norm', (2*ctrain(1:i)-1)');
                        end
                        if ~isnan(val) && val < minval
                            best = hyp;
                            minval = val;
                        end
                    end
                    hyp = best;
                end
                inf_func{2} = @infKL;
                new_x = acquisition_fun(x_norm, hyp, xtrain_norm, ctrain(1:i), meanfunc, covfunc, likfunc,inf_func);
                new_x = new_x.*(ub-lb)+lb;
            catch
                idx = randsample(size(x,2),1);
                new_x= x(:,idx);
            end
        else %When we have not started to train the GP classification model, the acquisition is random
            idx = randsample(size(x,2),1);
            new_x= x(:,idx);
        end
    end
end

w = whos;
close all
for a = 1:length(w)
    if ~strcmp(w(a).name, 'experiment')
        VA_measure.(w(a).name) = eval(w(a).name);
    end
end


return

%% Compute the value function

% [mu_c, mu_y, sigma2_y] = prediction_bin(theta, xtrain, ctrain, x, kernelfun, modeltype, post, regularization);
% [fitresult, gof] = sigmoid_fit(xtrain, ctrain);
% pred_fit = fitresult(x);
% acuity = fitresult.k;
hyp = minimize(hyp, @gp, -40, inf_func, meanfunc, covfunc, likfunc, xtrain_norm', (2*ctrain-1)');

[a b c d lp] = gp(hyp, inf_func, meanfunc, covfunc, likfunc, xtrain_norm', (2*ctrain-1)', x_norm', ones(size(x,2),1));
mu_y = c;
sigma2_y =d;

mu_c = exp(lp);

figure()
subplot(2,1,1)
plot(x,mu_c); hold on;
scatter(xtrain, ctrain)
subplot(2,1,2)
errorshaded(x,mu_y,sqrt(sigma2_y))


fitresult = glmfit(xtrain, ctrain', 'binomial','link','probit');
pred_fit = glmval(fitresult, x, 'probit');

% fitresult(1) = norminv(0.25);
% figure(); plot([0,x], normcdf(fitresult(2)*[0,x]+ fitresult(1)))

[v,id] = min(abs(pred_fit-0.8));%smallest letter size for which the succeess rate was above 80%, in px
s = x(id);
s_m = s./experiment.dpcm; %smallest letter size for which the succeess rate was above 80%, in cm
a = 2*atan(0.01*s_m/viewing_distance); %smallest letter size for which the succeess rate was above 80%, in dva
a= a*180/pi; %convert in degrees;
a= 60*a; %convert in minute of arc
acuity = 10./a; %we assume that if  a =1', VA = 10/10

fig = figure();
fig.Color = [1 1 1];
plot(x, mu_c, 'linewidth', 1.5); hold on;
plot(x, pred_fit, 'linewidth', 1.5); hold on;
scatter(xtrain, ctrain, markersize, 'k', 'filled'); hold off;
switch test
    case 'Vernier'
        xlabel('Offset')
        ylabel('Probability of a response to the right')
        title(['k = ', num2str(acuity)])
    case 'LandoltC'
        xlabel('Diameter')
        ylabel('Probability of correct response')
    case 'E'
        xlabel('Size (px)')
        ylabel('Probability of correct response')
end
box off
legend('GPC model','GLM fit')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xcm = x./experiment.dpcm;
xtrain_cm = xtrain./experiment.dpcm;
fig = figure();
fig.Color = [1 1 1];
plot(xcm, mu_c, 'linewidth', 1.5); hold on;
plot(xcm, pred_fit, 'linewidth', 1.5); hold on;
plot(xcm, 0.8*ones(size(x)), 'linewidth', 1.5); hold on;
scatter(xtrain_cm, ctrain, markersize, 'k', 'filled'); hold off;
switch test
    case 'Vernier'
        xlabel('Offset')
        ylabel('Probability of a response to the right')
        title(['k = ', num2str(acuity)])
    case 'LandoltC'
        xlabel('Diameter')
        ylabel('Probability of correct response')
    case 'E'
        xlabel('Size (cm)')
        ylabel('Probability of correct response')
end
box off
legend('GPC model','GLM fit')

