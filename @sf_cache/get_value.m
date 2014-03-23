function Sf = get_value(p, angle, offset, T2)
%
% function Sf = get_value(p, angle, offset, T2)
%
%

i = find(angle == p.angles);
j = find(offset == p.offsets);
k = find(T2 == p.T2);

if(isempty(i) | isempty(j) | isempty(k))
  disp 'value not in cache';
  return;
end

Sf = p.values(i,j,k);