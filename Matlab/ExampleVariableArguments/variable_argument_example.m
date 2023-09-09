function variable_argument_example(varargin)
%
% EXAMPLE: variable_argument_example()
%          variable_argument_example(pi,sqrt(2),10)
% 

disp(['Number of arguments passed = ' num2str(nargin) '.'])
if nargin>0
    for i=1:nargin
    disp(['   Argument ' num2str(i) ' = ' num2str(varargin{i}) '.'])
    end
end

return
