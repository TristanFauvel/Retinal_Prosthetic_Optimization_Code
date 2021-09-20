function BF_10 =  BayesFactor(f,n)
%%
% f = [0.3,0.4,0.3,0.5];
% n = [5,6,5,4];
% for i = 1:4
% y(i) = binornd(n(i), f(i));
% end
%%

% n is the vector containing the number of comparisons for each subject
% f is the vector containing the fraction of 1 for each subject
syms w k Ksi yi ni
y = round(n.*f);

V = var(f);

ksi = mean(f);
 
eqn = V == ksi*(1-ksi)/(1+1/w);
S = solve(eqn,w);
w= double(S); 

G = numel(y);

% %% Symbolic computation
% f1(yi, Ksi) = symprod(k-1+Ksi/w, k, 1,yi);
% f2(yi, ni, Ksi) = symprod(k-1+(1-Ksi)/w, k, 1,(ni-yi));
% f3(ni) = symprod(k-1+1/w, k, 1,ni);
% H1 = int(prod(f1(y, Ksi).*f2(y, n, Ksi)),Ksi, 0.5,1);
% H0 = int(prod(f1(y, Ksi).*f2(y, n, Ksi)),Ksi, 0, 0.5);
% 
% % H1 = int(prod(f1(y, Ksi).*f2(y, n, Ksi)./f3(n)),Ksi, 0.5,1);
% % H0 = int(prod(f1(y, Ksi).*f2(y, n, Ksi)./f3(n)),Ksi, 0, 0.5);
% BF_10= double(H1/H0);
 

%% Numerical computation of the Bayes Factor

f1 = @(i, ksi) prod((1:y(i))'-1+ksi/w,1);
f2 = @(i, ksi) prod((1:(n(i)-y(i)))'-1+(1-ksi)/w,1);
f3 = @(i) prod((i:n(i))-1+1/w);

fun = @(ksi) integrand(f1, f2, f3, G, ksi);
H1 = integral(fun, 0.5,1);
H0 = integral(fun, 0,0.5);

BF_10= double(H1/H0); %A Bayes factor above 1 means than H1 is more strongly supported than H0.

if isnan(log10(BF_10))
    error('Bayes Factor is NaN')
end
end
% 
function v = integrand(f1, f2, f3,  G, ksi)
v  =zeros(G, numel(ksi));
for i = 1:G
    v(i,:) = f1(i, ksi).*f2(i, ksi)./f3(i);
end
v = prod(v,1);
end