function p = set_T1(p,T1,level, dual_flag)

M = length(p.mt_angles);
N = length(p.offsets);

if(nargin < 4 | dual_flag == 0)
  p.T1(1) = T1;
  if(strncmp(p.model, 'mtspgr_dp', 9))
    for i = 1:M
      [Mz, Mxy(i)] = feval(p.model, p.angle(i), p.kf, p.f, p.TR(i), p.T1, ...
          [1 1], 0,   p.T2(2), 2*pi*1e5);
    end
  elseif(strncmp(p.model, 'mtspgr_rp', 9))
    for i = 1:M
      [Mz, Mxy(i)] = feval(p.model, p.angle(i), p.kf, p.f, p.TR(i), p.T1, ...
          [1 1], 0, p.T2(2), 2*pi*1e5, 1e-3);
    end
  elseif(strncmp(p.model, 'mtspgr_frp', 10))
    for i = 1:M
      [Mz, Mxy(i)] = feval(p.model, p.angle(i), p.kf, p.f, p.TR(i), p.T1, ...
          [1 1], 0, p.T2, 2*pi*1e5, 1e-3, 0);
    end
  else
    for i = 1:M
      [Mz, Mxy(i)] = feval(p.model, p.angle(i), p.kf, p.f, p.TR(1), p.T1, ...
          [1 1], 0);
    end
  end
else
  for i = 1:M
    [Mz, Mxy(i)] = feval('mtspgr_rp2_dual', p.angle(i), p.TR(i), p.R1, ...
        p.T2, [], p.P, p.K, [1 1], [0 0], 2*pi*1e5, p.tau(i), p.mix);
  end
end
p.beta = level./Mxy;