%% spectral graph drawing
close all
clc
clear all

%% Example of a ring graph  
%  plotted using the 2nd and 3rd eigenvector of its Laplacian matrix
N=10;
A = diag(ones(1,N-1),1);
A(N,1)=1; A=A+A';
D=diag(sum(A));
L=D-A;
[v,e]=eig(L);
figure
gplot(A,v(:,[2 3])); hold on;
gplot(A,v(:,[2 3]),'o');  
axis equal
axis square
%% a ring graph with a short cut of very high weight
N=10;
A = diag(ones(1,N-1),1);
A(N,1)=1; 
nsc = floor(N/2);
A(nsc+1,1)=10;  
A=A+A';
D=diag(sum(A));
L=D-A;
[v,e]=eig(L);
figure
gplot(A,v(:,[2 3])); hold on;
gplot(A,v(:,[2 3]),'o');  
axis equal
axis square


%% now construct weighted graph from a distance matrix 
%  similarity = 1+1/distance
N=5;
S = [ Inf 2 5 2 7 ; 0 Inf 9 1 10 ; 0 0 Inf 3 7 ; 0 0 0 Inf 2 ; 0 0 0 0 Inf];
S = S+S';
A = 1./(S+eps);
D=diag(sum(A));
L=D-A;
[v,e]=eig(L);
figure
gplot(A,v(:,[2 3])); hold on;
gplot(A,v(:,[2 3]),'o');  
axis equal
axis square
for i=1:N
    text(v(i,2),v(i,3),num2str(i),'FontSize',24)
end
