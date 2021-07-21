clear all
% global pathname
% pathname = '/media/sf_Documents/';
add_directories;

T = load(data_table_file).T;
T = T(T.Subject == 'TF',:);
T = T(13:end,:);

for i = 11:size(T,1)
    filename = [data_directory, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
    plot_encoder_evolution(filename)
end