function exampleode
% Example ODE solver: Integrates the differential equation dx/dt = lambda - x^2

    % Define the range of x values for plotting the ODE function
    x = -5:0.01:5;

    % Create a subplot for the right-hand side of the ODE
    subplot(2, 1, 1);
    plot(x, odefun(0, x), 'b', x, 0, 'r'); % Plot the ODE function
    xlabel('x'); % Label x-axis
    ylabel('rhs'); % Label y-axis
    title('Plot of the ODE function dx/dt = \lambda - x^2'); % Title for the subplot
    legend('rhs', 'x-axis'); % Legend for the plot

    % Define the time span and initial condition for the ODE solver
    total = 3; % Total time for integration
    x0 = 1; % Initial condition

    % Solve the ODE using ode15s solver
    [t, xx] = ode15s(@odefun, [0 total], x0);

    % Create a subplot for the solution of the ODE
    subplot(2, 1, 2);
    plot(t, xx, 'g'); % Plot the solution
    xlabel('time'); % Label x-axis
    ylabel('x'); % Label y-axis
    title('Solution of the ODE'); % Title for the subplot

end

% Function to compute the right-hand side of the ODE
function rhs = odefun(~, x)
    lambda = 6; % Parameter lambda
    rhs = lambda - x.^2; % Compute the right-hand side of the ODE
end
