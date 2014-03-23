function study = collect_mt_studies(studies, indices)

study = studies{indices(1)};

for i = 2:length(indices)
  for j = 1:length(study.nominal_offsets)
    study.nominal_offsets{j} = ...
        cat(2, study.nominal_offsets{j}, studies{indices(i)}.nominal_offsets{j}); 
  end
end

N = length(study.nominal_angles);
study.files = cell(1,N);

l = 0;
for i = 1:length(indices)
  P = length(studies{indices(i)}.files)/N;
  for k = 1:P
    for j = 1:N
      study.files{j}{l+k} = studies{indices(i)}.files{(j-1)*P+k};
    end
  end
  l = l + P;
end

return