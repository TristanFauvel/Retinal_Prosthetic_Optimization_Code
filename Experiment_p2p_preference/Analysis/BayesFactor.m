function BF_10 =  BayesFactor(n,y)
syms K
p = 0.5;
G = numel(y);
%probs = rand(G,1); %H1
probs = p*ones(G,1); %H0
y = y*n;

w= 0.005;
f1 = @(i) prod((1:y(i))-1+K/w,2);
f2 = @(i) prod((1:(n-i-y(i)))-1+(1-K)/w,2);


integrand(K) =  prod(((1/prod((1:n)-1+1/w))/(p^n))*f1((1:G)').*f2((1:G)'));
integral = int(integrand,K, 0,1);
BF_10 = double(integral); %A Bayes factor above 1 means than H1 is more strongly supported than H0.

% syms K
% p = 0.5;
% n = 40;
% G = 500;
% %probs = rand(G,1); %H1
% probs = p*ones(G,1); %H0
% y =  binornd(n,probs);
% 
% w= 0.005;
% f1 = @(i) prod((1:y(i))-1+K/w,2);
% f2 = @(i) prod((1:(n-i-y(i)))-1+(1-K)/w,2);
% 
% 
% integrand(K) =  prod(((1/prod((1:n)-1+1/w))/(p^n))*f1((1:G)').*f2((1:G)'));
% integral = int(integrand,K, 0,1);
% Bayes_factor_10 = double(integral); %A Bayes factor above 1 means than H1 is more strongly supported than H0.

