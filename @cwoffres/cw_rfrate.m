function W = cw_rfrate(p, T2, offset, line)
%
%  p = cw_rfrate(p, T2, offset)
%
%  offset : offset of lineshape in Hz
%
%  CW approximate solution for sequence of square pulses exciting a pool with specified linewidth
%
%  pulse w1(t) = const


if(T2 > 0)
  W = p.power * pi * lineshape(line, T2, 2*pi*offset)/p.TR;
else
  W = zeros(size(offset));
end
