function [ C ] = coupling2(xch,ych,ica,D,lambda,ra)
% COUPLING calculates the coupling matrix C = (c_{ij}) that gives the  steady
% state Ca2+ concentration contributed from channel i to channel j  for a given
% release site spatial  configuration. XCH and YCH are channels positions and
% the channel number corresponds to these indices.  ICA, D, LAMBDA, and CAINF
% are parameters need for the SSEBA.  RA is the distance between the pore and
% binding site of each channel and is used to calculate the diagonal elements
% (i.e., 'domain' calcium).

sigma = ica*(5182.4211); % convert from pA to umoles/s
% Note: 5182.4211 is 1/(2*9.648)*100000; this has not taken hemispherical
% symmetry into account, the 2 is for the valence of Ca2+.

N = length(xch);  
C = zeros(N);
flag = 0; 

for i = 1:N
   C(i,i) = C(i,i) +1/(4*pi*D)*sigma/ra*exp(-ra/lambda);
end

for i = 1:N
  for j = [ 1:i-1 i+1:N ] % off-diagonal    
     rho = sqrt( (xch(i) - xch(j)).^2 + (ych(i) - ych(j)).^2 + ra^2);  
     C(i,j) = C(i,j) +1/(4*pi*D)*sigma./rho.*exp(-rho/lambda);
     if C(i,j) > C(i,i), flag = 1; end
  end
end
       
if flag 
   disp('COUPLING says: diagonal elements of C are too small to represent domain calcium.')
end

return 

