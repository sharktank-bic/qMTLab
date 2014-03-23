function p = binomial(angle, duration, order)
%  function p = binomial(angle, duration, order)
%
%  binomial sequence of rect pulses of given angle (degrees)
%   and duration (seconds) 

if nargin == 0
  S = seqbase(0);
  p.tau = 0;
  p.order = 0;
  p.N = 0;
  p.A = [];
  p.rfrate = 0;
  p.lineshape = '';
  p = class(p, 'binomial');
elseif isa(angle, 'binomial')
  p = angle;
else
  p.tau = duration;
  p.order = order;
  c = [1 -1];
  % generate coefficients
  for i = 1:(order-1)
    c = conv(c, [1 -1]);
  end
  
  p.N = sum(abs(c));  % number of periods
  p.A = [];           % amplitude of each period
  for i = 1:length(c);
    p.A = [p.A ones(1,abs(c(i)))*sign(c(i))*angle*pi/(180*duration)];
  end
  p.rfrate = 0;
  p.lineshape = '';
  S = seqbase(p.N*duration);
  p = class(p, 'binomial', S);
end