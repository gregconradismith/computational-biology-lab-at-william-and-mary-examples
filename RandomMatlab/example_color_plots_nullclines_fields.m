% example color plots

clear
close all
clc

% example 1 : a random matrix
A = rand(10);
A = [ A zeros(10,1) ; zeros(1,11)]; % note padding
A(1,1)=1; A(10,1)=0; % find these elements in the figure

figure(1)
pcolor(A);
colorbar;
shading flat;
title('random')
print('fig1.pdf','-dpdf')

% example 2 : a polynomial
x = -2:0.1:4;
y = -2:0.1:2;
[X,Y] = meshgrid(x,y);
Z =  X.^2.*Y+Y.^2-0.1*Y.^3;

figure(2)
pcolor(x,y,Z);
colormap hsv; % lots of different colormaps!
colorbar;
shading flat;
shading interp;
title('polynomial')
print('fig2.pdf','-dpdf')

% example 3 : poor man's nullclines
% dxdt = f(x,y)
% dydt = g(x,y)
dx=1e-2;
dy=1e-3;
x = -2:dx:4;
y = -2:dy:2;

[X,Y] = meshgrid(x,y);

F =  X.*(1-X)-Y;
G =  Y.*(1-Y).*(Y-0.5)-X;

tol = 0.5e-1;
W = (abs(F)<tol)-(abs(G)<tol);

figure(3)
pcolor(x,y,W);
colormap jet;
shading interp;
title('x nullcline blue, y nullcline red')
xlabel('x')
ylabel('y')
print('fig3.pdf','-dpdf')
