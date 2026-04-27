% plotSrkc.m
%
% call plotS to plot the region of absolute stability S 
% for a Runge-Kutta-Chebyshev method of order 1 or 2.
%
% Requires
%     chebpoly.m, chebpoly1.m, chebpoly2.m
%     plotS.m from chapter7.
%
% From  http://www.amath.washington.edu/~rjl/fdmbook/chapter8  (2007)


order = 1;            % order of accuracy (1 or 2)
r = 6;                % number of stages
epsilon = 0.05;       % damping parameter

disp(' ' )
if plotOS
    disp(['Plotting S and OS for RKC method with s = ' num2str(s)])
  else
    disp(['Plotting S for RKC method with s = ' num2str(s)])
  end
disp(['  order = ' num2str(order)])
disp(['  epsilon = ' num2str(epsilon)])

if order==1
    % first-order Runge-Kutta-Chebyshev method:
    beta = 2*r^2;
    w0 = 1 + epsilon/r^2;
    w1 = chebpoly(r,w0) / chebpoly1(r,w0);
    R = @(z) chebpoly(r, w0 + w1*z) ./ chebpoly(r,w0);

  elseif order==2
    % second-order Runge-Kutta-Chebyshev method:
    w0 = 1 + epsilon/r^2;
    Trp = chebpoly1(r,w0);
    Trpp = chebpoly2(r,w0);
    w1 = Trp / Trpp;
    beta = (w0+1)*Trpp / Trp;
    br = Trpp / (Trp^2);
    ar = 1 - br*chebpoly(r,w0);
    R = @(z) ar + br*chebpoly(r, w0 + w1*z);

  else
    error('order must be 1 or 2')
  end

ylim = max(10, 2*r);
axisbox = [-beta-2 5 -ylim ylim];

% Now that R is set, plot S:
plotS(R,0,axisbox)

