function data = read_study_data(study)
%
%  data = read_study_data(study)
%
%  A function to read in data from a QMRI (MT-T1-T2-B0-B1) study.
%

%
%  Written by JG Sled ca. 1999
%  Modified March 8, 2005 Ives Levesque (_evil) to check input file path
%  Modified August 2006 (Ives) to allow 3D datasets 
%
% modified Feb 2011, Ives Levesque
% to allow separate B0 files for different parts of the experiment, if desired
%


vars = { 'b0_file' 'b0'; 'b1_file' 'b1'; 'dr1_file' 'dR1obs'; ...
         't2_file' 'T2obs';  't2res_file' 'T2res'; 't2evr_file' 'T2evr'};


%tmp = miinquire([study.dir study.mask],'ImageSize');

tmp = miinquire(study.mask,'imagesize');
nslices = tmp(2);
h = openimage_opt_gz([study.mask]);
data.mask = getimages(h, 1:nslices) > 0;
%size(data.mask)
L = length(data.mask);
closeimage(h)


for i = 1:size(vars, 1)
  if(isfield(study, vars{i,1}))
    display(getfield(study,vars{i,1}));
    if iscell(getfield(study, vars{i,1}))
        for j = 1:length(getfield(study, vars{i,1}))
            h = openimage_opt_gz(char(getfield(study, vars{i,1}, {j})));
            tmp = miinquire(char(getfield(study, vars{i,1}, {j})),'imagesize');
            nslices = tmp(2);
            img = getimages(h, 1:nslices);
            data = setfield(data, vars{i,2}, {1:sum(data.mask),j}, img(data.mask) );
            closeimage(h);
            check_dims(img, getfield(study, vars{i,1}), L);
        end
    else    
        h = openimage_opt_gz(getfield(study, vars{i,1}));
        %tmp = miinquire([study.dir getfield(study, vars{i,1})],'ImageSize');
        tmp = miinquire(getfield(study, vars{i,1}),'imagesize');
        nslices = tmp(2);
        img = getimages(h, 1:nslices);
     %   size(img)
        data = setfield(data, vars{i,2}, img(data.mask));
        closeimage(h);
        check_dims(img, getfield(study, vars{i,1}), L);
        
    end
  end
end
  
if(isfield(study, 't1_file'))
  h = openimage_opt_gz(study.t1_file);
  %tmp = miinquire([study.dir study.t1_file],'ImageSize');
  tmp = miinquire(study.t1_file,'imagesize');
  nslices = tmp(2);
  img = getimages(h, 1:nslices);
  check_dims(img, study.t1_file, L);
  img = img(data.mask);
  data.R1obs = ones(size(img))./(img + (img == 0));
  closeimage(h);
end

M = length(study.files);
data.measurements = cell(M,1);
for i = 1:M
  for j = 1:length(study.files{i})
        h = openimage_opt_gz(study.files{i}{j});
        %tmp = miinquire([study.files{i}{j}],'ImageSize');
        tmp = miinquire([study.files{i}{j}],'imagesize');
    nslices = tmp(2);
    img = getimages(h, 1:nslices);
    data.measurements{i}(:,j) = img(data.mask);
    closeimage(h);
    check_dims(img, study.files{i}{j}, L);
  end
end

return


%------------------------------------------------------------------------
function check_dims(img, name, L)

if(length(img) ~= L)
  error(sprintf('File %s does not match dimensions of mask file.', name));
end

return


%------------------------------------------------------------------------
function h = openimage_opt_gz(filename)

fid = fopen(filename);
if(fid == -1)
  h = openimage([filename '.gz']);
else
  fclose(fid);
  h = openimage(filename);
end

