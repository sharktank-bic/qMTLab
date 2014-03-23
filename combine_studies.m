function study = combine_studies(studies)
%
%
%  function study = combine_studies(studies)
%

study = studies{1};

names = {'TR' 'flip' 'nominal_angles' 'pulse_type' 'pulse_duration' ...
    'nominal_offsets' 'files'  'baseline' 'normalization_scale' 'b0_shift' 'b1_scale'};

for i = 1:length(names)
  if(isfield(study, names{i}))
    v = getfield(studies{1}, names{i});
    for j = 2:length(studies);
      v = cat(2, v, getfield(studies{j}, names{i}));
    end
    study = setfield(study, names{i}, v);
  end
end
