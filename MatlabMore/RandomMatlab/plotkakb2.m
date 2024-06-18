
clc; close all; clear

N=1e8;
R=exprnd(5,N,6);

a = R(:,1);
%abar = R(:,2); 
abar = ones(N,1);
b = R(:,3);
%bbar = R(:,4);  
bbar = ones(N,1);
c = R(:,5);
%cbar = R(:,6);
cbar = ones(N,1);

z1 = b.*c+abar.*c+abar.*bbar;
z2 = bbar.*cbar+a.*c+a.*bbar;
z3 = b.*cbar+abar.*cbar+a.*b;

ka=z2./z1;
kb=z3./z2;

tol=0.001;
ka0 = 5; kb0=3; % target 
aa = find((ka-ka0).^2+(kb-kb0).^2<tol);

  
plot3(a(aa),b(aa),c(aa),'o')
xlabel('a')
ylabel('b')
zlabel('c')
    
