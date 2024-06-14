function [ p ,v, d ] = poeq_eigs(Q) 
% POEQ_EIGS solves for the equilibrium probability vector of a given Q matrix using EIGS.  
% See also POEQ_DIRECT. 
% 
% EXAMPLES 
% 
% Q = [ -0.4 0.1 0.3; 0.2 -0.2 0 ; 0.1 0 -0.1]  
% [ p, v, d ] = poeq_eigs(Q) 
% bar(p)

dt=1e-8;

opts.disp = 0;

[ v, d ] = eigs( (speye(size(Q))+Q*dt)', 1, 1, opts);
p = v/sum(v);
p = p(:)';


return