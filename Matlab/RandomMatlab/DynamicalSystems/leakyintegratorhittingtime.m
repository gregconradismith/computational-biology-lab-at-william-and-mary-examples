% leaky integrator hitting time 

clear
clc
close all

N = 500;
T = 10000;

pbump = 0.05;
xbump = 2; 
theta = 10;
r=0.02;

X = zeros(N,T);

for t=2:T
   a = find(rand(N,1)<pbump);
   X(:,t)=(1-r)*X(:,t-1);
   X(a,t)=X(a,t)+xbump;
end

tau = NaN*ones(1,N);
for n=1:N
b=find(X(n,:)>theta,1,'first');
if ~isempty(b), tau(n)=b; end
end

subplot(2,1,1)
plot(1:T,X)

subplot(2,1,2)
hist(tau,20)
axis([0 Inf 0 Inf])
