function p = cw_rfrate(p, T2, offset)
%
%  p = cw_free(p, T2, offset)
%
%  offset : offset of lineshape in Hz
%
%  CW approximate solution for sequence of given pulse exciting a pool
%  with lorentzion linewidth.  (assume circularly polarized coil)
%
%  
%  linewidth g(w) = sqrt(2) * T2/sqrt(2*pi) * exp(-0.5*T2^2*(w + offset)^2)

W = sqrt(2) *p.power * T2/p.TR * 1./(1 + (p.dw+2*pi*offset)^2*T2^2);
%W = p.power * sqrt(pi/2)*T2/p.TR * exp(-0.5*((p.dw+2*pi*offset)^2*T2^2));
p.rfrate = W;