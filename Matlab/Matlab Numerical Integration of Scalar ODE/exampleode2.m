function exampleode2
% integrate dx/dt = A*x 

total = 10;
x0 = [1; 4];
[t xx] = ode15s(@odefun,[0 total],x0);

subplot(2,1,1)
plot(t,xx)
xlabel('time')
ylabel('x')

subplot(2,1,2)
plot(xx(:,1),xx(:,2))

return

function rhs = odefun(t,x)
%A = [ -1 1 ; 0 -1 ]; 
A = [ 0 1 ; -1 0 ];
rhs = A*x; 
return