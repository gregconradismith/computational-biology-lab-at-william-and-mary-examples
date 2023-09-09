
clear
clc
close all

tt = 0:0.02:1;
 
t = rand(1,20); t = sort(t);
x = rand(1,20); 

xx = interp1(t,x,tt);


plot(t,x,'or-',tt,xx,'og');
axis([0 1 0 1])
