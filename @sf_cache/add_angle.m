function p = add_angle(p, angle)
%
% function p = add_angle(p, angle)
%
%

if(~isempty(find(angle == p.angles)))
  type 'T2 value already present in cache';
  return;
end


[p.angles, I] = sort([p.angles angle]);
i = find(I == length(I));

% create pulse objects from angle list 
p.pulses = create_pulses(p)

% reserve first part of cache
if(i > 1)
  values(1:(i-1),:,:) = p.values(1:(i-1),:,:);
end

N = length(p.angles);
M = length(p.offsets);
P = length(p.T2);

for j = 1:M
  for k = 1:P
    disp(sprintf('Pulse: %5d  Offset: %10g   T2: %10g', p.angles(i), p.offsets(j),p.T2(k) ))   
    q = set_offset(p.pulses{i}, p.offsets(j));
    values(i,j,k) = sim_sf_o(q, 10, p.T2(k), p.offsets(j));
  end
end

if(i < N)
  values((i+1):N,:,:) = p.values(i:(N-1),:,:);
end

p.values = values;