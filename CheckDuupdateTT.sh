cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/

getRecordNum () {
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << !
set head off;
set pagesize 0;
set linesize 100;
select count(*) from DUUPDATETTM1 where processed is null ;
quit;
!
}

cnt=`getRecordNum`
echo $cnt
if [ $cnt -gt 100 -a $cnt -le 200 ]
then
 echo "More Than 100 records pending in duupdatett table " | mailx -s "Alert !!! More Then 100 records pending in duupdatett table" "shadi.trad@du.ae,ankur.saxena@du.ae,bhavana.tatti@du.ae,priyesh.a@du.ae,saravana.pandiyan@du.ae"
elif [ $cnt -gt 200 ]
then
 echo "More Than 200 records pending in duupdatett table " | mailx -s "Alert !!! More Than 200 records pending in duupdatett table" "shadi.trad@du.ae,ankur.saxena@du.ae,priyesh.a@du.ae,saravana.pandiyan@du.ae,bhavana.tatti@du.ae"
fi

sh /hpsm/hpsm/ops/reports/DuUpdateTT_Alert.sh $cnt
