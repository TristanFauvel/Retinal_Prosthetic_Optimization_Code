function s = load_landolt_C(correct_response, diameter, nx, ny, stimuli_folder, contrast)

files = dir(stimuli_folder);
s = zeros(ny,nx);
image = imread([stimuli_folder,'/C',num2str(correct_response),'.png']);
image =rgb2gray(image); % Convert to grey
image = imresize(image, [diameter, diameter], 'method','bilinear');
%
% figure()
% imagesc(image)

range_y = floor(1+ny/2-diameter/2):floor(ny/2+diameter/2);
range_x = floor(1+nx/2-diameter/2):floor(nx/2+diameter/2);
s(range_y, range_x) = 1-image(1:numel(range_y),1:numel(range_x))/255;
s= s(:);
if contrast<0
    s = 1-s;
end
contrast = abs(contrast);
s = s*contrast;
