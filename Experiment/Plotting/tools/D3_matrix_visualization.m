function D3_matrix_visualization(A)

[experiment.ny, experiment.nx, experiment.n_electrodes] = size(A);
    experiment.implant_size = [6,10];

h = figure();
h.Color =  [1 1 1];
h.Name = 'Projective fields';
bottom=min(A(:));
top=max(A(:));
if bottom<0 && 0<top
    a=max(abs(bottom),top);
    Clim=[-a,a];
else
    Clim=[bottom,top];
end

for i=1:experiment.n_electrodes
    subplot(experiment.implant_size(1),experiment.implant_size(2),i)
    imagesc(A(:,:,i),  Clim)
    set(gca,'YDir','normal')
    colormap('gray')
end
return
