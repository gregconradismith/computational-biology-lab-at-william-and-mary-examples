
function decay1(tol)

% decay1.m
% Sample code for solving a system of ODEs in matlab.
% Solves  system arising from decay process  A --> B --> C.
%
% From  http://www.amath.washington.edu/~rjl/fdmbook/chapter8  (2007)

global fcnevals K1 K2 

% decay rates:
K1 = 1;
K2 = 2;

t0 = 0;                      % initial time
u0 = [1 0 0];                % initial data for u(t) as a vector
tfinal = 4;                  % final time
fcnevals = 0;                % counter for number of function evaluations

% solve ode:
options = odeset('AbsTol',tol,'RelTol',tol);
odesolution = ode113(@f,[t0 tfinal],u0,options);

clf
hold on
t = linspace(0, tfinal, 500);
u = deval(odesolution, t);
plot(t,u(1,:),'b')
plot(t,u(2,:),'k')
plot(t,u(3,:),'r')
legend('u1','u2','u3')
axis([0 tfinal -.1 1.1])
title('u(t) as a function of time')


%----------------------------------

function f = f(t,u);
global fcnevals K1 K2 

f1 = -K1*u(1);
f2 = K1*u(1) - K2*u(2);
f3 = K2*u(2);
f = [f1; f2; f3];

fcnevals = fcnevals + 1;

