close all
clear all
clc

gNa=160; gK=30; gL=3; gCAN=4.5; gSyn=2.5; gNap=2; ENa=65; EK=-75; EL=-61; ECAN=0; ESyn=0; 
kCAN=0.9; kNa=10; kCa=22.5; uCAN=-0.05; r=200; C=45; N=4; 

params = [gNa; gK; gL; gCAN; gSyn; gNap; ENa; EK; EL; ECAN; ESyn; kCAN; kNa; kCa; uCAN; r; C; N];


y0 = [-65+10*randn(N,1); 0.05*ones(N,1); 0.6*ones(N,1); 0.32*ones(N,1); 0.8*ones(N,1); 0*ones(N,1); 0*ones(N,1); 5*ones(N,1); 0.5*ones(N,1)];

tspan = [0 6e3];

[t,y] = ode45(@(t,y) myODE(t,y,params), tspan, y0);

figure(1)
subplot(9,1,1);
plot(t,y(:,1:N));
xlabel('Time')
ylabel('V');

subplot(9,1,2);
plot(t,y(:,(N+1):2*N));
xlabel('Time')
ylabel('m');

subplot(9,1,3);
plot(t,y(:,(2*N+1):3*N));
xlabel('Time')
ylabel('h');

subplot(9,1,4);
plot(t,y(:,(3*N+1):4*N));
xlabel('Time')
ylabel('n');

subplot(9,1,5);
plot(t,y(:,(4*N+1):5*N));
xlabel('Time')
ylabel('hp');

subplot(9,1,6);
plot(t,y(:,(5*N+1):6*N));
xlabel('Time')
ylabel('s');

subplot(9,1,7);
plot(t,y(:,(6*N+1):7*N));
xlabel('Time')
ylabel('Ca');

subplot(9,1,8);
plot(t,y(:,(7*N+1):8*N));
xlabel('Time')
ylabel('Na');

subplot(9,1,9);
plot(t,y(:,(8*N+1):9*N));
xlabel('Time')
ylabel('d');

figure(2)
plot(t,y(:,1:N));
xlabel('Time')
ylabel('V');

figure(3)
plot(mean(y(:,(6*N+1):7*N),2),mean(y(:,(5*N+1):6*N),2));
xlabel('Ca')
ylabel('s');

figure(4)
plot(y(:,1:N),y(:,(8*N+1):9*N));
xlabel('V')
ylabel('d');

figure(5)
plot(t,y(:,(8*N+1):9*N));
xlabel('Time')
ylabel('d');

function der = myODE(t,y,params)

    gNa = params(1);
    gK = params(2);
    gL = params(3);
    gCAN = params(4);
    gSyn = params(5);
    gNap = params(6);
    ENa = params(7);
    EK = params(8);
    EL = params(9);
    ECAN = params(10);
    ESyn = params(11);
    kCAN = params(12);
    kNa = params(13);
    kCa = params(14);
    uCAN = params(15);
    r = params(16);
    C = params(17);
    N = params(18);

    V = y(1:N); 
    m = y((N+1):2*N);
    h = y((2*N+1):3*N);
    n = y((3*N+1):4*N);
    hp = y((4*N+1):5*N);
    s = y((5*N+1):6*N);
    Ca = y((6*N+1):7*N);
    Na = y((7*N+1):8*N);
    d = y((8*N+1):9*N);

    der = zeros(9*N,1);

    mlim=1./(1+exp((V+36)/-8.5)); 
    hlim=1./(1+exp((V+30)/5)); 
    nlim=1./(1+exp((V+30)/-5));
    mplim=1./(1+exp((V+40)/-6));
    hplim=1./(1+exp((V+48)/6));
    tm=1./cosh((V+36)/-17); 
    th=15./cosh((V+30)/10); 
    tn=30./cosh((V+30)/-10);
    thp=1./cosh((V+48)/12);
    NaPump = (Na.^3./(Na.^3+kNa^3) - 0.111);
    W = ones(N,N)/N;
    der(1:N) = (1/C)*(-gNa*m.^3.*h.*(V-ENa)-gK*n.^4.*(V-EK)-gL*(V-EL)-gNap*mplim.*hp.*(V-ENa)-gCAN*(V-ECAN)./(1+exp((Ca-kCAN)/uCAN))-gSyn*W*(s.*d).*(V-ESyn)-r*NaPump);
    der((N+1):2*N) = (mlim-m)./tm;
    der((2*N+1):3*N) = (hlim-h)./th;
    der((3*N+1):4*N) = (nlim-n)./tn;
    der((4*N+1):5*N) = 0.001*(hplim-hp)./thp;
    der((5*N+1):6*N) = ((0.067)*(1-s).*(1./(1+exp((V-15)/-3)))-(0.067)*(1*s))/2;
    der((6*N+1):7*N) = 0.0007*(s*1200-kCa*(Ca-0.05));
    der((7*N+1):8*N) = 0.000066*(-gCAN*(V-ECAN))./(1+exp((Ca-kCAN)/uCAN))-r*NaPump;
    der((8*N+1):9*N) = (-0.24*d.*(1./(1+exp((V-15)/-3)))+0.0067*(1-d));

end