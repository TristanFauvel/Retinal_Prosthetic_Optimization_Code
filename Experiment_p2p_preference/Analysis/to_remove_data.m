
% For example here I want to delete all the data about subject  'TF'
subject = 'TF';
add_modules;
T = load(data_table_file);
T= T.T;
V = T(T.Subject == subject,:);
for k = 1:size(V,1)
    task = cellstr(V(k,:).Task);
    task = task{1};
    acquisition_fun_name = cellstr(V(k,:).Acquisition);
    acquisition_fun_name = acquisition_fun_name{1};
    index = V(k,:).Index;
    filenames{k} = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index),'.mat'];
    delete(filenames{k})
end


T(T.Subject == subject,:) = [];
save(data_table_file,'T');