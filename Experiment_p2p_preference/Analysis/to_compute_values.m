
T = load(data_table_file).T;

for i = 1:size(T,1)
    task = cellstr(T(i,:).Task);
    task = task{1};
    index = T(i,:).Index;
    acquisition_fun_name = cellstr(T(i,:).Acquisition);
    acquisition_fun_name = acquisition_fun_name{1};
    subject = cellstr(T(i,:).Subject);
    subject = subject{1};
    raw_filename = [raw_data_directory, '/Data_Experiment_p2p_', task,'/',subject, '/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
    values = compute_GP_values(raw_filename);
    load(exp_filename)
    experiment.values =  values;
        exp_filename = [data_directory, '/Data_Experiment_p2p_', task,'/',subject, '/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];

    save(exp_filename, 'experiment');
end

