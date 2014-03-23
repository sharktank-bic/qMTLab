function s = fwphm_fcn(t, p)
%
%  function s = fwphm_fcn(t, p);
%
%  s  = omega1(p,t).^2 - 0.5*omega1(p,pulse_peak(p))^2;
%
%  This function is used to compute the fwhm of w1^2 for each pulse

s  = omega1(p,t).^2 - 0.5*omega1(p,pulse_peak(p))^2;
