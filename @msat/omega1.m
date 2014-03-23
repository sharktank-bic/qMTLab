function w = omega1(p, t)
% function w = omega1(p, t)

if(t >= p.T(1) & t <= p.T(p.N))
  w = interp1(p.T,p.A, t, '*linear');
else
  w = 0;
end



