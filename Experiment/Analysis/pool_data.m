function [x_train_data, x_train_norm_data, c_train_data, theta_data] =  pool_data(subject, seed, task)
add_directories;
T = load(data_table_file).T;
T = T(T.Subject == subject & T.Seed == seed  & T.Task == 'preference', :);
for k = 1:size(T,1)
    task = cellstr(T(k,:).Task);
    task = task{1};
    acquisition_fun_name = cellstr(T(k,:).Acquisition);
    acquisition_fun_name = acquisition_fun_name{1};
    index = T(k,:).Index;
    filenames{k} = [data_directory, '/Data_Experiment_p2p_',task,'/',subject,'/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
end

x_train_data = [];
x_train_norm_data = [];
c_train_data = [];
theta_data = [];
for i = 1:numel(filenames)
    filename = filenames{i};
    load(filename, 'experiment');
    x_train_data = [x_train_data, experiment.xtrain];
    x_train_norm_data = [x_train_norm_data,  experiment.xtrain_norm];    
    c_train_data = [c_train_data,  experiment.ctrain];
    theta_data =[theta_data,  experiment.theta(:)];
end
