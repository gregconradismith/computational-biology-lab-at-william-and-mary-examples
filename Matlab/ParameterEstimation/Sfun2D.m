function S = Sfun2D(b)
% computation of an error function for an ODE model
% INPUT: b - vector of parameters

global tdata xdata x0

%% ODE model 
% (nested function, uses parameters b(1) and b(2) of the main function)
    function dx = f(t,x)
        dx = zeros(2,1);
        dx(1) = -b(1)*x(1)*x(2);
        dx(2) = b(1)*x(1)*x(2) - b(2)*x(2);
    end

%% numerical integration set up

tspan = [0:0.1:max(tdata)];
[tsol,xsol] = ode23s(@f,tspan,x0);

%% plot result of the integration

figure(1)
for i = 1:2
    subplot(1,2,i)
    plot(tdata,xdata(:,i),'x','MarkerSize',10);
    hold on
    plot(tsol,xsol(:,i));
    hold off
    ylabel(['x(' num2str(i) ')']);
end
drawnow

%% find predicted values x(tdata)

xpred = interp1(tsol,xsol,tdata);

%% compute total error

S = 0;
for i = 1:length(tdata)
    S = S + sum((xpred(i,:)-xdata(i,:)).^2);
end

end