function W = cw_rfrate(p, T2, offset, line)
%
%  p = cw_rfrate(p, T2, offset, line)
%
%  offset : offset of lineshape in Hz
%
%  CW approximate solution for sequence of gaussian pulses exciting a pool
%  with specified linewidth.
%
%  pulse w1(t) = A*exp(-0.5*t^2/s^2)

%  linewidth g(w) = T2/sqrt(2*pi) * exp(-0.5*T2^2*(w + offset)^2)

%W = .3460805588*p.tau*p.A^2 * sqrt(pi/2)*T2/p.TR * exp(-0.5*((p.dw+2*pi*offset)^2*T2^2));
%p.rfrate = W;

if(T2 > 0)
  W = p.power * pi * lineshape(line, T2, 2*pi*offset)/p.TR;
else
  W = zeros(size(offset));
end
