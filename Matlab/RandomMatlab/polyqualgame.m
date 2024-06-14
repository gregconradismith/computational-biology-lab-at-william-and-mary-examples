% qualitative analysis quiz

clear
close all
clc
s = RandStream('mt19937ar','Seed','shuffle');
RandStream.setGlobalStream(s);
set(0,'defaultaxesfontsize',20);

careaboutsignf = true;
N=4;
sigma = 1;
wiggle = sigma/2;
x = -1:0.01:1;

a1 = sigma*randn(N,1); a2 = a1+wiggle*randn(N,1);
p1 = polyval(a1,x); p2 = polyval(a2,x);
ymax = max(0,max(max(p1,p2))); ymin = min(0,min(min(p1,p2)));
da1 = polyder(a1); da2 = polyder(a2); dp1 = polyval(da1,x); dp2 = polyval(da2,x);
dda1 = polyder(da1); dda2 = polyder(da2); ddp1 = polyval(dda1,x); ddp2 = polyval(dda2,x);


figure(1)
left = 0.05; bottom = 0.3; width = 1-2*left; height = 0.95-bottom;
subplot('Position',[left bottom width height ])
plot(x,[ p1 ; p2 ],'LineWidth',2); hold on;
axis off
if careaboutsignf
    line([-1 1],[0 0],'Color','k');
end

pause

scale = 0.9; verybottom = 0.05; answerheight = 0.05; margin = 0.02;
if careaboutsignf
    subplot('Position',[left verybottom width answerheight])
    line([-1 1],[0 0],'Color','k'); hold on;
    stairs(x,sign(p1),'LineWidth',2,'Color','b'); hold on;
    stairs(x,scale*sign(p2),'LineWidth',2,'Color','g'); hold on;
    ylabel('f','rot',0)
    axis([-Inf Inf -1.1 1.1])
    axis off
end

subplot('Position',[left verybottom+answerheight+margin width answerheight])
line([-1 1],[0 0],'Color','k'); hold on;
stairs(x,sign(dp1),'LineWidth',2,'Color','b'); hold on;
stairs(x,scale*sign(dp2),'LineWidth',2,'Color','g'); hold on;
ylabel('df','rot',0)
axis([-Inf Inf -1.1 1.1])
axis off

subplot('Position',[left verybottom+2*(answerheight+margin) width answerheight])
line([-1 1],[0 0],'Color','k'); hold on;
stairs(x,sign(ddp1),'LineWidth',2,'Color','b'); hold on;
stairs(x,scale*sign(ddp2),'LineWidth',2,'Color','g'); hold on;
ylabel('ddf','rot',0)
axis([-Inf Inf -1.1 1.1])
axis off

