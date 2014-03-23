function print_fit(data)
%   print_fit(data)
%   data is a structure used in QMT fitting
%   a function to print the data from the data structure used in QMT
%   fitting

%   John Sled ca. 2000
%   modified by Ives Levesque 2011, to enable printing without T2obs value
%   (if no T2 map acquired)

if isfield(data,'T2obs')
    disp(sprintf('label   b0 (Hz)     b1    T1obs   R1obs (s^-1) dR1obs   T2obs (ms)'))
    for i = 1:length(data.b0)
        disp(sprintf('%2d    %8.1f %8.3f %8.3f %8.2f  %8.2f   %8.1f', i, data.b0(i), data.b1(i), data.R1obs(i)^-1, data.R1obs(i), data.dR1obs(i), data.T2obs(i)*1000)); 
    end
else
    disp(sprintf('label   b0 (Hz)     b1    T1obs   R1obs (s^-1) dR1obs'))
    for i = 1:length(data.b0)
        disp(sprintf('%2d    %8.1f %8.3f %8.3f %8.2f  %8.2f   %8.1f', i, data.b0(i), data.b1(i), data.R1obs(i)^-1, data.R1obs(i), data.dR1obs(i))); 
    end
end
