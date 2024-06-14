% poisson_binomial

clear
close all
clc

% parameters
N = 100;
T = 200; % number of TE loci
dt=0.1;
mu = 10;
sigma = 2;

p = abs(randn(mu,sigma)); % reflected Gaussian distribution 


% sanity check
f=0:1/T:1;
vsafe = max(dt*vfun(f));
usafe = max(dt*ufun(f));
psafe = 0.1;
pmax = 0.1;
disp(['Safety factors: ' sprintf('v: %2.6f u: %2.6f',pmax/vsafe,pmax/usafe)]);
if any(vsafe>pmax || usafe>pmax)
    error('Safety factors must be greater than 1.');
end

nbins = 50;  
nbin = 0:1/(nbins-1):1;

xbins = 50;  
xbin = 0:1/(xbins-1):1;
 
initial_density = 0.1; 
NX = (rand(N,T)<initial_density); % initial alleles (TE=1,noTE=0)

clf; figure(1); set(gcf,'DoubleBuffer','on');

total = 1e6;
nskip = 1e2;
t=0; i=0;j=0;
while t <= total
    
    n = sum(NX,2)/T; % col vector
     
    if rem(i,nskip)==0
    j=j+1; 
    
    % n updated every time step (see above)
    navg = mean(n); nstd = std(n); navg_list(j) = navg; nstd_list(j) = nstd;  
    [nhist,~] = hist(n,nbin);
    
    % x updated every nskip time steps
    x = sum(NX,1)/N; % row vector
    xavg = mean(x); xstd = std(x); xavg_list(j) = xavg; xstd_list(j) = xstd; 
    [xhist,~] = hist(x,xbin);
    
    [nxi,nxj] = find(NX);
    
    figure(1)
    subplot(5,1,1)
    plot(nxj,nxi,'.');
    title([ 't=' sprintf('%d',t) '    n=' sprintf('%2.2f',navg) '\pm' sprintf('%2.2f',nstd) '   x=' sprintf('%2.2f',xavg) '\pm' sprintf('%2.2f',xstd)], 'FontSize',12);
    xlabel('TE loci','FontSize',12);
    ylabel('individual','FontSize',12);
    axis([1 T 0 N+1 ])

    subplot(5,1,2)
    bar(nbin,nhist/sum(nhist))
    xlabel('n = TE load','FontSize',12);
    ylabel('density','FontSize',12);
    axis([0 Inf 0 Inf ])
    
    subplot(5,1,3)
    bar(xbin,xhist/sum(xhist))
    xlabel('x = allele frequency','FontSize',12);
    ylabel('density','FontSize',12);
    axis([0 Inf 0 Inf ])
    
    subplot(5,1,4)
    t_list = [dt*nskip*(0:j-1) total];
    plot(t_list,[navg_list NaN],'b-',t_list,[nstd_list NaN],'g-',t_list,[xstd_list NaN],'c-')
    ylabel('stats','FontSize',12)
    xlabel('time','FontSize',12)
    axis([0 total 0 1.1*Inf])
    legend('navg=xavg','nstd','xstd')
    
    
    subplot(5,1,5)
    wscale = ( max(ufun(f)) + max(vfun(f)) )/2;
    plot(f,ufun(f),'b',f,vfun(f),'r',f,wscale*wfun(f),'g')
    xlabel('n')
    legend('u(n)','v(n)','w(n)')
    drawnow 
     
    if norm(navg-xavg)>1e-6, warning('navg ~= xavg ... could be problem.'), end
    
    end
    
    r = rand(N,T);
    a = find(NX); [ai,aj] = find(NX);
    b = find(~NX); [bi,bj] = find(~NX);
    
    NX(a(find(r(a)<dt*vfun(n(ai)))))=0;
    NX(b(find(r(b)<dt*ufun(n(bi)).*n(bi)./(1-n(bi)))))=1;
   
    if 0 
    % haploid selection
    NX = datasample(NX,N,'Replace',true,'Weights',wfun(n));  
    else 
    % diploid selection 
    NXa = datasample(NX,N,'Replace',true);
    NXb = datasample(NX,N,'Replace',true);
    na = sum(NXa,2)/N;
    nb = sum(NXb,2)/N;
    NX = datasample([ NXa ; NXb],N,'Replace',true,'Weights',wfun([(na+nb)/2 ; (na+nb)/2]));
    end
    
    t = t + dt;
    i=i+1;
end


return

