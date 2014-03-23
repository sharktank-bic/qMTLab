function q = set_angle(p, angle)
%
%  function q = set_angle(p, angle)
%  
%  p      : pulse
%  angle  : angle (degrees)

q = p;
% this could be replaced by the analytical solution
integral = quadl('angle_fcn', 0, p.tau, [], [], p); 
q.A = p.A*angle*pi/(180*integral);
q.power = power(q);
q.rfrate = -1;
