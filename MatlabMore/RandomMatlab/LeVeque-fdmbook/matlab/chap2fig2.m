%
% chap2fig2.m 
%
% second order finite difference method for the bvp
%   u'' = f, u'(ax)=sigma, u(bx)=beta
% Using 5-pt differences on an arbitrary grid.
%
% Produces Figure 2.2
% From  http://www.amath.washington.edu/~rjl/fdmbook/chapter2  (2007)


ax = 0;
bx = 1;
sigma = 0;
beta = 3;

f = @(x) exp(x);  % right hand side function
utrue = @(x) exp(x) + (sigma-exp(ax))*(x - bx) + beta - exp(bx);  % true soln

% Solve the problem for ntest different grid sizes to test convergence:
m1vals = [10 20 40 80];
ntest = length(m1vals);
hvals = zeros(ntest,1);  % to hold h values
E = zeros(ntest,1);      % to hold errors
u11 = zeros(11,2);  % to store 11-point solution for plotting

for approach=1:2
 for jtest=1:ntest
  m1 = m1vals(jtest);
  m2 = m1 + 1;
  m = m1 - 1;
  h = (bx-ax)/m1;
  hvals(jtest) = h;
  x = linspace(ax,bx,m2)';   % m+2 points counting the boundaries

  % set up matrix A (using sparse matrix storage):
  e = ones(m2,1);
  A = 1/h^2 * spdiags([e -2*e e], [-1 0 1], m2, m2);

  % fix up values in first and last row for BCs:
  A(1,1) = -1/h;
  A(1,2) = 1/h;
  A(m2,m1) = 0;
  A(m2,m2) = 1;
  
  % Right hand side:
  F = f(x);
  F(1) = sigma + h/2 * F(1) * (approach-1);  % Approach 1 or 2 from Section 2.12
  F(m2) = beta;
  
  % solve linear system:
  U = A\F;

  % compute errors:
  uhat = utrue(x);
  err = U - uhat;
  E(jtest,approach) = max(abs(err));  

  if jtest==1
     % save for plotting:
     x1 = x;
     u11(:,approach) = U;
     end
  end
 end

% plot solutions:
figure(1)
clf
xfine = linspace(ax,bx,101);
ufine = utrue(xfine);
plot(xfine,ufine)
hold on
plot(x1,u11(:,1),'+')
plot(x1,u11(:,2),'o')
hold off
axis([-.1 1.1 2.2 3.2])
set(gca,'fontsize',15)

% log-log plot of errors:
figure(2)
clf
loglog(hvals,E(:,1),'+-')
hold on
loglog(hvals,E(:,2),'o-')
hold off
axis([5e-3 .2 1e-5 1])
set(gca,'fontsize',15)

