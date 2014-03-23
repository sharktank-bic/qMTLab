function [f, s, w] = spectrum(p)

N = 1024;
zoom = 4;  % must be a power of 2
f = zeros(zoom*N,1);
w = zeros(zoom*N,1);
for i = 1:N
  t = (i-1)/(N-1)*p.tau;
  w(i) = omega1(p,t);
end

for i = -(N*zoom/2):(N*zoom/2-1) 
  f(i+N*zoom/2+1) = i/(zoom*N)*((N-1)/p.tau);
end

s = fftshift(fft(w));


mask = (f > (p.dw/(2*pi)-2*(p.bw+1/p.tau)) & f < (p.dw/(2*pi)+2*(p.bw+1/p.tau)));

plot(f(mask),abs(s(mask)));
xlabel('frequency')