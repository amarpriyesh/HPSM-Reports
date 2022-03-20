#!/bin/bash
cd /hpsm/hpsm/ops
find  *.sh > shfiles.txt
a=`cat shfiles.txt | wc -l`
c=`expr  $a + 1`
echo $c
for (( d=1; d<$c; d++ ))
do
e=`cat shfiles.txt  | awk  NR==$d` 
f=`cat $e | grep -i "parallel"`

if [ "$f" != "" ]
then
echo $e
fi
done

