function lineshape = cache_lineshape(study, lineshape)
%
%  function lineshape = cache_lineshape(study, lineshape)
%
%  create lineshape cache if necessary


if(~isa(lineshape, 'superlrtz_line') & strcmp(lineshape, 'superlrtz_line'))
  t2_range = [1e-6 100e-3];
  offset_range(1) = study.nominal_offsets{1}(1);
  offset_range(2) = max(study.nominal_offsets{1});
  if (length(study.nominal_angles) > 1)
    for j = 2:length(study.nominal_angles)
      offset_range(1) = min([offset_range(1) study.nominal_offsets{j}(1)]);
      offset_range(2) = max([offset_range(2) study.nominal_offsets{j}]);
    end
  end
  offset_range(1) = offset_range(1)/2;
  offset_range(2) = offset_range(2)*2;
  % generate lineshape cache 
  lineshape = superlrtz_line(t2_range, ...
      round(log10(t2_range(2)/t2_range(1))*20), offset_range,...
      length(study.nominal_offsets{1}));

end
