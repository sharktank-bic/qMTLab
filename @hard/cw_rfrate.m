function W = cw_rfrate(p, T2, line)
%
%  p = cw_rfrate(p, T2, line)
%
%  CW RF rate of on-resonance hard pulse
%
%  offset of lineshape is zero since hard pulse is assumed on-resonance
%
  
offset = 0;
offset

%W = sqrt(2) *p.power * sqrt(pi/2)*T2/p.TR * exp(-0.5*((p.dw+2*pi*offset)^2*T2^2));
if(T2 > 0)
  W = p.power * pi * lineshape(line, T2, 2*pi*offset)/p.tau;
else
  W = zeros(size(offset));
end
