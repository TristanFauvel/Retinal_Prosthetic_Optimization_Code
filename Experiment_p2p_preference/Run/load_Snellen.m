function S = load_Snellen(display_width, display_height, Stimuli_folder, stim_size , correct_response)

N = numel(correct_response);

S= zeros(numel(correct_response),display_height,display_width);

for i = 1:N
    s = zeros(display_height,display_width);
    
    image = load([Stimuli_folder,'/',correct_response(i),'.mat']);
    image= struct2cell(image);
    im = image{1};
    
    %Extract the letter
    [a, b] = find(im==1);
    min_i = min(a);
    min_j = min(b);
    max_i = max(a);
    max_j = max(b);
    
    im = im(min_i:max_i,min_j:max_j);
    
    ratio = size(im,2)/size(im,1);
    if ratio > 1
        im= imresize(im, [floor(stim_size),ratio*stim_size], 'method','bilinear');
    else
        im= imresize(im, [stim_size,ratio*floor(stim_size)], 'method','bilinear');
    end
    
    range_y = floor(1+display_height/2-size(im,1)/2):floor(display_height/2+size(im,1)/2);
    range_x = floor(1+display_width/2-size(im,2)/2):floor(display_width/2+size(im,2)/2);
    
    s(range_y, range_x) = double(im);
    
    S(i,:,:) = s;
  
    
    % im = im(min_i:max_i,min_j:max_j);
    % ratio = size(im,2)/size(im,1);
    % im= imresize(im, [floor(stim_size),ratio*stim_size], 'method','bilinear');
    % range_y = floor(1+display_height/2-size(im,1)/2):floor(display_height/2+size(im,1)/2);
    % range_x = floor(1+display_width/2-size(im,2)/2):floor(display_width/2+size(im,2)/2);
    %
    % s(range_y, range_x) = double(im);
    %
    % S(i,:,:)= imresize(s, [ny, nx], 'method','bilinear');
end
S =squeeze(S);
