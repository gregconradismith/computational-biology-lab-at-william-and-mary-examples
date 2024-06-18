% makeplotBL.m
%
% call plotBL to plot the boundary locus of the stability region S
% for a specific Linear Multistep Method.
%
% From  http://www.amath.washington.edu/~rjl/fdmbook/chapter7  (2007)

method = 'AM';     % set to desired method or class, see choices below
r = 2;             % for r-step classes of methods

disp(' ' )
disp(['Plotting boundary locus of S for method ',method])

switch method

  case 'euler'
     rho = @(z) -1 + z;
     sigma = @(z) 1;
     axisbox = [-3 1 -2 2];

  case 'AB'
     axisbox = [-3 1 -2 2];
     rho = @(z) (z-1) .* z.^(r-1);

     switch r
       case 1 
         sigma = @(z) ones(size(z));
       case 2 
         sigma = @(z) (3*z - 1)/2;
       case 3 
         sigma = @(z) ((23*z - 16) .* z +5) / 12;
       case 4 
         sigma = @(z) (((55*z - 59).*z +37).*z - 9) / 24;
       case 5 
         sigma = @(z) ((((1901*z - 2774).*z +2616).*z -1274).*z + 251) / 720;
       end

  case 'AM'
     axisbox = [-7 1 -4 4];
     rho = @(z) (z-1) .* z.^(r-1);

     switch r
       case 1 
         sigma = @(z) (z + 1)/2;
       case 2 
         sigma = @(z) ((5*z + 8).*z -1) / 12;
       case 3 
         sigma = @(z) (((9*z + 19).*z -5).*z +1) / 24;
       case 4 
         sigma = @(z) ((((251*z + 646).*z - 264).*z + 106) -19).*z / 720;
       case 5 
         sigma = @(z) (((((475*z + 1427).*z - 798).*z + 482).*z ...
                       - 173).*z + 27)/ 1440;
       end
          
     axisbox = [-5 5 -5 5];

  otherwise
     disp(' *** method not recognized')
  end

plotBL(rho,sigma,axisbox)

