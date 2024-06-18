% symbolic differentiation

syms so si v v0 z p F a

f = z*F*p*z*v/v0*(si-so*exp(-z*v/v0))/(1-exp(-z*v/v0));
f = v*(1-a*exp(-z*v))/(1-exp(-z*v));

derf = diff(f,v);
simplify(derf)

return

(a - exp(v*z) + exp(2*v*z) - a*exp(v*z) - v*z*exp(v*z) + a*v*z*exp(v*z)) 

a - x + x^2 - a*x - v*z*x + a*v*z*x

x^2 - (1+a+v*z+a*v*z)*x +a

a*exp(-z*v) - 1 + exp(v*z) - a  - v*z  + a*v*z 

a*(exp(-z*v)-1) + exp(v*z)-1    - v*z  + a*v*z 
a*(exp(-z*v)-1) + exp(v*z)-1 +   (a-1)*v*z    



