function [c, rt] = query_response_refractive_task(M, x, S, display_size, experiment, task, correct_response)

% opts = namevaluepairtostruct(struct( ...
%     'correct_response', 'NaN' ...
%     ), varargin);
% UNPACK_STRUCT(opts, false)

cmap = gray(256);

nx = experiment.nx;
ny = experiment.ny;

if strcmp(task, 'preference')
    
    W1 = refractive_error(x{1}, experiment);
    W2 = refractive_error(x{2}, experiment);
    
    letter = correct_response;
    [p1, pmax]= vision_model(M,W1,S);

    percept1 = reshape(p1, ny,nx);
    percept1 = imresize(percept1, display_size, 'method', 'bilinear');
    [p2 , pmax]= vision_model(M,W2,S);
    percept2 = reshape(p2, ny,nx);
    percept2 = imresize(percept2, display_size, 'method', 'bilinear');
    if experiment.use_ptb3 ==0
        clims = [0,255];
        fig1= figure(1);
        fig1.Color =  [0 0 0];
        imagesc(percept1,clims)
        colormap(cmap);
        title(letter)
        set(gca,'XColor', 'none','YColor','none')
        daspect([1 1 1])
        screensize = get(0,'screensize');
        width = screensize(3); % Screen width (px)
        height = screensize(4); % Screen height (px)
        if 2*display_size(2)>width || display_size(1)>height
            error('Screen not big enough')
        else
            fig1.Position = [0, (height-display_size(2))/2, display_size(2), display_size(1)]; %[1921, 476, 1271, 852]; [left bottom width height]
        end
        
        fig2= figure(2);
        fig2.Color =  [0 0 0];
        imagesc(percept2,clims)
        colormap(cmap);
        title(letter)
        set(gca,'XColor', 'none','YColor','none')
        daspect([1 1 1])
        truesize(fig2,display_size)
        fig2.Position = [display_size(2), (height-display_size(2))/2, display_size(2), display_size(1)]; %[3192, 476, 1271, 852];
        
        %% Record subject's response
        waiting_response = 1;
        while waiting_response
            c= input('Preferred image 1 or 2: ');
            if ~isempty(c) && (c == 1 || c==2)
                waiting_response = 0;
            end
        end
        if c==2
            c=0;
        end
        close(fig1)
        close(fig2)
        rt = NaN;
    elseif experiment.use_ptb3 == 1
        global window
        [screenXpixels, screenYpixels]=Screen('WindowSize', window,[]);
        
        vmargin = floor((screenYpixels - display_size(1))/2);%100;
        hmargin = floor((screenXpixels - 2*display_size(2))/3);%100;
        hspace = hmargin;%100;%space betwwen the two images
        Screen('PutImage', window, percept1/255, [hmargin, vmargin, hmargin  + display_size(2), vmargin + display_size(1)])
        Screen('PutImage', window, percept2/255, [hmargin + display_size(2) + hspace, vmargin, hmargin + 2*display_size(2) + hspace, vmargin + display_size(1)])
        white = WhiteIndex(window);
        Screen('TextSize', window, 70);
        DrawFormattedText(window, letter,'center', 90, white);
        tStart = GetSecs;
        screen.vbl = Screen('Flip', window);
        
        KbName('UnifyKeyNames');
        RestrictKeysForKbCheck([KbName('RightArrow'),KbName('LeftArrow'),KbName('c')]);
        
        [~, keyCode] = KbPressWait();
        tEnd = GetSecs;
        rt = tEnd - tStart;
        c = KbName(keyCode);
        
        switch c
            case 'RightArrow'
                c=0;
            case 'LeftArrow'
                c=1;
            case 'c'
                c = NaN;
        end
        
        screen.vbl = Screen('Flip', window);
    end
else
    S = imresize(S, [ny, nx], 'method', 'bilinear');
    S=S(:);

        W = refractive_error(x, experiment);

    p = vision_model(M,W,S);
    percept = reshape(p, ny,nx);
    percept = imresize(percept, display_size, 'method', 'bilinear');
    if experiment.use_ptb3 == 0
        clims = [0,255];
        fig= figure(4);
        fig.Color =  [0 0 0];
        imagesc(percept,clims)
        colormap(cmap);
        set(gca,'XColor', 'none','YColor','none')
        daspect([1 1 1])
        truesize(fig,display_size)
        %fig.Position =  [1921, 476, 1271, 852];
        
        screensize = get(0,'screensize');
        width = screensize(3);
        height = screensize(4);
        if display_size(2)>width || display_size(1)>height
            error('Screen not big enough')
        else
            fig.Position = [0, (height-display_size(2))/2, display_size(2), display_size(1)]; %[1921, 476, 1271, 852]; [left bottom width height]
        end
        
        % Record subject's response
        waiting_response = 1;
        while waiting_response
            switch task
                case 'LandoltC'
                    response= input('Position of the gap: ');
                    if ~isempty(response) && ismember(response, [1,2,3,4,6, 7,8,9])
                        waiting_response = 0;
                    end
                    
                case 'E'
                    response= input('Position of the E: ');
                    if ~isempty(response) && ismember(response, [2,4,8,6])
                        waiting_response = 0;
                    end
                    
                case 'Vernier'
                    response= input('Position of the upper bar: ');
                    if ~isempty(response) && ismember(response, [1,2])
                        waiting_response = 0;
                    end
                    response = 2*response-3;
                case 'Snellen'  
                    response= input('Letter: ');
                    if ~isempty(response) && ismember(response, ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'])
                        waiting_response = 0;
                    end
            end            
        end
        close(fig)
        rt = NaN;
    elseif experiment.use_ptb3 == 1
        global window
        [width, height]=Screen('WindowSize',window) ;
        
        m = floor((width-display_size(2))/2);
        M = floor((height-display_size(1))/2);
        Screen('PutImage', window, percept/255,[m,M,m+display_size(2), M+display_size(1)]);
        screen.vbl = Screen('Flip', window);
        tStart = GetSecs;
        
        KbName('UnifyKeyNames');
        switch task
            case 'LandoltC'
                RestrictKeysForKbCheck([KbName('1'),KbName('2'),KbName('3'),KbName('4'),KbName('6'),KbName('7'),KbName('8'),KbName('9'), KbName('c')]);
                [~, keyCode] = KbPressWait();
                if strcmp(KbName(keyCode),'c')
                    response = NaN;
                else
                    response= str2num(KbName(keyCode));
                end
            case 'E'
                RestrictKeysForKbCheck([KbName('RightArrow'),KbName('UpArrow'),KbName('DownArrow'),KbName('LeftArrow'), KbName('c')]);
                [~, keyCode] = KbPressWait();
                
                response = KbName(keyCode);
                switch response
                    case 'RightArrow'
                        response = 6;
                    case 'UpArrow'
                        response = 8;
                    case 'DownArrow'
                        response = 2;
                    case 'LeftArrow'
                        response = 4;
                end
              case 'Eneg'
                RestrictKeysForKbCheck([KbName('RightArrow'),KbName('UpArrow'),KbName('DownArrow'),KbName('LeftArrow'), KbName('c')]);
                [~, keyCode] = KbPressWait();
                
                response = KbName(keyCode);
                switch response
                    case 'RightArrow'
                        response = 6;
                    case 'UpArrow'
                        response = 8;
                    case 'DownArrow'
                        response = 2;
                    case 'LeftArrow'
                        response = 4;
                end
                   
            case 'Vernier'
                RestrictKeysForKbCheck([KbName('RightArrow'),KbName('LeftArrow'), KbName('c')]);
                [~, keyCode] = KbPressWait();
                response = KbName(keyCode);
                switch response
                    case 'RightArrow'
                        response = 1;
                    case 'LeftArrow'
                        response = -1;
                end
            case 'Snellen'
                RestrictKeysForKbCheck([KbName('a'),KbName('b'), KbName('c'),KbName('d'),KbName('e'),KbName('f'), KbName('g'),KbName('h'),KbName('i'), KbName('j'),KbName('k'),KbName('l'), KbName('m'),KbName('n'),KbName('o'), KbName('p'),KbName('q'),KbName('r'), KbName('s'),KbName('t'),KbName('u'), KbName('v'),KbName('w'),KbName('x'), KbName('y'),KbName('z')]);
                [~, keyCode] = KbPressWait();
                response = KbName(keyCode);
                response = upper(response);
        end
        tEnd = GetSecs;
        rt = tEnd - tStart;
        
        screen.vbl = Screen('Flip', window);
        
    end
    if strcmp(response,'c')
        c = NaN;
    else
        if response==correct_response
            c=1;
        else
            c=0;
        end
    end    
end
return
