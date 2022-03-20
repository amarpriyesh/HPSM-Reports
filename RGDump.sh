tr=`date "+%d%m%y%H%M"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
spool RGDump.csv
-------------------Retail TT extract------------------------------------

select  /*+PARALLEL(5)*/ 
'IncidentNo'
||'|'||'Interaction ID'
||'|'||'Category'
||'|'||'Area'
||'|'||'SubArea'
||'|'||'Priority'
||'|'||'Status'
||'|'||'ResolverGroup'
||'|'||'ResolvedBy'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'CloseTime'
from Dual
UNION ALL
select  /*+PARALLEL(5)*/ 
a."NUMBER"
||'|'||a.incident_id
||'|'||a.category
||'|'||a.subcategory
||'|'||a.product_type
||'|'||a.priority_code
||'|'||a.problem_status
||'|'||a.assignment
||'|'||a.resolved_by
||'|'||to_char(a.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.close_time+4/24,'mm/dd/yyyy HH24:MI:SS')
from probsummarym1 a
where a.open_time+4/24>=to_date('01/03/2016 00:00:00','dd/mm/yyyy HH24:MI:SS') and a.assignment in ('IT - Database Admin','IT - System Admin UNIX','IT - System Admin WINDOWS','IT - SAN Admin','IT - Backup Admin');

spool off;
quit;
EOF
