function plotBL(rho,sigma,axisbox)
%
% plot the boundary locus for the region of absolute stability of a Linear
% Multistep Method with characteristic polynomials rho and sigma.
%
% axisbox = axis region 
%           (if omitted, default values are used that may be a poor choice)
%
% See also makeplotBL.m, from which this routine is called for a variety of
% specific LMMs.
%
% From  http://www.amath.washington.edu/~rjl/fdmbook/chapter7  (2007)

if nargin==3
    xa = axisbox(1); xb = axisbox(2); ya = axisbox(3); yb = axisbox(4);
  else
    xa = -10; xb = 10; ya = -10; yb = 10;  % default values
  end


clf
theta = linspace(0, 2*pi, 1001);
eitheta = exp(1i * theta);
z = rho(eitheta) ./ sigma(eitheta);
plot(real(z), imag(z))
box on
hold on

% plot axes:
plot([xa xb],[0 0],'k')
plot([0 0],[ya yb],'k')
axis([xa xb ya yb])
set(gca,'FontSize',15)
hold off

