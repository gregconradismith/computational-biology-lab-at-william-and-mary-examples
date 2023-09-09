% y/(1-y) plots and cooperativity 

clc; clear; close all

x = logspace(-2,2,50);

% choose binding function here 
example = 1;
switch example
    case 1
        y = x./(1+x).*x.^2./(1+x.^2) + 1./(1+x).*x.^3./(1+x.^3);
        titlestr = 'y = x/(1+x) * x^2/(1+x^2) + 1/(1+x) * x^3/(1+x^3)';
    case 2
        y = x.^2./(1+x.^2);
        titlestr = 'y = x^2/(1+x^2)';
    otherwise 
        error('Uknown example.')
end

subplot(2,2,1)
semilogx(x,y)
xlabel('x')
ylabel('y')

subplot(2,2,2)
Y = y./(1-y);
loglog(x,Y)
xlabel('x')
ylabel('y/(1-y)')

subplot(2,2,3)
lnY = log10(Y); 
lnx = log10(x);
plot(lnx,lnY)
xlabel('ln x')
ylabel('ln[y/(1-y)]')

subplot(2,2,4)
dlnYdlnx = (lnY(2:end)-lnY(1:end-1))./(lnx(2:end)-lnx(1:end-1));
plot(lnx(2:end),dlnYdlnx)
xlabel('ln x')
ylabel('d ln[y/(1-y)] / d ln x')
title('n_{hill}')
axis([-Inf Inf min(dlnYdlnx)-0.1 max(dlnYdlnx)+0.1])

sgtitle(titlestr)
