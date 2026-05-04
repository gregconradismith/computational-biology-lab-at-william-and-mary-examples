function do_binding_curve_dimer
% y/(1-y) plots and cooperativity 

%kab_star=1; kbc_star=1; alpha=1; beta=1; delta=1; plotnum=1;
%makedata(kab_star, kbc_star, alpha, beta, delta, plotnum)
makedata(0.1, 4, 1, 1, 1, 1);
%makedata(0.2, 10, 1, 1, 1, 2);
 

return

function makedata(kab_star, kbc_star, alpha, beta, delta, plotnum)
 
x = logspace(-2,2,200);

% vectorize binding  
kab=kab_star*x; kbc=kbc_star*x;

za = 1; zb = kab; zc = kab.*kbc; zt = za+zb+zc;
pa = za./zt; pb = zb./zt; pc = zc./zt;

zaa = za.^2; zab = 2*za.*zb; zbb = alpha*zb.^2; 
zac = 2*za.*zc; zbc = 2*beta*alpha*zb.*zc; zcc = delta*beta^2*alpha*zc.^2; 
ztt = zaa+zab+zbb+zac+zbc+zcc;

paa = zaa./ztt; pab = zab./ztt; pbb = zbb./ztt;
pac = zac./ztt; pbc = zbc./ztt; pcc = zcc./ztt;

for i=1:3
    if i==1
y=pc;
    elseif i==2
y = pcc;
    elseif i==3
y = 0.5*(pac+pbc)+pcc;
    end
    
close all
subplot(2,2,1)
semilogx(x,y)
xlabel('x')
ylabel('y')

subplot(2,2,2)
Y = y./(1-y);
loglog(x,Y)
xlabel('x')
ylabel('y/(1-y)')

subplot(2,2,3)
lnY = log10(Y); 
lnx = log10(x);
plot(lnx,lnY)
xlabel('ln x')
ylabel('ln[y/(1-y)]')

subplot(2,2,4)
dlnYdlnx = (lnY(2:end)-lnY(1:end-1))./(lnx(2:end)-lnx(1:end-1));
plot(lnx(2:end),dlnYdlnx)
xlabel('ln x')
ylabel('d ln[y/(1-y)] / d ln x')
title('n_{hill}')
axis([-Inf Inf min(dlnYdlnx)-0.1 max(dlnYdlnx)+0.1])


dlnYdlnx_pad = [ 2*dlnYdlnx(1)-dlnYdlnx(2) dlnYdlnx ];
fid = fopen([ 'figdata' num2str(i) '-' num2str(plotnum) '.dat' ],'w');
fprintf(fid,'%6.10f %6.10f %6.10f %6.10f\n',[x ; y ; Y; dlnYdlnx_pad ]);
fclose(fid);



sgtitle(['kabstar=' num2str(kab_star) ',kbcstar=' num2str(kbc_star) ...
    ',alpha=' num2str(alpha) ',beta=' num2str(beta) ',delta=' num2str(delta)])
print([ 'fig' num2str(i) '-' num2str(plotnum) '.png' ],'-dpng')

end

 
fid = fopen([ 'figpmonomer' num2str(plotnum) '.dat' ],'w');
fprintf(fid,'%6.10f %6.10f %6.10f %6.10f\n',[x ; pa ; pb; pc]);
fclose(fid);
 
fid = fopen([ 'figpdimer' num2str(plotnum) '.dat' ],'w');
fprintf(fid,'%6.10f %6.10f %6.10f %6.10f %6.10f %6.10f %6.10f\n',[x ; paa ; pab; pbb; pac; pbc; pcc]);
fclose(fid);


return

