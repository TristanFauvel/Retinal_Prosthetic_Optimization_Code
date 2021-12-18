T = load('perceptual_model_table.mat');
T=T.T;

NT = T;

Electrode = 1;
A = [NT(1,:), table(Electrode)];
A(:,:) = [];
electrodes_perceptual_models_directory = '/home/tfauvel/Desktop/Electrodes_Perceptual_Models';

for i = 1:size(T,1)
    rho = T(i,:).rho;
    axlambda = T(i,:).axlambda;
    implant_name = 'ArgusII';
    rot = T(i,:).rot;
    z = T(i,:).z;
    center_x = T(i,:).center_x;
    center_y = T(i,:).center_y;
    beta_sup = T(i,:).beta_sup;
    beta_inf = T(i,:).beta_inf;
    M = load([perceptual_models_directory, '/',implant_name, '_rho_',num2str(rho),'_lambda_', num2str(axlambda), '_rot_',num2str(rot),'_center_x_',num2str(center_x), '_center_y_', num2str(center_y),'_z_',num2str(z), '_beta_sup_',num2str(beta_sup), '_beta_inf_',num2str(beta_inf),'.mat'], 'M');
    M = M.M;
    for j = 1:60
        Me = M(:,:,j);
        save([electrodes_perceptual_models_directory, '/',implant_name, '_rho_',num2str(rho),'_lambda_', num2str(axlambda), '_rot_',num2str(rot),'_center_x_',num2str(center_x), '_center_y_', num2str(center_y),'_z_',num2str(z), '_beta_sup_',num2str(beta_sup), '_beta_inf_',num2str(beta_inf),'_electrode_',num2str(j),'.mat'], 'Me');
        Electrode = j;
    end
    
end

