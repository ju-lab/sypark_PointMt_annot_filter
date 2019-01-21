#!/bin/bash
input=$1
tbam=$2
nbam=$3
srcDir=$4

outDir=$(dirname $input)
log=$outDir/$input.annot.log

echo $input > $log
echo "Starting: Readinfo annot"
(python $srcDir/readinfo_anno_bwa_181129.py $input $tbam) &>> $log || { c=$?;echo "Error";exit $c; }
echo "done"
echo "Starting: N readcount annot"
(python $srcDir/readcount_only_anno_bwa_181129.py $input.readinfo $nbam pairN) &>> $log || { c=$?;echo "Error";exit $c; }
echo "done"
rm $input.readinfo
echo "Starting: Local reassembly annot"
(python $srcDir/read_local_reassembly_181211.py $input.readinfo.readc $tbam $nbam) &>> $log || { c=$?;echo "Error";exit $c; }
echo "done"
rm $input.readinfo.readc

