This directory contains example shell and matlab scripts to run on the cluster. The idea is to run a single matlab script in parallel with a different input variable. This way, we can do large parameter studies very quickly.

This work used "https://newhpc.wm.edu/doc/matlab/matlabscripting.html" as a tutorial.


We have a matlab function called - Analysis.m - this function takes one input x, and produces some output y. We 
want to range over some parameter set, and do the calculations in parallel, on seperate nodes. In our example here, the Analysis function is just a sine wave with some noise. 

The script - do_Analysis_range - ranges over some user given values and submits these jobs to the cluster.

To run the parameter study move this directory into the cluster using sftp. 
Here is a very helpfull guide on sftp - "https://www.tecmint.com/sftp-command-examples/"

In order to run this script on the first try, the file path needs to be data10/ClusterMatlabPlayground. If it's not, you will need to change the path in "do_Analysis_range" to whatever the path actually is. Or just move this directory around until it's in "data10/ClusterMatlabPlayground".

Once the files are in the correct directory, make do_Analysis_range executable. Simply,
 > chmod u+x do_Analysis_range

Now, submit the job with qsub. Be sure to specify the inputs using -F. The first parameter is the start value of the range. 
The second parameter is the end value.

 > qsub -F "1 10" do_Analysis_range

This should run and spit 11 output files into the correct directory. At this point, it would be simple to have the Analysis.m script save output into a .mat file. Then have a final script compile all of these outputs and compile/plot the results. Other house keeping things would be nice, like an auto-delete feature for the old .out files when running another parameter study. Either way, this example should get the user off the ground!

Cheers
-Dan Borrus March 4th, 2021


