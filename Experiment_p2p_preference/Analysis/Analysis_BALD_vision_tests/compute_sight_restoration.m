function compute_sight_restoration(filename)
load(filename, 'experiment');
m=0;
if isfield(experiment, 'VA_measure_optimized')
    m=m+1;
    experiment.acuity_E_optimized = compute_VA(experiment,experiment.VA_measure_optimized);
end
if isfield(experiment, 'VA_measure_optimal')
    m=m+1;
    experiment.acuity_E_optimal = compute_VA(experiment,experiment.VA_measure_optimal);
end
if isfield(experiment, 'VA_measure_naive')
    m=m+1;    
    experiment.acuity_E_naive= compute_VA(experiment,experiment.VA_measure_naive);
end
if isfield(experiment, 'CS_measure_optimized')
    m=m+1;    
    experiment.cs_E_optimized = compute_CS(experiment,experiment.CS_measure_optimized);
end
if isfield(experiment, 'CS_measure_optimal')
    m=m+1;    
    experiment.cs_E_optimal = compute_CS(experiment,experiment.CS_measure_optimal);
end
if isfield(experiment, 'CS_measure_naive')
    m=m+1;    
    experiment.cs_E_naive = compute_CS(experiment,experiment.CS_measure_naive);
end

% if isfield(experiment, 'VA_CS_measure_optimized')
%     [experiment.acuity_E_optimized, experiment.cs_E_optimized] = compute_VA_CS(experiment,experiment.VA_CS_measure_optimized);
% end
% if isfield(experiment, 'VA_CS_measure_optimal')
%     [experiment.acuity_E_optimal, experiment.cs_E_optimal] = compute_VA_CS(experiment,experiment.VA_CS_measure_optimal);
% end
% if isfield(experiment, 'VA_CS_measure_naive')
%     [experiment.acuity_E_naive, experiment.cs_E_naive] = compute_VA_CS(experiment,experiment.VA_CS_measure_naive);
% end
save(filename,'experiment')