function P = power_fcn(t, p)
%
%  function P = power_fcn(t, p)
%
%  P  = omega1(p,t).^2;
%
%  This function is used by the power() function of each pulse class.

  P  = abs(omega1(p,t)).^2;
