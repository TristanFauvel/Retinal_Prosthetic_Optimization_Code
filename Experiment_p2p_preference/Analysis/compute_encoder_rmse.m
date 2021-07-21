function rmse = compute_encoder_rmse(filename)


load(filename, 'experiment');
UNPACK_STRUCT(experiment, false)

letter_folder =  Stimuli_folder;
S = load_stimuli_letters(experiment);
S= S(:,1);
wbar = waitbar(0,'Computing best parameters...');

for i = 1:maxiter
    waitbar(i/maxiter,wbar,'Computing the rmse...');
    W = encoder(x_best(:,i), experiment,ignore_pickle);
    p_kss = vision_model(M,W,S);
    rmse(i) = sqrt(mean((p_kss(:)-S(:)).^2));
end

