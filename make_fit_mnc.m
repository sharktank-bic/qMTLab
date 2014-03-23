function make_fit_mnc(data, fit, basename, template, limits, mask)
%
%  function make_fit_mnc(study, fit, basename, limits, mask )
%
%

var = { 'kf' 1; 'f' 1;  'R1' 1; 'T2' 1; 'T2' 2};
name = { 'kf' 'f' 'r1f' 't2f' 't2r'};

N = sqrt(length(data.mask));

if(nargin < 5 | isempty(limits))
  limits = [0 0 0 0 0; 10 0.5 10 1 5e-5]';
end

if(nargin < 6 | isempty(mask))
  mask = ones(size(data.mask));
end



for i = 1:size(var,1)
  a = getfield(fit,var{i,1});
  img = zeros(size(data.mask));
  img(data.mask) = clamp_img(a(:,var{i,2}), limits(i,:));

  %h = newimage([basename '_' name{i} '.mnc'], [0 1 N N], template);
  h = newimage([basename '_' name{i} '.mnc'], [0 size(data.mask,2)], template,'float',[],'transverse');
  putimages(h, img, 1:size(data.mask,2));
  closeimage(h)
end

a = sqrt(getfield(fit,'e2'));
img = zeros(size(data.mask));
img(data.mask) = clamp_img(a(:,1), [0 1]);

%h = newimage([basename '_rms.mnc'], [0 1 N N], template);
%h = newimage([basename '_rms.mnc'], [0 1], template);
%putimages(h, img, 1);
h = newimage([basename '_rms.mnc'], [0 size(data.mask,2)], template,'float',[],'transverse');
putimages(h, img, 1:size(data.mask,2));
closeimage(h)
