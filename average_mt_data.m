function rdata = average_mt_data(study, data, labels)
%
% average_mt_data(study, data, labels)
%

% modified Feb 2011, Ives Levesque
% to allow separate B0 files for different parts of the experiment, if desired


N = round(max(labels));
rdata.mask = ones(N,1);

names = {'b0', 'b1', 'R1obs', 'dR1obs', 'T2obs', 'dT2obs', 'T2evr'};

for i = 1:N
  mask(:,i) = (labels > i - 0.5) & (labels < i + 0.5);
end

for j = 1:length(names)
  if(isfield(data, names{j}))
    img = getfield(data,names{j});
    for i = 1:N
        for k = 1:size(img,2)   % mod here
            rdata = setfield(rdata, names{j}, {i,k}, mean(img(mask(:,i),k)));
        end
    end
  end
end

for j = 1:length(data.measurements)
  for i = 1:N
    rdata.measurements{j}(i,:) = mean(data.measurements{j}(mask(:,i),:),1);
    rdata.measdev{j}(i,:) = std(data.measurements{j}(mask(:,i),:),1);
  end
end

if(isfield(data, 'T2res'))
  rdata.T2res = zeros(N,1);
  for i = 1:N
    rdata.T2res(i,1) = sum(data.T2res(mask(:,i)))/sum(mask(:,i))^2;
  end
end

if(isfield(data, 'MT_variance'))
  rdata.MT_variance = zeros(N,1);
  for i = 1:N
    rdata.MT_variance(i,1) = sum(data.MT_variance(mask(:,i)))/sum(mask(:,i))^2;
  end
end
