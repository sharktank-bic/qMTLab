function [fit, cache, lineshape] = mt_img(study, data, prev_fit, model, mapping, lineshape, tempfile, range, options, use_t2_flag)
%
%
%  function fit = mt_img(study,  data, prev_fit, model, mapping, lineshape, tempfile, range, options, use_t2_flag)
%  
%  Estimate MT parameters
%
%  study    :  study description (filenames, sequence parameters etc.)
%  prev_fit :  previously fitted values if available
%  model    :  signal model
%  lineshape:  lineshape function
%  mapping  :  determines search space
%  tempfile :  name of mat file for intermediate results
%  range    :  range of voxels to fit (relative to mask)
%  options  :  minimization options
%  use_t2_flag :  1 -> use estimate of t2f in fit, and ojective function with T2obs involved
%		  0 -> don't use T2obs, and start with estimated T2f = T1/10
%
%
%------------------------------------------------------------------------------


%------------------------------------------------------------------------------
%  Originally coded by JGSled 199?-2000
%
%  Modified by Ives Levesque
%                  July 2006: added commenting, adjustment to path (mt_startup.m)
%
% modified Feb 2011, Ives Levesque
% to allow separate B0 files for different parts of the experiment, if desired
% to correct the excitation flip angle in addition to saturation pulse
%------------------------------------------------------------------------------

%-- set paths

startup


%-- load raw data (within mask)
%data = read_study_data(study);

%-- normalize data
%(isfield(study, 'baseline'))
%  disp('Normalizing MT data');
%  data = normalize_mt_data(study, data);
%end

%-- use T2obs value in MT fitting?
if(nargin < 10|use_t2_flag ==0) 
  use_t2_flag = 0;
else
  if(~isfield(data, 'T2obs') | ~isfield(data, 'T2evr') | ...
        ~isfield(data, 'T2res'))
    error('data must define T2obs, T2evr, and T2res for incorporation of T2obs in fit');
  end
end

%-- get B0 offset to be used
if(~isfield(study, 'b0_shift'))
  study.b0_shift = zeros(1,length(study.nominal_offsets));
end

%-- check if there B0 field map is specified, otherwise set to zero
if (~isfield(data, 'b0'))
  data.b0 = zeros(size(data.R1obs));
end


%-- b1 map scaling factor
if(~isfield(study, 'b1_scale'))
  study.b1_scale = ones(1,length(study.nominal_offsets));
end


%disp('Create new fit.')

%-- map previous fit in to new mask region
fit = create_new_fit(prev_fit, data.mask);

%-- declare variables for model, parameter-map, lineshape
fit.model = model;
fit.mapping = mapping;
if(isa(lineshape, 'superlrtz_line'))
  fit.lineshape = 'superlrtz_line';
else
  fit.lineshape = lineshape;
end

%-- declare mask
fit.mask = data.mask;

%-- determine setting for dipole flag: use dipole term or not
if(strcmp(model, 'mtspgr_dp') | strcmp(model, 'mtspgr_rp3'))
  dipole_flag = 1;
else
  dipole_flag = 0;
end


%disp('Create initial try.')

%-- create default initial guess
p0 = create_try(study, model);

%-- load caches for free pool attenuation ("direct effect")
% this requires that the code in @sf_cache be accessible, see mt_startup.m
%
getfield(study, 'pulse_type')
for j = 1:length(study.nominal_angles)
  if(isfield(study, 'pulse_duration') & ...
        abs(study.pulse_duration(j)- 30720e-6) < 0.001)
    gh{j} = sf_cache('gh6_30720.mat');
  elseif(isfield(study, 'pulse_duration') & ...
        abs(study.pulse_duration(j)-20480e-6) < 0.001)
    gh{j} = sf_cache('gh_20480.mat');
  elseif(isfield(study, 'pulse_duration') & ...
	   abs(study.pulse_duration(j)-8e-6) < 0.001 & ...
	   strmatch(study.pulse_type{1},'fermi'))
	gh{j} = sf_cache('fermi_8.mat');
  else
    gh{j} = sf_cache('gh6.mat');
  end
end

%-- make sure that range is within bounds
M = length(fit.f);

if(nargin < 8 | isempty(range))
  range = [1 M];
else
  range(1) = max(range(1),1);
  range(2) = min(range(2),M);
end

%-- get values of T1 and S^2 for R1obs and R1r (from 95% confidence interval)
T1obs = 1./data.R1obs;
% sum-of-squared residuals (variance) in R1obs fit
R1obs_s2 = (data.dR1obs./norminv(1-0.025)).^2;
% sum-of-squared residuals (variance) in R1r - impose confidence interval of 1.0 s
R1r_s2 = (ones(M,1)./norminv(1-0.025)).^2; 


%disp('Create lineshape cache.')
%pause

%-- create lineshape cache if necessary
lineshape = cache_lineshape(study, lineshape);

%------------------------------------------------------------------------------

%-- loop over every voxel

disp('Begin fitting of MT data')
count = 0;
for i = range(1):range(2)
  if(isfinite(data.dR1obs(i)) & fit.computed(i) ~= 1)
    i
    count = count + 1;
    
    %progress report
    progress = count/(range(2)-range(1)+1)*100;
    disp(['Progress: ' num2str(progress) '%']);
    
    p = p0; 
    %-- consider using previous value as initial estimate
    if(fit.computed(i) == -1)
      p = pick_good_guesses(p, fit, i);                
    elseif(fit.computed(i) == -2)     % use adjacent values as initial estimate
      p = average_adjacent_fit(p, data.mask, fit, i);
    else  % use measured T2 as a guess
      if(use_t2_flag)
        p.T2(1) = data.T2obs(i);
      else  % use T1/10 as an estimate
        p.T2(1) = T1obs(i)/10;
      end
    end
    
    %-- create pulses
    %disp('Create pulses for fitting.')
    p.mt_angles = study.nominal_angles*data.b1(i)*study.b1_scale(1); % degrees

    for j = 1:length(p.mt_angles)
      if(strcmp(study.pulse_type,'gaussian_hann'))
        p.pulses{j} = gaussian_hann(p.mt_angles(j), ... 
            p.mt_duration(j), 0, p.TR(j), p.mt_bw(j)); 
      elseif(strcmp(study.pulse_type,'gaussian'))
        p.pulses{j} = gaussian(p.mt_angles(j), ...
            p.mt_duration(j), 0, p.TR(j)); 
      elseif(strcmp(study.pulse_type,'fermi'))
        p.pulses{j} = fermi(p.mt_angles(j), ...
            p.mt_duration(j), 0, p.TR(j), '', p.s(j)); 
      else
        error('Unknown pulse type.');
      end
    end
    
    %-- do some stuff ???
    p.T1obs = T1obs(i);
    if(use_t2_flag)
      p.T2obs = data.T2obs(i);	% only if T2 is being used!
      p.T2_variance_scale = data.T2evr(i)/data.T2res(i)^2;
      p.MT_variance = data.MT_variance(i);
      method = 4;  % combined MT and T2obs objective fcn
    else
      method = 3;  % regular (y-fcn(x))^2 objective fcn
    end
    p.R1obs_s2 = R1obs_s2(i); 
    p.R1r_s2 = R1r_s2(i);

    p.tau = p.mt_duration*0.235;
    p = set_T1(p, p.T1(1), 1);
    
    % correct the excitation flip angle
    p.angle = p.angle*data.b1(i)*study.b1_scale(1);
    
    %-- extract data for given voxel and correct for B0
    N = length(data.measurements);
    voxel_data = struct('samples', {cell(N,1)});
    for j = 1:N
        %study.nominal_offsets{j} + data.b0(i) + study.b0_shift(j)
        %data.measurements{j}(i,:)
        %data.b0(i,:)
        voxel_data.samples{j,1} = [study.nominal_offsets{j} + data.b0(i,min(size(data.b0,2),j)) ...
              + study.b0_shift(j); data.measurements{j}(i,:)];
    end

    %-- create reduced cache
    time = cputime;
    for j = 1:length(p.mt_angles)
      T2 = getfield(struct(gh{j}), 'T2');
      cache{j} = resample_cache(gh{j}, p.mt_angles(j), ...
          study.nominal_offsets{j} + data.b0(i,min(size(data.b0,2))) + study.b0_shift(j), T2);
    end
    
    %-- fittin options ??
%     if(nargin < 9 | isempty(options))
%       options = [0 3e-3 1e-6*N*length(study.nominal_offsets)];
%     end

    %disp('Run fitting.')
    %-- set fitting options for 'fminsearch': display:0 tolX:3e-3 and tolFUN:1e-6*N*N_offsets
    %my_options = [0 3e-3 1e-6*N*length(study.nominal_offsets)];
    my_options = optimset('Display', 'on', 'TolX', 3e-3, 'TolFun', 1e-6*N*length(study.nominal_offsets));
    pa = fit_mtspgr_cw_study(voxel_data, p, cache, method, mapping, ...
        lineshape, 'obj_mtspgr_cw_study', my_options);
    [stderr, R1, X, t] = inf_region_r1(voxel_data, pa, cache, lineshape, ...
        'obj_mtspgr_cw_study');
    disp(sprintf('Voxel %6d    CPU time: %12f', i, cputime-time));

    %-- set output
    fit.f(i) = pa.f;
    fit.df(i) = t.f;
    fit.kf(i) = pa.kf;
    fit.dkf(i) = t.kf;
    fit.R1(i,:) = 1./pa.T1(1:2);
    fit.dR1(i) = t.R1(1);
    fit.T2(i,:) = pa.T2;
    fit.dT2(i,:) = t.T2;
    if(dipole_flag)
      fit.T1d(i) = pa.T1(3);
      fit.dT1d(i) = t.T1d;
    end
    fit.e2(i) = pa.e2;

    fit.computed(i) = 1;

    %-- save temp file (progress??)
    if(mod(count,20) == 0)
      save(tempfile, 'study', 'fit');
    end

    %-- display results
    disp(sprintf('kf =  %14f, f =   %14f,\n T1f = %14f, T1r = %14f,\n T2f = %14f T2r = %14e',pa.kf, pa.f, pa.T1(1), pa.T1(2), pa.T2(1), pa.T2(2)));
    disp(sprintf('beta = %10f', pa.beta));
    if(dipole_flag)
       disp(sprintf('T1d = %14f', pa.T1(3)));
    end
    disp(sprintf('mt_angles: '));
    disp(sprintf('%15f ', pa.mt_angles));
    disp(sprintf('\n'));
    disp(sprintf('RMS error: %15f', sqrt(pa.e2)));

  end
end

%-- after fitting is done
disp('Fitting of MT data completed')
save(tempfile, 'study', 'fit');
cache = gh;
return


%------------------------------------------------------------------------------
%------------------------------------------------------------------------------
%------------------------------------------------------------------------------
%
%   Built-in FUNCTIONS
%
%------------------------------------------------------------------------------
%------------------------------------------------------------------------------
%------------------------------------------------------------------------------


%------------------------------------------------------------------------------
function p = pick_good_guesses(p, fit, index)

if(fit.df(index) < 0.02)
  p.f = fit.f(index);
end
if(fit.dkf(index) < 1)
  p.kf = fit.kf(index);
end
if(fit.dR1(index,1) < 0.1)
  p.T1(1) = 1/fit.R1(index);
end
if(fit.dT2(index,1) < 0.005)
  p.T2(1) = fit.T2(index,1);
end
if(fit.dT2(index,2) < 1e-5)
  p.T2(2) = fit.T2(index,2);
end

return



%------------------------------------------------------------------------------
function p = average_adjacent_fit(p, mask, fit, index)

N = sqrt(length(mask));
M = N;

indices = [];
invmap = find(mask);
map = zeros(size(mask));
map(mask) = 1:length(invmap);
c = invmap(index);
i = floor(c/N)+1;
j = c - N*(i-1);

for k = -1:1
  for l = -1:1
    v = (i+k-1)*N+j+l;
    if(i+k >= 1 & i+k <= N & j+l >= 1 & j+l <= M & i*j ~= 0 & mask(v) & fit.computed(map(v)) == 1)
      indices = [indices map(v)];
    end
  end
end

if(length(indices) > 0)
  p.f = mean(fit.f(indices));
  p.kf = mean(fit.kf(indices));
  p.T1(1) = 1/mean(fit.R1(indices,1));
  p.T2(1) = mean(fit.T2(indices,1));
  p.T2(2) = mean(fit.T2(indices,2));
end
return



%------------------------------------------------------------------------------
function p0 = create_try(study, model)
%
%  function p0 = create_try(study, model)
%  
%  Create initial guess at parameters

p0.kf = 5;
p0.f = 0.1;
p0.T1 = [2 1 1e-3];
%p0.T1 = [2 0.83 1e-3];
%warning('T1r set to 0.83s!')
p0.T2 = [50e-3 13e-6];
p0.beta = ones(1,length(study.nominal_offsets));;
p0.offsets = study.nominal_offsets;

% given in pulse sequence
if(isfield(study, 'flip'))
  p0.angle = study.flip;
else
  p0.angle = 10*ones(1,length(study.nominal_angles));        % degrees
end
if(isfield(study, 'TR'))
  p0.TR = study.TR;
else
  p0.TR = 50e-3*ones(1,length(study.nominal_angles));        % ms
end
p0.model = model;

if(isfield(study, 'pulse_duration'))
  p0.mt_duration = study.pulse_duration;
else
  p0.mt_duration = 10240e-6*ones(1,length(study.nominal_angles));    % s  
end

if(strcmp(study.pulse_type,'gaussian_hann'))
  p0.mt_bw = 200*10240e-6./p0.mt_duration;                        % Hz
end

if(strcmp(study.pulse_type,'fermi'))
	p0.s = 15*ones(1,length(study.nominal_angles));				% just a guess, dimensionless
end

return



%------------------------------------------------------------------------------
function fit = create_new_fit(previous_fit, mask)
%
%  function create_new_fit(previous_fit, mask)
%
%

M = sum(sum(mask));

names =  {'f' 'df' 'kf' 'dkf' 'R1' 'dR1' 'T2'...
    'dT2' 'T1d' 'dT1d' 'e2' 'computed'};
number = [ 1   1   1    1     2    2     2    2     1     1      1   1 ];

fit = struct('f', 0);

for i = 1:length(number)
  if(isfield(previous_fit, names{i}))
    img = zeros(length(previous_fit.mask),number(i));
    img(logical(previous_fit.mask),:) = getfield(previous_fit, names{i}); 
    fit = setfield(fit, names{i}, img(logical(mask), :));
  else
    fit = setfield(fit, names{i}, zeros(M, number(i)));
  end
end

return

