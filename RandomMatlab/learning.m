% learning.m

clc
clear
% temporal difference learning algorithm

myeps = 0.1;
alpha = 0.5;
gamma = 0.8;
r(1)=10; r(2)=100;
Q(1)=1; Q(2)=0;

for t=1:100
    
if rand < myeps % randomly pick action
    display(['time = ' num2str(t) ': Q-reverse action :'])
    [q,a] = min(Q);
else % pick action with largest Q
    display(['time = ' num2str(t) ': Q-best action :'])
    [q,a] = max(Q);
end

reward = r(a);

Q(a) = Q(a)+alpha*(reward+gamma*max(Q)-Q(a));

display(['      action #' num2str(a) ' chosen, reward is ' num2str(reward), ' and Q = [' num2str(round(Q(1))) ', ' num2str(round(Q(2))) '].'])

if rem(t,30)==0
      r = r([2 1]);
      display(['r1 = ' num2str(r(1)) ', ' 'r2 = ' num2str(r(2)) '.'])

end

end

