function p = update_rfrate(p, T2, offset)
%
%  function update_rfrate(p, T2, offset)
%
%  p          :  pulse object
%  T2         :
%  offset     :  frequency offset of lineshape

if(p.rfrate ~= 0)
  p = compute_rfrate(p, p.lineshape, T2, offset);
end