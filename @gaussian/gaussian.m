function p = gaussian(angle, duration,offset,TR)
%  function p = gaussian(angle, duration, offset,TR)
%
%  gaussian pulse of given angle (degrees), duration (seconds),
%  and offset (Hz)

if nargin == 0
  S = seqbase(0);
  p.tau = 0;
  p.A = 0;
  p.power = 0;
  p.c = 0;
  p.s2 = 0;
  p.dw = 0;
  p.TR = 0;
  p.rfrate = -1;
  p.lineshape = '';
  p = class(p, 'gaussian');
elseif isa(angle, 'gaussian')
  p = angle;
else
  p.tau = duration;
  p.A = pi*angle/(0.4843*180*duration);
  p.power = 0;
  p.c = duration/2;
  p.s2 = (duration*100/512)^2;
  p.dw = 2*pi*offset;
  p.TR = TR;
  p.rfrate = -1;
  p.lineshape = '';
  S = seqbase(TR);
  p = class(p, 'gaussian', S);
  p.power = power(p);
end