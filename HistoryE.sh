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
spool historyE$datestr.csv
-------------------History extract------------------------------------

select 
'SysDate'
||'|'||'IncidentNo'
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
||'|'||'TTType'
||'|'||'RFO TAB'
||'|'||'Customer Type'
||'|'||'Action'
from Dual
UNION ALL
select
trunc(sysdate-1)
||'|'||b."NUMBER"
||'|'||replace(a.category,'
','')
||'|'||replace(a.subcategory,'
','')
||'|'||replace(a.product_type,'
','')
||'|'||a.priority_code
||'|'||a.assignment
||'|'||a.resolved_by
||'|'||to_char(a.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||b.type
||'|'||to_char(b.datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.close_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||replace(a.resolution_code,'
','')
||'|'||replace(a.resolution_type,'
','')
||'|'||replace(a.resolution_area,'
','')
||'|'||a.folder
||'|'||a.du_tt_type
||'|'||is_rfo
||'|'||du_cust_value
||'|'||replace(replace(DBMS_LOB.SUBSTR(description, 200,1),chr(10)),chr(13))
from probsummarym1 a, activitym1 b ,(Select "NUMBER" from probsummarym1 where trunc(CLOSE_TIME+4/24)>=trunc(sysdate-1)) c
where  a."NUMBER" = b."NUMBER" 
 and c."NUMBER" = b."NUMBER"  
and b.type in ('Open','ReAssigned','Assigned','Accepted','In Progress','Rejected',
'Rejected to Business','Resolved','Closed','Reopened','Pending Input','Auto Closure')
and a.problem_status='Closed';
spool off;
quit;
EOF
echo "."| mail -v -s "DailyTT History Report for `date`" -a /hpsm/ops/reports/historyE$datestr.csv "ankur.saxena@du.ae"
