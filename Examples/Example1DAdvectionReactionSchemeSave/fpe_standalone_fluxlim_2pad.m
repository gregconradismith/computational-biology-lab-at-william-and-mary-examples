function fpe_standalone_fluxlim_2pad

clc
clear
close all

global f dt df pmat pintegral
global F Fm2 Fm1 Fp1 Fp2 am3h am1h ap1h ap3h

dt = 0.01; endtime = 200*dt; lenf = 1000;
fmin = 0; fmax = 1;

df=(fmax-fmin)/(lenf-1);
f=fmin:df:fmax; % row vector
fpad = [ f(1)-2*df f(1)-df f f(end)+df f(end)+2*df ]; % two extra points

% Define flux here
% This is a simple example that reverses on the interior 
% and includes just advection, no diffusion
F = 1-3*fpad;  
% F = 0.1*sin(2*pi*fpad/0.2);
% zero out size of ode where we want pile up
% F(1:2)=0; 
% F(end-1:end)=0;

% auxilary parameters that only need to be calculated once
Fm2 = [ 0 0 F(1:end-2) ];
Fm1 = [ 0 F(1:end-1) ];
Fp1 = [ F(2:end) 0 ];
Fp2 = [ F(3:end) 0 0];
am3h = 0.5*(Fm2+Fm1); am1h = 0.5*(Fm1+F); ap1h = 0.5*(F+Fp1); ap3h = 0.5*(Fp1+Fp2);

% Set up initial probability distribution - bell-shaped curve
sigma = (fmax-fmin)/10; 
pmat=exp(-(f-f(ceil(0.5*lenf))).^2/2/sigma^2);
normalize;

% MAIN LOOP
figure(1), set(gcf,'DoubleBuffer','on');

% initial conditions
y0 = pmat(:); % make it a column vector

% do integration
time = 0;
options = odeset('RelTol',1e-3,'AbsTol',1e-6);
while time+dt <= endtime
    
    [t,y]=ode23(@odefun,[time time+dt],y0,options);
    
    y0 = y(end,:); % result from final time step
    pmat = y0(:)'; % make it column vector again
    
    norm_error = abs(1-sum(pintegral));
    normtol = 1e-12;
    if norm_error > normtol
        disp(['t = ' num2str(time) ': error in normalization of PDF = ' num2str(norm_error) ]);
    end
    
    pintegral = sum(pmat.*df);
    time = time+dt;
    do_plot;
    
end

return

%--------------------------
% Subfunctions
%--------------------------
function [ dydt ] =  odefun(t,y)
% ODEFUN returns a column vector corresponding to the RHS of the ODEs
% when the PDEs are solved using the method of lines.
%
% flux limiting method
global F df lenf
global Fm2 Fm1 Fp1 Fp2 am3h am1h ap1h ap3h

pmat = y(:)'; % row vector
rho = [ 0 0 pmat 0 0];
rhom2 = [ 0 0 rho(1:end-2) ];
rhom1 = [ 0 rho(1:end-1) ];
rhop1 = [ rho(2:end) 0 ];
rhop2 = [ rho(3:end) 0 0 ];

f0 = F.*rho; % I write f0 not f just to avoid confusion with state variable f "fraction of channels"
fm2 = Fm2.*rhom2; fm1 = Fm1.*rhom1; fp1 = Fp1.*rhop1; fp2 = Fp2.*rhop2;

fsRp3h = 0.5*(fp1+fp2)-0.5*abs(ap3h).*(rhop2-rhop1);
fsRp1h = 0.5*(f0+fp1)-0.5*abs(ap1h).*(rhop1-rho);
fsRm1h = 0.5*(fm1+f0)-0.5*abs(am1h).*(rho-rhom1);
fsRm3h = 0.5*(fm2+fm1)-0.5*abs(am3h).*(rhom1-rhom2);

argp_m3h = (f0-fsRm1h)./(fm1-fsRm3h);
argp_m1h = (fp1-fsRp1h)./(f0-fsRm1h);
argm_p1h = (fm1-fsRm1h)./(f0-fsRp1h);
argm_p3h = (f0-fsRp1h)./(fp1-fsRp3h);

psip_m3h = max(0,max(min(2*argp_m3h,1),min(argp_m3h,2)));
psip_m1h = max(0,max(min(2*argp_m1h,1),min(argp_m1h,2)));
psim_p1h = max(0,max(min(2*argm_p1h,1),min(argm_p1h,2)));
psim_p3h = max(0,max(min(2*argm_p3h,1),min(argm_p3h,2)));

brackets = fsRp1h + 0.5*psip_m1h.*(f0-fsRm1h)+0.5*psim_p3h.*(fp1-fsRp3h);
brackets_m1 = fsRm1h + 0.5*psip_m3h.*(fm1-fsRm3h)+0.5*psim_p1h.*(f0-fsRp1h);

divpad = brackets-brackets_m1;
div = divpad(3:end-2)/df;

dydt = -div(:); % column vector 

return

function [] =  normalize
global pmat pintegral df
pmat = pmat/sum(pmat*df); % normalize
pintegral = sum(pmat*df); % should be = 1
return

function [] = do_plot
global F f pmat pintegral time
figure(1)
subplot(2,1,1)
plot(f,F(3:end-2),'-o')
subplot(2,1,2)
plot(f,pmat,'-o')
axis([ -Inf Inf -Inf Inf ]) % set axes individually
ylabel([ 'prob density' ])
xlabel([ 'f' ])
title([ 'Pr=' sprintf('%1.5f', pintegral) '   Time = ' sprintf('%1.5f',time) ])
set(gca,'Box','off','Gridlinestyle','none','Xcolor',[1 1 1],'Ycolor',[1 1 1]);
drawnow

return


