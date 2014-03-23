function p = msat(angle, duration, offset)
%  function p = msat(duration, offset)
%
%  off resonance MSAT gaussian pulse
%  
%  duration    : pulse duration
%  offset      : offset frequency

load MSAT.63MHZ.dat

if nargin == 0
  S = seqbase(0);
  p.tau = 0;
  p.N = 0;
  p.T = [];
  p.A = [];
  p = class(p, 'msat', S);
elseif isa(angle, 'msat')
  p = angle;
else
  p.tau = duration;
  N = size(MSAT,1);
  p.N = N;
  p.T = p.tau*((0:(N-1))'+0.5)/N;
  scale = angle*pi*N/(180*247.904571533*p.tau);
  p.A = scale*MSAT(:,1).*exp(sqrt(-1)*2*pi*offset*(p.T - p.T(N/2+1)));
  
  S = seqbase(duration);
  p = class(p, 'msat', S);
end