function [ Kp1sub, Km1sub, U1sub, G1sub ] = kfourstate3(kap,kam,kbp,kbm,kcp,kcm,kdp) 
% KFOURSTATE calculates the the association rate constant matrix and the
% dissociation rate matrix for a four-state calcium channel model. 
%
% KP1SUB and KM1SUB are the matrices for 1 subunit. Note that we are also
% sometimes interested in the matrices for an entire channel composed of 4
% identical subunits (see KFOURSTATE35).
% 
% 
%             kbp*ca 
%         2-------------3 
%         |     kbm     | 
%         |             | 
%  kap*ca | kam  kcp*ca | kcm
%         |             | 
%         |   kdp*ca    | 
%         1-------------4 
%               kdm
% 
% EXAMPLE: 
%  
% [ Kp1sub, Km1sub, U1sub, G1sub ] = kfourstate(0)
%  

if (0) % Use parameter choices consistent with DeYoung and Keizer 1992:  
   ip3=2; 
   a2=0.2; a4=0.2; a5=20; d1=0.13; d2=1.049; d4=0.144552; d5=0.08234;
   d3=d1*d2/d4; % thermodynamic constraint
   b2=a2*d2; b4=a4*d4; b5=a5*d5; % auxilary parameters (dissociation rate constants)  
   ip = ip3/(ip3+d1); im = 1-ip; 
   jp = ip3/(ip3+d3); jm = 1-jp; 

   % convert to four-state notation 
   % calcium activation rate does not depend on IP3 
   kap = a5; kam = b5; kcp = a5; kcm = b5;   
   % calcium inactivation rate does depend on IP3 
   kbp = a2*ip+a4*im; kbm = b2*ip+b4*im; 
   kdp = a2*jp+a4*jm; kdm = b2*jp+b4*jm; 

else % Use other parameters 
   % kap = 0.1; kam = 1; kbp = 0.1; kbm = 1; kcp = 1; kcm = 1; kdp = 0.01; 
   % kap = 0.1; kam = 1; kbp = 0.01; kbm = 1; kcp = 1; kcm = 1; kdp = 0.01; 
   % kdm=kdp*kam/kap*kbm/kbp/(kcm/kcp); % thermodynamic constraint
   % kap = 1; kam = 10; kbp = 10; kbm = 10; kcp = kap; kcm = kam; kdp = kbp;
   kdm=kdp*kam/kap*kbm/kbp/(kcm/kcp);
   % eps here is just so I'm not dividing by zero when kbp is set to zero
end 

% 
% One subunit 
% 

%                  (1)  (2)  (3)  (4)  
Kp1sub = sparse( [ 0    kap  0    kdp  ; ... % (1) 
                   0    0    kbp  0    ; ... % (2) 
                   0    0    0    0    ; ... % (3) 
                   0    0    kcp  0    ] ) ; % (4)  

%                  (1)  (2)  (3)  (4)  
Km1sub = sparse( [ 0    0    0    0    ; ... % (1) 
                   kam  0    0    0    ; ... % (2) 
                   0    kbm  0    kcm  ; ... % (3) 
                   kdm  0    0    0  ] ) ; % (4)  

U1sub = spones([ 0 1 0 0 ]); 

%G1sub = [ 0 1 2 2 ]; % closed open refractory 
G1sub = [ 0 1 2 3 ]; % phi, A, AI, I 

Km1sub = Km1sub - diag(sum(Km1sub,2)); 
Kp1sub = Kp1sub - diag(sum(Kp1sub,2)); 


return
