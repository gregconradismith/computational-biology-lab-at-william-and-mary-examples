function [ dummy ] = position_determination(dum,fig)
%
% Position Determination Simulator
%

Ninitial = 1000;
Nmax = 2*Ninitial;

D = 100;% um^2/s
xmax = 400; %um
nbins = 100; % for histogram
decay = 0.01; % s^-1
prod = 5; % number/s

sigma = xmax/50;

dt = sigma^2/2/D; % s

if dt*decay > 0.05
    error('Decay rate or dt too large.')
end
total = 1000*dt; % s

n = 1:Nmax;
x = zeros(1,Nmax);
a = zeros(1,Nmax); a(1:Ninitial)=1; % 1 = paricle exists

imax = total/dt;
sigma = sqrt(2*D*dt);
nxbins = 50;

dx = xmax/nxbins;

xbinedges = 0:dx:xmax;
t = 0;
for i = 1:imax
    t = t + dt;

    % random walk
    b = find(a==1);
    x(b) = x(b) + sigma*randn(1,length(b));
    itfl = find(x<0);
    x(itfl) = -x(itfl);
    itfr = find(x>xmax);
    x(itfr) = 2*xmax-x(itfr); % xmax-(x-xmax)

    % decay
    loose = find(rand(1,length(b)) < decay*dt);
    a(b(loose)) = 0;

    % production
    numnew = poissrnd(dt*prod);
    if numnew > 0
        anew = find(a==0,numnew,'first');
        x(anew)=0;
        a(anew)=1;
    end

    if fig
        figure(1)
        subplot(2,1,1)
        b = find(a==1);
        plot(x(b),n(b),'b.')
        ylabel('#','FontSize',24)
        xlabel('x','FontSize',24)
        axis([ 0 xmax 0 Inf ])
        title(['Time = ' sprintf('%6.2f',t) ...
            '  Number = ' sprintf('%6.2f',length(b))], ...
            'FontSize',24)

        subplot(2,1,2)
        [ xconc ] = histc(x(b),xbinedges);
        bar(xbinedges,xconc,'histc');
        ylabel('[]','FontSize',24)
        xlabel('x','FontSize',24)
        axis([ 0 xmax 0 200 ])

    end
end

dummy = NaN;
return

