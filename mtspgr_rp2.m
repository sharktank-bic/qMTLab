function [Mz, Mxy]  = mtspgr_rp2(alpha, kf, f, TR, T1, S, W, T2r, dw, tau)
% 
% Analytic signal equation for MT spoiled grass sequence including 
% instantateous irradiation of the free pool and equivalent power
% rectangular pulse irradiation of Zeeman pool.
%
%
%  function [Mz, Mxy]= mtspgr_rp2(alpha, rf, f, TR, T1, S, W, dw, tau)
% 
%  alpha      : flip angle of excitation pulse (degrees)
%  rf         : first order rate constant for exchange (= Ka = R M0b)
%  f          : ratio of pool sizes M0b/M0a
%  TR         : repetition time
%  T1         : [T1f T1r]  T1 of free and restricted pools
%  S          : [Sf Sr]  fractional saturation due to MT pulse
%                 Sr should be 1 for this if CW model is assumed
%  W          : rate constant for CW irradiation
%  T2r        : ignored (since W takes into account T2r)
%  dw         : offset frequency of irradiation (radians)
%  tau        : duration of equivalent rect pulse
%
%  Copyright 2002  John G. Sled

if(f < 0)
  Mxy = nan;
  Mz = nan;
  return
end

alpha = alpha * pi/180; % radians
r1f = 1/T1(1);
r1r = 1/T1(2);
if(f == 0)
  kr = 0;
else  
  kr = kf/f;
end

Sf=S(:,1).*cos(alpha); Sr=S(:,2); 
M0f = 1;
%eta = 3*(dw*T2r)^2;

We = W*TR/tau;   % equivalent rate for rect pulse of duration tau

% matrix exponentials
A12 = [r1f+kf  -kr ; -kf  r1r+kr+We];
eA12 = expm(-tau/2*A12);

A0 = [r1f+kf  -kr; -kf  r1r+kr];
eA0 = expm(-(TR-tau)*A0);


% steady state CW solution (without direct affect)
%denominator = (We.*eta.*T1(3).*r1r.*f.*r1f+We.*eta.*T1(3).*r1r.*f.*kf+kf.*We.*eta.*T1(3).*r1f+r1r.*f.*r1f+r1r.*f.*kf+r1f.*kf+We.*f.*r1f+We.*f.*kf);

%beta = M0f.*We.*f.*eta.*T1(3).*(r1r.*f.*r1f+r1r.*f.*kf+r1f.*kf)/ denominator;

%Mzr_inf = f.*M0f.*(We.*eta.*T1(3).*r1r.*f.*r1f+r1r.*f.*r1f+We.*eta.*T1(3).*r1r.*f.*kf+kf.*We.*eta.*T1(3).*r1f+r1r.*f.*kf+r1f.*kf)/ denominator;

%Mzf_inf = M0f.*(We.*eta.*T1(3).*r1r.*f.*kf+We.*eta.*T1(3).*r1r.*f.*r1f+kf.*We.*eta.*T1(3).*r1f+r1r.*f.*kf+r1r.*f.*r1f+r1f.*kf+We.*f.*r1f) / denominator;



if(f == 0)
  Mzf_inf = M0f;
  Mzr_inf = 0;
else  
  Mzf_inf = M0f.*(r1r.*f.*kf+r1r.*f.*r1f+r1f.*kf+We.*f.*r1f)./(r1r.*f.*r1f+r1r.*f.*kf+r1f.*kf+We.*f.*r1f+We.*f.*kf); 
  Mzr_inf = f.*M0f.*(r1r.*f.*r1f+r1r.*f.*kf+r1f.*kf)./(r1r.*f.*r1f+r1r.*f.*kf+r1f.*kf+We.*f.*r1f+We.*f.*kf);
end

% solve for Mz
Mrf_inf = [Mzf_inf; Mzr_inf];

M0_inf = [M0f; M0f*f]; 
I = eye(2);

Mz(1:2,:) = inv(I - eA12*eA0*eA12*diag([Sf Sr]))* ...
    ( (I + eA12*(-I + eA0*(I -  eA12)))*Mrf_inf + eA12*(I - eA0)*M0_inf);

Mxy = Mz(1,:).*sin(alpha).*S(:,1);


return


