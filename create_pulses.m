function pulses = create_pulses(p)

for i = 1:length(p.angles)
  if(strcmp(p.pulse_name, 'gaussian_hann'))
    pulses{i} = gaussian_hann(p.angles(i), p.duration, 0, p.TR, p.bw);
  elseif(strcmp(p.pulse_name, 'gaussian'))
    pulses{i} = gaussian(p.angles(i), p.duration, 0, p.TR);
  elseif(strcmp(p.pulse_name, 'fermi'))
    pulses{i} = fermi(p.angles(i), p.duration, 0, p.TR, p.bw, p.s);
  else
    error('Unknown pulse name');
  end
end

return
