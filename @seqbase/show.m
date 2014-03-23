function show(p)

N = 1000;
for i = 1:1000
  t(i) = ((i-1)/(N-1)*(1.2)-.1)*p.duration;
  w(i) = omega1(p,t(i));
end

plot(t,real(w),t,imag(w));
xlabel('time')