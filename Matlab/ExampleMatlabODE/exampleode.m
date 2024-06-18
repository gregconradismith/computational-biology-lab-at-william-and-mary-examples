function exampleode
% EXAMPLEODE - Integrates the differential equation dx/dt = lambda - x^2
% This script demonstrates how to set up and solve a simple ODE using MATLAB's ode15s solver.
% The results are visualized in two subplots: one for the right-hand side of the ODE and one for the solution.

    % Define the range of x values for plotting the ODE function (right-hand side)
    x = -5:0.01:5;

    % Create a subplot for the right-hand side (RHS) of the ODE
    subplot(2, 1, 1); % Divide the figure window into a 2x1 grid and use the first section
    plot(x, odefun(0, x), 'b', x, 0, 'r'); % Plot RHS of ODE in blue and x-axis in red
    xlabel('x'); % Label the x-axis
    ylabel('rhs'); % Label the y-axis
    title('Plot of the ODE function dx/dt = \lambda - x^2'); % Title for the subplot
    legend('rhs', 'x-axis'); % Legend for the plot to distinguish between the RHS and x-axis

    % Define the time span and initial condition for the ODE solver
    total = 3; % Total time for integration (from 0 to 3)
    x0 = 1; % Initial condition for x at time t = 0

    % Solve the ODE using the ode15s solver
    [t, xx] = ode15s(@odefun, [0 total], x0); % ode15s is used for stiff ODEs

    % Create a subplot for the solution of the ODE
    subplot(2, 1, 2); % Use the second section of the 2x1 grid
    plot(t, xx, 'g'); % Plot the solution in green
    xlabel('time'); % Label the x-axis
    ylabel('x'); % Label the y-axis
    title('Solution of the ODE'); % Title for the subplot

end

% Nested function to compute the right-hand side of the ODE
function rhs = odefun(~, x)
    lambda = 6; % Parameter lambda in the differential equation
    rhs = lambda - x.^2; % Compute the right-hand side (RHS) of the ODE
    % The ODE is given by dx/dt = lambda - x^2
end
