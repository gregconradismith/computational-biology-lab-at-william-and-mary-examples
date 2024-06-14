function [p,Q,b] = poeq_leastsquares(Q)

% EXAMPLES 
% 
% Q = [ -0.4 0.1 0.3; 0.2 -0.2 0 ; 0.1 0 -0.1]  
% [ p,Q,b ] = poeq_leastsquares(Q) 
% bar(p)

[n,n]=size(Q);
b = zeros(n+1,1); b(end)=1; 
Q = [Q ones(n,1)];

p = Q'\b;
p = p'; % make a row vector

return