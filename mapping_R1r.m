function Z = mapping_R1r(type, p, X)
%
%   function Z = mapping_R1r(type, p [, X])
%
%   mapping for 4 dof fit
%  
%   type == 1 =>  X = mapping(1,p)       % forward mapping
%   type == 2 =>  p = mapping(2,p,X)     % reverse mapping
%   type == 3 =>  q = mapping(3)         % return names of dimensions
%   type == 4 =>  scales = mapping(4)    % return scales
%
%        X   =  [ R1r ];


N = 1;
scales = [ 1];

if(type == 1)
  X = zeros(N,1);
  X = [1/ p.T1(2)];
  X = X ./ scales;
  Z = X;
elseif(type == 2)
  X = X .* scales;
  rd = X(1) - 1/p.T1obs;
  if(p.f > 0)
    p.T1(1) = 1/(1/p.T1obs  - p.kf * rd /(rd + p.kf/p.f)); 
  else
    p.T1(1) = p.T1obs;
  end
  if(strcmp(p.model,'cz'))
    p.beta = 1.0;
  else
    if(strcmp(p.model,'cz'))
      p.beta = 1.0;
    else
      p = set_T1(p, p.T1(1), 1.0);
    end
  end
  Z = p;
elseif(type == 3)
  Z = { 'R1r' };
elseif(type == 4)
  Z = scales;
else
  error('Unknown mapping type');
end