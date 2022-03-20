cd 
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/
datestr=`date "+%d%m%y%H%M"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
spool tsd_open$datestr.txt
-------------------TSD Open extract------------------------------------
select
'IncidentNo'
||'|'||'OpenTime'
||'|'||'UpdateTime'
||'|'||'Activity'
||'|'||'ServiceType'
||'|'||'Priority'
||'|'||'TimeSpent'
||'|'||'Auto Assigned'
from Dual
union ALL
select
A."NUMBER"
||'|'||to_char(A.OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(A.UPDATE_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||B.name
||'|'||A.du_service_type
||'|'||A.priority_code
||'|'||(B.total -to_date('01014000000000','ddmmyyyyhh24miss'))*24*60
||'|'||A.auto_assigned
from
probsummarym1 A, clocksm1 B
where A."NUMBER"=B.key_char and trunc(A.open_time+4/24) = trunc(sysdate-1)
and (B.name LIKE 'TSD%' or B.name LIKE 'CSM%');
spool off;
quit;
EOF
gzip tsd_open$datestr.txt 
( echo "Please find attached the TSD Response Time report"; uuencode tsd_open$datestr.txt.gz tsd_open$datestr.txt.gz)| mailx -s "TSD Response Time Report for `date`" "nihalchand.dehury@du.ae"

/usr/bin/smbclient \\\\172.22.31.31\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\TSD Reports\"; lcd /hpsm/hpsm/ops/reports/; prompt; recurse; mput tsd_open$datestr.txt.gz  exit;"
