function p = add_T2(p, T2)
%
% function p = add_T2(p, T2)
%
%

if(~isempty(find(T2 == p.T2)))
  type 'T2 value already present in cache';
  return;
end


[p.T2, I] = sort([p.T2 T2]);
k = find(I == length(I));

if(k > 1)
  values(:,:,1:(k-1)) = p.values(:,:,1:(k-1));
end

N = length(p.angles);
M = length(p.offsets);
P = length(p.T2);

for i = 1:N
  for j = 1:M
    disp(sprintf('Pulse: %2d  Offset: %10g   T2: %10g', i, p.offsets(j),p.T2(k) ))   
    q = set_offset(p.pulses{i}, p.offsets(j));
    values(i,j,k) = sim_sf_o(q, 10, p.T2(k), p.offsets(j));
  end
end

if(k < P)
  values(:,:,(k+1):P) = p.values(:,:,k:(P-1));
end

p.values = values;