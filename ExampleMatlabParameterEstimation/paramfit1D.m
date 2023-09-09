function paramfit1D
% main program for fitting parameters of an ODE model to data
% the model and the error function are defined in the file Sfun1D.m
clearvars -global
global tdata xdata x0

%% data for the model
% time - x value
tdata(1) = 0.5; xdata(1) = 0.5;
tdata(2) = 1;   xdata(2) = 1.2;
tdata(3) = 5;   xdata(3) = 2.5;
tdata(4) = 30;  xdata(4) = 2.7;

%% initial condition
x0(1) = 0;

%% initial guess of parameter values
b(1) = 1;
b(2) = 0.5;

%% minimization step
[bmin, Smin] = fminsearch(@Sfun1D,b);
disp('Estimated parameters b(i):');
disp(bmin)
disp('Smallest value of the error S:');
disp(Smin)

end