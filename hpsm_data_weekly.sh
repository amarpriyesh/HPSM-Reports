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
spool hpsm_data_weekly$datestr.txt
-------------------HPSM Incident History extract------------------------------------
select
'SysDate'
||'|'||'TroubleTicketNumber'
||'|'||'IncidentNo'
||'|'||'Category'
||'|'||'Priority'
||'|'||'ResolverGroup'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'ActivityType'
||'|'||'UpdateTime'
||'|'||'CloseTime'
||'|'||'Folder'
||'|'||'Action'
||'|'||'StatusChange'
from Dual
UNION ALL
select
distinct
trunc(sysdate-1)
||'|'||a.reference_no
||'|'||b."NUMBER"
||'|'||a.category
||'|'||a.priority_code
||'|'||a.assignment
||'|'||to_char(a.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||b.type
||'|'||to_char(b.datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.close_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||a.folder
||'|'||replace(replace(DBMS_LOB.SUBSTR(description, 200,1),chr(10)),chr(13))
from probsummarym1 a, activitym1 b
where  a."NUMBER" = b."NUMBER"
and b.type in ('Open','ReAssigned','Assigned','Accepted','In Progress','Rejected',
'Rejected to Business','Resolved','Closed','Reopened','Pending Input','Auto Closure')
and trunc(a.open_time+4/24) >= trunc(sysdate-29) and trunc(a.open_time+4/24) < trunc(sysdate-1) and a.folder='SIEBEL-CRM';
spool off;
quit;
EOF
/usr/sfw/bin/smbclient\\\\172.22.31.31\\Public\$ -A .passwd.txt -c "cd \"CEP Analytics\60 Inputs\HPSM\"; lcd /hpsm/hpsm/ops/; prompt; recurse;mput hpsm_data_weekly$datestr.txt; exit;
