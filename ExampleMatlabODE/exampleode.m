function exampleode
% integrate dx/dt = lambda - x^2

subplot(2,1,1)
x=-5:0.01:5;
plot(x,odefun(0,x),'b',x,0,'r')
xlabel('x')
ylabel('rhs')

total = 3;
x0 = 1;
[t xx] = ode15s(@odefun,[0 total],x0);

subplot(2,1,2)
plot(t,xx,'g')
xlabel('time')
ylabel('x')
return

function rhs = odefun(t,x)
lambda = 6;
rhs = lambda-x.^2; 
return