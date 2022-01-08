add_modules;

cd([code_directory, '/modified_P2P_stable'])
flag = int32(bitor(2, 8)); %To avoid memory allocation erros
py.sys.setdlopenflags(flag);
pymod = py.importlib.import_module('perceptual_model');
cd([code_directory,'/Experiment'])

graphics_style_paper;


T = load(data_table_file).T;
subject = 'TF';
id = find(T.Subject== subject)';
xi=  [];
for i = id
    task = cellstr(T(i,:).Task);
    task = task{1};
    index = T(i,:).Index;
    acquisition_fun_name = cellstr(T(i,:).Acquisition);
    acquisition_fun_name = acquisition_fun_name{1};
    subject = cellstr(T(i,:).Subject);
    subject = subject{1};
    filename = [data_directory, '/Data_Experiment_p2p_', task,'/',subject, '/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
    
    load(filename)
    
    xi = [xi; experiment.xtrain(1,1:5)];
end

for i = id
    task = cellstr(T(i,:).Task);
    task = task{1};
    index = T(i,:).Index;
    acquisition_fun_name = cellstr(T(i,:).Acquisition);
    acquisition_fun_name = acquisition_fun_name{1};
    subject = cellstr(T(i,:).Subject);
    subject = subject{1};
    filename = [data_directory, '/Data_Experiment_p2p_', task,'/',subject, '/',subject, '_', acquisition_fun_name, '_experiment_',num2str(index)];
    plot_BO_p2p_results(filename)
end

