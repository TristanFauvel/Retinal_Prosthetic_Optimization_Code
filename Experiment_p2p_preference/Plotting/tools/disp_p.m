function [output, offset] = disp_p(p, varargin)
opts = namevaluepairtostruct(struct( ...
    'dp', 'eq', ...
    'n', NaN, ...
    'plot_N', false, ...
    'test', '' ...
    ), varargin);

UNPACK_STRUCT(opts, false)
offset = 0.08;
full_disp = 0;

plot_N = false;
if plot_N
  plot_N = [', N =$', num2str(n)];
else
   plot_N = '$'; 
end
if strcmp(test, 'Bayes')
    logbayes = 1;
    
    if logbayes==1
        x = log10(p);
        x = round(x,2,'significant');
        if full_disp == 1
            prefix = 'log$B_{21} = ';
        else
            prefix = '$K = ';
        end
        if abs(x)<1
            nd = 0;
            while (abs(x)*10^nd<1)
                nd=nd+1;
            end
            x = num2str(x*10^nd);
            stars = [prefix, x, '\times 10^{-', num2str(nd),'}', plot_N];
        elseif abs(x)>10
            nd = 0;
            while (abs(x)*10^nd>10)
                nd=nd-1;
            end
            x = num2str(x*10^nd);
            stars = [prefix, x, '\times 10^{', num2str(-nd),'}', plot_N];
        else
            stars = [prefix, num2str(x), plot_N];
        end
    else
        x = round(p,2,'significant');
         if full_disp == 1
            prefix = '$B_{21} = ';
        else
            prefix = '$';
        end
        if x<1
            nd = 0;
            while (x*10^nd<1)
                nd=nd+1;
            end
            x = num2str(x*10^nd);
            stars = [prefix, x, '\times 10^{-', num2str(nd),'}', plot_N];
        elseif x>10
            nd = 0;
            while (x*10^nd>10)
                nd=nd-1;
            end
            x = num2str(x*10^nd);
            stars = [prefix, x, '\times 10^{', num2str(-nd),'}', plot_N];
        else
            stars = [prefix, num2str(x),', N =$', num2str(n)];
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
                nd = 0;
                while (x*10^nd<1)
                    nd=nd+1;
                end
                x = num2str(x*10^nd);
                stars = ['$p = ', x, '\times 10^{-', num2str(nd),'}$'];
            else
                stars = ['$p = ', num2str(x),'$'];
                
            end
        end
    else
        x = round(p,2,'significant');
        if x<1
            nd = 0;
            while (x*10^nd<1)
                nd=nd+1;
            end
            x = num2str(x*10^nd);
            stars = ['$p = ', x, '\times 10^{-', num2str(nd),'}$'];
        else
            stars = ['$p = ', num2str(x),'$'];
            
        end
    end
end
output = stars;