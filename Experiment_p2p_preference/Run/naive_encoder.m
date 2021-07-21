function W = naive_encoder(experiment)

% matrix_visualization(M, experiment)
add_directories;
experiment.nelectrodes = 60;
lattice = NaN(experiment.n_electrodes, 2);
for i=1:experiment.n_electrodes
    m = reshape(experiment.M(:,i), experiment.ny, experiment.nx);
    [~, idmax]= max(m(:));
    [idy,idx]= ind2sub(size(m),idmax);
    lattice(i,:) = [idx,idy];
end

% figure();
% scatter(lattice(:,1),lattice(:,2))
% 
xrange = 1:experiment.nx;
yrange = 1:experiment.ny;

[p,q]= meshgrid(xrange,yrange);
P = [p(:),q(:)]';
x= P(1,:);
y= P(2,:);

kdtree = KDTreeSearcher([lattice(:,1),lattice(:,2)]);
F=(1:experiment.nelectrodes)';
f = @(x_in,y_in) F(kdtree.knnsearch([x_in(:),y_in(:)]) );
fvals = f(x,y);


W = zeros(size(experiment.M'));
for j = 1:size(W,1)
    W(j,:)=(fvals==j);
end


% %% Compute the magnitude of currents. 
% display_size = floor(experiment.display_size);
% stim_size = 0.8*display_size(1);
% Stimuli_folder =  [Stimuli_folder,'/E'];
% S = load_E(6, stim_size, display_size(2), display_size(1), Stimuli_folder, 1);
% nx = experiment.nx;
% ny = experiment.ny;
% 
% S = imresize(S, [ny, nx],'method','bilinear');
% S=S(:);
% Mest = pinv(W);
% [~,pmax] = vision_model(Mest,W,S);
% 
% magnitude_factor = 255/pmax;

optimal_magnitude = 1;
if optimal_magnitude == 1
    display_size = floor(experiment.display_size);
       Stimuli=  [Stimuli_folder, '/letters'];

       stim_size = floor(0.9*display_size(1));
    S = load_Snellen(experiment.display_width, experiment.display_height, Stimuli, stim_size , 'A');
    S = imresize(S, [experiment.ny, experiment.nx], 'method', 'bilinear');
    S=S(:);
    [P,pmax] = vision_model(experiment.M,W,S); %assumes we know the true model;

    magnitude_factor = 255/pmax;
end


%W= 0.1*0.3103*W;
W = magnitude_factor*W;
