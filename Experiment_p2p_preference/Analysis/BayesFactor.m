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
syms Ksi
y = round(n.*f);

V = var(f);

ksi = mean(f);
syms w
eqn = V == ksi*(1-ksi)/(1+1/w);
S = solve(eqn,w);
w= double(S);%0.05;

% %%%%%%%%%%%%
% w= 0.05;
% %%%%%%%%%%%
G = numel(y);
f1 = @(i, Ksi) prod((1:y(i))-1+Ksi/w,2);
f2 = @(i, Ksi) prod((1:(n(i)-y(i)))-1+(1-Ksi)/w,2);
integrand(Ksi) =  prod(f1(1:G, Ksi)'.*f2(1:G, Ksi)');

H1 = int(integrand,Ksi, 0.5,1);
H0 = int(integrand,Ksi, 0,0.5);

BF_10= double(H1/H0); %A Bayes factor above 1 means than H1 is more strongly supported than H0.


