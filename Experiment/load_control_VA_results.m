function [VA_E_controls,VA_Snellen_controls] = load_control_VA_results(reload)
add_directories;
filename = [data_directory,'/VA_control.mat'];
if reload
    [VA_E_controls,VA_Snellen_controls] = load_VA();
    save(filename, 'VA_E_controls','VA_Snellen_controls');
else
    load(filename, 'VA_E_controls','VA_Snellen_controls');
end
end

function [VA_E, VA_Snellen]= load_VA()
add_directories;
T = load(data_table_file).T;

indices = 1:size(T,1);
indices = indices(T.Acquisition=='MUC' & T.Misspecification == 0);
N = numel(indices);

VA_E = NaN(3,N);
VA_Snellen = NaN(3,N);


%% Case 1 : MaxVarChallenge
%% Case 2 : MaxVarChallenge, misspecified
%% Case 3 : E TS
            misspecification = 0;


for i =1:N
    
    index = indices(i);
    subject = char(T(index,:).Subject);
    model_seed = T(index,:).Model_Seed;
    %     filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    
    for k = 1:3
        if k ==1
            acquisition = 'MUC';
            task = 'preference';
        elseif k==2
            acquisition = 'random';
                        task = 'preference';
        elseif k==3
            acquisition = 'TS_binary';
                        task = 'E';
        end
        j = T(T.Subject == subject & T.Task == task & T.Acquisition == acquisition & T.Misspecification == misspecification & T.Model_Seed == model_seed,:).Index;
        va_snellen = NaN;
        va_e = NaN;
        if ~isempty(j)
            filename = [data_directory, '/Data_Experiment_p2p_',task,'/', subject, '/', subject, '_', acquisition, '_experiment_', num2str(j)];
            load(filename, 'experiment');
            if isfield(experiment, 'E_VA_control')
                va_e = experiment.E_VA_control;
            end
            if isfield(experiment, 'Snellen_VA_control')
                va_snellen = experiment.Snellen_VA_control;
            end
            
            VA_E(k,i) = va_e;
            VA_Snellen(k,i) = va_snellen;
        end
    end
end
end

%
% clear all
% add_modules;
% task = 'preference';
% data_directory = [experiment_path,'/Data'];
% figures_folder = [experiment_path,'/Figures'];
% alpha =0.01;
% T = load(data_table_file).T;
% T = T(T.Subject ~= 'CL' & T.Subject ~= 'PC' & T.Subject ~= 'TFs',:);
%
% indices_preference_acq = 1:size(T,1);
%
% acquisition = 'MUC';
%
% indices_preference_acq = indices_preference_acq(T.Task == task & T.Acquisition==acquisition & T.Misspecification==0);
%
% indices_preference_acq_misspecification = 1:size(T,1);
% indices_preference_acq_misspecification = indices_preference_acq_misspecification(T.Task == task & T.Misspecification==1);
%
%
% indices_preference_random = 1:size(T,1);
% indices_preference_random = indices_preference_random(T.Task ==task & T.Acquisition=='random');
%
%
% indices_E_TS = 1:size(T,1);
% indices_E_TS = indices_E_TS(T.Task == 'E' & T.Acquisition == 'TS_binary');
%
% %
% % [a,b] = sort(T(indices_preference_acq,:).Seed);
% % indices_preference_acq = indices_preference_acq(b);
% % [a,b] = sort(T(indices_preference_random,:).Seed);
% % indices_preference_random= indices_preference_random(b);
% % [a,b] = sort(T(indices_E_TS,:).Seed);
% % indices_E_TS= indices_E_TS(b);
%
% E_VA_control = NaN(3,numel(indices_preference_acq));
% Snellen_VA_control = NaN(3,numel(indices_preference_acq));
%
% for i =1:numel(indices_preference_acq)
%     index = indices_preference_acq(i);
%     filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
%     load(filename, 'experiment');
%
%     E_VA_control(1,i) = experiment.E_VA_control;
%         Snellen_VA_control(1,i) = experiment.Snellen_VA_control;
%         subject1{i} = char(T(index,:).Subject);
% end
% for i =1:numel(indices_E_TS)
%     index = indices_E_TS(i);
%     filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
%     load(filename, 'experiment');
%
%     E_VA_control(2,i) = experiment.E_VA_control;
%         Snellen_VA_control(2,i) = experiment.Snellen_VA_control;
%                 subject2{i} = char(T(index,:).Subject);
%
% end
% for i =1:numel(indices_preference_acq)
%     index = indices_preference_acq(i);
%     filename = [data_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
%     load(filename, 'experiment');
%
%     E_VA_control(3,i) = experiment.E_VA_control;
%         Snellen_VA_control(3,i) = experiment.Snellen_VA_control;
%                 subject3{i} = char(T(index,:).Subject);
% end
%
% graphics_style_paper;
%
%
% data_E = E_VA_control-mean(E_VA_control,1);
% std(data_E(:))
%
% data_S = Snellen_VA_control-mean(Snellen_VA_control,1);
% std(data_S(:))
%
% variance = [var(E_VA_control,1); var( Snellen_VA_control,1)]
%
%
% figure()
% scatter_plot(variance(1,:),variance(2,:), tail,'E', 'Snellen',[]); % H1: x – y come from a distribution with greater than 0
%
% fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
% fig.Color =  [1 1 1];
% x = E_VA_control(1,:);
% y= E_VA_control(2,:);
% tail = 'both'; %'right';
% scatter_plot(x,y,tail,'VA (logMAR)', 'VA (logMAR)',[]); % H1: x – y come from a distribution with greater than 0
% text(-0.18,1.15,'A','Units','normalized','Fontsize', 12,'FontWeight', 'Bold')
%
% %%
% data_E = (E_VA_control-mean(E_VA_control,1))./mean(E_VA_control,1);
% mean_rad_E = mean(data_E(:));
%
% data_S = (Snellen_VA_control-mean(Snellen_VA_control,1))./mean(Snellen_VA_control,1);
% mean_rad_S =mean(data_S(:));
%
% fig=figure('units','centimeters','outerposition',1+f*[0 0 16 1/2*16]);
% fig.Color =  [1 1 1];
% subplot(1,2,1)
% histogram(data_E(:),12);
% xlabel('Relative average deviation')
% box off
% title(['Tumbling E, (mean : ', num2str(mean_rad_E),')']);
% subplot(1,2,2)
% histogram(data_S(:), 12);
% xlabel('Relative average deviation')
% title(['Snellen, (mean : ', num2str(mean_rad_S),')']);
% box off