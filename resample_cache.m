function p = resample_cache(p, angles, offsets, T2s)
%
% 
%
% interpolate Sf values


[xi, yi, zi] = meshgrid(offsets, angles, T2s);
v = interp3(p.offsets, p.angles, p.T2, p.values, xi, yi, zi);

p.values = v;
p.offsets = offsets;
p.angles = angles;
p.T2 = T2s;
