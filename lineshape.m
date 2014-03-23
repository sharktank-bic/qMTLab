function g = lineshape(p, T2, dw)
%
%  g = lineshape(p, T2, dw)
%
%  Compute line shape for given T2 (s) and dw (rad/s)
%
%  Note g has been set arbitrarily to zero for dw = 0.
%

% this gives me problems in versions 7.5 and 7.10 - I Levesque, July 2010
%mbrealscalar(T2);

m = dw > 0;
ln_s = log(T2*dw(m));
g = zeros(size(dw));
g(m) = T2*interp1(p.cache(:,1), p.cache(:,2), ln_s, '*linear');

n = isnan(g);
g(logical(n)) = p.overrange;
