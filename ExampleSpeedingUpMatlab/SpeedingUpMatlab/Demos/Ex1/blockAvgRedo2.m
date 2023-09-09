%   Copyright 2007-2009 The MathWorks, Inc.
%   Last Edited: S. Wait Zaranek 4/14/2009

 function blockAvgRedo2(Nx,Ny,Nxavg,Nyavg)
%% Example 1, Redo 2
% Input values Nx, Ny = 1500, Nxavg, Nyavg = 25;
%
% Want to create a surface and look at it averaged over a
% a particular resolution

%% Initial Parameter Values

tic

Lx = 10; % Length of x dimension
Ly = 10; % Length of y dimension

x = linspace(1,Lx,Nx);  % Creating x vector
y = linspace(1,Ly,Ny);  % Creating y vector

%% Setting up values of surface on grid

% Precomputation of inputs
[ygrid,xgrid] = meshgrid(y,x);

mysurf = 5*cos((xgrid+ygrid)*2*pi)+...
    2*sin(xgrid*2*pi)+2*cos(xgrid*2*pi);








%% Averaging values over the grid

% Average x and y positions
xavg = x(Nxavg:Nxavg:Nx)- 0.5*(x(Nxavg)-x(1));
yavg = y(Nyavg:Nyavg:Ny)- 0.5*(y(Nyavg)-y(1));


% Cropping and reshaping and summing
newX = (1:floor(Nx/Nxavg)*Nxavg);  % removing excess points 
newY = (1:floor(Ny/Nyavg)*Nyavg);  % not used in averaging

mysurf_avg = sum(reshape(mysurf(newX,newY),Nxavg,[]));
mysurf_avg = reshape((1/Nxavg)* mysurf_avg,floor(Nx/Nxavg),[]);

mysurf_avg = sum(reshape(mysurf_avg',Nyavg,[]));
mysurf_avg = reshape((1/Nyavg)* mysurf_avg,floor(Ny/Nxavg),[])';

toc













%% Plotting the results to compare

ax(1) = subplot(2,1,1);
plot1 = pcolor(y,x,mysurf);
set(plot1,'EdgeColor','none');
title('Original Function');
axis off

ax(2) = subplot(2,1,2);
plot2 = pcolor(yavg,xavg,mysurf_avg);
set(plot2,'EdgeColor','none');
title('Averaged Function');
axis off

linkaxes(ax,'x');