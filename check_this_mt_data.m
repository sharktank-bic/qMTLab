function check_this_mt_data_opt(subject_id)
%-----------------------------------------------------------------------------
%
% USAGE: check_mt_data(subject_id)
%
% matlab script to check MT data for a THIS PHANTOM
% loads and plots MT data
% Ives Levesque    Aug. 2004
%

%
%
%----------------------------------------------------------------------------



%addpath(work_dir);

%-- Load some stuff
if exist('do_subject.m','file') == 0
   disp('do_subject.m file not found.')
   return
end

comp = do_subject

%-- Insert missing excitation pulse flip angles: 7 degs for short TR seq, and 10 degs for long TR seq
% comp{1}.flip = [  7.0000,  7.0000,  7.0000,  7.0000,  7.0000,  7.0000,  7.0000 ]

display('checkpoint 3');
pause;
%-- Combine information from short and long TR studies
study = combine_studies(comp);

study

study.nominal_offsets{1}
study.nominal_offsets{2}

display('checkpoint 4');
pause;

%-- Read in MT data and  normalize
data = read_study_data(study);
data = normalize_mt_data(study, data);

%-- Read in labels to be used for ROI inspection of data
uiwait(helpdlg('Select ROI label file'));
[filename filepath] = uigetfile('*.*');
h = openimage(fullfile(filepath,filename));
tmp = miinquire(fullfile(filepath,filename),'imagesize');
n_slices = tmp(2);
lbl = getimages(h,1:n_slices);
closeimage(h);
%size(lbl)
%size(data.mask)
lbl = lbl(data.mask);

%-- Average data over ROI
rdata = average_mt_data(study, data, lbl);

%-- Load label IDs
label_id;

%which label_id
%labelpdf

size(rdata.measurements{1})
size(rdata.measurements{2})
%size(rdata.measurements{3})
%size(rdata.measurements{4})

%     1:length(label)

%-- Plot data for short TR experiment, then long TR experiment
%figure
%semilogx(study.nominal_offsets{8}, rdata.measurements{8}(1:length(label),:)', 'x--b', study.nominal_offsets{9}, rdata.measurements{9}(1:length(label),:)','x--b', study.nominal_offsets{10}, rdata.measurements{10}(1:length(label),:)','x--b')
%xlabel('frequency offset (Hz)');
%ylabel('normalized MTw signal');
%title('in vivo data, TR = 60 ms, T_{MT} = 30.72 ms')
%print('-dpdf', sprintf([study.dir '/' subject_id '_opt_longTR_data_init.pdf']));

figure
% semilogx(study.nominal_offsets{1}, rdata.measurements{1}(1:length(label),:)', 'x--b',study.nominal_offsets{2}, rdata.measurements{2}(1:length(label),:)', 'x--b',study.nominal_offsets{3}, rdata.measurements{3}(1:length(label),:)', 'x--b', study.nominal_offsets{4}, rdata.measurements{4}(1:length(label),:)', 'x--b', study.nominal_offsets{5}, rdata.measurements{5}(1:length(label),:)', 'x--b', study.nominal_offsets{6}, rdata.measurements{6}(1:length(label),:)', 'x--b', study.nominal_offsets{7}, rdata.measurements{7}(1:length(label),:)', 'x--b')
%semilogx(study.nominal_offsets{1}, rdata.measurements{1}(1:length(label),:)', 'x--b',study.nominal_offsets{2}, rdata.measurements{2}(1:length(label),:)', 'x--b')
semilogx(study.nominal_offsets{1}, rdata.measurements{1}(1:length(label),:)', 'x--b')
xlabel('frequency offset (Hz)');
ylabel('normalized MTw  signal');
title('in vivo data, TR = 25 ms, T_{MT} = 10.24 ms')
print('-dpdf', sprintf([study.dir '/' subject_id '_opt_shortTR_data_init.pdf']));



%-- Plot data by ROI
figure
for i = 1:length(label)
    %subplot(2,3,i)
    %semilogx( study.nominal_offsets{1}, rdata.measurements{1}(i,:)', '.--b', study.nominal_offsets{2}, rdata.measurements{2}(i,:)', '.--b', study.nominal_offsets{3}, rdata.measurements{3}(i,:)', '.--b', study.nominal_offsets{4}, rdata.measurements{4}(i,:)', '.--b', study.nominal_offsets{5}, rdata.measurements{5}(i,:)', '.--b', study.nominal_offsets{6}, rdata.measurements{6}(i,:)', '.--b', study.nominal_offsets{7}, rdata.measurements{7}(i,:)', '.--b')
    semilogx( study.nominal_offsets{1}, rdata.measurements{1}(i,:)', '.--b', study.nominal_offsets{2}, rdata.measurements{2}(i,:)', '.--b');
    xlabel('frequency offset (Hz)');
    ylabel('MTw signal');
    title(label(i));
end
print('-dpdf', sprintf([study.dir '/' subject_id '_opt_roi_data.pdf']));

%-- Change sign of B0 data
rdata.b0 = -rdata.b0;
data.b0 = -data.b0;
study.b0_shift = -study.b0_shift;


[fit, cache, lineshape] = mt_img(study,rdata,[],'mtspgr_rp2','mapping_4d','superlrtz_line',[study.dir 'roi_fit.mat']);
print_fit(fit)
print_dfit(fit)
print_data(rdata)

%pause

figure
for i = 1:length(label)
    %subplot(2,3,i)
    show_fit(study,fit,rdata,cache,lineshape,i,logspace(2,5))
    %xlabel('frequency offset (Hz)');
    %ylabel('MTw signal');
    title(label(i));
end
print('-dpdf', sprintf([study.dir '/' subject_id '_roi_fits.pdf']));


%'Hit any key to continue!'
%pause


save([study.dir '/' subject_id '_2x2_ini.mat'],'study','data')


return


%-- Normalize data manually based on data points farthest from resonance
% the factor of 0.975 is determined manually by looking at the ROI data plots
comp{1}.normalization_scale = [1 1 1 1 1 1 1]/.975 ;
comp{2}.normalization_scale = [1 1 1]/.975 ;



%-- Recombine information from short and long TR studies
study = combine_studies({comp{1:2}});


%-- Re-read and renormalize data
data = read_study_data(study);
data = normalize_mt_data(study, data);

%-- Re-average data over ROI
rdata = average_mt_data(study, data, lbl)

figure
semilogx(study.nominal_offsets{8}, rdata.measurements{8}(1:length(label),:)', 'x--b', study.nominal_offsets{9}, rdata.measurements{9}(1:length(label),:)','x--b', study.nominal_offsets{10}, rdata.measurements{10}(1:length(label),:)','x--b')
xlabel('frequency offset (Hz)');
ylabel('normalized MTw signal');
title('in vivo data, TR = 60 ms, T_{MT} = 30.72 ms')
print('-dpdf', sprintf([study.dir '/' subject_id '_longTR_data_norm.pdf']));

figure
semilogx(study.nominal_offsets{1}, rdata.measurements{1}(1:length(label),:)', 'x--b',study.nominal_offsets{2}, rdata.measurements{2}(1:length(label),:)', 'x--b',study.nominal_offsets{3}, rdata.measurements{3}(1:length(label),:)', 'x--b', study.nominal_offsets{4}, rdata.measurements{4}(1:length(label),:)', 'x--b', study.nominal_offsets{5}, rdata.measurements{5}(1:length(label),:)', 'x--b', study.nominal_offsets{6}, rdata.measurements{6}(1:length(label),:)', 'x--b', study.nominal_offsets{7}, rdata.measurements{7}(1:length(label),:)', 'x--b')
xlabel('frequency offset (Hz)');
ylabel('normalized MTw  signal');
title('in vivo data, TR = 25 ms, T_{MT} = 10.24 ms')
print('-dpdf', sprintf([study.dir '/' subject_id '_shortTR_data_norm.pdf']));


%-- Plot data by ROI
figure
for i = 1:length(label)
    %subplot(2,3,i)
    semilogx( study.nominal_offsets{1}, rdata.measurements{1}(i,:)', '.--b', study.nominal_offsets{2}, rdata.measurements{2}(i,:)', '.--b', study.nominal_offsets{3}, rdata.measurements{3}(i,:)', '.--b', study.nominal_offsets{4}, rdata.measurements{4}(i,:)', '.--b', study.nominal_offsets{5}, rdata.measurements{5}(i,:)', '.--b', study.nominal_offsets{6}, rdata.measurements{6}(i,:)', '.--b', study.nominal_offsets{7}, rdata.measurements{7}(i,:)', '.--b', study.nominal_offsets{8}, rdata.measurements{8}(i,:)', '.--b', study.nominal_offsets{9}, rdata.measurements{9}(i,:)', '.--b', study.nominal_offsets{10}, rdata.measurements{10}(i,:)', '.--b' )
    xlabel('frequency offset (Hz)');
    ylabel('MTw signal');
    title(label(i));
end
print('-dpdf', sprintf([study.dir '/' subject_id '_roi_data_norm.pdf']));

%-- Change sign of B0 data
rdata.b0 = -rdata.b0;
data.b0 = -data.b0;
study.b0_shift = -study.b0_shift;


[fit, cache, lineshape] = mt_img(study,rdata,[],'mtspgr_rp2','mapping_4d','superlrtz_line','norm_roi_fit.mat');
print_fit(fit)
print_dfit(fit)
print_data(rdata)

%pause

for i = 1:length(label)
    %subplot(2,3,i)
    show_fit(study,fit,rdata,cache,lineshape,i,logspace(2,5))
    %xlabel('frequency offset (Hz)');
    %ylabel('MTw signal');
    title(label(i));
end
print('-dpdf', sprintf([study.dir '/' subject_id '_roi_fits_norm.pdf']));


save([study.dir '/' subject_id '_norm_2x2_ini.mat'],'study','data')


