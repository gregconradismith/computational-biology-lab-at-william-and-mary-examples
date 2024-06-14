
function hw0(u,uprime)

x = 1;
nh = 7;
errors = ones(nh,4);
ux = feval(u,x);

disp(' ')
disp('         h         D+ error      D_0 error     D_3 error')
disp(' ')

for i=1:nh
  h = 10^(-i);
  up = feval(u,x+h);
  um = feval(u,x-h);
  umm = feval(u,x-2*h);
  dp = (up - ux)/h;
  d0 = (up - um)/ (2*h);
  d3 = (2*up + 3*ux - 6*um + umm) / (6*h);
  dtrue = feval(uprime,x);
  errp = dp-dtrue;
  err0 = d0-dtrue;
  err3 = d3-dtrue;
  errors(i,:) = [h,errp,err0,err3];
  disp(sprintf('  %12.4e  %12.4e  %12.4e  %12.4e',h,errp,err0,err3))
  end

% plot errors:
figure(1)
clf
hold on
loglog(errors(:,1),abs(errors(:,2)),'+')
keyboard

loglog(errors(:,1),abs(errors(:,3)),'o')
loglog(errors(:,1),abs(errors(:,4)),'x')
hold off


%------------------------------

function u=u1(x)
u = sin(10*x);

%------------------------------

function up=u1prime(x)
up = 10*cos(10*x);
