function plotS(R,plotOS,axisbox)
%
% plot S, the region of absolute stability for the rational function R(z).
%
% If plotOS=1 then also plot the Order Star (complement of the 
% region of relative stability) 
%
% Typically R(z) is an approximation to exp(z) obtained by applying a 
% finite difference method to y' = lambda y, where z = dt*lambda.
%
% axisbox = axis region 
%           (if omitted, default values are used that may be a poor choice)
%
% See also makeplotS.m, from which this routine is called for a variety of
% specific R(z) functions.
%
% From  http://www.amath.washington.edu/~rjl/fdmbook/chapter7  (2007)

if nargin==1     % if only one input argument R:
   plotOS = 0;   % defaults to plotting only S.
   end

if nargin==3
    xa = axisbox(1); xb = axisbox(2); ya = axisbox(3); yb = axisbox(4);
  else
    xa = -10; xb = 10; ya = -10; yb = 10;  % default values
  end

% compute ratio R(z) over a fine grid on the region [xa,xb] x [ya,yb]

nptsx = 501;
nptsy = 501;
x = linspace(xa,xb,nptsx);
y = linspace(ya,yb,nptsy);
[X,Y] = meshgrid(x,y);
Z = X + 1i*Y;
Rval = feval(R,Z);

%----------------------------------------------------------------------
% Plot S, region of absolute stability:

Rabs = abs(Rval);

% plot Rabs with a color map that is shaded in S (where Rabs < 1)
% and which in complement (where Rabs > 1).

figure(1)
clf
surf(x,y,0*Rabs,Rabs,'EdgeColor','none')
view(2)
colormap([.7 .7 1;1 1 1])
%colormap([.7 .7 .7;1 1 1])   % grayscale
caxis([.99 1.01])
daspect([1 1 1])
hold on
contour(x,y,Rabs,[1 1],'k')
box on
hold off
title('Region of absolute stability','FontSize',15)
% plot axes:
hold on
plot([xa xb],[0 0],'k')
plot([0 0],[ya yb],'k')
axis([xa xb ya yb])
set(gca,'FontSize',15)
hold off

if ~plotOS, return, end

%----------------------------------------------------------------------
% Plot order star, complement of region of relative stability:

Rrel = abs(Rval ./ exp(Z));

% plot Rrel with a color map that is shaded in order star (where Rrel > 1)
% and white in complement (where Rrel < 1).

figure(2)
clf
surf(x,y,0*Rrel,Rrel,'EdgeColor','none')
view(2)
colormap([1 1 1; .7 .7 1])
%colormap([1 1 1; .7 .7 .7])   % grayscale
caxis([.99 1.01])
daspect([1 1 1])
hold on
contour(x,y,Rrel,[1 1],'k')
box on
hold off
title('Order Star','FontSize',15)
% plot axes:
hold on
plot([xa xb],[0 0],'k')
plot([0 0],[ya yb],'k')
axis([xa xb ya yb])
set(gca,'FontSize',15)
hold off

