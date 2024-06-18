
% decaytest
% test decay1 for various tolerances
%
% From  http://www.amath.washington.edu/~rjl/fdmbook/chapter8  (2007)

clear all
global fcnevals 

disp(' ')
disp('       tol         f evaluations')
disp(' ')
for tol = [1e-2 1e-4 1e-6 1e-8]
   decay2(tol)
   disp(sprintf('  %12.3e   %7i',tol,fcnevals))
   end
   
