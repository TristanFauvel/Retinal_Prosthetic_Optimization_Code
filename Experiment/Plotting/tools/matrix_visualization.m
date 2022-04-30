function h = matrix_visualization(A, varargin)


if nargin == 1
    experiment.nx = 61;
    experiment.ny = 41;
    experiment.implant_size = [6,10];
    experiment.n_electrodes = 60;
else
    experiment = varargin{1};
end

mr = experiment.implant_size(1);
mc = experiment.implant_size(2);
i = 0;
k=1;

h=figure('units','centimeters','outerposition',1+[0 0 16 0.5*16]);


tiledlayout(mr,mc, 'TileSpacing', 'tight', 'padding','compact');

h.Color =  [1 1 1];
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

mapping = [6,5,4,3,2,1];
k = 0;
for i = 1:experiment.implant_size(1)
    for j=1:experiment.implant_size(2)
        k = k+1;
        ii= mapping(i);
        p= j + (ii-1)*experiment.implant_size(2);
        %subplot(experiment.implant_size(1),experiment.implant_size(2),p)
        nexttile(p);
        imagesc(reshape(A(:,k), experiment.ny, experiment.nx),  Clim)
        set(gca,'YDir','normal')
        colormap('gray')
        set(gca,'xtick',[],'ytick',[],'title',[],'ylabel',[],'dataAspectRatio',[1 1 1])

    end
end

 return
