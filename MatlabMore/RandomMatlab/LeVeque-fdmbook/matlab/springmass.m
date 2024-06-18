
function springmass

% springmass.m
% Oscillating spring-mass system
% Solves
%   z'' = (K/m)*(zstar - z - L) - g - (D/m) z'
% where z is the location of the mass and zstar is the location of the
% support (which may be a prescribed function of t)
%
% From  http://www.amath.washington.edu/~rjl/fdmbook/chapter5  (2007)

m = 1;     % mass
g = 9.8;   % gravitational constant
L = 2;     % rest length of spring
K = 10;     % spring constant
D = 0.2;    % damping coefficient

% specify motion of upper support for spring:
zstar = @(t) zeros(size(t));    % not moving, always at z = 0.

% zstar = @(t) 0.1*sin(5*t);    % Forced by motion of upper support.

t0 = 0;           % initial time
z0 = -2;          % initial location of mass
v0 = 0;           % initial velocity of mass
y0 = [z0; v0];    % initial data for y(t) as a vector
tfinal = 20;
f = @(t,y) springf(t,y,m,g,L,K,D,zstar);

% solve ode:
odesolution = ode45(f,[t0 tfinal],y0);

% plot z = y(1) as a function of t:
figure(1)
clf
t = linspace(0, tfinal, 500);
y = deval(odesolution, t);
subplot(2,1,1)
plot(t,y(1,:))
axis([0 tfinal -5 0])
title('z(t) as a function of time')


%%% simulation:

answerstring = input('Start simulation?  ','s');
if strcmp(answerstring,'y') | strcmp(answerstring,'yes') 

  figure(2)
  clf

  t = linspace(0, tfinal, 200);
  y = deval(odesolution, t);
  
  theta = linspace(0,2*pi,50);   % parameter for drawing circular mass
  rm = 0.2;                      % radius of mass
  xm = rm*cos(theta);            % x-cordinates of circle
  ym = rm*sin(theta);            % y-cordinates of circle
  
  s = linspace(0,1,100);         % parameter for drawing spring
  xs = rm*sin(10*pi*s);          % x-coordinates of spring
  
  dt = t(2) - t(1);              % time increment between plotting times
  
  for n=1:length(t)
     zstarn = zstar(t(n));       % location of support at time t(n)
     fill([-2*rm 2*rm 2*rm -2*rm -2*rm],...
          [zstarn zstarn zstarn+.2 zstarn+.2 zstarn],'b')   % plot upper support
     hold on
     plot(xs,zstarn-s*(zstarn-(y(1,n)+rm)))      % plot spring
     fill(xm,ym+y(1,n),'b')                % plot mass
     axis([-1 1 -5 2])
     daspect([1 1 1])
     drawnow                     % produce the plot
     pause(dt)                   % pause so that elapsed time is real time
     hold off
     end
  
  end  % running the simulation

%------------------------------------------------------------------------

function f = springf(t,y,m,g,L,K,D,zstar);

z = y(1);                    % position
v = y(2);                    % velocity
zstart = feval(zstar, t);    % location of upper support

f1 = v;
f2 = K/m * (zstart - z - L) -g - D/m * v;
f = [f1; f2];
