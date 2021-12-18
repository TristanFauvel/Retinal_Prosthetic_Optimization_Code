function  training_session(task, visual_field_size, viewing_distance, Stimuli_folder)

%training session before the start of experiments

close all
maxiter = 2;


dpcm = get(0,'ScreenPixelsPerInch')/2.54; % number of pixels per centimeter
display_size = 2*viewing_distance*tan(0.5*visual_field_size*pi/180); % Size of the image on screen (in m)
display_size = floor(display_size*100*dpcm) ; % Size of the image on screen (in pixels)

nx = 30;
ny = 20;
experiment.nx = nx;
experiment.ny = ny;

    im_ny = floor(0.9*ny);
    im_nx = floor(0.9*nx);

    
image_size = [im_ny, im_nx];


M= eye(nx*ny);
experiment.use_ptb3 =1;
switch task
    case 'preference'
        Stimuli_folder =  [Stimuli_folder, '/letters'];
        bounds = [0.9*display_size(1), 0.9*display_size(1)]; 
    case 'LandoltC'
        Stimuli_folder =  [Stimuli_folder, '/landoltC'];
        bounds = [10, display_size(1)]; %size range for the C
       
    case 'E'
        bounds = [0.9*display_size(1), 0.9*display_size(1)]; %size range for the E
        Stimuli_folder =  [Stimuli_folder, '/E'];
    case 'Snellen'
        bounds = [0.9*display_size(1), 0.9*display_size(1)]; %size range for the E
        Stimuli_folder =  [Stimuli_folder, '/letters'];
          
    case  'Vernier'
        barwidth=10;
        b = 15; %margin
        bounds = [0,nx-barwidth-1-b];
end

%% Initialize the experiment
contrast = 1;
for i=1:maxiter
    disp(i)
    
        W = 255*pinv(M);
        access_param = rand_interval(bounds(1), bounds(2));
        switch task
            case 'LandoltC'
                correct_response = randsample([1,2,3,4,6,7,8,9], 1);
                S = load_landolt_C(correct_response, access_param, nx, ny, Stimuli_folder);
            case 'E'
                correct_response = randsample([2,6,4,8], 1);
                S =  load_E(correct_response, access_param, display_size(2), display_size(1), Stimuli_folder);
            case 'Vernier'
                if numel(1+b+ceil((abs(access_param) + barwidth)/2): (nx-b -floor((abs(access_param)+barwidth)/2))) == 1
                    center = 1+b+ceil((abs(access_param) + barwidth)/2);
                else
                    if isempty(1+b+ceil((abs(access_param) + barwidth)/2): (nx-b -floor((abs(access_param)+barwidth)/2)))
                        center = floor(nx/2);
                    else
                        center = randsample(1+b+ceil((abs(access_param) + barwidth)/2): (nx-b -floor((abs(access_param)+barwidth)/2)),1);
                    end
                end
                correct_response = sign(access_param);
                S = Vernier_frame(access_param, nx, ny, barwidth, center);
            case 'Snellen'
                correct_response = randsample('ABCD',1);
                S = load_Snellen(display_size(2), display_size(1), Stimuli_folder,access_param, correct_response);
            case 'preference'
                correct_response = randsample('ABCDEFGHIJKLMNOPQRSTUVWXYZ',1);
                S = load_Snellen(display_size(2), display_size(1), Stimuli_folder,access_param, correct_response);
                %query_preference_training(M, S, display_size, experiment);
                clear('W')
                W{1} = 100*(pinv(M)+randn(600).*eye(600));
                W{2} = 100*(pinv(M)+0.1*randn(600).*eye(600));
        end
%         S = imresize(S, [ny,nx]);
        query_response_task(M, W, S, display_size, experiment, task, correct_response)
    end
end


