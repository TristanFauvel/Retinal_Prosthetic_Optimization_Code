function [rho,lambda, rot, center_x, center_y, magnitude, beta_sup, beta_inf,z, lb, ub, model_lb, model_ub] = sample_perceptual_model(to_update,default_values,rho_range,lambda_range,rot_range,center_x_range,center_y_range,beta_sup_range,beta_inf_range,z_range,magnitude_range)
% Sample a perceptual model

default_values=num2cell(default_values);
[d_rho,d_lambda, d_rot, d_center_x, d_center_y, d_magnitude, d_beta_sup, d_beta_inf,d_z] = deal(default_values{:});

[rho,lambda, rot, center_x, center_y, magnitude, beta_sup, beta_inf,z] = deal(d_rho,d_lambda, d_rot, d_center_x, d_center_y, d_magnitude, d_beta_sup, d_beta_inf,d_z); 

lb = [];
ub = [];
if ismember('rho', to_update)
    lb =[lb; rho_range(1)];
    ub =[ub; rho_range(2)];
    rho = rand_interval(rho_range(1),rho_range(2));
end
if ismember('lambda', to_update)  
    lb =[lb; lambda_range(1)];
    ub =[ub; lambda_range(2)];
    lambda = rand_interval(lambda_range(1),lambda_range(2));
end
if ismember('rot', to_update)
    lb =[lb; rot_range(1)];
    ub =[ub; rot_range(2)];
    rot = rand_interval(rot_range(1), rot_range(2)); %rot =0;%  pi/4;
end
if ismember('center_x', to_update)
    lb =[lb; center_x_range(1)];
    ub =[ub; center_x_range(2)];
    center_x= rand_interval(center_x_range(1), center_x_range(2));%0;
end
if ismember('center_y', to_update)
    lb =[lb; center_y_range(1)];
    ub =[ub; center_y_range(2)];
    center_y= rand_interval(center_y_range(1), center_y_range(2)); %0;
end
if ismember('magnitude', to_update)
    lb =[lb; magnitude_range(1)];
    ub =[ub; magnitude_range(2)];
    magnitude= rand_interval(magnitude_range(1), magnitude_range(2)); %0;
end
if ismember('beta_sup', to_update)
    lb =[lb; beta_sup_range(1)];
    ub =[ub; beta_sup_range(2)];
    beta_sup = rand_interval(beta_sup_range(1), beta_sup_range(2));  
end
if ismember('beta_inf', to_update)
    lb =[lb; beta_inf_range(1)];
    ub =[ub; beta_inf_range(2)];
    beta_inf = rand_interval(beta_inf_range(1), beta_inf_range(2));
end
if ismember('z', to_update)
    lb =[lb; z_range(1)];
    ub =[ub; z_range(2)];
    z = rand_interval(z_range(1), z_range(2));
end

model_lb = [rho_range(1),lambda_range(1),rot_range(1),center_x_range(1),center_y_range(1),magnitude_range(1),beta_sup_range(1),beta_inf_range(1), z_range(1)]';
model_ub = [rho_range(2),lambda_range(2),rot_range(2),center_x_range(2),center_y_range(2),magnitude_range(2),beta_sup_range(2),beta_inf_range(2), z_range(2)]';

 