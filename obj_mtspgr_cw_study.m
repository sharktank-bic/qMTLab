function [Z, G] = obj_mtspgr_cw_study(X, study, p, cache, method, mapping, lineshape)
%
%  function [Z, G] = obj_mtspgr_cw_study(X, study, p, cache,...
%                      method, mapping, lineshape)
%
%  X            :  unknowns :  kf, f, T1f, T1r, T2r, beta
%  study        :  study data
%  p            :  fit structure
%  cache        :  cell array of caches of Sf values
%  method       :  1 =>  sum (y - f(x))^2 ;  2 =>  (y - f(x)) ; 3 => f(x) 
%               :  4 =>  sum (y - f(x))^2/s^2 + a (t2f-T2obs) /s_t2^2
% lineshape     :  lineshape function / object

N = length(p.mt_angles);
P = size(study.samples,2);

%X = exp(X);
%X = X.*p.scales;

p = feval(mapping, 2, p, X);  % reverse mapping

W = zeros(N,1);
for i = 1:N
  for j = 1:P
    Q = size(study.samples{i,j},2);
    Mxy{i,j} = zeros(1,Q);
    rates = cw_rfrate(p.pulses{i}, p.T2(2),study.samples{i,j}(1,:), lineshape);
    for k = 1:Q
      offset = study.samples{i,j}(1,k);
%      q = solid_rfrate(p.pulses{i}, T2r, offset);
      Sf = get_value_iT2(cache{i}, 1, k, p.T2(1));
      if(strncmp(p.model, 'mtspgr_dp', 9))
        [Mz, Mxy{i,j}(k)] = feval(p.model, p.angle(i), p.kf, p.f, p.TR(i), p.T1, ...
            [Sf 1], rates(k), p.T2(2), offset*2*pi);
      elseif(strncmp(p.model, 'mtspgr_rp', 9))
        [Mz, Mxy{i,j}(k)] = feval(p.model, p.angle(i), p.kf, p.f, p.TR(i), p.T1, ...
            [Sf 1], rates(k), p.T2(2), offset*2*pi, p.tau(i));
      elseif(strncmp(p.model, 'mtspgr_frp', 10))
        [ignore, avgP] = lookup_power (p.pulses{i});
        [Mz, Mxy{i,j}(k)] = feval(p.model, p.angle(i), p.kf, p.f, p.TR(i), p.T1, ...
            [Sf 1], rates(k), p.T2, offset*2*pi, p.tau(i), avgP);
      else
        [Mz, Mxy{i,j}(k)] = feval(p.model, p.angle(i), p.kf, p.f, p.TR(i), p.T1, ...
            [Sf 1], rates(k));
      end
    end
  end
end
%disp(sprintf('kf =  %14f, f =   %14f,\n T1f = %14f, T1r = %14f,\n T2f = %14f T2r = %14e  beta = %14f',p.kf, p.f, p.T1(1), p.T1(2), p.T2(1), p.T2(2), p.beta))
%if(length(p.T1) == 3)
%  disp(sprintf('T1d = %14f', p.T1(3)));
%end
%disp(sprintf('mt_angles: %15f %15f %15f', p.mt_angles));
if(method == 1)
  % compute sum of squares error  
  Z = 0;
  n = 0;
  for i = 1:N
    for j = 1:P
%      n = n + length(Mxy{i,j});
      Z = Z + sum((Mxy{i,j}*p.beta(i)-study.samples{i,j}(2,:)).^2);
    end
  end
  
  G = -X;
%  disp(sprintf('%14f', sqrt(Z/n)));
elseif(method == 2)
  % compute error vector
  Z = [];
  for i = 1:N
    for j = 1:P
      Z = [Z (Mxy{i,j}*p.beta(i)-study.samples{i,j}(2,:))];
    end
  end
elseif(method == 3)
  % compute function vector
  Z = [];
  G = [];
  for i = 1:N
    for j = 1:P
      Z = [Z (Mxy{i,j}*p.beta(i))];
      G = [G study.samples{i,j}(2,:)];
    end
  end
elseif(method == 4)
  % compute weighted error fcn for MT and T2obs data  
  Zmt = 0;
  n = 0;
  for i = 1:N
    for j = 1:P
%      n = n + length(Mxy{i,j});
      Zmt = Zmt + sum((Mxy{i,j}*p.beta(i)-study.samples{i,j}(2,:)).^2);
    end
  end
  Z = Zmt/p.MT_variance + p.T2_variance_scale*(p.T2(1)-p.T2obs)^2;
%  disp(sprintf('%14f    %14f   %14f', Zmt/p.MT_variance, p.T2_variance_scale*(p.T2(1)-p.T2obs)^2, p.T2(1)-p.T2obs));
  G = -X;
else
  error('Unknown method');
end


