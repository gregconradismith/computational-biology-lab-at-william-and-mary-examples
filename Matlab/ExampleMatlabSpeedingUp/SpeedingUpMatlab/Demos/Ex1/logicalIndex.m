%% Logical Indexing 
% Copyright 2009 The MathWorks, Inc.
%
% This is an example of how to do some logical indexing -- 
% how you can vectorize code that might use an nested for loop
% and an if statement. 

%%  Finding elements using logical matrices
% " While most indices are numeric, indicating a certain row or column
% number, logical indices are positional. That is, it is the position of 
% each 1 in the logical matrix that determines which array element is 
% being referred to " 

N = 2000;

A = magic(N);  
A2 = magic(N);
A3 = magic(N);

myRef = 1e6; 

%%  Using an if and a nested for loop 
%  In this example we want to find all values that are over myRef.
%  This is how we do that in a nested for loop with an if-statement:

tic

ix = 1;

vals = zeros(size(A(:)));

for jj = 1:N
    for ii = 1:N
        if A(ii,jj) > myRef
            vals(ix) = A(ii,jj);
            ix = ix + 1;
        end
    end
end

vals(ix:end) = []; %#ok<*NASGU>

toc

%% Defining and Using Logical Matrices

B = A2 > myRef;

spy(B(1:100,1:100))

%%
tic

vals = A2(A2 > myRef);
  
toc

%%  Using the find Function

% "The find function determines the indices of array elements that meet 
% a given logical condition. It returns the indices in the form of linear
% indexing " 

myIndex = find(A3 > myRef);
display(myIndex(1:3))

%%
tic
vals = A3(find(A3 > myRef));
toc



