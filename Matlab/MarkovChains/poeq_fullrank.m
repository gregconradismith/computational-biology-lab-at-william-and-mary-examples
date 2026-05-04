function [p,Q,Qbar,b] = poeq_fullrank(Q)

% EXAMPLES 
% 
% Q = [ -0.4 0.1 0.3; 0.2 -0.2 0 ; 0.1 0 -0.1]  
% [p,Q,Qbar,b] = poeq_fullrank(Q) 
% bar(p)

[n,n]=size(Q);
b = zeros(n,1); b(end)=1;  
Qbar = [Q(:,1:end-1) ones(n,1)];

p = Qbar'\b;
p = p'; % make a row vector

return