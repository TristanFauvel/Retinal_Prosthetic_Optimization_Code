function to_compute_thresholds_QUEST(T, task, data_table_file, data_directory)
measured_var = {'VA'};

if isempty(T)
    T = load(data_table_file).T;
end
codes = {'optimal', 'optimized','control', 'naive'};
N = numel(codes);
for i = 1:size(T,1)
    filename = [data_directory, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
    load(filename, 'experiment');
   
    for ki = 1:N
                    code = codes{ki};
        if strcmp(code, 'optimized')
            code = experiment.acquisition_fun_name;
            
%             %%%%%%%%%%%%%%
%             if isfield(experiment, ['VA_', task, '_QUEST_','optimized'])
%                 experiment.(['VA_', task, '_QUEST_',code]) = experiment.(['VA_', task, '_QUEST_','optimized']);
%                 experiment = rmfield(experiment, ['VA_', task, '_QUEST_','optimized']);
%                 experiment = rmfield(experiment, [task, '_VA_optimized']);
%             end
%             %%%%%%%%%%%%%
         end
        if ismember('CS', measured_var)
            if isfield(experiment, ['CS_', task, '_QUEST_',code ])
                measure= experiment.(['CS_', task, '_QUEST_', code ]);
                if ~isstruct(measure)
                    measure = measure{1};
                end
                
                CS = threshold_computation_QUEST(filename, 'CS', measure);
                experiment.([task, '_CS_', code ])= CS;
            end
        end
        if ismember('VA', measured_var)
            if isfield(experiment, ['VA_', task, '_QUEST_',code ])
                measure= experiment.(['VA_', task, '_QUEST_', code ]);
                if ~isstruct(measure)
                    measure = measure{1};
                end
                
                VA = threshold_computation_QUEST(filename, 'VA', measure);
                experiment.([task, '_VA_', code ])= VA;
            end
        end
    end
    exp_filename = [data_directory, '/Data_Experiment_p2p_',char(T(i,:).Task),'/', char(T(i,:).Subject), '/', char(T(i,:).Subject), '_', char(T(i,:).Acquisition), '_experiment_',num2str(T(i,:).Index)];
    save(exp_filename, 'experiment')
end
