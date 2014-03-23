function p = seqbase(duration)
%  function p = seqbase(duration)
%
%  base class for sequences

if nargin == 0
  p.duration = 0;
  p = class(p, 'seqbase');
elseif isa(duration, 'seqbase')
  p = angle;
else
  p.duration = duration;
  p = class(p, 'seqbase');
end