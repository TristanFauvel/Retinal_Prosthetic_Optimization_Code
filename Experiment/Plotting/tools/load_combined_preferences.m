function [Pref_vs_E_training, Pref_vs_E_test, acq_vs_random_training, acq_vs_random_test, acq_vs_opt_training, acq_vs_opt_test, optimized_misspecified_vs_optimized_training, optimized_misspecified_vs_optimized_test,optimized_miss_vs_opt_miss_test, optimized_miss_vs_opt_miss_training, acq_vs_control_test, acq_vs_control_training, optimized_vs_naive_training, optimized_vs_naive_test, optimized_miss_vs_control_training, optimized_miss_vs_control_test, optimized_miss_vs_naive_training, optimized_miss_vs_naive_test, control_vs_naive_training, E_vs_naive_training,E_vs_control_training,opt_miss_vs_control_training]  = load_combined_preferences(reload)


[Pref_vs_E_training, Pref_vs_E_test, acq_vs_random_training, acq_vs_random_test, acq_vs_opt_training, acq_vs_opt_test, optimized_misspecified_vs_optimized_training, optimized_misspecified_vs_optimized_test,optimized_miss_vs_opt_miss_test, optimized_miss_vs_opt_miss_training, acq_vs_control_test, acq_vs_control_training, optimized_vs_naive_training, optimized_vs_naive_test, optimized_miss_vs_control_training, optimized_miss_vs_control_test, optimized_miss_vs_naive_training, optimized_miss_vs_naive_test, control_vs_naive_training, E_vs_naive_training,E_vs_control_training,opt_miss_vs_control_training]  = load_preferences(reload);
[acq_vs_random_training_v1, acq_vs_random_test_v1, acq_vs_opt_training_v1, acq_vs_opt_test_v1]  = load_preferences_expv1(reload);

acq_vs_random_training = [acq_vs_random_training_v1, acq_vs_random_training];
acq_vs_random_test = [acq_vs_random_test_v1, acq_vs_random_test];
acq_vs_opt_training = [acq_vs_opt_training_v1, acq_vs_opt_training];
acq_vs_opt_test= [acq_vs_opt_test_v1, acq_vs_opt_test];



% 
% Pref_vs_E_training(Pref_vs_E_training>0.5)= 1;
% Pref_vs_E_training(Pref_vs_E_training<0.5) = 0;
% 
% Pref_vs_E_test(Pref_vs_E_test>0.5)= 1;
% Pref_vs_E_test(Pref_vs_E_test<0.5) = 0;
% 
% acq_vs_random_training(acq_vs_random_training>0.5)= 1;
% acq_vs_random_training(acq_vs_random_training<0.5) = 0;
% 
% acq_vs_random_test(acq_vs_random_test>0.5)= 1;
% acq_vs_random_test(acq_vs_random_test<0.5) = 0;
% 
% acq_vs_opt_training(acq_vs_opt_training>0.5)= 1;
% acq_vs_opt_training(acq_vs_opt_training<0.5) = 0;
% 
% acq_vs_opt_test(acq_vs_opt_test>0.5)= 1;
% acq_vs_opt_test(acq_vs_opt_test<0.5) = 0;
% 
% optimized_misspecified_vs_optimized_training(optimized_misspecified_vs_optimized_training>0.5)= 1;
% optimized_misspecified_vs_optimized_training(optimized_misspecified_vs_optimized_training<0.5) = 0;
% 
% optimized_misspecified_vs_optimized_test(optimized_misspecified_vs_optimized_test>0.5)= 1;
% optimized_misspecified_vs_optimized_test(optimized_misspecified_vs_optimized_test<0.5) = 0;
% 
% optimized_miss_vs_opt_miss_test(optimized_miss_vs_opt_miss_test>0.5)= 1;
% optimized_miss_vs_opt_miss_test(optimized_miss_vs_opt_miss_test<0.5) = 0;
% 
% optimized_miss_vs_opt_miss_training(optimized_miss_vs_opt_miss_training>0.5)= 1;
% optimized_miss_vs_opt_miss_training(optimized_miss_vs_opt_miss_training<0.5) = 0;
% 
% acq_vs_control_test(acq_vs_control_test>0.5)= 1;
% acq_vs_control_test(acq_vs_control_test<0.5) = 0;
% 
% acq_vs_control_training(acq_vs_control_training>0.5)= 1;
% acq_vs_control_training(acq_vs_control_training<0.5) = 0;
% 
% optimized_vs_naive_training(optimized_vs_naive_training>0.5)= 1;
% optimized_vs_naive_training(optimized_vs_naive_training<0.5) = 0;
% 
% optimized_vs_naive_test(optimized_vs_naive_test>0.5)= 1;
% optimized_vs_naive_test(optimized_vs_naive_test<0.5) = 0;
% 
% optimized_miss_vs_control_training(optimized_miss_vs_control_training>0.5)= 1;
% optimized_miss_vs_control_training(optimized_miss_vs_control_training<0.5) = 0;
% 
% optimized_miss_vs_control_test(optimized_miss_vs_control_test>0.5)= 1;
% optimized_miss_vs_control_test(optimized_miss_vs_control_test<0.5) = 0;
% 
% optimized_miss_vs_naive_training(optimized_miss_vs_naive_training>0.5)= 1;
% optimized_miss_vs_naive_training(optimized_miss_vs_naive_training<0.5) = 0;
% 
% optimized_miss_vs_naive_test(optimized_miss_vs_naive_test>0.5)= 1;
% optimized_miss_vs_naive_test(optimized_miss_vs_naive_test<0.5) = 0;
% 
% control_vs_naive_training(control_vs_naive_training>0.5)= 1;
% control_vs_naive_training(control_vs_naive_training<0.5) = 0;
% 
% E_vs_naive_training(E_vs_naive_training>0.5)= 1;
% E_vs_naive_training(E_vs_naive_training<0.5) = 0;
% 
% E_vs_control_training(E_vs_control_training>0.5)= 1;
% E_vs_control_training(E_vs_control_training<0.5) = 0;
% 
% opt_miss_vs_control_training(opt_miss_vs_control_training>0.5)= 1;
% opt_miss_vs_control_training(opt_miss_vs_control_training<0.5) = 0;
% 
