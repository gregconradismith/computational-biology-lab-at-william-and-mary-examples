function [ time, state ] = markov(Q,state_init,total_time,total_states) 
% MARKOV produces a instance of a discrete-state continous-time Markov process
% for a given Q matrix using Gillepsie's method.  TOTAL_TIME is the maximum time of
% the simulation and TOTAL_STATES is the maximum number of states that will be returned. 
% Setting one of these to 0 will ensure the other is returned exactly. 
% STATEs are labelled beginning with 1 and STATE_INIT is the
% state at time zero.  TIME is the same length as STATE and is time of
% transition to the associated STATE, that is, the first element of STATE is
% STATE_INIT and the first element of TIME is 0.  
% 
% 
% EXAMPLE:
% 
% Q = [ -0.1 0.1 ; 0.2 -0.2 ]  
% [ time, state ] = markov(Q,1,100,0);
% stairs(time,state) 
% axis([ time(1) time(end) min(state)-1 max(state)+1 ]);
% 

[ m, dummy ] = size(Q); 

% Do Gillespie's method 
t = 0; s = state_init;
time = t; state = s; 
while t < total_time | length(state)<total_states
   t = t + log(rand(1))/Q(s,s); % Note: Q(s,s) is negative so increment of t is positive 
   srow = [ 1:s-1 s+1:m ]; qrow = Q(s,srow); 
   s = srow(min(find(sum(qrow)*rand(1)<cumsum(qrow))));
   time = [ time;  t ]; state = [ state; s ]; 
end
if t > total_time & length(state)<total_states
   time(end)=total_time;
end

return

