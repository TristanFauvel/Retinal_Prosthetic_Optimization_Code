function frame=Vernier_frame(offset, nx, ny, barwidth, center)

v = zeros(1,nx);
v(center + fix(offset/2) +(-floor(barwidth/2):floor(barwidth/2))) = 1;

up_frame=repmat(v,floor(ny/2)+1,1);
low_frame=zeros(floor(ny/2), nx);
frame1 = [up_frame;low_frame];

v = zeros(1,nx);
v(center - fix(offset/2) +(-floor(barwidth/2):floor(barwidth/2))) = 1;
up_frame=zeros(floor(ny/2)+1, nx);
low_frame=repmat(v,floor(ny/2),1);

frame2 = [up_frame; low_frame];

frame= frame1 + frame2;

frame = frame(:);

