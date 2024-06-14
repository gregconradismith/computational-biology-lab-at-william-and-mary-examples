function [ Kp1sub, Km1sub, U1sub ] = kthreestate(kap,kam,kbp,kbm) 
% KTHREESTATE calculates the the association rate constant matrix and the
% dissociation rate matrix for a three-state calcium channel model. 

 

%                  (1)  (2)  (3)    
Kp1sub = sparse( [ 0    kap  0    ; ... % (1) 
                   0    0    kbp  ; ... % (2) 
                   0    0    0    ] ) ; % (3)  

%                  (1)  (2)  (3)    
Km1sub = sparse( [ 0    0    0    ; ... % (1) 
                   kam  0    0    ; ... % (2) 
                   0    kbm  0    ] ) ; % (3)  

U1sub = spones([ 0 0 1 ]); 



return




