% myscramble.m

clc; close all; clear;

ActualType = [ 2 2 2 1 1 1 2 NaN 2 2 2 2 2 1 1 1 1 ];

% 7 type 1 and 9 type 2
% scramble so that 7:9 odds are fixed 
% and exactly 8 of the 16 change type
% pick four 1's and four 2's to change state

N=10;
Scramble=zeros(N,length(ActualType));
Scramble(1,:)=ActualType;

for i=2:N

a1 = find(ActualType==1);
a2 = find(ActualType==2);

b1=randsample(a1,4,'false'); % without replacement 
b2=randsample(a2,4,'false'); % 
 
scram = ActualType; scram(b1)=2; scram(b2)=1;

Scramble(i,:)=scram;  

end

Scramble 
 

