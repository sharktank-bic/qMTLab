function w = omega1(p, t)
% function w = omega1(p, tau)

if(t >= 0 & t <= p.tau)
  w = p.A*ones(size(t));
else
  w = 0;
end

