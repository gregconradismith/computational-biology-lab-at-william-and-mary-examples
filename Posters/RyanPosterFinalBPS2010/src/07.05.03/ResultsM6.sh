#!/bin/sh 
# add -v for verbose mode in line above
# extract results from Nsolve, Approx, MLsolve generated stdout.log files
#
# Parameter 1: directory with results starting at local directory
#
echo "starting with ResultsM6.sh"
#
#  ADJUST THE FOLLOWING TWO LINES FOR NEW LOCATIONS
#
RESULTDIR=/Users/mdlama/Work/Calcium/Kron/CMSB/07.05.03/Output/ResultsM6
EXTRACTFILE=/Users/mdlama/Work/Calcium/Kron/CMSB/07.05.03/Output/ResultsM6/extracted.txt
#
#
echo "starting with extract.sh for results in $RESULTDIR, output appends to $EXTRACTFILE"
echo "output format: 1:methodnumber 2:number-of-iterations 3:cpu-time-in-seconds 4:wallclock-time-in-sec 5:Max-residual 6:L1-Sum-residual 7:L1-as6-but-after-normalization 8:comment"
touch $EXTRACTFILE
for i in `ls $RESULTDIR`
do
echo "starting result extraction for $RESULTDIR/$i"
for j in `ls $RESULTDIR/$i`
do
echo "starting result extraction for $RESULTDIR/$i/$j"
# get the CPU time in seconds
cpu=`grep "Solution requires" $RESULTDIR/$i/$j | awk '{print $3}'`
if test "$cpu" = ""
then
cpu=`grep "Solution procedure stops after" $RESULTDIR/$i/$j | awk '{print $5}'`
fi
#
# get the wallclock time in seconds
wallclock=`grep "Real time used" $RESULTDIR/$i/$j | awk '{print $4}'`
if test "$wallclock" = ""
then
wallclock=`grep "Solution procedure stops after" $RESULTDIR/$i/$j | awk '{print $9}'| sed "s/(//"`
fi
#
# get number of iterations
iter=`grep "Solution requires" $RESULTDIR/$i/$j | awk '{print $8}'`
if test "$iter" = ""
then
iter=`grep "Norms after normalization max:" $RESULTDIR/$i/$j | awk '{print $8}' | sed "s/(//"`
fi
#
# get the max residual
resmax=`grep "estimated accuracy" $RESULTDIR/$i/$j | awk '{print $3}'`
if test "$resmax" = ""
then
resmax=`grep "estimated accuracy" $RESULTDIR/$i/$j | awk '{print $3}'`
fi
if test "$resmax" = ""
then
resmax=`grep "Norms after normalization max:" $RESULTDIR/$i/$j | awk '{print $5}'`
fi
#
#
#
# some method finally normalize solution and compute sum of residuals from that others do not
# grep res sum for those that do not, values based on last line of intermediate output
# case 1
muster="Iteration $iter residuals max:"
ressum1=`grep "$muster" $RESULTDIR/$i/$j | awk '{print $7}'`
# case 2
iter2=`echo $iter | awk '{print int($1/10)*10}'`
muster2="Iteration $iter2 residuals max:"
ressum2=`grep "$muster2" $RESULTDIR/$i/$j | awk '{print $7}'`
# pick right case
if test "$ressum1" = ""
then
#echo "$ressum1 equals empty string"
ressum=$ressum2
else
#echo "$ressum1 not equals empty string"
ressum=$ressum1
fi
# following line gives not unique result, first match assigned, which is not ok
#ressum=`grep " residuals max: " $RESULTDIR/$i/$j | grep "$iter" | awk '{print $7}'`
# grep res sum for those that do report values after final normalization
ressum2=`grep "Norms after normalization max:" $RESULTDIR/$i/$j | awk '{print $7}'`
comment=`grep "SORRY PROCEDURE IS CURRENTLY UNDER CONSTRUCTION" $RESULTDIR/$i/$j`
comment2=`grep "currently not implemented!!!" $RESULTDIR/$i/$j`
#echo "method $i number of iterations $iter cpu time $cpu wallclock time $wallclock resmax $resmax ressum $ressum ressum2 $ressum2"
# pick right case
if test "$comment" = ""
then
#echo "$ressum1 equals empty string"
echo "$iter $cpu $wallclock $resmax $ressum $ressum2 $comment $comment2" >> $EXTRACTFILE
ressum=$ressum2
else
#echo "$ressum1 not equals empty string"
echo "$comment $comment2" >> $EXTRACTFILE
fi
done
done
echo "finished with extract.sh"
cat $EXTRACTFILE