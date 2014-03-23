function print_fit(fit, range)


disp(sprintf('label     f        kf      T2f (ms)  T2r (us)   T1f (s)'))

if (nargin == 1)
  for i = 1:length(fit.f)
  disp(sprintf('%2d    %8.4f %8.2f %8.1f  %8.1f   %8.3f', i, fit.f(i), fit.kf(i), fit.T2(i,1)*1e3, fit.T2(i,2)*1e6, 1/fit.R1(i,1)))

  end
else
  for i = range(1):range(2)
  disp(sprintf('%2d    %8.4f %8.2f %8.1f  %8.1f   %8.3f', i, fit.f(i), fit.kf(i), fit.T2(i,1)*1e3, fit.T2(i,2)*1e6, 1/fit.R1(i,1)))

  end
end  
