
% odesampletest
% test odesample for various tolerances
%
% From  http://www.amath.washington.edu/~rjl/fdmbook/chapter5  (2007)

clear all
global fcnevals maxerror

disp(' ')
disp('       tol          max error    f evaluations')
disp(' ')
for tol = logspace(-1,-13,13)
   odesample(tol)
   disp(sprintf('  %12.3e   %12.3e   %7i',tol,maxerror,fcnevals))
   end
   
