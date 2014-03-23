function p = gaussian_hann(angle, duration,offset,TR, bw)
%  function p = gaussian_hann(angle, duration, offset,TR, bw)
%
%  Hann windowed Gaussian pulse of given angle (degrees),
%  duration (seconds), offset (Hz), and bandwidth (Hz) 
%

%-----------------------------------------------------------------------------
%   author: John Sled
%   date: ??/??/????
%
%   modified: Ives Levesque, August 9, 2004
%             replaced QUAD8 (obsolete in MATLAB version 6.0.0.88) with QUADL (recommended replacement)
%             fixed usage of FSOLVE in COMPUTE_FWPHM (old version had ...,OPTIONS, GRADFUN, P1,...)
%   modified: July 2006
%             fixed usage of FSOLVE in COMPUTE_FWPHM to include optimset('fsolve')
%
%-----------------------------------------------------------------------------

if nargin == 0
  S = seqbase(0);
  p.tau = 0;
  p.A = 0;
  p.power = 0;
  p.c = 0;
  p.s2 = 0;
  p.dw = 0;
  p.bw = 0;
  p.TR = 0;
  p.rfrate = -1;
  p.lineshape = '';
  p.fwphm = 0;
  p = class(p, 'gaussian_hann');
elseif isa(angle, 'gaussian_hann')
  p = angle;
else
  p.tau = duration;
  p.A = 1;
  p.power = 0;
  p.c = duration/2;
  p.s2 = 2*log(2)/(pi*bw)^2;
  p.dw = 0;
  p.bw = bw;
  p.TR = TR;
  p.rfrate = -1;
  p.lineshape = '';
  p.fwphm = 0;
  S = seqbase(TR);
  p = class(p, 'gaussian_hann', S);
%  integral = quad8('angle_fcn', 0, p.tau, [], [], p); 
  integral = quadl('angle_fcn', 0, p.tau, [], [], p); 
  p.A = angle*pi/(180*integral);
  p.power = power(p);
  p.dw = 2*pi*offset;
  p.fwphm = compute_fwphm(p);
end

function fwphm = compute_fwphm(p)
%
% function fwphm = compute_fwphm(p)
%
% Compute FWHM of w1^2

%
%t = fsolve('fwphm_fcn', p.c/2, [],[], p);
[t, tmp, exitflag] = fsolve('fwphm_fcn', p.c/2, optimset('TolFun',1e-7,'TolX',1e-7), p);

fwphm = 2*abs(p.c - t);
