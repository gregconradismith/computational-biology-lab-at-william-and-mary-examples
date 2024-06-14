function [Out] = Analysis(In)
	% This is an example function which we will parallelize using the cluster
	% Rather than looping through a range of values for In inside a single matlab script, 
	% we will range the values in the upstream shell command, and only call this function with one In value. 
	% We will call this function several times in parallel, all with different In values. The tutorial this script 
	% is based on can be found at "https://newhpc.wm.edu/doc/matlab/matlabscripting.html"

	Out = some_big_calculation(In)

	disp(['The answer is ' mat2str(Out)])

end

function [y] = some_big_calculation(x)
	% This is our example BIG calculation. I'll do a small calculation of an known function, one we can recognize, 
	% for examples sake (with some noise included for fun)

	A = 1; 		% Wave amplitude
	f = 1;		% Wave frequency (Hz)

	u = 0; 		% standard deviation of gaussian noise
	s = 0.1;	% standard deviation of gaussian noise
	
	% The big calulcation!! Just a sine wave, with some noise
	y = A*sin(2*pi*f*x) + (s*randn+u); 

end 	
