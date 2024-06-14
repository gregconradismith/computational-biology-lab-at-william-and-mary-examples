% myintegraleq
close all; clear; clc;

w=logspace(-4,5,1e3);
a=1.5; % a=alpha*tau
c=1;
w=logspace(-3,log10(3*a),1e3);
max_iter=10;

RHO = zeros(max_iter,length(w));
RHO(1,:) = c*exp(-w);
RHO(1,:) =  RHO(1,:)/trapz(w,RHO(1,:));

for i=2:max_iter
    for j=2:length(w)
    intw = cumtrapz(w,RHO(i-1,:))

        index=find(w<=w(j) & w>w(j)-1);
        if length(index)>1
        integ=trapz(w(index),RHO(i-1,index));
        else
            integ=0;
        end
        RHO(i,j) =  c./w(j) + a./w(j)*integ;
    end
    RHO(i,:) =  RHO(i,:)/trapz(w,RHO(i,:));
    mynorm=norm(RHO(i,:)-RHO(i-1,:))
    if mynorm<1e-4, RHO=RHO(1:i,:); break, end
end
RHO(:,1)=NaN;

subplot(3,1,1)
semilogx(w,RHO'); hold on;
semilogx(w,RHO(end,:),'r','LineWidth',2);

subplot(3,1,2)
semilogx(w,RHO(end,:),'r-o','LineWidth',2);

subplot(3,1,3)
loglog(w,RHO(end,:),'r-o','LineWidth',2);

ii=find(w<10);
figure(2)
plot(w(ii),RHO(end,ii),'b-o','LineWidth',2)
