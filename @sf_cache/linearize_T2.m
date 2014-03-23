function p = linearize_T2(p)
%

dims = size(p.values);

m = max(p.T2);
inc = min(abs([m p.T2] - [p.T2 -m]));

nT2 = p.T2(1):inc:p.T2(length(p.T2));
n = length(nT2);
v = zeros([dims(1:2) n]);

for i = 1:dims(1)
  for j = 1:dims(2)
    v(i,j,:)  = interp1(p.T2, squeeze(p.values(i,j,:)), nT2);
  end
end
p.values = v;
p.T2 = nT2;