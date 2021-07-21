function W = lanczos_encoder(experiment)

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

distances = sqrt((lattice(:,1)-lattice(:,1)').^2+(lattice(:,2)-lattice(:,2)').^2);
a = min(distances(distances>0));
% figure();
% scatter(lattice(:,1),lattice(:,2))
% 
xrange = 1:experiment.nx;
yrange = 1:experiment.ny;

[p,q]= meshgrid(xrange,yrange);
P = [p(:),q(:)]';
x= P(1,:);
y= P(2,:);

window_fun = @(x,y,i) (abs(x-lattice(i,1))<a).*(abs(y-lattice(i,2))<a);
% kdtree = KDTreeSearcher([lattice(:,1),lattice(:,2)]);
% F=(1:experiment.nelectrodes)';
% f = @(x_in,y_in) F(kdtree.knnsearch([x_in(:),y_in(:)]) );
% fvals = f(x,y);

W = zeros(size(experiment.M'));
for j = 1:size(W,1)
    W(j,:)=window_fun(x,y,j);
end


%% Compute the magnitude of currents. 
display_size = floor(experiment.display_size);
stim_size = 0.8*display_size(1);
Stimuli_folder =  [Stimuli_folder,'/E'];
S = load_E(6, stim_size, display_size(2), display_size(1), Stimuli_folder, 1);
nx = experiment.nx;
ny = experiment.ny;

S = imresize(S, [ny, nx], 'method','bilinear');
S=S(:);
%Mest = pinv(W); %%%%%%%%%%%%%%%%%%%%%%%%%%%
Mest = experiment.M; %%%%%%%%%%%%%%%%%%%%%%%%%
[~,pmax] = vision_model(Mest,W,S);

magnitude_factor = 255/pmax;

%W= 0.1*0.3103*W;
W = magnitude_factor*W;

return
%Another way to compute the magnitude factor, that cheats (using the true
%perceptual model ) 
W = zeros(size(experiment.M'));
for j = 1:size(W,1)
    W(j,:)=window_fun(x,y,j);
end
[~,pmax] = vision_model(experiment.M,W,S);
magnitude_factor = 255/pmax;
W = magnitude_factor*W;
