function p = thermal_2pool_flex(lineshape);
%  p = thermal_2pool_flex(lineshape);
%
if nargin == 0
  p.lineshape = 0;
  p = class(p, 'thermal_2pool_flex');
elseif isa(lineshape, 'thermal_2pool_flex')
  p = lineshape;
else
  p.lineshape = lineshape;
  p = class(p, 'thermal_2pool_flex');
end
