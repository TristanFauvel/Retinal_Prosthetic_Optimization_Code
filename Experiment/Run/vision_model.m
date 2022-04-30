function [p, pmax] = vision_model(M,W,S)
%Linear-nonlinear prosthetic vision model taking stimulus and encoder as inputs.
a = W*S;
p = abs(M*a);
pmax = max(p);
p = min(p,255);
p = max(p,0);



return
