function Sf = get_value_i(p, angle, offset, T2)
%
% function Sf = get_value_i(p, angle, offset, T2)
%
% interpolate Sf values


Sf = interp3(p.offsets, p.angles, p.T2, p.values, offset, angle, T2);
% note order of parameters.  Strange?

if(sum(isnan(Sf)))
  error(sprintf('Requested values not in cache.\nangle = %4d deg, offset = %f Hz, T2 = %f ms', angle, offset, T2*1000))
end