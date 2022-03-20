#!/bin/sh
#set -vx
while read line 
do
cnt=`echo ${line}|grep "^IM"|wc -l`
if [ $cnt -ge 1 ]; then
echo -e "\n$line \c" >> $1_new.txt
else 
echo -e "$line \c" >> $1_new.txt
fi
done < /hpsm/hpsm/ops/$1.txt
mv -f $1\_new.txt $1.txt
