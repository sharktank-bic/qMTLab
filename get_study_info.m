function study = get_study_info(dir, study)
%
%  function study = get_study_info(study)
%
%  Fill in additional study information
%
%  Modified March 8, 2005 Ives Levesque (_evil)
%

if(isfield(study, 'files'))
  filename = study.files{1};
  [TR, flip] = miinquire(filename, 'attvalue', 'acquisition', ...
	   'repetition_time', 'attvalue', 'acquisition', 'flip_angle');
  clear filename
else
  flip = 0;
  TR = 0;
end

template = pick_template(study.sequence);

if(~isempty(template))
  names = fieldnames(study);
  for i = 1:length(names)
    template = setfield(template, names{i}, getfield(study,names{i}));
  end

  study = template;
  sets = length(study.nominal_angles);
  study.TR = ones(1,sets)*TR;
  study.flip = ones(1,sets)*flip;
else
  study.TR = TR;
  study.flip = flip;
end  


function pick = pick_template(sequence)

i = 1;
template{i}.template = 'mtspgr_im15_1';
template{i}.nominal_angles = [142 710];
template{i}.nominal_offsets{1} = [800*(100.^([0:5]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];


i = 2;
template{i}.template = 'mtspgr_im15_2';
template{i}.nominal_angles = [142 710];
template{i}.nominal_offsets{1} = [800*(100.^([6:11]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];


i = 3;
template{i}.template = 'mtspgr_im15_3';
template{i}.nominal_angles = [142 710];
template{i}.nominal_offsets{1} = [800*(100.^([12:15]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];


i = 4;
template{i}.template = 'mtspgr_im15_4';
template{i}.nominal_angles = [347 1735];
template{i}.nominal_offsets{1} = [800*(100.^([0:5]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];


i = 5;
template{i}.template = 'mtspgr_im15_5';
template{i}.nominal_angles = [347 1735];
template{i}.nominal_offsets{1} = [800*(100.^([6:11]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];


i = 6;
template{i}.template = 'mtspgr_im15_6';
template{i}.nominal_angles = [347 1735];
template{i}.nominal_offsets{1} = [800*(100.^([12:15]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];


i = 7;
template{i}.template = 'mtspgr_im14_1';
template{i}.nominal_angles = [142 568];
template{i}.nominal_offsets{1} = [800*(100.^([0:5]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];


i = 8;
template{i}.template = 'mtspgr_im14_2';
template{i}.nominal_angles = [142 568];
template{i}.nominal_offsets{1} = [800*(100.^([6:11]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];


i = 9;
template{i}.template = 'mtspgr_im14_3';
template{i}.nominal_angles = [142 568];
template{i}.nominal_offsets{1} = [800*(100.^([12:15]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];


i = 10;
template{i}.template = 'mtspgr_im14_4';
template{i}.nominal_angles = [347 1388];
template{i}.nominal_offsets{1} = [800*(100.^([0:5]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];


i = 11;
template{i}.template = 'mtspgr_im14_5';
template{i}.nominal_angles = [347 1388];
template{i}.nominal_offsets{1} = [800*(100.^([6:11]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];


i = 12;
template{i}.template = 'mtspgr_im14_6';
template{i}.nominal_angles = [347 1388];
template{i}.nominal_offsets{1} = [800*(100.^([12:15]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];

i = 13;
template{i}.template = 'mtspgr_im15_7';
template{i}.nominal_angles = [142 710];
template{i}.nominal_offsets{1} = [800*(100.^([0:5]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];


i = 14;
template{i}.template = 'mtspgr_im15_8';
template{i}.nominal_angles = [142 710];
template{i}.nominal_offsets{1} = [800*(100.^([6:11]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];


i = 15;
template{i}.template = 'mtspgr_im15_9';
template{i}.nominal_angles = [142 710];
template{i}.nominal_offsets{1} = [800*(100.^([12:15]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];


i = 16;
template{i}.template = 'mtspgr_im15_10';
template{i}.nominal_angles = [347 1735];
template{i}.nominal_offsets{1} = [800*(100.^([0:5]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];


i = 17;
template{i}.template = 'mtspgr_im15_11';
template{i}.nominal_angles = [347 1735];
template{i}.nominal_offsets{1} = [800*(100.^([6:11]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];


i = 18;
template{i}.template = 'mtspgr_im15_12';
template{i}.nominal_angles = [347 1735];
template{i}.nominal_offsets{1} = [800*(100.^([12:15]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];

i = 19;
template{i}.template = 'mtspgr_im14_7';
template{i}.nominal_angles = [142 568];
template{i}.nominal_offsets{1} = [800*(100.^([0:5]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];


i = 20;
template{i}.template = 'mtspgr_im14_8';
template{i}.nominal_angles = [142 568];
template{i}.nominal_offsets{1} = [800*(100.^([6:11]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];


i = 21;
template{i}.template = 'mtspgr_im14_9';
template{i}.nominal_angles = [142 568];
template{i}.nominal_offsets{1} = [800*(100.^([12:15]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];


i = 22;
template{i}.template = 'mtspgr_im14_10';
template{i}.nominal_angles = [347 1388];
template{i}.nominal_offsets{1} = [800*(100.^([0:5]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];


i = 23;
template{i}.template = 'mtspgr_im14_11';
template{i}.nominal_angles = [347 1388];
template{i}.nominal_offsets{1} = [800*(100.^([6:11]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];


i = 24;
template{i}.template = 'mtspgr_im14_12';
template{i}.nominal_angles = [347 1388];
template{i}.nominal_offsets{1} = [800*(100.^([12:15]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];

i = 25;
template{i}.template = 'mtspgr_im14_13';
template{i}.nominal_angles = [142 568];
template{i}.nominal_offsets{1} = [800*(100.^([-4:-1]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];

i = 26;
template{i}.template = 'mtspgr_im14_14';
template{i}.nominal_angles = [347 1388];
template{i}.nominal_offsets{1} = [800*(100.^([-4:-1]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];

i = 27;
template{i}.template = 'mtspgr_im15_13';
template{i}.nominal_angles = [142 710];
template{i}.nominal_offsets{1} = [800*(100.^([-4:-1]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];

i = 28;
template{i}.template = 'mtspgr_im15_14';
template{i}.nominal_angles = [347 1735];
template{i}.nominal_offsets{1} = [800*(100.^([-4:-1]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];

i = 29;
template{i}.template = 'mtspgr_im14_15';
template{i}.nominal_angles = [347 1388];
template{i}.nominal_offsets{1} = [800*(100.^([-4:2:7]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];

i = 30;
template{i}.template = 'mtspgr_im14_16';
template{i}.nominal_angles = [347 1388];
template{i}.nominal_offsets{1} = [800*(100.^([8:2:15]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];

i = 31;
template{i}.template = 'mtspgr_im1';
template{i}.nominal_angles = [283 849];
template{i}.nominal_offsets{1} = [800*(100.^([0:3]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];

i = 32;
template{i}.template = 'mtspgr_im2';
template{i}.nominal_angles = [283 849];
template{i}.nominal_offsets{1} = [800*(100.^([4:7]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];

i = 33;
template{i}.template = 'mtspgr_im3';
template{i}.nominal_angles = [283 849];
template{i}.nominal_offsets{1} = [800*(100.^([8:11]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];

i = 34;
template{i}.template = 'mtspgr_im4';
template{i}.nominal_angles = [283 849];
template{i}.nominal_offsets{1} = [800*(100.^([12:15]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];

i = 35;
template{i}.template = 'mtspgr_im5';
template{i}.nominal_angles = [693 2079];
template{i}.nominal_offsets{1} = [800*(100.^([0:3]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];

i = 36;
template{i}.template = 'mtspgr_im6';
template{i}.nominal_angles = [693 2079];
template{i}.nominal_offsets{1} = [800*(100.^([4:7]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];

i = 37;
template{i}.template = 'mtspgr_im7';
template{i}.nominal_angles = [693 2079];
template{i}.nominal_offsets{1} = [800*(100.^([8:11]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];

i = 38;
template{i}.template = 'mtspgr_im8';
template{i}.nominal_angles = [693 2079];
template{i}.nominal_offsets{1} = [800*(100.^([12:15]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];

i = 39;
template{i}.template = 'mtspgr_im14_m1';
template{i}.nominal_angles = [347 1047];
template{i}.nominal_offsets{1} = [800*(100.^([-4 -4 -2.5 -2.5 -1 -1]/15)).*[1 -1 1 -1 1 -1]];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];

i = 40;
template{i}.template = 'mtspgr_im14_m2';
template{i}.nominal_angles = [347 1047];
template{i}.nominal_offsets{1} = [800*(100.^([-3.5 -3.5 -2 -2 -0.5 -0.5]/15)).*[1 -1 1 -1 1 -1]];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];

i = 41;
template{i}.template = 'mtspgr_im14_m3';
template{i}.nominal_angles = [347 1047];
template{i}.nominal_offsets{1} = [800*(100.^([-3 -3 -1.5 -1.5 -0 -0]/15)).*[1 -1 1 -1 1 -1]];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];

i = 42;
template{i}.template = 'mtspgr_im15_m4';
template{i}.nominal_angles = [142 710];
template{i}.nominal_offsets{1} = [800*(100.^(-[4 4 2.5 2.5 1 1]/15)).*[1 -1 1 -1 1 -1]];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];

i = 43;
template{i}.template = 'mtspgr_im15_m5';
template{i}.nominal_angles = [142 710];
template{i}.nominal_offsets{1} = [800*(100.^(-[3.5 3.5 2 2 0.5 0.5]/15)).*[1 -1 1 -1 1 -1]];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];

i = 44;
template{i}.template = 'mtspgr_im15_m6';
template{i}.nominal_angles = [142 710];
template{i}.nominal_offsets{1} = [800*(100.^(-[3 3 1.5 1.5 0 0]/15)).*[1 -1 1 -1 1 -1]];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];

i = 45;
template{i}.template = 'mtspgr_im14_15test1';
template{i}.nominal_angles = [347 1388];
template{i}.nominal_offsets{1} = [800*(100.^([-4:2:7]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [20480e-6 20480e-6];

i = 46;
template{i}.template = 'mtspgr_im14_16test1';
template{i}.nominal_angles = [347 1388];
template{i}.nominal_offsets{1} = [800*(100.^([8:2:15]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [20480e-6 20480e-6];

i = 47;
template{i}.template = 'mtspgr_im14_17';
template{i}.nominal_angles = [283 1132];
template{i}.nominal_offsets{1} = [800*(100.^([-4:2:7]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [20480e-6 20480e-6];

i = 48;
template{i}.template = 'mtspgr_im14_18';
template{i}.nominal_angles = [283 1132];
template{i}.nominal_offsets{1} = [800*(100.^([8:2:15]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [20480e-6 20480e-6];

i = 49;
template{i}.template = 'qmtspgr';
%template{i}.template = 'evil_qmtspgr';
template{i}.nominal_angles = [142 568];
template{i}.nominal_offsets{1} = [800*(100.^([-4:15]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];

i = 50;
template{i}.template = 'qmtspgr2';
%template{i}.template = 'evil_qmtspgr2';
template{i}.nominal_angles = [347 1388];
template{i}.nominal_offsets{1} = [800*(100.^([-4:2:15]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];

i = 51;
template{i}.template = 'qmtspgr_total';
%template{i}.template = 'evil_qmtspgr';
template{i}.nominal_angles = [142 284 426 568 710];
template{i}.nominal_offsets{1} = [800*(100.^([-4:15]/15))];
for k = 2:length(template{i}.nominal_angles)
  template{i}.nominal_offsets{k} = template{i}.nominal_offsets{1};
end
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6 10240e-6 10240e-6 10240e-6];

i = 52;
template{i}.template = 'qmtspgr2_total';
%template{i}.template = 'evil_qmtspgr2';
template{i}.nominal_angles = [347 694 1041 1388 1735];
template{i}.nominal_offsets{1} = [800*(100.^([-4:15]/15))];
for k = 2:length(template{i}.nominal_angles)
  template{i}.nominal_offsets{k} = template{i}.nominal_offsets{1};
end
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6 30720e-6 30720e-6 30720e-6];

i = 53;
template{i}.template = 'qmtspgr_mfa';
template{i}.nominal_angles = [142 426 568];
template{i}.nominal_offsets{1} = [800*(100.^([-4:15]/15))];
for k = 2:length(template{i}.nominal_angles)
  template{i}.nominal_offsets{k} = template{i}.nominal_offsets{1};
end
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6 10240e-6];

i = 54;
template{i}.template = 'qmtspgr2_mfa';
%template{i}.template = 'evil_qmtspgr2';
template{i}.nominal_angles = [347 1041 1388];
template{i}.nominal_offsets{1} = [800*(100.^([-4:2:15]/15))];
for k = 2:length(template{i}.nominal_angles)
  template{i}.nominal_offsets{k} = template{i}.nominal_offsets{1};
end
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6 30720e-6];

i = 55;
template{i}.template = 'qmtspgr_opt';
template{i}.nominal_angles = [ 142 284 426 568 710 710 710 ];
template{i}.nominal_offsets{1} = [ 800 ];
template{i}.nominal_offsets{2} = [ 2009.5 ];
template{i}.nominal_offsets{3} = [ 9327.3 ];
template{i}.nominal_offsets{4} = [ 12679 ];
template{i}.nominal_offsets{5} = [ 1478.3 ];
template{i}.nominal_offsets{6} = [ 2009.5 ];
template{i}.nominal_offsets{7} = [ 12679 ];
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [ 10240e-6 10240e-6 10240e-6 10240e-6 10240e-6  10240e-6  10240e-6 ];

i = 56;
template{i}.template = 'qmtspgr2_opt';
template{i}.nominal_angles = [ 347 347 694 ];
template{i}.nominal_offsets{1} = [ 126.8 ];
template{i}.nominal_offsets{2} = [ 172.4 ];
template{i}.nominal_offsets{3} = [ 2009.5 ];
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann' 'gaussian_hann' };
template{i}.pulse_duration = [ 30720e-6 30720e-6 30720e-6 ];

i = 57;
template{i}.template = 'qmtspgr_uk';
template{i}.nominal_angles = [ 142 568 ];
template{i}.nominal_offsets{1} = [800*(100.^([-2:3:10]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [ 10240e-6 10240e-6 ];

i = 58;
template{i}.template = 'qmtspgr_pm';
template{i}.nominal_angles = [ 205.0 521.0 584.0 710.0 647.0 268.0 142.0 331.0 394.0 458.0 710.0 205.0 205.0 268.0 710.0 205.0 710.0 710.0 268.0 142.0 710.0 647.0 205.0 205.0 647.0 647.0 710.0 584.0 268.0 710.0 ];
template{i}.nominal_offsets = { 1087.5 318.5 12679 2009.5 12679 2009.5 234.3, 2731.6 318.5 9327.3 1478.3 234.3 1478.3 1478.3 1087.5 318.5 12679 2731.6 2731.6 318.5 433.0 2009.5, 2009.5 800.0 2009.5 2731.6 9327.3 318.5 1087.5 800.0};
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' };
template{i}.pulse_duration = 10240e-6 * ones(1, length(template{i}.nominal_angles));

i = 59;
template{i}.template = 'mni_gre_qmt_10u';
template{i}.nominal_angles = [ 142 568 ];
template{i}.nominal_offsets{1} = [800*(100.^([-2:3:10]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [ 10240e-6 10240e-6 ];

i = 60;
template{i}.template = 'qmtspgr_3t';
template{i}.nominal_angles = [142 426];
template{i}.nominal_offsets{1} = [800*(100.^([-4:15]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [10240e-6 10240e-6];

i = 61;
template{i}.template = 'qmtspgr2_3t';
template{i}.nominal_angles = [347 1041];
template{i}.nominal_offsets{1} = [800*(100.^([-4:2:15]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [30720e-6 30720e-6];

i = 62;
template{i}.template = 'qmtspgr_opt_3t';
template{i}.nominal_angles = [ 142.0 213.0 284.0 355.0 426.0 426.0 426.0];
template{i}.nominal_offsets{1} = [ 1087.5 ];
template{i}.nominal_offsets{2} = [ 2009.5 ];
template{i}.nominal_offsets{3} = [ 12679.0 ];
template{i}.nominal_offsets{4} = [ 12679.0 ];
template{i}.nominal_offsets{5} = [ 800.0 ];
template{i}.nominal_offsets{6} = [ 1087.5 ];
template{i}.nominal_offsets{7} = [ 12679.0 ];
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [ 10240e-6 10240e-6 10240e-6 10240e-6 10240e-6  10240e-6  10240e-6 ];

i = 63;
template{i}.template = 'qmtspgr2_opt_3t';
template{i}.nominal_angles = [ 347.0 347.0 521.0 ];
template{i}.nominal_offsets{1} = [ 126.8 ];
template{i}.nominal_offsets{2} = [ 172.4 ];
template{i}.nominal_offsets{3} = [ 1478.3 ];
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann' 'gaussian_hann' };
template{i}.pulse_duration = [ 30720e-6 30720e-6 30720e-6 ];

i = 64;
template{i}.template = 'qmtspgr_uk_3t';
template{i}.nominal_angles = [ 142 426 ];
template{i}.nominal_offsets{1} = [800*(100.^([-2:3:10]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'gaussian_hann' 'gaussian_hann'};
template{i}.pulse_duration = [ 10240e-6 10240e-6 ];

i = 65;
template{i}.template = 'qmtspgr_ge';
template{i}.nominal_angles = [ 580 435 290 145 ];
template{i}.nominal_offsets{1} = [800*(100.^([-4:2:15]/15))];
template{i}.nominal_offsets{2} = template{i}.nominal_offsets{1}; 
template{i}.nominal_offsets{3} = template{i}.nominal_offsets{1}; 
template{i}.nominal_offsets{4} = template{i}.nominal_offsets{1}; 
template{i}.pulse_type = {'fermi' 'fermi' 'fermi' 'fermi'};
template{i}.pulse_duration = [ 8e-6 8e-6 8e-6 8e-6];



for j = 1:i
  names{j} = template{j}.template;
end

I = strmatch(sequence, names, 'exact');
display(I)

if(isempty(I))
  pick = [];
else
  pick = template{I(1)};
end

return
