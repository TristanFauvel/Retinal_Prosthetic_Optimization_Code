function [output, offset] = disp_p(p, varargin)
opts = namevaluepairtostruct(struct( ...
    'dp', 'eq', ...
    'test', '' ...
    ), varargin);

UNPACK_STRUCT(opts, false)
offset = 0.08;

if strcmp(test, 'Bayes')
    logbayes = 1;
    
    if logbayes==1
        x = log(p);
        x = round(x,2,'significant');
        if abs(x)<1
            n = 0;
            while (abs(x)*10^n<1)
                n=n+1;
            end
            x = num2str(x*10^n);
            stars = ['log$B_{21} = ', x, '\times 10^{-', num2str(n),'}$'];
        elseif abs(x)>10
            n = 0;
            while (abs(x)*10^n>10)
                n=n-1;
            end
            x = num2str(x*10^n);
            stars = ['log$B_{21} = ', x, '\times 10^{', num2str(-n),'}$'];
        else
            stars = ['log$B_{21} = ', num2str(x),'$'];
        end
    else
        x = round(p,2,'significant');
        if x<1
            n = 0;
            while (x*10^n<1)
                n=n+1;
            end
            x = num2str(x*10^n);
            stars = ['$B_{21} = ', x, '\times 10^{-', num2str(n),'}$'];
        elseif x>10
            n = 0;
            while (x*10^n>10)
                n=n-1;
            end
            x = num2str(x*10^n);
            stars = ['$B_{21} = ', x, '\times 10^{', num2str(-n),'}$'];
        else
            stars = ['$B_{21} = ', num2str(x),'$'];
        end
    end
else
    
    if strcmp(dp, 'stars')
        if p<=1E-3
            stars='***';
        elseif p<=1E-2
            stars='**';
        elseif p<=0.05
            stars='*';
        elseif isnan(p)
            stars='nan';
            offset=offset  + f*0.005;
        else
            stars='n.s.';
            offset= offset  + f*0.035;
        end
    elseif strcmp(dp, 'ineq')
        
        if p<=1E-3
            stars='p$<$0.001';
        elseif p<=1E-2
            stars='p$<$0.01';
        elseif p<=0.05
            stars='p$<$0.05';
        elseif isnan(p)
            stars='nan';
            offset=f*0.005;
        else
            x = round(p,2,'significant');
            if x<1
                n = 0;
                while (x*10^n<1)
                    n=n+1;
                end
                x = num2str(x*10^n);
                stars = ['$p = ', x, '\times 10^{-', num2str(n),'}$'];
            else
                stars = ['$p = ', num2str(x),'$'];
                
            end
        end
    else
        x = round(p,2,'significant');
        if x<1
            n = 0;
            while (x*10^n<1)
                n=n+1;
            end
            x = num2str(x*10^n);
            stars = ['$p = ', x, '\times 10^{-', num2str(n),'}$'];
        else
            stars = ['$p = ', num2str(x),'$'];
            
        end
    end
end
output = stars;