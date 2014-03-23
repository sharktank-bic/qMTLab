function comp = do_subject

uiwait(warndlg('Please select working directory'));
workdir = [uigetdir '/'];
display(workdir)

study = qmt_off_data(workdir);

for ii = 1:length(study)
  baseline{ii} = study{ii}.baseline;
  study{ii} = rmfield(study{ii},'baseline');
  if ~isempty(study{ii})
    study{ii} = get_study_info(workdir, study{ii});
  else
    warning(sprintf('Study %d is empty.',ii))
  end
  comp{ii} = collect_mt_studies(study, [ii]);
  normScale(ii) = 1;

  comp{ii}.normalization_scale = ones(1,length(comp{ii}.files))*normScale(ii);

  for jj = 1:length(comp{ii}.files)
      comp{ii}.baseline{jj} = char(baseline{ii});
  end
 
end

uiwait(helpdlg('Select mask file'));
  [filename filepath] = uigetfile('*.*');
  mask = fullfile(filepath,filename);

  uiwait(helpdlg('Select B0 file'));
  [filename filepath] = uigetfile('*.*');
  b0_file = fullfile(filepath,filename);
  b0_shift = [0 0 0 0 0 0 0 0 0 0];

  uiwait(helpdlg('Select B1 file'));
  [filename filepath] = uigetfile('*.*');
  b1_file = fullfile(filepath,filename);
  b1_scale = [1 1 1 1 1 1 1 1 1 1];

  
  uiwait(helpdlg('Select T1 file'));
  [filename filepath] = uigetfile('*.*');
  t1_file = fullfile(filepath,filename);

  
  uiwait(helpdlg('Select dR1 file'));
  [filename filepath] = uigetfile('*.*');
  dr1_file = fullfile(filepath,filename);

for i = 1:length(comp)
  comp{i}.dir = workdir;
  comp{i}.mask = mask;
  comp{i}.b0_file = b0_file;
  comp{i}.b0_shift = b0_shift;
  comp{i}.b1_file = b1_file;
  comp{i}.b1_scale = b1_scale;
  comp{i}.t1_file = t1_file;
  comp{i}.dr1_file = dr1_file;

%  comp{i}.t2_file = ['t2/' basename '_t2.mnc'];
%  comp{i}.t2res_file = ['t2/' basename 't2_res.mnc'];
%  comp{i}.t2evr_file = ['t2/' basename 't2_evr.mnc'];
end

return
