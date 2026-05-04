% John Conway's Game of Life

close all; clc; clear

set(0,'defaultAxesFontSize',24)
set(0,'defaultTextFontSize',24)

m = 100; X = spalloc(m,m,m^2/10);

% Initial Condition
c = round(m/2); % the center

% Random
X = sprand(m,m,0.5)>0;

% Blinker
% X(c,c-1)=1; X(c,c)=1; X(c,c+1)=1;

% Glider
% X(c,c-1)=1; X(c,c)=1; X(c,c-2)=1; X(c-1,c)=1; X(c-2,c-1)=1;

% R-pentomino
% X(c,c-1)=1; X(c,c)=1; X(c,c+1)=1; X(c-1,c-1)=1; X(c+1,c)=1; 

% Define shifted indices
m = [m 1:m-1]; p = [2:m 1];

maxgen = 1e3;
for g = 0:maxgen
    % Update plot
    spy(X,20)
    set(gca,'XTick',[],'YTick',[]) % Second argument is markersize
    title(['Generation ' num2str(g) ])
    drawnow
   
    % How many of eight neighbors are alive
    N = X(p,:) + X(m,:) + X(:,p) + X(:,m) + ...
        X(p,p) + X(p,m) + X(m,p) + X(m,m);
    
    % A live cell with two live neighbors, or any cell with three
    % neigbhors, is alive at the next time step
    X = (X & (N == 2)) | (N == 3);
end