function y = Lanczos(x,a)
y= sinc(x).*sinc(x/a).*(-a<x & x<a);
