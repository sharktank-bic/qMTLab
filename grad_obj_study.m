function dF = grad_obj_study(study, p, caches, mapping, lineshape, objective)
%
% dF = grad_obj_study(study, p, caches, mapping, lineshape, objective)
%
% Inputs: 
%   study         :     study data structure
%   p0            :     initial guess for fit
%   cache         :     Sf values
%   mapping       :     parameter mapping function
%   lineshape     :
%   objective     :     objective function

% initial guess

X0 = feval(mapping, 1, p);  % forward mapping
scales = feval(mapping, 4);

F0 = feval(objective, X0,study, p, caches, 3, mapping, lineshape);
for i = 1:length(X0)
  X = X0;
  X(i) = X(i)*1.001;
  F(i,:) = feval(objective,X,study, p, caches, 3, mapping, lineshape);
  dF(i,:) = (F(i,:) - F0)/ ((X(i)-X0(i))*scales(i));
end

dF = dF';
