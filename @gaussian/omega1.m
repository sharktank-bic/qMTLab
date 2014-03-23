function w = omega1(p, t)
% function w = omega1(p, t)

if(t >= 0 & t <= p.tau)
  dt = (t-p.c);
  w = p.A*exp(-0.5*dt.^2/p.s2+sqrt(-1)*p.dw*dt);
else
  w = 0;
end
