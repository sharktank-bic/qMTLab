function p = compute_rfrate(p, lineshape, T2, offset)
%
%  function compute_rfrate(p, lineshape, T2, offset)
%
%  p          :  pulse object
%  lineshape  :  function(w, T2)
%  T2         :
%  offset     :  frequency offset of lineshape

% compute bandwidth of window
ws2 = 2*log(2)*(p.tau/(2*pi))^2;


width1 = 3/sqrt(p.s2+ws2);
width2 = 3/T2;

%w0 = min(p.dw-width1, offset-width2);
%w1 = max(width1+p.dw, offset+width2);

w0 = p.dw - width1;
w1 = p.dw + width2;

%d = (w1-w0)/200;
%w = w0:d:w1;
%s = gaussian_spectrum(w, lineshape, T2, offset, p.A, p.s2, p.dw);
%plot(w/(2*pi),s);

%sum(s)*d/(2*TR)

%tol = [1e-3, 1e-6]; 


p.rfrate = quad('gaussian_hann_spectrum', w0, w1, [], [], lineshape, T2, offset, p.A, p.s2, p.dw, ws2)/(2*p.TR);
p.lineshape = lineshape;


