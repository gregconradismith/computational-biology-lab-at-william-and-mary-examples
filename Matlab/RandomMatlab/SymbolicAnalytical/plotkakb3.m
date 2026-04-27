
clc
clear 
close all

syms z1 z2 z3 A1 real positive

 
A1 = z1*[ 0 0 1 1 ; 0 0 0 1 ; 1 0 0 0 ; 1 1 0 0 ]
rank(A1)
Arref = rref(A1)

syms a abar b bbar c cbar real

x1 = [ abar b bbar c ]'

x1A1x1 = collect(x1'*A1*x1,[ z1 abar b bbar c ])

[VA1,DA1] = eig(A1)

  
 