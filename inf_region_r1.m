function [stderr, R1, X, T] = inf_region_r1(study, p, cache, lineshape, objective)
%
% function [stderr, R1, X, T] = inf_region_r1(study, p, cache, lineshape, objective)
%
% Compute inference region taking into account uncertainty in R1f
%
%	stderr: vector of std error estimates
%	R1:	right-matrix from QR decomposition
%	X: 	scaled fitted parameters vector?
%	T:	vector of confidence intervals for each parameter
%
%

%
%	Originally coded by John G. Sled circa 1999?
%	Modified: April 2008: added comments (Ives Levesque)  _evil
%
%


% pick model: with or without dipole flag
if(strcmp(p.model, 'mtspgr_dp') | strcmp(p.model, 'mtspgr_rp3'))
  dipole_flag = 1;
else
  dipole_flag = 0;
end
if(dipole_flag)
  mapping = 'mapping_dp';
else
  mapping = 'mapping_4d';
end

% compute model signal equation gradient vs. each parameter and size of output
dF = grad_obj_study(study, p, cache, mapping, lineshape, objective);
[M,N] = size(dF);

% QR decomposition to yield R1, required for parameter uncertainty computation
[Q1,R1] = qr(dF,0);


X0 = eval([mapping '(1, p)']);  % forward mapping

% compute fitted model value for final parameters
[F, Y] = feval(objective, X0, study, p, cache, 3, mapping, lineshape);

% compute sum-of-squares residuals
s2 = sum((F - Y).^2) / (M - N);

% compute additional variance due to R1obs and R1r (inputs to the fit that are not included in MT data)
U = grad_obj_study(study, p, cache, 'mapping_R1obs', lineshape, objective);
V = grad_obj_study(study, p, cache, 'mapping_R1r', lineshape, objective);
s2 = s2 + U'*U/M*p.R1obs_s2 + V'*V/M*p.R1r_s2;
%U'*U/M*p.R1obs_s2/s2
%V'*V/M*p.R1r_s2/s2

% invert R1 matrix from QR decomposition
Rinv = inv(R1);

% compute standard error estimates and 95% confidence interval of parameter estimates, from total variance
% note that this only include T2f, T2r, kf, and f (not R1f)
for i = 1:N
  stderr(i) = norm(Rinv(i,:))*sqrt(s2);
  % equivalent computation
  %  iRtR = inv(R1'*R1);
  %  stderr(i) = sqrt(iRtR(i,i)*s2);
  t(i) = tinv(1-2.5e-2, M-N)*stderr(i);
end

% display parameter estimated std errors
disp('Standard errors');
names = feval(mapping, 3);  % get parameter names
for i = 1:length(names)
  disp(sprintf('%5s = %14f', names{i}, stderr(i)));
end


% display parameter estimates
disp('Estimated values');
disp(sprintf('kf   =   %14.7f', p.kf))
disp(sprintf('f    =   %14.7f', p.f))
disp(sprintf('R1f  =   %14.7f', 1/p.T1(1)))
disp(sprintf('R1r  =   %14.7f', 1/p.T1(2)))
disp(sprintf('T2f  =   %14.7f', p.T2(1)))
disp(sprintf('T2r  =   %14.7f', p.T2(2)))
disp(sprintf('beta =   %14.7f', p.beta))
if(dipole_flag)
   disp(sprintf('T1d =   %14.7f', p.T1(3)))
end

% display parameters with 95% confidence intervals
disp('Confidence interval');
for i = 1:length(names)
  disp(sprintf('%-5s +- %14.7f', names{i}, t(i)))
end


% compute confidence interval for R1f
% based on variance due to other parameters in the model?
% propagate error through model via numerical approximation of partial derivative

% variance due to T2f
r1f0 = calc_r1f(p);
q = p;
q.T2(1) = q.T2(1)*1.001;
var = ((calc_r1f(q) - r1f0)/(0.001*q.T2(1)))^2*t(1)^2;
T.T2(1) = t(1);

% additional variance due to T2r
q = p;
q.T2(2) = q.T2(2)*1.001;
var = var + ((calc_r1f(q) - r1f0)/(0.001*q.T2(2)))^2*t(2)^2;
T.T2(2) = t(2);

% additional variance due to kf
q = p;
q.kf = q.kf*1.001;
var = var + ((calc_r1f(q) - r1f0)/(0.001*q.kf))^2*t(3)^2;
T.kf = t(3);

% additional variance due to F
q = p;
q.f = q.f*1.001;
var = var + ((calc_r1f(q) - r1f0)/(0.001*q.f))^2*t(4)^2;
T.f = t(4);

% optional additional variance due to T1d (dipole)
if(dipole_flag)
  q = p;
  q.T1(3) = q.T1(3)/1.001;
  var = var + ((calc_r1f(q) - r1f0)/(0.001/p.T1(3)))^2*t(5)^2;
  T.T1d = t(5);
end

% additional variance due to R1r
q = p;
q.T1(2) = q.T1(2)/1.001;
var = var + ((calc_r1f(q) - r1f0)/(0.001/q.T1(2)))^2*p.R1r_s2;
T.R1(2) = sqrt(p.R1r_s2)*norminv(1-0.025);

% additional variance due to T1obs
q = p;
q.T1obs = q.T1obs/1.001;
var = var + ((calc_r1f(q) - r1f0)/(0.001/p.T1obs))^2*p.R1obs_s2;

% compute confidence interval for R1f (based on normal distribution) and display
t(N+1) = sqrt(var)*norminv(1-0.025);
names{N+1} = 'R1f';
disp(sprintf('%-5s  +- %14.7f', names{N+1}, t(N+1)))
T.R1(1) = t(N+1);



X = [];
return


% compute correlation matrix and display
L = diag(1./sqrt(diag(Rinv*Rinv')))*Rinv;
C = L*L'; 
disp(sprintf('\nCorrelation matrix'))
for i = 1:N
  disp(sprintf('%10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f', C(i,:)));
end

%figure(1);
X = X0 .* feval(mapping, 4);
joint_int_plot(X, R1, s2, M, N, t, names)

%error('here')



%-------------------------------------------------------------------------------

function r1f = calc_r1f(p)
% returns the value of R1f given inputs T1 obs, F, and kf
% according to the formula derived and published by Henkelman

rd = 1/p.T1(2) - 1/p.T1obs;
if(p.f > 0)
  r1f = (1/p.T1obs  - p.kf * rd /(rd + p.kf/p.f)); 
else
  r1f = 1/p.T1obs;
end
