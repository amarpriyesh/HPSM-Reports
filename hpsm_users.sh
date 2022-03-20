cd
. ./.bash_profile



datestr=`date "+%d%m%y"`
sm -reportlic:1 |  awk '{print $1","$2","$3}'  > /hpsm/hpsm/ops/reports/users_hpsm$datestr.csv
sleep 1
chmod 777 /hpsm/hpsm/ops/reports/users_hpsm$datestr.csv
b=`cat /hpsm/hpsm/ops/reports/users_hpsm$datestr.csv | wc -l`
a=`expr $b - 41`
c=`expr $a + 1`
echo "/hpsm/hpsm/ops/reports/users_hpsm$datestr.csv"
echo $c
cat /hpsm/hpsm/ops/reports/users_hpsm$datestr.csv | tail -n $c > /hpsm/hpsm/ops/reports/users_hpsm1$datestr.csv
chmod 777 /hpsm/hpsm/ops/reports/users_hpsm1$datestr.csv
echo -e " Dear All,\n\n PFA total users in HPSM \n Total logged in users  $a. \n\n Regards \n HPSM Team"| mail -v -s "HPSM logged in user report for  `date`" -a /hpsm/hpsm/ops/reports/users_hpsm1$datestr.csv priyesh.a@du.ae,ankur.saxena@du.ae,Huzefa.Ali@du.ae
