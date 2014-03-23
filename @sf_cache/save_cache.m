function save_cache(p, filename)
%
%  function save_cache(p, filename)
%
%
%

sf = struct(p);
sf = rmfield(sf, 'pulses');
save(filename, 'sf');