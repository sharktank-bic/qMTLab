function q = set_offset(p, offset)
%
%  function q = set_offset(p, offset)
%  
%  p      : pulse
%  offset : offset frequency (Hz)

q = p;
q.dw = 2*pi*offset; 