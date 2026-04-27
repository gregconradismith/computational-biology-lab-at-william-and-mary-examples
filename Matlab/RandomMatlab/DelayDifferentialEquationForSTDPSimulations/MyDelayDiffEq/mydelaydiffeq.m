% mydelaydiffeq.m
clc; clear; close all;
system('rm Figures/*');
a_list = [ 0.8 1.2 5 ] % a=alpha*tau (positive)
for k=1:length(a_list)
    a=a_list(k);
    x_start = 1e-8; x_end = max(2,3*a); n_steps = 1e5;
    x = logspace(log10(x_start),log10(x_end), n_steps+1);

    % The first step x=0..1
    rho = zeros(size(x));
    aone=find(x<=1); bone = find(x>1);
    rho(aone)=x(aone).^(a-1);

    % integrate from x=1..w_end
    for i = aone(end)+1:n_steps
        rho_delay_one = interp1(x, rho, x(i)-1, 'next', 0);
        rho_prime = ((a-1)*rho(i-1) - a*rho_delay_one)/x(i);
        rho(i) = rho(i-1) + (x(i)-x(i-1))*rho_prime;
    end

    % Plot the solution
    subplot(2,1,1)
    plot(x, rho, 'b-','LineWidth',2); hold on;
    ylabel('p(w)','rot',0)

    subplot(2,1,2)
    semilogy(x, rho, 'b-','LineWidth',2); hold on;
    ylabel('p(w)','rot',0)
    xlabel('w')

    sgtitle([ 'a=' num2str(a) ' :  d(x*p[x])/dx = (a-1)*p[x] - a*p[x-1]']);

    % test analytical results - this is not working yet
    if 1
        subplot(2,1,2)
        semilogy(x, rho, 'b-','LineWidth',2); hold on;
        ylabel('p(x)','rot',0)
        xlabel('x')
        semilogy(x,x.^(a-1),'r'); hold on
        x=1:0.01:2;
        semilogy(x,x.^(a-1).*(1-(x-1).^a.*(hypergeom([a,a],a+1,1-x))),'go-')
    end
    legend('','numerical integration','x^{(a-1)}','hypergeometric')
    print(['Figures/fig' sprintf('%03d',k) '_a_' sprintf('%g',a) '.png'],'-dpng')
    close all 
end
return
