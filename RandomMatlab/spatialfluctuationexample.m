
clc; clear; close all

L = 700; % kb 
x = rand(1,1e3)*L;

mylist = [25 50 100];

for i=1:length(mylist)
nbins = mylist(i);   
subplot(3,2,(i-1)*2+1)
[n, edges] = histcounts(x,nbins);
bar(L*(0.5:nbins-0.5)/nbins,n)
axis([0 L 0 Inf])

nbins2=20;
subplot(3,2,(i-1)*2+2)
[n2, edges2] = histcounts(n,nbins2);
bar((edges2(1:end-1)+edges2(2:end))/2,n2)
axis([0 150 0 Inf])

u = mean(n);
s = std(n);
cv = s/u;
title(['u=' sprintf('%2.2f',u) ' s=' sprintf('%2.2f',s) ' cv=' sprintf('%2.2f',cv) ])
end