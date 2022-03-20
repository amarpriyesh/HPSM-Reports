sh finduser.sh > abctest.txt
s=`cat abctest.txt | wc -l `
for (( i=1 ; i<=$s ; i++ ))
{

crontab -l | grep `cat abctest.txt | awk NR==$i` 

}
