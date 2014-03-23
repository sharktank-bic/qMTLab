function p = solid_rfrate(p, T2, offset)
%
%  p = gaussian_gaussian(p, T2, offset)
%
%  offset : offset of lineshape in Hz
%
%  Analytic solution for sequence of gaussian pulses exciting a pool
%  with gaussian linewidth.
%
%  pulse w1(t) = A*exp(-0.5*t^2/(s^2+ws^2))
%  linewidth g(w) = T2/sqrt(2*pi) * exp(-0.5*T2^2*(w + offset)^2)

% compute bandwidth of window
ws2 = 2*log(2)*(p.tau/(2*pi))^2;

s2 = 1/(1/ws2 + 1/p.s2);
%s2 =  p.s2;

W = pi*p.A^2*s2*T2/p.TR * exp(-((p.dw+2*pi*offset)^2*T2^2*s2)/(2*s2 + T2^2))/sqrt(abs(2*s2 + T2^2));
p.rfrate = W;