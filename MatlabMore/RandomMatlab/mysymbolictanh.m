% symbolic 

syms x a b 

f(x) =  tanh(x);
fp = diff(f)
fpp = diff(fp)

subplot(2,2,1)
ezplot(fpp)