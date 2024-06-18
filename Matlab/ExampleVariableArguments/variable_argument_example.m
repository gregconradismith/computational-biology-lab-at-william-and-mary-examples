function variable_argument_example(varargin)
% VARIABLE_ARGUMENT_EXAMPLE - A function demonstrating the use of variable input arguments
%
% EXAMPLES:
%   variable_argument_example()
%   variable_argument_example(pi, sqrt(2), 10)
%
% This function takes a variable number of input arguments and displays each one.

    % Display the number of arguments passed to the function
    disp(['Number of arguments passed = ' num2str(nargin) '.'])

    % Check if there are any arguments passed
    if nargin > 0
        % Loop through each argument passed to the function
        for i = 1:nargin
            % Display the argument number and its value
            disp(['   Argument ' num2str(i) ' = ' num2str(varargin{i}) '.'])
        end
    end

end
