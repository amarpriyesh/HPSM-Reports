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
spool tsd_open_weekly$datestr.txt
-------------------TSD Open Weekly extract------------------------------------
select
'IncidentNo'
||'|'||'OpenTime'
||'|'||'Activity'
||'|'||'ServiceType'
||'|'||'Priority'
||'|'||'TimeSpent'
from Dual
union ALL
select
A."NUMBER"
||'|'||to_char(A.OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||B.name
||'|'||A.du_service_type
||'|'||A.priority_code
||'|'||(B.total -to_date('01014000000000','ddmmyyyyhh24miss'))*24*60
from
probsummarym1 A, clocksm1 B
where A."NUMBER"=B.key_char and A.open_time < trunc(sysdate) and A.open_time > trunc(sysdate-7)
and B.name LIKE 'TSD%';
spool off;
quit;
EOF
gzip tsd_open_weekly$datestr.txt 
( echo "Please find attached the TSD Response Time weekly report"; uuencode tsd_open_weekly$datestr.txt.gz tsd_open_weekly$datestr.txt.gz)| mailx -s "TSD Response Time weekly Report for `date`" "Ateeque.Hassan@du.ae,Syed.Ahsan@du.ae,Alfred.Gadon@du.ae,Youssef.Aboukhurj@du.ae,tech.sd@du.ae,CustomerServiceDeskReporting@du.ae,Samar.Khan@du.ae"
