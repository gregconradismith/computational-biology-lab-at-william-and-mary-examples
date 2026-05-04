%% An exploration of "Euclidian Primes" 
% myprimes.m
%

clc
clear

imax=12;

p(1)=vpi(2); p(2)=vpi(3); i=3;
while i<imax
    p(i)=prod(p)+1;
    disp('------------------------------------------------------------------------')
    disp(['Euclidian Prime #' num2str(i) ':'])
    disp(p(i))
    i=i+1;
    
end    

 