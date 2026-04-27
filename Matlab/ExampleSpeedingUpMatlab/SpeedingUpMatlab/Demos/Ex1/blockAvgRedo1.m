%   Copyright 2007-2009 The MathWorks, Inc.
%   Last Edited: S. Wait Zaranek 4/14/2009

function blockAvgRedo1(Nx,Ny,Nxavg,Nyavg)
%% Example 1, Redo 1
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

% Preallocation
mysurf = zeros(length(x),length(y));

for i = 1:length(x)
    for j = 1:length(y)
        yp = y(j);
        xp = x(i);
        mysurf(i,j) = 5*cos((xp+yp)*2*pi)+...
            2*sin(xp*2*pi)+2*cos(xp*2*pi);
    end
end


%% Averaging values over the grid

% Preallocation
mysurf_avg = zeros(floor(length(x)/Nxavg),floor(length(y)/Nyavg));
xavg = zeros(1,floor(length(x)/Nxavg));
yavg = zeros(1,floor(length(y)/Nyavg));

for i = Nxavg:length(x)
    for j = Nyavg:length(y)
         if (mod(j,Nyavg)==0 && mod(i,Nxavg)==0)
          
           idown = i-Nxavg+1;
           jdown = j-Nyavg+1;
           iup = i;
           jup = j;
           
           iavg = floor(i/Nxavg);
           javg = floor(j/Nyavg);
           
           mysurf_avg(iavg,javg) =...
               sum(sum(mysurf(idown:iup,jdown:jup)))/(Nxavg*Nyavg);
           
           xavg(iavg) = (x(iup)+x(idown))/2;
           yavg(javg) = (y(jup)+y(jdown))/2;
           
         end
    end
end

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