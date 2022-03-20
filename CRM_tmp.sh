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
spool history_crm_TT$datestr.txt
-------------------History extract------------------------------------

select 
'IncidentNo'
||'|'||'Category'
||'|'||'Area'
||'|'||'SubArea'
||'|'||'Priority'
||'|'||'ResolverGroup'
||'|'||'ResolvedBy'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'ActivityType'
||'|'||'UpdateTime'
||'|'||'CloseTime'
||'|'||'ResolutionCategory'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'Folder'
||'|'||'Customer Value'
||'|'||'Reopen COunt'
||'|'||'TTType'
||'|'||'Action'
from Dual
UNION ALL
select
b."NUMBER"
||'|'||a.category
||'|'||a.subcategory
||'|'||a.product_type
||'|'||a.priority_code
||'|'||a.assignment
||'|'||a.resolved_by
||'|'||to_char(a.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||b.type
||'|'||to_char(b.datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.close_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||a.resolution_code
||'|'||a.resolution_type
||'|'||a.resolution_area
||'|'||a.folder
||'|'||a.du_cust_value
||'|'||a.du_reopencount
||'|'||a.du_tt_type
||'|'||replace(replace(DBMS_LOB.SUBSTR(action, 200,1),chr(10)),chr(13))
from probsummarym1 a, activitym1 b 
where  a."NUMBER" = b."NUMBER"  
and b.type in ('Open','ReAssigned','Assigned','Accepted','In Progress','Rejected',
'Rejected to Business','Resolved','Closed','Reopened','Pending Input','Auto Closure')
and  a.folder ='SIEBEL-CRM' and b.datestamp between '26-jun-2018' and '28-jun-2018';
spool off;
quit;
EOF
gzip history_crm_TT$datestr.txt
ech0 "." | mail -s "crm_tt" -a /hpsm/hpsm/ops/reports/history_crm_TT$datestr.txt.gz priyesh.a@du.ae




