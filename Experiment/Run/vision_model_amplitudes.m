function [p, pmax] = vision_model_amplitudes(M,a)
%Linear-nonlinear prosthetic vision model taking amplitudes as inputs.
p = abs(M*a);
pmax = max(p);
p = min(p,255);
p = max(p,0);



return
