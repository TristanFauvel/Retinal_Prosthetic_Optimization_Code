function [p, pmax] = vision_model(M,a)

p = abs(M*a);
pmax = max(p);
p = min(p,255);
p = max(p,0);



return
