function paramfit2D

% main program for fitting parameters of an ODE model to data
% the model and the error function are defined in the file Sfun2D.m

clearvars -global
global tdata xdata x0

%% data for the model
% time  - value of 1st variable - value of 2nd variable 

tdata(1) = 0.5; xdata(1,1) = 99;   xdata(1,2) = 2;    
tdata(2) = 1;   xdata(2,1) = 98;   xdata(2,2) = 4;   
tdata(3) = 5;   xdata(3,1) = 50;   xdata(3,2) = 35;  
tdata(4) = 20;  xdata(4,1) = 3;    xdata(4,2) = 7;   

%% initial conditions

x0(1) = 100;
x0(2) = 1;

%% initial guess of parameter values

b(1) = 0.01;
b(2) = 0.2;

%% minimization step

[bmin, Smin] = fminsearch(@Sfun2D,b);

disp('Estimated parameters b(i):');
disp(bmin)
disp('Smallest value of the error S:');
disp(Smin)

end
