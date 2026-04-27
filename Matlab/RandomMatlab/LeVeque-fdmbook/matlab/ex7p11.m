
% ex7.11.m
% test several methods on the damped linear pendulum of Ex. 7.11.

method = 'euler';

a = 100;
b = 3;

A = [0 1;-a -b];
eta = [1; 0];
I = eye(2);

T = 2;  % final time
t = linspace(0,T,1001);      % times to plot true solution
utrue = zeros(2,length(t));  % storage for true solution
utrue(:,1) = eta;
dt = T/(length(t)-1);
Btrue = expm(dt*A);
for n=2:length(t)
  utrue(:,n) = Btrue * utrue(:,n-1);
  end


disp(' ')
disp('Hit return after each plot...')
disp(' ')
disp(method)
disp(' ')
disp('      k          error')

for N = [25 50 100 200 400]
  k = T/N;
  tn = linspace(0,T,N+1);
  U = zeros(2,length(tn));  % storage for computed solution
  U(:,1) = eta;             % starting value U^0
  Btrap = (I - k/2 * A) \ (I + k/2 * A);  % used for trapezoid method
  un = eta;                 % starting value
  for n = 1:N
     switch method
       case 'euler'
          unp1 = un + k*A*un;
       case 'trapezoid'
          unp1 = Btrap * un;
       case 'midpoint'
          if n==1
              unp1 = un + k*A*un;  % starting value U^1
              unm1 = un;
            else
              unp1 = unm1 + 2*k*A*un;
              unm1 = un;
            end
       end
     un = unp1;
     U(:,n+1) = unp1;
     end

  % error at time T:
  err = U(1,end) - utrue(1,end);
  disp(sprintf('%10.5f   %10.4e',k,err))

  % plot solution with this k:
  plot(t,utrue(1,:),'r')
  hold on
  plot(tn,U(1,:),'bo-')
  title(sprintf('%s method with k = %8.4f',method,k))
  xlabel('t')
  ylabel('theta = u(1)')
  hold off

  % wait for user to hit return:
  pause
  end

