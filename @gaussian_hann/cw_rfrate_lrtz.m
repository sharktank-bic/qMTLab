function p = cw_rfrate(p, T2, offset)
%
%  p = cw_rfrate(p, T2, offset)
%
%  offset : offset of lineshape in Hz
%
%  CW approximate solution for sequence of given pulse exciting a pool
%  with lorentz linewidth.
%
%  
%  linewidth g(w) = p.power * T2/p.TR * 1/(1+(((p.dw+2*pi*offset)^2*T2^2)));

W = p.power * T2/p.TR * 1/(1+(((p.dw+2*pi*offset)^2*T2^2)));
p.rfrate = W;

