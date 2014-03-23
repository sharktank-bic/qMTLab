function  sar(p, M)
%
% function  sar(p, M)
% 
% SAR of given pulse
%
% p         : pulse
% M         : mass of patient

beta = 0.346*p.tau*p.A^2/(1000*pi^2);

E_head = 0.00495*M^0.835;
E_body = 0.0009/1.7*M^1.83;

sar_avg_head = beta*E_head/(M*p.TR); 
sar_peak_head = beta/(9.37*p.TR); 
max_b1 = p.A/(2*pi*42.57e6);

disp(['headcoil average sar       = ' num2str(sar_avg_head) ' W/Kg'])
disp(['headcoil peak sar          = ' num2str(sar_peak_head) ' W/Kg'])
disp(['max B1 amplitude           = ' num2str(max_b1) ' uT'])