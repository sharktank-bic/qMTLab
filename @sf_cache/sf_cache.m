function p = sf_cache(angles, offsets, T2, pulse_name, duration, TR, bw, s)
%  function p = sf_cache(angles, offsets, T2, pulse_name, duration, TR, bw, s)
%
%    or 
%
%  function p = sf_cache('filename.mat')

if nargin == 0
  p.angles = [];
  p.offsets = [];
  p.T2 = [];
  p.pulse_name = '';
  p.duration = 0;
  p.TR = 0;
  p.bw = 0;
  p.pulses = {};
  p.values = [];
  p = class(p, 'sf_cache');
elseif isa(angles, 'sf_cache')
  p = angles;
elseif isa(angles, 'char')
  %which sf
  %clear sf;
  load(angles);
  %p.angles = getfield(sf, 'angles');
  p.angles = sf.angles;
  p.offsets = getfield(sf,'offsets');
  p.T2 = getfield(sf, 'T2');
  p.pulse_name = getfield(sf, 'pulse_name');
  p.duration = getfield(sf, 'duration');
  p.TR = getfield(sf, 'TR');
  p.bw = getfield(sf, 'bw');
  %p.s = getfield(sf, 's');
  p.pulses = {};
  p.values = getfield(sf, 'values');
  p = class(p, 'sf_cache');
  p.pulses = create_pulses(p);
else
  p.angles = angles;
  p.offsets = offsets;
  p.T2 = T2;
  p.pulse_name = pulse_name;
  p.duration = duration;
  p.TR = TR;
  p.bw = bw;
  if strmatch(pulse_name, 'fermi')
    p.s = s;
  end
  p.pulses = {};
  p.values = [];
  p = class(p, 'sf_cache');
  p.pulses = create_pulses(p);
  p.values = compute_values(p);
end


function values = compute_values(p)

N = length(p.angles);
M = length(p.offsets);
P = length(p.T2);

values = zeros(N, M, P);

for i = 1:N
    i
  for j = 1:M
    %save sf_temp.mat
    j
    for k = 1:P
      q = set_offset(p.pulses{i}, p.offsets(j));
      values(i,j,k) = sim_sf_o(q, 10, p.T2(k), p.offsets(j));
    end
  end
end

return
