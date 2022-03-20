cd
. ./.bash_profile
cd /hpsm/hpsm/ops/

#datestr=`date "+%d%m%M"`
arr1=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)


for (( i = 22 ; i < 23 ; i++ ))
do
#datestr=`date "+%d%m%M"`
datestr=master_tt_
if [ $i -lt 11 ]
then
fromdate="'01-${arr1[$i]}-2018'"
todate="'01-${arr1[$i+1]}-2018'"
elif [ $i -eq 11 ]
then
fromdate="'01-${arr1[$i]}-2018'"
todate="'01-${arr1[$i+1]}-2019'"
elif [ $i -gt 11 -a $i -lt 23 ]
then
fromdate="'01-${arr1[$i]}-2019'"
todate="'01-${arr1[$i+1]}-2019'"
else
fromdate="'01-${arr1[$i]}-2019'"
todate="'01-${arr1[$i+1]}-2020'"
echo $todate
fi

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
set define off
spool FMSIncidentOLA$fromdate-$todate.csv
-------------------FMS Incident extract------------------------------------
select
'IncidentNo'
||'|'||'Priority'
||'|'||'OpenTime'
||'|'||'Name'
||'|'||'TimeSpent'
||'|'||'HPSMStatus'
||'|'||'CurrentResolverGroup'
||'|'||'AssigneeName'
||'|'||'ResolvedTime'
||'|'||'Folder'
from Dual
union ALL
select
A."NUMBER"
||'|'||A.priority_code
||'|'||to_char(A.OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||replace(replace(B.name,chr(10),' '),chr(13),' ')
||'|'||(B.closed_total -to_date('01014000000000','ddmmyyyyhh24miss'))*24*60
||'|'||A.problem_status
||'|'||A.assignment
||'|'||A.assignee_name
||'|'||to_char(A.RESOLVED_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||replace(A.folder,chr(10),' ')
from
HPSM94BKPADMIN.probsummarym1 A, HPSM94BKPADMIN.clocksm1 B
where A."NUMBER"=B.key_char and B.key_char LIKE 'IM%' and A.folder='FMS' and (B.name like '%NOC - Mobile RAN%' or B.name like '%SOC - Access Mobile RAN%') and ((A.resolved_time+4/24>=$fromdate) and  (A.resolved_time+4/24<$todate) );
spool off;
quit;
EOF

/hpsm/hpsm/ops/reports/FMSIncidentOLA$fromdate-$todate.csv
gzip FMSIncidentOLA$fromdate-$todate.csv
echo "."| mail -v -s "Please find attached report" -a /hpsm/hpsm/ops/reports/FMSIncidentOLA$fromdate-$todate.csv.gz bhavana.tatti@du.ae
#/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\FMSReports\"; lcd /hpsm/hpsm/ops/; prompt; recurse; mput FMSIncidentOLA$fromdate-$todate.csv.gz; exit;"
done
