
close all; clc; clear

S=100;
X = full(sprand(S,S,0.1)>0);

a = 1:S;
ap = [2:S, 1];
am = [S 1:S-1];

N = X(ap,ap)+X(ap,a)+X(ap,am)+X(a,am)+ ...
X(am,am)+X(am,a)+X(am,ap)+X(a,ap);

Npad = [ zeros(1,S) 0 ; N zeros(S,1)];
pcolor(flipud(Npad)); 
colorbar
shading flat
hold on;
[x,y] = find(flipud(X));
plot(y+0.5,x+0.5,'o','MarkerFaceColor','w');
hold off;