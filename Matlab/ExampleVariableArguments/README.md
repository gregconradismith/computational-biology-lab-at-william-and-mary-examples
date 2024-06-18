```matlab
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
'''

### Explanation:

1. **Function Definition (`variable_argument_example`)**:
    - `varargin` allows the function to accept a variable number of input arguments. It stores the arguments in a cell array.

2. **Documentation**:
    - The function header comment explains what the function does and provides examples of how to use it.

3. **Display the Number of Arguments**:
    - `nargin` is a built-in variable that stores the number of input arguments passed to the function.
    - `disp` is used to print the number of arguments.

4. **Check for Arguments**:
    - The `if nargin > 0` statement checks if any arguments have been passed to the function.

5. **Loop Through Arguments**:
    - A `for` loop iterates over each argument.
    - Inside the loop, `num2str` converts each argument to a string for display purposes.
    - `disp` prints the argument number and its value.

6. **Return Statement**:
    - The `return` statement is not necessary in this context, as the function will naturally exit after completing all statements. It is kept here as it was in the original code for clarity.

By adding these comments, the code becomes much more understandable for a new programmer, explaining each part of the function step by step.
