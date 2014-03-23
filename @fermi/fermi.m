function p = fermi(angle, duration,offset,TR, bw, s)
%  function p = fermi(angle, duration, offset,TR, s)
%
%  Fermi pulse of given angle (degrees),
%  duration (seconds), offset (Hz), and bandwidth (Hz) 
%

%-----------------------------------------------------------------------------
%   author: Ives Levesque
%   date: 03/05/2011
%   based on @gaussian_hann
%
%-----------------------------------------------------------------------------

if nargin == 0
  S = seqbase(0);
  p.tau = 0;
  p.A = 0;
  p.power = 0;
  p.c = 0;
%  p.s2 = 0;
  p.dw = 0;
  p.s = 0;
  p.t0 = 0;
  p.b = 0;
  p.TR = 0;
  p.rfrate = -1;
  p.lineshape = '';
  p.fwphm = 0;
  p = class(p, 'fermi');
elseif isa(angle, 'fermi')
  p = angle;
else
  p.tau = duration;
  p.A = 1;
  p.power = 0;
  p.c = duration/2;
%  p.s2 = 2*log(2)/(pi*bw)^2;
  p.dw = 0;
  p.s = s;
  p.t0 = p.tau/(2 + 13.81/p.s);    % from the Bernstein handbook
  p.b = p.t0./p.s;
  p.TR = TR;
  p.rfrate = -1;
  p.lineshape = '';
  p.fwphm = 0;
  S = seqbase(TR);
  p = class(p, 'fermi', S);
  % this could be replaced with the analytical solution...
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
