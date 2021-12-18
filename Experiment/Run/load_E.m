function S = load_E(correct_response, stim_size, display_width, display_height, stimuli_folder)

stim_size = floor(stim_size);

S = zeros(numel(correct_response),display_height,display_width);
ratio = 1;
if stim_size > ratio
    for i = 1:numel(correct_response)
        s = zeros(display_height,display_width);
        
        image = imread([stimuli_folder,'/E',num2str(correct_response(i)),'.png']);
        image =rgb2gray(image); % Convert to grey
        ratio = size(image, 1)/size(image,2);

        if correct_response == 4 || correct_response == 6
            image = imresize(image, [stim_size, floor(stim_size/ratio)],'method', 'bilinear');
        elseif correct_response == 8 || correct_response == 2
            image = imresize(image, [floor(stim_size/ratio),stim_size],'method','bilinear');
        end
        
        
        range_x = floor(1+display_width/2-size(image,1)/2):floor(display_width/2+size(image,1)/2);
        range_y = floor(1+display_height/2-size(image,2)/2):floor(display_height/2+size(image,2)/2);
        
        s(range_y, range_x) = 1-image(1:numel(range_y),1:numel(range_x))/255;

        S(i,:,:) = s;
    end
end
S =squeeze(S);

