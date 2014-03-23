function Z = mapping_4d(type, p, X)
%
%   function Z = mapping_4d(type, p [, X])
%
%   mapping for 4 dof fit
%  
%   type == 1 =>  X = mapping(1,p)       % forward mapping
%   type == 2 =>  p = mapping(2,p,X)     % reverse mapping
%   type == 3 =>  q = mapping(3)         % return names of dimensions
%   type == 4 =>  scales = mapping(4)    % return scales
%
%        X   =  [ T2f; T2r; kf;  f ];


N = 4;
scales = [ 1e-2; 1e-5; 1; .1];

if(type == 1)
  X = zeros(N,1);
  X = [p.T2(1); p.T2(2); p.kf; p.f];
  X = X ./ scales;
  Z = X;
elseif(type == 2)
  X = X .* scales;
  rd = 1/p.T1(2) - 1/p.T1obs;
  if(X(4) > 0)
    p.T1(1) = 1/(1/p.T1obs  - X(3) * rd /(rd + X(3)/X(4)));  
  else
    p.T1(1) = p.T1obs;
  end
  p.T2(1) = X(1);
  p.T2(2) = X(2);
  p.kf = X(3);
  p.f = X(4);
  if(strcmp(p.model,'cz'))
    p.beta = ones(size(p.beta));
  else
    p = set_T1(p, p.T1(1), 1.0);
  end
  Z = p;
elseif(type == 3)
  Z = { 'T2f' 'T2r' 'kf' 'f' };
elseif(type == 4)
  Z = scales;
else
  error('Unknown mapping type');
end