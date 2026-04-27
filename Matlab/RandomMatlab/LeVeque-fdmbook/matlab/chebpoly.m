function Tn = chebpoly(n,z)
%
% evaluate Chebyshev polynomial T_n(z)
%
% From  http://www.amath.washington.edu/~rjl/fdmbook/chapter8  (2007)


if n<0, error('n must be non-negative integer'), end;

Tn = ones(size(z));
if n==0
   return
   end

Tnm1 = Tn;
Tn = z;
if n==1
   return
   end

for i=2:n
   Tnm2 = Tnm1;
   Tnm1 = Tn;
   Tn = 2*z.*Tnm1 - Tnm2;
   end
