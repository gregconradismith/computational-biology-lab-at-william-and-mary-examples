% permuton
close all; clc; clear;

n=7;
rho=-0.3;

figure
[ perm, P, U ] = copula_perm(rho,n,1)

if 1
    kmax = 1e4;
    Perms = perms(1:n);
    W0 = zeros(n);
    Ulist = [];
    for k=1:kmax
        [perm,P,U] = copula_perm(rho,n,0);
        [~, a]=ismember(perm,Perms,'rows');
        Z(k)=a;
        W0=W0+P;
        Ulist = [ Ulist; U ];
    end
    figure
    histogram(Z,'BinMethod','integers')
    W=W0/kmax
    figure
    imagesc(W)
    colormap jet
    colorbar
    figure
    plot(Ulist(:,1),Ulist(:,2),'o')
end
edges = 0:1/n:1
histogram2(Ulist(:,1),Ulist(:,2),edges,edges,'DisplayStyle','tile')
colormap jet
colorbar
shading flat
return

function [ perm, P, U ] = copula_perm(rho,n,fig)
U = copularnd('Gaussian',[1 rho; rho 1],n); 
%U = copularnd('t',[1 rho; rho 1],4,n); 
X = sortrows(U,'ascend');
[~,ay] = sort(X(:,2),'descend');
[~,aw] = sort(ay,'ascend');
perm=aw';
P = zeros(n);
a = 0:n:n*(n-1); a=a+perm;
P(a)=1;
if fig
    plot(U(:,1),U(:,2),'*','MarkerSize',20)
    axis([0 1 0 1])
    title(num2str(perm))
    axis square
end
end