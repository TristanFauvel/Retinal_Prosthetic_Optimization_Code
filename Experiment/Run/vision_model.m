function [p, pmax] = vision_model(M,W,S)
%Linear-nonlinear prosthetic vision model taking stimulus and encoder as inputs.

p = abs(M*W*S);
pmax = max(p);
p = min(p,255);
p = max(p,0);



return
