function print_dfit(fit)


disp(sprintf('label    df       dkf     dT2f (ms) dT2r (us)  dR1f (s)     eps'))
for i = 1:length(fit.f)
  disp(sprintf('%2d    %8.4f %8.2f %8.1f  %8.1f   %8.3f   %8.3f', i, fit.df(i), fit.dkf(i), fit.dT2(i,1)*1e3, fit.dT2(i,2)*1e6, fit.dR1(i,1), sqrt(fit.e2(i))))
end
