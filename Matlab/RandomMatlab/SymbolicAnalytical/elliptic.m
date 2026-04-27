% Elliptic curves
clear;clc;close all;

xmax=2;
n=100;
x=linspace(-xmax,xmax,100);
y=x;
[X,Y]=meshgrid(x,y);

a=[-1:2];
b=[-2:1];
na=length(a);
nb=length(b);


for i=1:na
    for j=1:nb
        figure
        F = -Y.^2+X.^3+a(i)*X+b(j);
        surf(x,y,F); shading flat; hold on;
        contour3(x,y,F,[0 0],'-k', 'LineWidth',1.5); hold on;
        title(['a=' num2str(a(i)) ', b=' num2str(b(j) )])
    end
end

 