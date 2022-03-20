#!/bin/sh
#set -vx
while read line 
do
cnt=`echo ${line}|grep "^IM"|wc -l`
if [ $cnt -ge 1 ]; then
echo -e "\n$line \c" >> $1_new.csv
else 
echo -e "$line \c" >> $1_new.csv
fi
done < /hpsm/hpsm/ops/$1.csv
mv -f $1\_new.csv $1.csv
