function [P, avgP] = power(p)
%   original implementation: JG Sled
%   July 2010: replaced quad8 (obsolete) with quadl - I Levesque


%P = quad8('power_fcn', 0, p.tau, [], [], p);
P = quadl('power_fcn', 0, p.tau, [], [], p);

avgP = P/p.TR;
