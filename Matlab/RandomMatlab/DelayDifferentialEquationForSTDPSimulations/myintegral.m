% myintegral
clc; clear; close all

a = 0.8;

x01 = 0:0.01:1; x01=x01(:);
x12 = x01+1;  
N=10;

rho01 = x01.^(a-1);
int12binom = zeros(length(x12),1);
for k=0:N
   % nchoosek(n,k) = gamma(n+1)/gamma(k+1)/gamma(n-k+1)
   % nchoosek(a+k-1,k) w/ n=a+k-1 ==> gamma(a+k-1+1)/gamma(k+1)/gamma(a+k-1-k+1)
   int12binom = int12binom + (-1)^k*gamma(a+k)/gamma(k+1)/gamma(a)*(x12-1).^(k+a)/(k+a);
   figure(1)
   semilogy(x12,int12binom); hold on;
end
int12hypergeom=1/a*(x12-1).^a.*hypergeom([a,a],a+1,1-x12);
semilogy(x12,int12binom,'r-','LineWidth',2); hold on;
semilogy(x12,int12hypergeom,'b--','LineWidth',2);  
xlabel('x')
ylabel('\rho','Rotation',0)
sgtitle(['\alpha = ' num2str(a) ])
print(['fig1_alpha_' num2str(a) '.png'],'-dpng')

rho12binom = max(0,x12.^(a-1).*(1-a*int12binom));
rho12hypergeom = x12.^(a-1).*(1-a*int12hypergeom);

figure(2)
subplot(2,1,1)
plot(x01,rho01,'g','LineWidth',2); hold on;
plot(x12,rho12binom,'r','LineWidth',2); 
plot(x12,rho12hypergeom,'b--','LineWidth',2); 
ylabel('\rho','Rotation',0)

subplot(2,1,2)
semilogy(x01,rho01,'g','LineWidth',2); hold on;
semilogy(x12,rho12binom,'r','LineWidth',2); 
semilogy(x12,rho12hypergeom,'b--','LineWidth',2);
xlabel('x')
ylabel('\rho','Rotation',0)
legend({'step1',['step2 binomial expansion with ' num2str(N) ' terms'],'step2 hypergeometric'},'Location','south')
sgtitle(['\alpha = ' num2str(a) ])
print(['fig2_alpha_' num2str(a) '.png'],'-dpng')