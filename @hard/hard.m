function p = hard(angle, duration)
%  function p = hard(angle, duration)
%
%  rect pulse of given angle (degrees) and duration (seconds) 

if nargin == 0
  S = seqbase(0);
  p.A = 0;
  p.power = 0;
  p.dw = 0;
  p.tau = 0;
  p = class(p, 'hard', S);
elseif isa(angle, 'hard')
  p = angle;
else
  S = seqbase(duration);
  p.power = 0;
  p.A = angle*pi/(180*duration);
  p.tau = duration;
  p = class(p, 'hard',S);
  p.power = power(p);
end
