% function test
% close all; clear; clc
% system('rm -f *.dat');
%
% gt=10; ht=20;
% K= 10; Kh = 2; Kg = 3; alpha = 4; beta = 6; gamma = 7;
%
% [x,fval] = fsolve(@(x) myzero(x,gt,ht,Kg,Kh,K,alpha,beta,gamma), [ 0 0 ])
% gss=x(1); hss=x(2);
%
% [ gz, hz ] = zero_loci(2*gss,2*hss,gt,ht,Kg,Kh,K,alpha,beta,gamma);
% figure(2)
% plot(gz(1,2:end),gz(2,2:end),'r'); hold on; % contour lines are (:,2:end) because first column is level and number of points
% plot(hz(1,2:end),hz(2,2:end),'b'); hold on;
% plot(gss,hss,'*c'); hold on;
% end


function do_ghratio_study
% mGlu2/5-HT2A ratio study
close all; clear; clc
system('rm -f *.dat *.pdf');

gt=10;
K0 = 1; Kh0 = 1; Kg0 = 1; alpha0 = 1; beta0 = 1; gamma0 = 1;
best_goodness = 0;
for k=1:1e4
    Kg = min(1e4,max(0.001,exprnd(Kg0)));
    Kh = min(1e4,max(0.001,exprnd(Kh0)));
    K = min(1e4,max(0.001,exprnd(K0)));
    alpha = min(1e4,max(0.001,exprnd(alpha0)));
    beta = min(1e4,max(0.001,exprnd(beta0)));
    gamma = min(1e4,max(0.001,exprnd(gamma0)));
    [ r, G, H, GGH ] = ghratio(gt,Kg,Kh,K,alpha,beta,gamma,0);
    %goodness = (GGH(2)-GGH(1))*(GGH(2)-GGH(3));
    goodness = 1/norm(GGH/sum(GGH) - [0.4 0.4 0.2]);  
    %goodness = (GGH(2)-GGH(1))*(GGH(2)-GGH(3));
    if goodness > best_goodness
        best_goodness = goodness; best_k = k; best_r = r; best_GGH = GGH;
        best_G = G; best_H = H; best_K = K; best_alpha = alpha; best_beta = beta; best_gamma = gamma;
        best_Kh = Kh; best_Kg = Kg;
        K0 = K; Kh0 = Kh; Kg0 = Kg; alpha0=alpha; beta0=beta; gamma0=gamma;
        mystr = [ 'trial = ', num2str(k), ', K = ' num2str(K) ', Kh = ' num2str(Kh) ...
            ', Kg = ' num2str(Kg) ', alpha = ' num2str(alpha) ', beta = ' num2str(beta) ...
            ', gamma = ' num2str(gamma) ',  goodness = ' num2str(best_goodness) ];
        disp(mystr)
        figure(1)
        bar(best_r,best_GGH)
        title(mystr)
        drawnow
    end
end
print('fig_bar_graph.pdf','-dpdf')

fid = fopen('fig_bar_graph.dat','w');
fprintf(fid,'%6.6f  %6.6f\n',[r ; GGH]);
fclose(fid);

fid = fopen('fig_params.dat','w');
fprintf(fid,'%s\n',mystr);
fclose(fid);

gmax=2*max(best_G);
hmax=2*max(best_H);
for i=1:length(r)
    ht=r(i)*gt;
    [ gz, hz ] = zero_loci(gmax,hmax,gt,ht,best_Kg,best_Kh,best_K,best_alpha,best_beta,best_gamma);
    figure(2)
    plot(gz(1,2:end),gz(2,2:end),'r'); hold on; % contour lines are (:,2:end) because first column is level and number of points
    plot(hz(1,2:end),hz(2,2:end),'b'); hold on;
    plot(best_G(i),best_H(i),'*c'); hold on;
    
    fid = fopen(['fig_gloci' num2str(i) '.dat'],'w');
    fprintf(fid,'%6.6f  %6.6f\n',[gz(1,2:end) ; gz(2,2:end)]);
    fclose(fid);
    
    fid = fopen(['fig_hloci' num2str(i) '.dat'],'w');
    fprintf(fid,'%6.6f  %6.6f\n',[hz(1,2:end) ; hz(2,2:end)]);
    fclose(fid);

end
xlabel('G')
ylabel('H')
legend({'f_g = 0','f_h = 0'})
print('fig_loci_graph.pdf','-dpdf')


end

function [r_list, G_list, H_list, GGH_list] = ghratio(gt,Kg,Kh,K,alpha,beta,gamma,verbose)
r_list = [1 2 3];
for k=1:length(r_list)
    ht = r_list(k)*gt;
    x0 = [ 0 0 ];
    [x,fval] = fsolve(@(x) myzero(x,gt,ht,Kg,Kh,K,alpha,beta,gamma), x0,optimoptions('fsolve','Display','off'));
    g=x(1); G_list(k)=g;
    h=x(2); H_list(k)=h;
    GGH = alpha*Kg*K*g^2*h;
    GGH_list(k)=GGH;
end
end

function z = myzero(x,gt,ht,Kg,Kh,K,alpha,beta,gamma)
g=x(1); h=x(2);
if g<0 || h<0
    z=[Inf Inf]; 
else
z = [ -gt + g + 2*Kg*g.^2 + K*g.*h + 2*alpha*Kg*K*g.^2.*h + beta*Kh*K*h.^2.*g + 2*alpha*beta*gamma*Kg*Kh*K*g.^2.*h.^2, ...
      -ht + h + 2*Kh*h.^2 + K*g.*h + alpha*Kg*K*g.^2.*h + 2*beta*Kh*K*h.^2.*g + 2*alpha*beta*gamma*Kg*Kh*K*g.^2.*h.^2 ];
end
end

function [ gz, hz ] = zero_loci(gmax,hmax,gt,ht,Kg,Kh,K,alpha,beta,gamma)
nmesh=50;
dg=gmax/nmesh; dh=hmax/nmesh;
g = 0:dg:gmax; h = 0:dh:hmax;

[G,H] = meshgrid(g,h);

ZG =  -gt + G + 2*Kg*G.^2 + K*G.*H + 2*alpha*Kg*K*G.^2.*H + beta*Kh*K*G.*H.^2 + 2*alpha*beta*gamma*Kg*Kh*K*G.^2.*H.^2;
ZH =  -ht + H + 2*Kh*H.^2 + K*G.*H + alpha*Kg*K*G.^2.*H + 2*beta*Kh*K*G.*H.^2 + 2*alpha*beta*gamma*Kg*Kh*K*G.^2.*H.^2;

gz = contourc(g,h,ZG,[0 0]);
hz = contourc(g,h,ZH,[0 0]);
end


