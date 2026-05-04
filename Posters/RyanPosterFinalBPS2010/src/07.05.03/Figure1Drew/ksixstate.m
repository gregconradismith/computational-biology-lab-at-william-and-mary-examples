function [ Kp1sub, Km1sub, U1sub, G1sub ] = ksixstate(kap,kam,kbp,kbm,kcp,kcm,kdp,kdm,kep,kem,kfp,kfm) 
% KTHREESTATE calculates the the association rate constant matrix and the
% dissociation rate matrix for a three-state calcium channel model. 

 

%                  (1)  (2)  (3)    
Kp1sub = sparse( [ 0    kap  0       0     0     0; ... % (1) 
                   0    0    2*kbp   2*kep 0     0; ... % (2) 
                   0    0    0       0     2*kcp 0;
                   0    0    0       0     kdp   0;
                   0    0    0       0     0     2*kfp;
                   0    0    0       0     0     0] ); % (6)  

%                  (1)  (2)  (3)    
Km1sub = sparse( [ 0     0      0       0      0     0; ... % (1) 
                   2*kam 0      0       0      0     0; ... % (2) 
                   0     2*kbm  0       0      0     0;
                   0     kem    0       0      0     0;
                   0     0      2*kcm   2*kdm  0     0;
                   0     0      0       0      kfm    0] ) ; % (6)  
U1sub = spones([ 0 0 0 1 0 0]); 

G1sub = spones([ 0 0 0 1 0 2]); 




return
