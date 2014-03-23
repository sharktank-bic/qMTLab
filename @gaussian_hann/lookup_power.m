function [P, avgP] = lookup_power(p)

P = p.power;
avgP = P/p.TR;