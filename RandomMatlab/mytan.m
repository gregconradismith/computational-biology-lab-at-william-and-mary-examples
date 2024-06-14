
clear
clc
close all

a = 1; 

t = 0:0.001:pi/a;

for y0 = -10:1:10  

y = a*(a*tan(a*t)+y0)./(a-y0*tan(a*t));

plot(t,y); hold on;
axis([0 Inf -10 10])

end