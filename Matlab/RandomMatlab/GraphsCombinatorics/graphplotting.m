% graph drawing
close all
clc
clear all

%% Example  

graph_type = 1; % 1 = ER, 2 = other 


if graph_type == 1 % ER network 
    N=20;
    p=0.1;
    A = (rand(N,N)<p); 
elseif graph_type == 2 % Other 
    N=50;
    
    A11 = (rand(N/2,N/2)<0.1); 
    A12 = (rand(N/2,N/2)<0.0); 
    A21 = (rand(N/2,N/2)<0.0); 
    A22 = (rand(N/2,N/2)<0.8); 
    
    A = [ A11 A12 ; A21 A22];
else
    error('Need graph_type to be 1 or 2')
end


% xy = rand(N,2); % random positions 

dphi = 2*pi/(N-1);
phi = 0:dphi:2*pi; phi=phi(:); % col vec
xy = [ cos(phi) sin(phi) ];

figure
gplot(A,xy,'b-'); hold on;
plot(xy(:,1),xy(:,2),'ro','MarkerSize',10); 

axis equal
axis square


return

