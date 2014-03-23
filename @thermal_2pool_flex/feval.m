function varargout = feval(p, varargin)
%
% [dM, out2, out3] = feval(p, varargin)
%
if(nargout == 1)
  dM = model(p, varargin{:});
  varargout(1) = {dM};
else
  [dM, out2, out3] = model(p, varargin{:});
  varargout(1) = {dM};
  varargout(2) = {out2};
  varargout(1) = {out3};
end