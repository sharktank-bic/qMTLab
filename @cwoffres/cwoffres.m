function p = cwoffres(angle, duration,offset)
%  function p = cwoffres(angle, duration,offset)
%
%  rect pulse of given angle (degrees) and duration (seconds) and offset (Hz)

if nargin == 0
  S = seqbase(0);
  p.A = 0;
  p.power = 0;
  p.tau = 0;
  p.dw = 0;
  p.TR = 0;
  p = class(p, 'cwoffres', S);
elseif isa(angle, 'cwoffres')
  p = angle;
else
  S = seqbase(duration);
  p.A = angle*pi/(180*duration);
  p.power = 0;
  p.tau = duration;
  p.dw = 2*pi*offset;
  p.TR = 0;
  p = class(p, 'cwoffres',S);
  p.power = power(p);
end
