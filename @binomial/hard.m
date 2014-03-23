function p = binomial(angle, duration, order)
%  function p = binomial(angle, duration, order)
%
%  rect pulse of given angle (degrees) and duration (seconds) 

if nargin == 0
  p.A = 0;
  p.tau = 0;
  p.order = 0;
  p.c = [];
  p.N = 0;
  p = class(p, 'binomial');
elseif isa(angle, 'binomial')
  p = angle;
else
  p.A = angle*pi/(180*duration);
  p.tau = duration;
  p.order = order;
  p.c = [1 -1];
  % generate coefficients
  for i = 1:(order-1)
    p.c = conv(p.c, [1 -1]);
  end
  p.N = = sum(abs(p.c)); 
  
  p = class(p, 'binomial');
end