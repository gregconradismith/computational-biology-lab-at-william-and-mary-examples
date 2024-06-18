% zeros for heterodimer steady state - poor man

clear; close all; clc
gt = 10; ht = 20; Kg = 1;  Kh = 1; K = 1; alpha = 1; beta = 1; gamma = 1;
dg=1e-3; dh=1e-3;
g = 0:dg:2; h = 0:dh:3;

[G,H] = meshgrid(g,h);
ZG =  -gt + G + 2*Kg*G.^2 + K*H.*G + 2*alpha*Kg*K*G.^2.*H + beta*Kh*K*H.^2.*G + 2*alpha*beta*gamma*Kg*Kh*K*G.^2.*H.^2;  
ZH =  -ht + H + 2*Kh*H.^2 + K*H.*G + alpha*Kg*K*G.^2.*H + 2*beta*Kh*K*H.^2.*G + 2*alpha*beta*gamma*Kg*Kh*K*G.^2.*H.^2;  
 
tol = 0.1;
W = (abs(ZH)<tol)-(abs(ZG)<tol); Z = (abs(ZH)<tol)+(abs(ZG)<tol);
a = find(Z==2); % intersection
gss = mean(G(a))
hss = mean(H(a))

figure(1)
pcolor(g,h,W);
colormap pink;
shading interp;
title(['G = ', num2str(gss), '  H = ', num2str(hss) ])
xlabel('G')
ylabel('H')
legend({'ZG black, ZH white'})
print('fig.pdf','-dpdf')

% now solve using fsolve
x0 = [ 0 0 ];
[x,fval] = fsolve(@(x) myzero(x,gt,ht,Kg,Kh,K,alpha,beta,gamma), x0)

function z = myzero(x,gt,ht,Kg,Kh,K,alpha,beta,gamma)
g=x(1); h=x(2);
z = [ -gt + g + 2*Kg*g.^2 + K*h.*g + 2*alpha*Kg*K*g.^2.*h + beta*Kh*K*h.^2.*g + 2*alpha*beta*gamma*Kg*Kh*K*g.^2.*h.^2, ...  
  -ht + h + 2*Kh*h.^2 + K*h.*g + alpha*Kg*K*g.^2.*h + 2*beta*Kh*K*h.^2.*g + 2*alpha*beta*gamma*Kg*Kh*K*g.^2.*h.^2 ];
end


