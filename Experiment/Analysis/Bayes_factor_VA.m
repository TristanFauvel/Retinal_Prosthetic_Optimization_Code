function BF = Bayes_factor_VA(x,y)

%a,b : min and max VA that can be measured
delta = x-y;
sigma = std(delta);

a = 10*max(abs(delta));%0
b = -10*max(abs(delta)); %5
bounds =  (b-a)*[-1, 1];

N = 5e6;
samples1 = rand(1,N)*(0-bounds(1))+ bounds(1);
samples2 = rand(1,N)*bounds(2);

L1 = sum(prod(normpdf((delta-samples1')./sigma),2));
L2 = sum(prod(normpdf((delta-samples2')./sigma),2));

BF = L2/L1;