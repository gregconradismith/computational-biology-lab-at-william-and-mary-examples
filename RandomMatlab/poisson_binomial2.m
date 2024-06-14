% poisson_binomial

clear
close all
clc

N = 1e4;
M = 2e4;
nbin = 50;

mu = 0.7;
sigma = 0.1;
%p = mu+sigma*randn(N,1); % reflected Gaussian distribution 
%p = rand(N,1);
p(1:N/2) = 0.2*ones(N/2,1);
p(N/2+1:N) = 0.4*ones(N/2,1);

p(find(p<0))=0;
p(find(p>1))=1;

x = sum((rand(N,M) < p(:)),2); 
[xhist,xbin] = hist(x,nbin);
[phist,pbin] = hist(p,nbin);

subplot(2,1,1)
bar(pbin,phist/sum(phist))
xlabel('P: reflected Gaussian','FontSize',12);
ylabel('density','FontSize',12);
axis([0 1 0 Inf ])


subplot(2,1,2)
bar(xbin,xhist/sum(xhist))
title(['\mu=' num2str(mean(x)) '  \sigma=' num2str(std(x))])
xlabel('X: Poisson Binomial','FontSize',12);
ylabel('density','FontSize',12);
axis([0 Inf 0 Inf ])
    
return

