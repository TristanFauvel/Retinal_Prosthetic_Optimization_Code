T = load(data_table_file);
T= T.T;
subject = 'TF';
T = T(T.Subject == subject,:);
% T=T(13:end,:);
% T=T(13:end,:); nexp = size(T,1);
% T = T(T.Acquisition == 'random' & T.Task == 'preference' & T.Misspecification == 0,:);
%
% T = T(end-exp+1,:);
filenames  = [];
for k = 1:size(T,1)
    task = cellstr(T(k,:).Task);
    task = task{1};
    acquisition_fun_name = cellstr(T(k,:).Acquisition);
    acquisition_fun_name = acquisition_fun_name{1};
    index = T(k,:).Index;
    filenames{k} = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
end

for k = 1:numel(filenames)
     filename = filenames{k};
     sequence_plot(filename);
end