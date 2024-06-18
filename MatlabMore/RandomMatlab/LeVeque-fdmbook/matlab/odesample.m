
function odesample(tol)

% odesample.m
% Sample code for solving a system of ODEs in matlab.
% Solves  v'' = v^2 + (v')^2 - v -1  with v(0)=1, v'(0)=0
% with true solution v(t) = cos(t).
% Rewritten as a first order system.
% From  http://www.amath.washington.edu/~rjl/fdmbook/chapter5  (2007)


global fcnevals maxerror

t0 = 0;                      % initial time
u0 = [cos(t0); -sin(t0)];    % initial data for u(t) as a vector
tfinal = 2;                  % final time
fcnevals = 0;                % counter for number of function evaluations

% solve ode:
options = odeset('AbsTol',tol,'RelTol',tol);
odesolution = ode113(@f,[t0 tfinal],u0,options);

% plot v = u(1) as a function of t:
figure(1)
clf
t = linspace(0, tfinal, 500);
u = deval(odesolution, t);
v = u(1,:);
plot(t,v)
title('v(t) as a function of time')

% compare to true solution:
vtrue = cos(t);
hold on
plot(t,vtrue,'r')
hold off

maxerror = max(abs(v-vtrue));


%----------------------------------

function f = f(t,u);
global fcnevals

f1 = u(2);
f2 = u(1).^2 + u(2).^2 - u(1) - 1;
f = [f1; f2];

fcnevals = fcnevals + 1;

