% Define the parameters
clc; clear; close all;

a = 1.5; % positive, a=alpha*tau 
c = 1; % arbitrary (gets scaled away)
w_start = 0;
w_end = max(5,3*a);
n_steps = 1e4;
dw = (w_end - w_start) / n_steps;
w = linspace(w_start, w_end, n_steps+1);

% The first step w=0..1
rho = zeros(size(w));
aone=find(w<=1); bone = find(w>1);
rho(aone)=c*w(aone).^(a-1);

% integrate from w=1..w_end
for i = aone(end)+1:n_steps
    rho_delay_one = interp1(w, rho, w(i)-1, 'next', 0);
    rho_prime = ((a-1)*rho(i-1) - a*rho_delay_one)/w(i);
    rho(i) = rho(i-1) + dw*rho_prime;
end

rho_int = c*dw^a/a + trapz(w(2:end),rho(2:end)); % first dx handled separately 
rho=rho/rho_int;
rho_cdf_one = c*dw^a/a/rho_int;
rho_cdf = [ 0 rho_cdf_one+cumtrapz(w(2:end),rho(2:end))];
rho_int_check = rho_cdf_one + trapz(w(2:end),rho(2:end)) 

% Plot the solution
subplot(2,2,1)
plot(w, rho, 'b-o')
ylabel('p(x)','rot',0)

subplot(2,2,2)
loglog(w, rho, 'b-o')
ylabel('p(x)','rot',0)

subplot(2,2,3)
semilogy(w, rho, 'b-o')
ylabel('p(x)','rot',0)
xlabel('x')

subplot(2,2,4)
plot(w, rho_cdf, 'b-o')
xlabel('x')
ylabel('P(x)','rot',0)

sgtitle(['d(w*p[w])/dw = (a-1)*p[w] - a*p[w-1]']);  
return
