add_directories;
nT = load(data_table_file).T;
ndata_directory = data_directory;
indices = 1:size(nT,1);

for i =1:numel(indices)
    index = indices(i);
    T = nT;
    savetofilename = [ndata_directory, '/Data_Experiment_p2p_',char(T(index,:).Task),'/', char(T(index,:).Subject), '/', char(T(index,:).Subject), '_', char(T(index,:).Acquisition), '_experiment_',num2str(T(index,:).Index)];
    load(savetofilename, 'experiment');
    
    UNPACK_STRUCT(experiment, false)
    clear('experiment')
    
     experiment.display_size = display_size;
    experiment.p2p_version = p2p_version;
    experiment.default_values = default_values;
    experiment.implant_size = implant_size;
    experiment.n_electrodes = n_electrodes;
    experiment.n_ax_segments = n_ax_segments;
    experiment.n_axons = n_axons;
    experiment.xystep = xystep;
    experiment.use_ptb3 = use_ptb3;
    experiment.implant_name = implant_name;
    experiment.nx = nx ;
    experiment.ny = ny;
%     experiment.M = M;
    experiment.task = task;
    experiment.to_update = to_update;
    experiment.params = params;
    experiment.ib = ib ;
    experiment.image_size = image_size;
%     experiment.S = S;
    experiment.Stimuli_folder = Stimuli_folder;
    experiment.acquisition_fun = acquisition_fun;
    experiment.acquisition_fun_name = acquisition_fun_name;
    experiment.base_kernelfun = base_kernelfun;
    experiment.beta_inf = beta_inf;
    experiment.beta_inf_range = beta_inf_range;
    experiment.beta_sup = beta_sup;
    experiment.beta_sup_range = beta_sup_range;
    experiment.center_x = center_x;
    experiment.center_x_range = center_x_range;
    experiment.center_y = center_y;
    experiment.center_y_range = center_y_range;
    experiment.contrast = contrast;
    experiment.ctrain = ctrain;
    experiment.d = d;
    experiment.display_height = display_height;
    experiment.display_width = display_width;
    experiment.displayed_stim = displayed_stim;
    experiment.dpcm = dpcm;
    experiment.hyps = hyps;
    experiment.im_nx = im_nx;
    experiment.im_ny = im_ny;
    experiment.implant = implant;
    experiment.index = index;
    experiment.kernelfun = kernelfun;
    experiment.kernelname = kernelname;
    experiment.lambda = lambda;
    experiment.lambda_range = lambda_range;
    experiment.latest_perceptual_model_table_file = latest_perceptual_model_table_file;
    experiment.latest_perceptual_models_directory = latest_perceptual_models_directory;
    experiment.lb = lb;
    experiment.lb_norm = lb_norm;
    experiment.letter = letter;
    experiment.letters = letters;
    experiment.letters_range = letters_range;
    experiment.link = link;
    experiment.magnitude = magnitude;
    experiment.magnitude_range = magnitude_range;
    experiment.max_x = max_x;
    experiment.maxiter = maxiter;
    experiment.min_x = min_x;
    experiment.miniter = miniter;
    experiment.misspecification = misspecification;
    experiment.model_params = model_params;
    experiment.model_seed = model_seed;
    experiment.modeltype = modeltype;
    experiment.nelectrodes = nelectrodes;
    experiment.new_duel = new_duel;
    experiment.nopt = nopt;
    experiment.optimal_magnitude = optimal_magnitude;
    experiment.options_maxmean = options_maxmean;
    experiment.options_theta = options_theta;
    experiment.rho = rho;
    experiment.rho_range = rho_range;
    experiment.rot = rot;
    experiment.rot_range = rot_range;
    experiment.rt = rt;
    experiment.seed = seed;
    experiment.stable_perceptual_model_table_file = stable_perceptual_model_table_file;
    experiment.stable_perceptual_models_directory = stable_perceptual_models_directory;
    experiment.stop = stop;
    experiment.stopping_criterion = stopping_criterion;
    experiment.subject = subject;
    experiment.theta = theta;
    experiment.theta_init = theta_init;
    experiment.hyp_lb = hyp_lb;
    experiment.hyp_ub = hyp_ub;
    experiment.true_model_params = true_model_params;
    experiment.ub = ub;
    experiment.ub_norm = ub_norm;
    experiment.update_period = update_period;
    experiment.viewing_distance = viewing_distance;
    experiment.visual_field_size = visual_field_size;
    experiment.x0 = x0;
    experiment.x_best = x_best;
    experiment.x_best_norm = x_best_norm;
    experiment.x_duel = x_duel;
    experiment.x_duel1 = x_duel1;
    experiment.x_duel2 = x_duel2;
    experiment.x_rand = x_rand;
    experiment.xtrain = xtrain;
    experiment.xtrain_norm = xtrain_norm;
    experiment.z = z;
    experiment.z_range = z_range;
    try
    experiment.acq_vs_random_test = convert_preference_measurement(acq_vs_random_test);
    experiment.acq_vs_random_training = convert_preference_measurement(acq_vs_random_training);
    experiment.acq_vs_opt_test = convert_preference_measurement(acq_vs_opt_test);
    experiment.acq_vs_opt_training = convert_preference_measurement(acq_vs_opt_training);
    end
    try
    experiment.Pref_vs_E_test = convert_preference_measurement(Pref_vs_E_test);
    experiment.Pref_vs_E_training = convert_preference_measurement(Pref_vs_E_training);
    end
    experiment.VA_E_QUEST_optimal = convert_vision_test_QUEST(VA_E_QUEST_optimal);
    experiment.VA_E_QUEST_optimized = convert_vision_test_QUEST(VA_E_QUEST_optimized);
    try
    experiment.VA_E_QUEST_control{1} = convert_vision_test_QUEST(VA_E_QUEST_control{1});
    end 
    try
    experiment.VA_Snellen_QUEST_control{1} = convert_vision_test_QUEST(VA_Snellen_QUEST_control{1});
    end
    experiment.VA_Snellen_QUEST_optimized = convert_vision_test_QUEST(VA_Snellen_QUEST_optimized);
    experiment.VA_Snellen_QUEST_optimal = convert_vision_test_QUEST(VA_Snellen_QUEST_optimal);
    experiment.Snellen_VA_optimal = Snellen_VA_optimal;
    experiment.Snellen_slope_optimal = Snellen_slope_optimal;
    experiment.Snellen_threshold_intercept_optimal = Snellen_threshold_intercept_optimal;
    experiment.Snellen_VA_optimized = Snellen_VA_optimized;
    experiment.Snellen_slope_optimized = Snellen_slope_optimized;
    experiment.Snellen_threshold_intercept_optimized = Snellen_threshold_intercept_optimized;
    try
    experiment.Snellen_VA_control = Snellen_VA_control;
    experiment.Snellen_slope_control = Snellen_slope_control;
    experiment.Snellen_threshold_intercept_control = Snellen_threshold_intercept_control;
    end
    experiment.E_VA_optimal = E_VA_optimal;
    experiment.E_VA_slope_optimal = E_VA_slope_optimal;
    experiment.E_VA_threshold_intercept_optimal = E_VA_threshold_intercept_optimal;
    experiment.E_VA_optimized = E_VA_optimized;
    experiment.E_VA_slope_optimized = E_VA_slope_optimized;
    experiment.E_VA_threshold_intercept_optimized = E_VA_threshold_intercept_optimized;
    try
    experiment.E_VA_control = E_VA_control;
    experiment.E_VA_slope_control = E_VA_slope_control;
    experiment.E_VA_threshold_intercept_control = E_VA_threshold_intercept_control;
    end
    save(savetofilename, 'experiment');
end
save( 'C:\Users\tfauvel\Documents\TF_maxvar_challenge_experiment_1', 'experiment');
