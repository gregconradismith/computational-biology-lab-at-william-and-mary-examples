% copula
% https://bochang.me/blog/posts/copula/
close all; clc; clear;

alpha=0.5;
n=10;
x=0:1/n:1;
y=x;
[X,Y]=meshgrid(x,y);
% alpha=0.5; C = min(X,Y).*max(X,Y).^(1-alpha);
delta = 2;
C = 1-((1-X).^delta+(1-Y).^delta-(1-X).^delta.*(1-Y).^delta).^(1/delta);


figure
imagesc(C)
colormap jet
colorbar

