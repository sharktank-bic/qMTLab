function L = linefcn(y,s)
% integrate from 0 to 1 for super-lorentzian lineshape 

A = 1./(3*y.^2 - 1);
L = sqrt(2/pi)*abs(A).*exp(-2*(s.*A).^2);