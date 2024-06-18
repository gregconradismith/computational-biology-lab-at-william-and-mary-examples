%
% bvpspectral.m 
% pseudospectral finite difference method for the bvp
%   u''(x) = f(x),   u'(ax)=sigma,   u(bx)=beta
% The use of Chebyshev grid points gives a very accurate method.
% With a uniform grid it is quite accurate for small m, but unstable as
% m increases.
%
% Different BCs can be specified by changing the first and/or last rows of 
% A and F.
%
% From  http://www.amath.washington.edu/~rjl/fdmbook/chapter2  (2007)

ax = 0;
bx = 3;
sigma = -5;   % Neumann boundary condition at ax
beta = 3;     % Dirichlet boundary condtion at bx

f = @(x) exp(x);  % right hand side function
utrue = @(x) exp(x) + (sigma-exp(ax))*(x - bx) + beta - exp(bx);  % true soln

% true solution on fine grid for plotting:
xfine = linspace(ax,bx,101);
ufine = utrue(xfine);

% Solve the problem for ntest different grid sizes to test convergence:
m1vals = [5 10 15 20];   % note: fewer points than used for other methods
ntest = length(m1vals);
hvals = zeros(ntest,1);  % to hold h values
E = zeros(ntest,1);      % to hold errors

for jtest=1:ntest
  m1 = m1vals(jtest);
  m2 = m1 + 1;
  m = m1 - 1;                 % number of interior grid points
  hvals(jtest) = (bx-ax)/m1;  % average grid spacing, for convergence tests

  % set grid points:  
  gridchoice = 'chebyshev';
  x = xgrid(ax,bx,m,gridchoice);   

  % set up matrix A:
  A = zeros(m2,m2);      % initialize (A is dense)

  % first row for Neumann BC at ax:
  A(1,:) = fdcoeffF(1, x(1), x);

  % interior rows:
  for i=2:m1
     A(i,:) = fdcoeffF(2, x(i), x);
     end

  % last row for Dirichlet BC at bx:
  A(m2,:) = fdcoeffF(0,x(m2),x);

  
  % Right hand side:
  F = f(x); 
  F(1) = sigma;  
  F(m2) = beta;
  
  % solve linear system:
  U = A\F;


  % compute error at grid points:
  uhat = utrue(x);
  err = U - uhat;
  E(jtest) = max(abs(err));  
  disp(' ')
  disp(sprintf('Error with %i points is %9.5e',m2,E(jtest)))

  clf
  plot(x,U,'o')  % plot computed solution
  title(sprintf('Computed solution with %i grid points',m2));
  hold on
  plot(xfine,ufine)  % plot true solution
  hold off
  
  % pause to see this plot:  
  drawnow
  input('Hit <return> for next plot ');
  
  end

error_table(hvals, E);   % print tables of errors and ratios
error_loglog(hvals, E);  % produce log-log plot of errors and least squares fit

