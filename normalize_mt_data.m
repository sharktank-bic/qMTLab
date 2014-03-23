function data = normalize_mt_data(study, data, median_flag)
%
% function data = normalize_mt_data(study, data, median_flag)
%
% median_flag : 1 -> normalize by median as well
%

%
%  Modified August 2006 (Ives) to allow 3D datasets 
%  Modified July 2008 (Ives) img(data.mask==1) instead of img(data.mask)
%

M = length(study.files);

if(isfield(study, 'normalization_scale'))
  fudge = study.normalization_scale;
else
  fudge = ones(1,M);
end

for i = 1:M
  h = openimage_opt_gz(study.baseline{i});
  %tmp = miinquire([study.dir study.baseline{i}],'ImageSize');
  tmp = miinquire(study.baseline{i},'imagesize');
  nslices = tmp(2);
  img = getimages(h, 1:nslices);
  norm = img(data.mask==1);
  norm = 1./(norm + (norm == 0));
  closeimage(h);
  if(length(img) ~= length(data.mask))
    error(sprintf('File %s does not match dimensions of mask file.', ...
      study.baseline{i}));
  end

  N = length(study.files{i});
  if(nargin > 2 & median_flag == 1)
    fudge(i) = fudge(i)/median(data.measurements{i}(:,N).*norm);
  end
  for j = 1:N
    data.measurements{i}(:,j) = fudge(i)*data.measurements{i}(:,j).*norm;
  end
end

function h = openimage_opt_gz(filename)

fid = fopen(filename);
if(fid == -1)
  h = openimage([filename '.gz']);
else
  fclose(fid);
  h = openimage(filename);
end
