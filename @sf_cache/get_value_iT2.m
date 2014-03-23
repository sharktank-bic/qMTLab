function Sf = get_value_iT2(p, i, j, T2)
%
% function Sf = get_value_iT2(p, i, j, T2)
%
%


%v = squeeze(p.values(i,j,:));

v = reshape(p.values(i,j,:),length(p.T2),1);
Sf = interp1q(p.T2, v, T2);

if(isnan(Sf))
  Sf = 0;
end
