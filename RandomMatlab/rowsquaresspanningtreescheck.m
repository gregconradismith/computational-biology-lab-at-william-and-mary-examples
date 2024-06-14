% row of squares spanning trees check

n=5; % number of squares 
v = 2*(n+1); % number of vertices
A = zeros(v);

for nn=1:n
    A(nn,nn+1)=1; % rightward top
    A(nn,nn+n+1)=1; % downward
    A(nn+n+1,nn+n+2)=1; % rightward bottom
end
A(n+1,v)=1;

A=A+A';
spy(A,'o')
maxA = max(max(A))

L = diag(sum(A,2))-A;
trees = det(L(2:end,2:end))

nn=n+1;
check=((2+sqrt(3))^nn-(2-sqrt(3))^nn)/(2*sqrt(3))