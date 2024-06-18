function [ m ] = kqcheck(varargin) 
% KQCHECK checks to make sure that a Q or a K matrix is valid and returns the size
% M.  If multiple matrices can be passed, the matrices must be square and of
% the same size.  
% 
% The last argument must be the flag 'd' or 'nod'. 
% 
%    'd' indicates that the diagonal entries must be such that row sum is zero. 
%    
%    'nod' indicates that the diagonal entries must be zero. 
% 
% EXAMPLE 
% 
% kqcheck([ -0.1 0.1 ; 0.2 -0.2 ],'d') 
% kqcheck([  0 0.1 ; 0 0 ],[  0 0 ; 0.2 0 ],'nod') 

rowsumtol = 1e-10;
myopt = varargin{nargin}; 

for i = 1:nargin-1 % for each matrix

   K = varargin{i};

   % Check that K is square 
   [ m, n(i) ] = size(K);
   if m ~= n(i) 
      error([ 'KQCHECK says: matrix ' num2str(i) ' is not square.']);
   end

   % Check the diagonal elements 
   if myopt == 'nod' 
      if find( diag(K) ~= 0 ) 
         error([ 'KQCHECK says: matrix ' num2str(i) ' has nonzero diagonal element(s).']);
      end  
   elseif myopt == 'd' 
      if sum(sum(K,2) > rowsumtol )
         error([ 'KQCHECK says: matrix ' num2str(i) ' has nonzero row sum.']);
      end  
   else 
      error([ 'KQCHECK says: last argument must be the option d or nod.']);
   end

   % Check that off-diagonal elements are non-negative 
   K(find(speye(m,m)==1))=0; % zero out diagonal elements of K 
   if find( K < 0 ) 
      error([ 'KQCHECK says: matrix ' num2str(i) ' has negative off-diagonal element(s).']);
   end

end

if length(unique(n)) > 1 
      error([ 'KQCHECK says: all matrices are not the same size.']);
end 

return



