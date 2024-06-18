% GPCR Cycle Kinetics
clc; clear all; 

% model params
as=5; % conserved as=ad+at+cd+ct
rs=10; % conserved rs=r+cd+ct
h=0.1; x=20; kdp=1; kdm=1; ktp=1; ktm=1;

% calculate appropriate time step (dt)
ms = max(as,rs); dt=1e-2/max([h,x,kdp*ms,kdm,ktp*ms,ktm]);

tol=1e-10; % tolerance (steady state when rates of change < tol)
nmax=1e5; % maximum iterations (safety for while loop)
at=as/2; [cd,ct]=deal(rs/4);  % initial values
n=0; [d_at,d_cd,d_ct]=deal(Inf); % initialize while loop
while norm([d_at d_cd d_ct])>tol && n<nmax
    n=n+1;
    r=rs-cd-ct; ad=as-at-cd-ct;
    jh=h*at; jx=x*cd; jd=kdp*r*ad-kdm*cd; jt=ktp*r*at-ktm*ct;
    d_at=-jh-jt;  d_cd=-jx+jd; d_ct=jx+jt; % d_ad=jh-jd; d_r=-jd-jt;
    at=at+dt*d_at; cd=cd+dt*d_cd; ct=ct+dt*d_ct;
end
if n==nmax, disp('Warning: Did not converge'); end
fprintf('dt=%g, iterations=%d, final norm=%g\n',[dt,n,norm([d_at d_cd d_ct])]);
r = rs-cd-ct; ad = as-at-cd-ct;
fprintf('at=%g, ad=%g, cd=%g, ct=%g, r=%g, at/as=%g\n',[at ad cd ct r at/as]);

do_xlarge_check = 1; % 0 or 1
if do_xlarge_check
    kd=kdm/kdp;
    kt=ktm/ktp;
    at_approx = as*r*kt/(h*kt/kdp+r*kt+r*(r+h/ktp));  % checks should be
    r_approx = rs*(kt/kdp)/(kt/kdp+ad/kdp+at/kdp); % small for x large
    fprintf('rel errors for large x approx: at=%g, r=%g\n',[abs((at-at_approx)/at) abs((r-r_approx)/r)]);
end

return

