
function c = fdcoeffV(k,xbar,x)

% Compute coefficients for finite difference approximation for the
% derivative of order k at xbar based on grid values at points in x.
%
% WARNING: This approach is numerically unstable for large values of n since
% the Vandermonde matrix is poorly conditioned.  Use fdcoeffF.m instead,
% which is based on Fornberg's method.
%
% This function returns a row vector c of dimension 1 by n, where n=length(x),
% containing coefficients to approximate u^{(k)}(xbar), 
% the k'th derivative of u evaluated at xbar,  based on n values
% of u at x(1), x(2), ... x(n).  
%
% If U is a column vector containing u(x) at these n points, then 
% c*U will give the approximation to u^{(k)}(xbar).
%
% Note for k=0 this can be used to evaluate the interpolating polynomial 
% itself.
%
% Requires length(x) > k.  
% Usually the elements x(i) are monotonically increasing
% and x(1) <= xbar <= x(n), but neither condition is required.
% The x values need not be equally spaced but must be distinct.  
%
% From  http://www.amath.washington.edu/~rjl/fdmbook/  (2007)

n = length(x);
if k >= n 
   error('***  length(x) must be larger than k')
   end

A = ones(n,n);
xrow = (x(:)-xbar)';  % displacements x-xbar as a row vector.
for i=2:n
   A(i,:) = (xrow .^ (i-1)) ./ factorial(i-1);
   end

b = zeros(n,1);    % b is right hand side,
b(k+1) = 1;        % so k'th derivative term remains

c = A\b;           % solve n by n system for coefficients
c = c';            % row vector
