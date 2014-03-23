function [offsets, Mxy, Mxy_sim, p] = show_fit(study, fits, data, cache, lineshape, index, offsets_, sim_flag, eps)
%
%  [offsets, Mxy] = show_fit(study, fits, data, cache, lineshape, index, [offsets, sim_flag, eps])
% 

if(nargin < 9 | isempty(eps))
  eps = 0.0005;                         % accuracy for simulations
end

if(~isfield(study, 'b0_shift'))
  study.b0_shift = zeros(1,length(study.nominal_offsets));;
end

% scale b1
if(~isfield(study, 'b1_scale'))
  study.b1_scale = ones(1,length(study.nominal_offsets));
end

l = length(fits.model);
dual_flag = strcmp(fits.model((l-4):l), '_dual');

if(dual_flag == 0)
  p = create_try(fits, study, index);
else
  p = create_try_dual(fits, study, index);
end

for i = 1:length(cache)
  if(isa(cache{i},'char'))
    cache{i} = sf_cache(cache{i});
  end
end

if(nargin < 8)
  sim_flag = 0;
end
Mxy_sim = [];

% create pulses
if(~isempty(data))
  p.mt_angles = study.nominal_angles*data.b1(index)*study.b1_scale(1); % degrees
else
  p.mt_angles = study.nominal_angles; % degrees
end

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

p.tau = p.mt_duration*0.235;
if(dual_flag == 0)
  p = set_T1(p, p.T1(1), 1);
else
  p = set_T1(p, [], 1, 1);
end

if(~isempty(data))
  N = length(data.measurements);
  voxel_data = struct('samples', {cell(N,1)});

  for j = 1:N
    %  P = size(data.measurements{j},2);
    %  norm = mean(data.measurements{j}(index,((P-1):P)));
    voxel_data.samples{j,1} = [study.nominal_offsets{j} + data.b0(index,min(size(data.b0,2),j)) + study.b0_shift(j); ...
        data.measurements{j}(index,:)];
  end
end

if(nargin < 7 | isempty(offsets_))
  if(~isempty(data))
    offsets = p.offsets{1} + data.b0(index,min(size(data.b0,2),j)) + study.b0_shift(1); 
  else
    offsets = p.offsets{1};
  end
else
  if(~isempty(data))
    offsets = offsets_ + data.b0(index,min(size(data.b0,2),j)) + study.b0_shift(1);
  else
    offsets = offsets_;
  end
end


N = length(p.mt_angles);
M = length(offsets);
Mxy = zeros(M,N);


if(dual_flag == 0)
  for i = 1:N
    rates = cw_rfrate(p.pulses{i}, p.T2(2), offsets, lineshape);
    for j = 1:M
      Sf{i}.values(j) = get_value_i(cache{i}, p.mt_angles(i),...
          offsets(j), p.T2(1));
      if(strncmp(p.model, 'mtspgr_dp', 9))
        [Mz_, Mxy(j,i)] = feval(p.model, p.angle(i), p.kf, p.f, p.TR(i), p.T1,...
            [Sf{i}.values(j) 1], rates(j), p.T2(2), ...
            offsets(j)*2*pi);
      elseif(strncmp(p.model, 'mtspgr_rp', 9))
        [Mz_, Mxy(j,i)] = feval(p.model, p.angle(i), p.kf, p.f, p.TR(i), ...
            p.T1, [Sf{i}.values(j) 1], rates(j), p.T2(2), ...
            offsets(j)*2*pi, p.tau(i));
      elseif(strncmp(p.model, 'mtspgr_frp', 10))
        [P, avgP] = lookup_power (p.pulses{i});
        [Mz_, Mxy(j,i)] = feval(p.model, p.angle(i), p.kf, p.f, p.TR(i), p.T1,...
            [1 1], rates(j), p.T2, ...
            offsets(j)*2*pi, p.tau(i), avgP);
      else
        [Mz_, Mxy(j,i)] = feval(p.model, p.angle(i), p.kf, p.f, p.TR(i), p.T1, ...
            [Sf{i}.values(j) 1], rates(j));
      end
      Mz(j,i) = Mz_(1,1);
      
      if(sim_flag)
        BW = 1.2e-3*10e-3*42.57e6*5120/1024;
        excite = gaussian_hann(p.angle(i), 1024e-6, 0, p.TR(i), BW);
        pulse = set_offset(p.pulses{i}, offsets(j));
        if(strcmp(p.model, 'mtspgr_dp') | strcmp(p.model, 'mtspgr_rp3') | ...
              strcmp(p.model, 'mtspgr_frp3'))
          disp('warning: flexible lineshape not implemented for 3 pool simulation');
          sim = 'dipolar_3pool';
          M0 = [0 0 1 p.f 0]*Mz(j,i);
        else
          sim = thermal_2pool_flex(lineshape);
          M0 = [0 0 1 p.f]*Mz(j,i);
        end
        [t, m] = sim_mtspgr(M0, pulse, excite, p.T1, p.T2, p.f, p.kf, ...
            p.TR(i), sim, 100, eps);
        Mxy_sim(j,i) = norm(m(length(t),1:2));
        Mz_sim(j,i) = m(length(t),3);
      end
    end
  end
else
  for i = 1:N
    rates(1,:) = cw_rfrate(p.pulses{i}, p.T2(2), offsets, lineshape);
    rates(2,:) = cw_rfrate(p.pulses{i}, p.T2(4), offsets, lineshape);
    for j = 1:M
      Sf(1) = get_value_i(cache{i}, p.mt_angles(i), offsets(j), p.T2(1));
      Sf(2) = get_value_i(cache{i}, p.mt_angles(i), offsets(j), p.T2(3));
%      f = p.P(2)/(1-p.P(2));
%      [Mz_, Mxy(j,i)] = mtspgr_rp2_opt(p.angle(i), p.K(2), f, ...
%          p.TR(i), 1./p.R1(1:2), [Sf{i}.values(j) 1], rates_a(j), p.T2(2), ...
%            offsets(j)*2*pi, p.tau(i));
      [Mz_, Mxy(j,i)]  = mtspgr_rp2_dual(p.angle(i), p.TR(i), p.R1, p.T2,...
          [], p.P, p.K, Sf, rates(:,j), [], p.tau(i), p.mix);
      Mz(j,i) = Mz_(1,1)+Mz_(3,1);
      
      if(sim_flag)
        BW = 1.2e-3*10e-3*42.57e6*5120/1024;
        excite = gaussian_hann(p.angle(i), 1024e-6, 0, p.TR(i), BW);
        pulse = set_offset(p.pulses{i}, offsets(j));
        sim = thermal_4pool_flex(lineshape);
%        M0 = [0 0 p.P(1)*(1-p.P(2)) p.P(1)*p.P(2) 0 0 p.P(2)*(1-p.P(3)) p.P(2)*p.P(3)]'* ...
%            Mz(j,i);
        M0 = [0 0 Mz_(1) Mz_(2) 0 0 Mz_(3) Mz_(4)];
        [t, m] = sim_mtspgr_dual(M0, pulse, excite, p.R1, p.T2, p.T1d, ...
            p.P, p.K, p.TR(i), sim, 100, eps);
        Mxy_sim(j,i,1) = norm(m(length(t),1:2));
        Mxy_sim(j,i,2) = norm(m(length(t),5:6));
        Mz_sim(j,i,1) = m(length(t),3);
        Mz_sim(j,i,2) = m(length(t),7);
      end
    end
  end
end


% plot curves with data
colors = ['kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk'];
if(~isempty(data))
  Z = p.beta(1)*abs(Mxy(:,1));
  semilogx(voxel_data.samples{1}(1,:), voxel_data.samples{1}(2,:), [colors(1) '.'], voxel_data.samples{1}(1,:), voxel_data.samples{1}(2,:), [colors(1) '--'], offsets', Z, 'b-' )
  hold on
  for j = 2:length(p.offsets)
    Z = p.beta(j)*abs(Mxy(:,j));
    semilogx(voxel_data.samples{j}(1,:), voxel_data.samples{j}(2,:), [colors(j) '.'], voxel_data.samples{j}(1,:), voxel_data.samples{j}(2,:), [colors(j) '--'], offsets', Z, 'b-')
  end
  if(nargin < 7 | isempty(offsets_))
    n = 0;
    e2 = 0;
    for j = 1:length(p.offsets)
      Z = p.beta(j)*abs(Mxy(:,j));
      n = n+length(Z);
      if(length(Z) == length(voxel_data.samples{j}(2,:)))
        e2 = e2 + sum((Z' - voxel_data.samples{j}(2,:)).^2);
      else
        disp('Warning: error in fit cannot be calculated')
      end
    end
    p.e2 = e2/n;
  end
else
  Z = abs(Mxy)*diag(p.beta);
  semilogx(offsets', Z, 'r-' )
end
if(sim_flag)
  hold on
  if(dual_flag == 0)
    semilogx( offsets', Mxy_sim*diag(1./Mxy_sim(size(Mxy_sim,1),:)), 'r-.' )
  else
    mixed = Mxy_sim(:,:,1)*fits.mix(1) + Mxy_sim(:,:,2)*fits.mix(2);
    mixed = mixed*diag(1./(mixed(size(mixed,1),:)));
    semilogx( offsets', mixed, 'k-');
%    semilogx( offsets', Mxy_sim(:,:,1)*diag(1./Mxy_sim(size(Mxy_sim,1),:,1)), 'b-' )
%    semilogx( offsets', Mxy_sim(:,:,2)*diag(1./Mxy_sim(size(Mxy_sim,1),:,2)), 'k-' )
  end
end
hold off
axis([min(500,min(offsets)) max(1e5,max(offsets)) 0 1.1])
xlabel('frequency offset (Hz)')
ylabel('MTw signal')



function p0 = create_try(fits, study, index)
%
%  function p0 = create_try(fits, study, index)
%  
%  Create initial guess at parameters

p0.kf = fits.kf(index);
p0.f = fits.f(index);
p0.T1 = 1./fits.R1(index,:);
if(isfield(fits, 'T1d'))
  p0.T1(3) = fits.T1d(index);
end
p0.T2 = fits.T2(index,:);

p0 = create_try_common(p0, fits, study, index);

return

function p0 = create_try_dual(fits, study, index)
%
%  function p0 = create_try(fits, study, index)
%  
%  Create initial guess at parameters

p0.K = fits.K(index,:);
p0.P = fits.P(index,:);
p0.R1 = fits.R1(index,:);
if(isfield(fits, 'T1d') & ~isempty(fits.T1d))
  p0.T1d = fits.T1d(index);
else
  p0.T1d = [];
end
p0.T2 = fits.T2(index,:);
p0.mix = fits.mix;

p0 = create_try_common(p0, fits, study, index);

return

function p0 = create_try_common(p0, fits, study, index)
%
%  function p0 = create_try_common(p0, fits, study, index)
%  
%  Create initial guess at parameters

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
p0.model = fits.model;

if(isfield(study, 'pulse_duration'))
  p0.mt_duration = study.pulse_duration;
else
  p0.mt_duration = 10240e-6*ones(1,length(study.nominal_angles));    % s  
end

if(strcmp(study.pulse_type,'gaussian_hann'))
  p0.mt_bw = 200*10240e-6./p0.mt_duration;                        % Hz
end

if(strcmp(study.pulse_type,'fermi'))
  p0.s = 15*ones(1,length(study.nominal_angles));                        % Hz
end

return
