% spanning trees of P_3^(2) 

clc
clear

syms ab_a ab_b ab_c ba_a ba_b ba_c bc_a bc_b bc_c cb_a cb_b cb_c

% a2 ab ac b2 bc c2 
% 4   8  8  4  8  4 
X = [ 0       2*ab_a 0      0       0       0 ; 
      ba_a   0       bc_a  ab_b   0       0 ; 
      0       cb_a   0      0       ab_c   0 ; 
      0       2*ba_b 0      0       2*bc_b 0 ; 
      0       0       ba_c  cb_b   0       bc_c ; 
      0       0       0      0       2*cb_c 0 ];

X = diag(sum(X,2))-X;

X

for i=1:6
a=[1:(i-1) (i+1):6];
i
detX(i)=det(X(a,a));
detX(i)=simplify(detX(i));
disp(detX(i))
end


