% Local Global FHN

clc
clear all
close all

% good ones
% nv = 2; gamma = 0.5; alpha = 0.7; beta= -0.8; epsilon = 0.08; iapp = 0.1;
 %nv = 500; gamma = 0.2; alpha = 0.7; beta= -0.1; epsilon = 0.08; iapp = 0.1;

%nv = 100; gamma = 1; alpha = 0.7; beta= -0.8; epsilon = 0.08; iapp = 0.8;

nv = 6; vgamma = 0.1; alpha = 0.7; beta= -1; epsilon = 0.008; iapp = 0.5;
nw = 1; wgamma = 0;

dt = 0.1;
nt = 4e3;
t=dt*(0:nt-1);
vrand = vgamma*sqrt(dt)*randn(nt,nv);
wrand = wgamma*sqrt(dt)*randn(nt,nw);
vmin = -2.5;
vmax = 2.5;
wmin = -5;
wmax = 5;

vv = -2.5:0.01:2.5;
v = zeros(nt-1,nv);
w = zeros(nt-1,nw);

v(1,:) = 2;
w(1,:) = 1;

vavg(1) = mean(v(1,:));
wavg(1) = mean(w(1,:));

for i = 1:nt-1
    
    v(i+1,:) = v(i,:)+dt*(v(i,:)-v(i,:).^3/3-wavg(i)+iapp)+vrand(i,:);
    w(i+1,:) = w(i,:)+dt*epsilon*(vavg(i)+alpha+beta*w(i,:))+wrand(i,:);
    vavg(i+1) = mean(v(i+1,:));
    wavg(i+1) = mean(w(i+1,:));
    
    nplot=20;
    if i-nplot>1
        %subplot(2,1,1)
        plot(vv,vv-vv.^3/3+iapp,'r-',vv,-(vv+alpha)/beta,'b-'); hold on;
        axis([ vmin vmax wmin wmax ])
        ylabel('w')
        xlabel('v')
        plot(v(i-nplot:i+1,:),wavg(i-nplot:i+1),'mo:',vavg(i-nplot:i+1),w(i-nplot:i+1,:),'mo:',vavg(i-nplot:i+1),wavg(i-nplot:i+1),'k*-'); 
        hold off;
        %subplot(2,1,2)
        %hist(w(i,:),20)
        
        
        drawnow
    end
end

figure(2)

figname = [ 'fig ' datestr(now) ];

plot(t,v,'r:',t,w,'b:',t,vavg,'r-',t,wavg,'b-');
title([ figname ... 
    ': nv=' num2str(nv) ...
    ' alpha=' num2str(gamma) ...
    ' beta=' num2str(gamma) ...
    ' epsilon=' num2str(gamma) ...
    ' iapp=' num2str(gamma) ])
drawnow

print([ figname '.pdf'],'-dpdf')


