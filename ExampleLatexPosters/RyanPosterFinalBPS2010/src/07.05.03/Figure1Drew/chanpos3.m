function [ x, y ] = chanpos3(n,distribution,R)
% CHANPOS3 (version 3) generates a two column vectors with the X and Y
% coordinates of N channel spatially distributed in one of four manners: 
% 
% 'uniform' : according to a uniform distribution on a disc of radius R.  N is
% the number of channels so that the resulting density on disc is N/(pi*R^2). 
% 
% 'exponential' : with uniformly distributed polar angle and radius distributed
% exponentially with parameter R.  N is the number of channels. 
% 
% 'gaussian' : with uniformly distributed polar angle and radius distributed as
% exp(-r^2/R^2).  N is the number of channels.  R is the standard deviation. 
% 
% 'grid' : arranged on a Cartesian grid with radius R. N adjusted upwards to
% fill out the grid if necessary. 
% 
% 'honeycomb' : arranged on a triangular grid with radius R. N is adjusted upwards
% to fill out the grid if necessary. 
% 
% EXAMPLES: 
% 
% [ x, y ] = chanpos3(100,'uniform',10) 
%
% [ x, y ] = chanpos3(20,'exponential',5) 
%
% [ x, y ] = chanpos3(100,'gaussian',10) 
%
% [ x, y ] = chanpos3(25,'grid',10) 
%
% [ x, y ] = chanpos3(19,'honeycomb',0.6)
%

if n == 1, x=0; y=0; return; end

if strcmp(distribution,'uniform')
   %disp('uniform'); 
   np = n*4; % expected number of misses plus safety 
   x = R*(2*rand(np,1)-1); 
   y = R*(2*rand(np,1)-1); 
   rs = x.^2+y.^2; 
   a = find(rs < R^2);
   x=x(a(1:n)); y=y(a(1:n));
elseif strcmp(distribution,'exponential')
   %disp('exponential');
   th = 2*pi*rand(n,1); 
   r = -R*log(rand(n,1)); 
   [ x, y ] = pol2cart(th,r);
elseif strcmp(distribution,'gaussian')
   %disp('gaussian');
   th = 2*pi*rand(n,1); 
   r = R*abs(randn(n,1))/(2/sqrt(2*pi)); % this should make R the mean distance from origin 
   [ x, y ] = pol2cart(th,r);
elseif strcmp(distribution,'grid')
   %disp('grid');
   n = ceil(sqrt(n));
   [ x, y ] = meshgrid(1:n,1:n);
   if n>1
     x = x/(n-1)*2*R; y = y/(n-1)*2*R;
   end
   x = x - mean(mean(x)); y = y - mean(mean(y)); 
   x = reshape(x,n^2,1); y = reshape(y,n^2,1);
elseif strcmp(distribution,'honeycomb')
   %disp('honeycomb');
   % number of channels is given by n=1+3*i*(i-1) where i = 1, 2, 3, ... and n = 1, 7, 19, ... 
   % i is one more than radius  
   i=1; 
   while n>1+3*i*(i-1) 
      i=i+1; 
   end
   %n = 1+3*i*(i-1); 
   radius = i-1; % don't need i anymore
   %R;
   dx = R/radius;
   x = (-radius:radius)*dx;
   y = zeros(size(x));
   for i = 1:radius
      xnew = (-radius+i*0.5:radius-i*0.5)*dx;
      x = [ x xnew xnew ];
      ynew = i*sqrt(3)/2*dx*ones(1,length(xnew));
      y = [ y ynew -ynew ];
   end
   
else
   error('Sorry, chanpos does not know that distribution.');
end

if 0 
x
y
plot(x,y,'ob'); hold on; plot(x,y,'+r'); hold off;
axis square
axis equal 
axis([-2*R 2*R -2*R 2*R ])
end

return 

