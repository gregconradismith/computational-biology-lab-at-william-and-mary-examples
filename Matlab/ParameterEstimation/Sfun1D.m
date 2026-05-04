function S = Sfun1D(b)
% computation of an error function for an ODE model % INPUT: b - vector of parameters
global tdata xdata x0

%% ODE model
% (nested function, uses parameters b(1) and b(2) of the main function)
    function dx = f(t,x)
        dx(1) = b(1)-b(2)*x(1);
    end

%% numerical integration set up
tspan = [0:0.1:max(tdata)];
[tsol,xsol] = ode23s(@f,tspan,x0);

%% plot result of the integration
plot(tdata,xdata,'x','MarkerSize',10); hold on
plot(tsol,xsol(:,1));
hold off
drawnow

%% find predicted values x(tdata)
xpred = interp1(tsol,xsol(:,1),tdata);

%% compute total error
S = 0;
for i = 1:length(tdata)
    S = S + (xpred(i)-xdata(i))^2;
end

end
