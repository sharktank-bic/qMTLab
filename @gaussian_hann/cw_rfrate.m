function W = cw_rfrate(p, T2, offset, line)
%
%  p = cw_rfrate(p, T2, offset, line)
%
%  offset : offset of lineshape in Hz
%
%  CW approximate solution for sequence of given pulse exciting a pool
%  with given lineshape.  (assume circularly polarized coil)
%
%  
%  linewidth g(w) = T2/sqrt(2*pi) * exp(-0.5*T2^2*(w + offset)^2)

%W = sqrt(2) *p.power * sqrt(pi/2)*T2/p.TR * exp(-0.5*((p.dw+2*pi*offset)^2*T2^2));
if(T2 > 0)
  W = p.power * pi * lineshape(line, T2, 2*pi*offset)/p.TR;
else
  W = zeros(size(offset));
end