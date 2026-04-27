% example poor man's nulllcines 
% dx/dt = f(x,y) = x*(1-x)-y
% dy/dt = g(x,y) = y*(1-y)*(y-0.5)-x

clear; close all; clc
dx=1e-2;
dy=1e-3;
x = -2:dx:4;
y = -2:dy:2;

[X,Y] = meshgrid(x,y);

F =  X.*(1-X)-Y; % f(x,y)
G =  Y.*(1-Y).*(Y-0.5)-X; % g(x,y)

figure(1)
contour(x,y,F,[0,0],'b'); hold on;
contour(x,y,G,[0,0],'r');
legend({'x nullcline','y nullcline'})
title('dx/dt = x*(1-x)-y, dy/dt = y*(1-y)*(y-0.5)-x')
xlabel('x')
ylabel('y','rot',0)
 

