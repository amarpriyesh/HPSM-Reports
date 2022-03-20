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
spool tsd_weekly$datestr.txt
-------------------TSD Weekly extract------------------------------------
select
'IncidentNo'
||'|'||'Operator'
||'|'||'Activity'
||'|'||'ActionTime'
||'|'||'Action'
from Dual
union ALL
select
"NUMBER"
||'|'||operator
||'|'||type
||'|'||to_char(datestamp+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||replace(replace(DBMS_LOB.SUBSTR(description, 2000,1),chr(10)),chr(13))
from 
activitym1 where datestamp < trunc(sysdate) and datestamp > trunc(sysdate-7) and type in ('Open','Accepted','In Progress','Pending Input','Resolved','Rejecte
d',
'ReAssigned','Rejected to Business') and operator<>'falcon' and description LIKE '%TSD%';
spool off;
quit;
EOF
gzip tsd_weekly$datestr.txt 
( echo "Please find attached the TSD weekly report"; uuencode tsd_weekly$datestr.txt.gz tsd_weekly$datestr.txt.gz)| mailx -s "TSD weekly Report for `date`" "Youssef.Aboukhurj@du.ae,tech.sd@du.ae,CustomerServiceDeskReporting@du.ae,Samar.Khan@du.ae"
