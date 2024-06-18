% differenceBinomials.m

clc; close all; clear;
set(0,'defaultAxesFontSize',20)

N=8; % number of type 1 and type 2 neurons (2N is total)
p=0.76; % dropout probability 
M=55367; % number of genes 

C = binornd(N,p,[M 2]);
D = abs(C(:,1)-C(:,2)); % absolute value of difference of binomials

figure 
subplot(3,1,1)
histogram(C(:),'BinMethod','integers')
xlabel('# dropouts')
titlestr=['N=' num2str(N) ' of each type, dropout prob=' num2str(p) ];
title(titlestr)

subplot(3,1,2)
histogram(abs(D),'BinMethod','integers')
xlabel('abs(typ1 minus type 2 dropouts) ')

subplot(3,1,3)
histogram(D,'BinMethod','integers','Normalization','cdf')
xlabel('abs(typ1 minus type 2 dropouts) ')

for k=0:max(D)
Mdrop = length(find(D>=k));
disp([ num2str(round(Mdrop)) ' of ' num2str(M) ' genes have differential dropout of ' num2str(k) ' or more.']) 
end



print(['Figures/differenceBinomials.png'],'-dpng')

return
