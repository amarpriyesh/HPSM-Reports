cd
. .profile
cd /hpsm/hpsm/ops/
datestr=`date "+%d%m%y%H%M"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
spool itsd_open$datestr.txt
-------------------ITSD Open extract------------------------------------
select
'IncidentNo'
||'|'||'OpenTime'
||'|'||'UpdateTime'
||'|'||'Activity'
||'|'||'ServiceType'
||'|'||'Priority'
||'|'||'TimeSpent'
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
from
probsummarym1 A, clocksm1 B
where A."NUMBER"=B.key_char and A.open_time < trunc(sysdate) and A.open_time > trunc(sysdate-1)
and B.name = 'IT - TSD IT.Open';
spool off;
quit;
EOF
/usr/sfw/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/ ; prompt; recurse; mput itsd_open$datestr.txt; exit;"
