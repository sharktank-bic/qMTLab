function p = fit_mtspgr_cw_study(study, p, cache, method, mapping, lineshape, obj, options)
%
% p = fit_mtspgr_cw_study(study, p, cache, method, mapping, lineshape, ...
%                         obj, options)
%
% Inputs: 
%   study         :     study data structure
%   p0            :     initial guess for fit
%   cache         :     Sf values
%   method        :     1 => 'constr' or 2 => 'leastsq' or 3, 4 => 'fmins'
%   mapping       :     function determining number of variables
%   lineshape     :
%   obj           :     objective function
%   options       :

%------------------------------------------------------------------------------
%  Originally coded by JGSled 199?-2000
%
%  Modified by Ives Levesque
  %                  July 2006: commenting, replaced 'fmins' by 'fminsearch'
%
%------------------------------------------------------------------------------

if(nargin < 7)
  obj = 'obj_mtspgr_cw_study';
end
if(nargin < 8)
  options = [];
end

% initial guess

X0 = eval([mapping '(1, p)']);  % forward mapping

%obj_mtspgr_cw_study(X0,study, p, cache, method);
% do minimization
%options(2) = 1e-5;

if(method == 1)  % constr
  %VLB = [1e-2; 1e-6; 1e-3; 1e-3; 1e-9; 0];
  %VUB = [50; 2; 10; 10; 1; 1e6];
  lower = p;
  lower.kf = 1e-2;
  lower.f = 1e-6;
  lower.T1 = [1e-3 0.5 1e-9];
  lower.T2 = [min(getfield(struct(cache),'T2'))*1.1 1e-9];
  lower.beta = 0;
  m = min(getfield(struct(cache),'angles'))/p.mt_angles(1);
  lower.mt_angles = p.mt_angles*m*1.001;
  VLB = feval(mapping, 1, lower);       % forward mapping;
  upper = p;
  upper.kf = 50;
  upper.f = 2;
  upper.T1 = [100; 100; 100];
  upper.T2 = [max(getfield(struct(cache),'T2'))*0.9; 1e-4];
  upper.beta = 1e9;
  m = max(getfield(struct(cache),'angles'))/p.mt_angles(length(p.mt_angles));
  upper.mt_angles = p.mt_angles*m*0.999;
  VUB = feval(mapping, 1, upper);  % forward mapping;
  for i = 1:length(VLB) 
    if(VLB(i) > VUB(i))
      temp = VLB(i);
      VLB(i) = VUB(i);
      VUB(i) = temp;
    end
  end
  [X,OPTIONS,LAMBDA,J]=constr(obj,X0,options,VLB,VUB,[], study, p, cache, method, mapping, lineshape);
elseif(method ==2)
  [X,OPTIONS,F,J]=leastsq(obj,X0,options,[], study, p, cache, method, mapping, lineshape);
else
  if(method == 4)
    obj_method = 4;
  else
    obj_method = 1;
  end
  %X=fmins(obj,X0,options,[], study, p, cache, obj_method, mapping, lineshape);
  %-- 'fmins' now obsolete, replace with 'fminsearch'
  [X,fval,exitflag]=fminsearch(obj, X0, options, study, p, cache, obj_method, mapping, lineshape);
end

p = feval(mapping, 2, p, X);  % reverse mapping
error = feval(obj, X, study, p, cache, 2, mapping, lineshape);
p.e2 = error*error'/length(error);
