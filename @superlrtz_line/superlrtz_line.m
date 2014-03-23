function p = superlrtz_line(T2_range, n, offset_range, m)
%  p = superlrtz_line(T2_range, n, offset_range, m)
%
%  Superlorentzian lineshape function derived from gaussian line.
%  Values are cached using logarithmic sampling
%
%  T2_range       :  [min T2, max T2]
%  n              :  number of logarithmic samples in T2
%  offset_range   :  [min offset, max offset]    (Hz)
%  m              :  number of logarithmic samples in offset frequency

if nargin == 0
  p.min_ln_s = 0;
  p.max_ln_s = 0;
  p.cache = [];
  p.overrange = 0;
  p = class(p, 'superlrtz_line');
elseif isa(T2_range, 'superlrtz_line')
  p = T2_range;
else
  p.min_ln_s = log(T2_range(1)) + log(2*pi*offset_range(1));
  p.max_ln_s = log(T2_range(2)) + log(2*pi*offset_range(2));
  p.cache = [];
  p.overrange = 0;
  p = class(p, 'superlrtz_line');

  % determine sampling of cache
  delta = min(log(T2_range(2)/T2_range(1))/(n-1), ...
      log(offset_range(2)/offset_range(1))/(m-1));
  n = ceil((p.max_ln_s - p.min_ln_s) / delta);
  delta = (p.max_ln_s - p.min_ln_s) / n;

  p.cache = zeros(n,2);
  % compute cache values
  for i = 1:n
    ln_s = (i-1)*delta + p.min_ln_s;
    p.cache(i,1) = ln_s;
    singularity = 1/sqrt(3);
    p.cache(i,2) = quad('superlrtz_fcn',0,singularity, [], [], exp(ln_s));
    p.cache(i,2) = p.cache(i,2) + ...
        quad('superlrtz_fcn',singularity, 1, [], [], exp(ln_s));
  end

  p.overrange = 100*p.cache(1,2);  % used for values outside of cache
end
