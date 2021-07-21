function frame=Vernier_frame(offset, nx, ny, barwidth, center)

v = zeros(1,nx);
% v(center + floor(nx/2)+offset+(-floor(barwidth/2):floor(barwidth/2))) = 1;
v(center + fix(offset/2) +(-floor(barwidth/2):floor(barwidth/2))) = 1;

up_frame=repmat(v,floor(ny/2)+1,1);
low_frame=zeros(floor(ny/2), nx);
frame1 = [up_frame;low_frame];

v = zeros(1,nx);
% v(center + floor(nx/2)-offset+(-floor(barwidth/2):floor(barwidth/2))) = 1;
v(center - fix(offset/2) +(-floor(barwidth/2):floor(barwidth/2))) = 1;
up_frame=zeros(floor(ny/2)+1, nx);
low_frame=repmat(v,floor(ny/2),1);

frame2 = [up_frame; low_frame];

frame= frame1 + frame2;

frame = frame(:);
% figure()
% imagesc(frame)

% sig=10;
% % yd=height/2-experiment.dx/2;
% up_frame=repmat(exp(-((1:width)-width/2-center-offset/2).^2/sig),floor(height/2)+1,1);
% low_frame=zeros(floor(height/2), width);
% %frame1=repmat(exp(-((-width/2:width/2)-center-offset/2).^2/sig), yd-yt+1,1);
% frame1 = [up_frame;low_frame];
% %% draw the lower rectangle
% % 
% % yt=height/2+experiment.dx/2;
% % yd=height;
% low_frame=repmat(exp(-((1:width)-width/2-center+offset/2).^2/sig), floor(height/2)+1,1);
% up_frame=zeros(floor(height/2), width);
% 
% frame2 = [up_frame;low_frame];
% 
% frame= frame1 + frame2;
% frame(21,:) = 0;
% 
% function frame=Vernier_frame(height, width, center, offset)
% sig=10;
% % yd=height/2-experiment.dx/2;
% up_frame=repmat(exp(-((1:width)-width/2-center-offset/2).^2/sig),floor(height/2)+1,1);
% low_frame=zeros(floor(height/2), width);
% %frame1=repmat(exp(-((-width/2:width/2)-center-offset/2).^2/sig), yd-yt+1,1);
% frame1 = [up_frame;low_frame];
% %% draw the lower rectangle
% % 
% % yt=height/2+experiment.dx/2;
% % yd=height;
% low_frame=repmat(exp(-((1:width)-width/2-center+offset/2).^2/sig), floor(height/2)+1,1);
% up_frame=zeros(floor(height/2), width);
% 
% frame2 = [up_frame;low_frame];
% 
% frame= frame1 + frame2;
% frame(21,:) = 0;