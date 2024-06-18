


close all
clear 
clc

x = -1:0.01:1;
y = x;
[X,Y] = meshgrid(x,y);


camel = @(x,y)(4-2.1*x.^2+x.^4/3).*x.^2+x.*y+4*(y.^2-1).*y.^2;
loss = @(p)camel(p(1),p(2));

contourf(X,Y,camel(X,Y)); hold on;
colorbar

[x f] = anneal(loss,[0 0])

plot(x(1),x(2),'r*')





