function P = power(p)

%Q = QUAD8(FUN,A,B,TOL,TRACE,P1,P2,...)
%P = quad8('power_fcn', 0, p.tau, [], [], p); 

%QUADL(FUN,A,B,TOL,TRACE,P1,P2,...)
P = quadl('power_fcn', 0, p.tau, [], [], p); 

