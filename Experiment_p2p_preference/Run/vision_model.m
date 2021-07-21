function [p, pmax] = vision_model(M,W,S)

p = abs(M*W*S);
pmax = max(p);
p = min(p,255);
p = max(p,0);



return
