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
spool Monthly_RFC_DB$datestr.txt
-------------------RFC Details extract------------------------------------

select
'ChangeID'
||'|'||'TaskID'
||'|'||'ChangeCategory'
||'|'||'TaskOpenTime'
||'|'||'ChangePhase'
||'|'||'Priority'
||'|'||'TaskStatus'
||'|'||'TaskCloseTime'
||'|'||'TaskPlannedStart'
||'|'||'TaskPlannedEnd'
||'|'||'TaskActualStart'
||'|'||'TaskActualEnd'
||'|'||'ChangePlannedDowntimeStart'
||'|'||'ChangePlannedDowntimeEnd'
||'|'||'TaskDowntimeStart'
||'|'||'TaskDowntimeEnd'
||'|'||'Assignment Group'
||'|'||'Assignee Name'
||'|'||'InitiatedBy'
||'|'||'SubCategory'
||'|'||'Emergency'
||'|'||'TaskDescription'
from Dual
union ALL
select 
A.parent_change
||'|'||A."NUMBER"
||'|'||B.category
||'|'||to_char(A.orig_date_entered+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||B.current_phase
||'|'||B.priority_code
||'|'||A.status
||'|'||to_char(A.CLOSE_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(A.planned_start+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(A.planned_end+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(A.actualstart+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(A.actualend+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(B.down_start+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(B.down_end+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(A.down_start+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(A.down_end+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||A.assign_dept
||'|'||A.assigned_to
||'|'||B.requested_by
||'|'||B.subcategory
||'|'||B.emergency
||'|'||replace(replace(DBMS_LOB.SUBSTR(A.description, 100,1),chr(10)),chr(13))
from CM3TM1 A, CM3RM1 B where A.parent_change=b."NUMBER" and (A.CLOSE_TIME+4/24) >= trunc(trunc(sysdate,'MM')-1,'MM')
and (A.CLOSE_TIME+4/24) < trunc(sysdate,'MM')
and A.assign_dept in ('IT - Billing','IT - GIS','IT - ICS','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT - Payment Gateway',
'IT - POS' ,'IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT',
'IT - OSS-OPS-Mobile Provisioning' ,'IT - OSS-OPS-Network Core Services' ,'IT - OSS-OPS-OAIM' ,'IT - CRM','IT - OSS-OPS- HPSM');
spool off;
quit;
EOF
/usr/sfw/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/reports/ ; prompt; recurse; mput Monthly_RFC_DB$datestr.txt; exit;"
