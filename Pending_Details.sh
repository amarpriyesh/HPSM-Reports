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
spool Pending_Details$datestr.txt
-------------------Pending Details extract------------------------------------
select
'IncidentNo'
||'|'||'IncidentCreatedate'
||'|'||'IncidentStatus'
||'|'||'CurrentResolverGroup'
||'|'||'Priority'
||'|'||'TT Type'
||'|'||'Activity Type'
||'|'||'Operator'
||'|'||'Activity Datestamp'
||'|'||'ResolvedTime'
||'|'||'ClosedTime'
||'|'||'PendingWithVendor'
||'|'||'PendingWithCustomer'
||'|'||'PendingWithThirdParty'
||'|'||'Pending for Others'
||'|'||'Engaged with other task'
||'|'||'Pending for Transport'
||'|'||'Pending for Site Visit'
||'|'||'Pending for Hardware'
||'|'||'Pending for CR Implementation'
||'|'||'Pending for Testing'
||'|'||'Pending with Development/Planning'
||'|'||'Pending for Site Access'
||'|'||'Brief Description'
||'|'||'Resolution'
||'|'||'Activity Description'
from Dual
UNION ALL
select
distinct a."NUMBER"
||'|'||to_char(b.OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||b.problem_status
||'|'||b.assignment
||'|'||b.priority_code
||'|'||b.du_tt_type
||'|'||a.type
||'|'||a.operator
||'|'||to_char(a.datestamp+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(b.resolved_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(b.close_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS')
from clocksm1 where name = 'Pending Vendor' and KEY_CHAR = a."NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS')
from clocksm1 where name = 'Pending Customer' and KEY_CHAR = a."NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS')
from clocksm1 where name = 'Pending Third Party' and KEY_CHAR = a."NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS')
from clocksm1 where name = 'Pending for Others' and KEY_CHAR = a."NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS')
from clocksm1 where name = 'Engaged with other task' and KEY_CHAR = a."NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS')
from clocksm1 where name = 'Pending for Transport' and KEY_CHAR = a."NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS')
from clocksm1 where name = 'Pending for Site Visit' and KEY_CHAR = a."NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS')
from clocksm1 where name = 'Pending for Hardware' and KEY_CHAR = a."NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS')
from clocksm1 where name = 'Pending for CR Implementation' and KEY_CHAR = a."NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS')
from clocksm1 where name = 'Pending for Testing' and KEY_CHAR = a."NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS')
from clocksm1 where name = 'Pending with Development/Planning' and KEY_CHAR = a."NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS')
from clocksm1 where name = 'Pending for Site Access' and KEY_CHAR = a."NUMBER")
||'|'||REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(brief_description, 2000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' ')
||'|'||REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(resolution, 2000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' ')
||'|'||REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(a.description, 2000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' ')
from activitym1 a, probsummarym1 b where a."NUMBER"=b."NUMBER" and
(a.type in ('ReAssigned','Reopened') and (a.description LIKE '%to IT - Technical Support%' or a.description LIKE '%to IT - Corporate Technical Support%' or a
.description LIKE '%to IT - TSD IT%')
and ((a.datestamp+4/24) >= trunc(sysdate-7)));
spool off;
quit;
EOF
gzip Pending_Details$datestr.txt 
( echo "Please find attached Pending Details report"; uuencode Pending_Details$datestr.txt.gz Pending_Details$datestr.txt.gz)| mailx -s "Pending Details Report for `date`" "nihalchand.dehury@du.ae"
