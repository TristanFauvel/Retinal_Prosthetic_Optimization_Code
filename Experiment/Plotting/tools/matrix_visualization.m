function matrix_visualization(A, varargin)


if nargin == 1
    experiment.nx = 61;
    experiment.ny = 41;
    experiment.implant_size = [6,10];
    experiment.n_electrodes = 60;
else
    experiment = varargin{1};
end

h = figure();
h.Color =  [1 1 1];
h.Name = 'Projective fields';
bottom=min(min(A));
top=max(max(A));
if bottom<0 && 0<top
    a=max(abs(bottom),top);
    Clim=[-a,a];
else
    Clim=[bottom,top];
end

if size(A,2) ~= experiment.n_electrodes
    A=A';
end

for i=1:experiment.n_electrodes
    subplot(experiment.implant_size(1),experiment.implant_size(2),i)
    imagesc(reshape(A(:,i), experiment.ny, experiment.nx),  Clim)
    %imagesc(reshape(A(:,i)/max(A(:,i)), 41, 61))
    set(gca,'YDir','normal')
    colormap('gray')
end
return
