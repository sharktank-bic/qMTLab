function q = set_angle(p, angle)
%
%  function q = set_angle(p, angle)
%  
%  p      : pulse
%  angle  : angle (degrees)

q = p;
integral = quad8('angle_fcn', 0, p.tau, [], [], p); 
q.A = p.A*angle*pi/(180*integral);
q.power = power(q);
q.rfrate = -1;
