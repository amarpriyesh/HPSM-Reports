cd
. ./.bash_profile
cd /hpsm/hpsm/ops/
datestr=`date "+%d%m%y"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
spool AS_Throughput_Test$datestr.txt
------------------- TT Incident extract------------------------------------

select
'IncidentNo'
||'|'||'Type'
||'|'||'Priority'
||'|'||'Date'
||'|'||'Operator'
||'|'||'Category'
||'|'||'Area'
||'|'||'SubArea'
||'|'||'Folder'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'ClosedTime'
||'|'||'Cust Value'
||'|'||'TT Type'
||'|'||'ResolverGroup'
||'|'||'ResolutionCategory'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'IssueDescription'
||'|'||'Resolution'
||'|'||'Group Status'
from Dual
union ALL
select distinct
b."NUMBER"
||'|'||b.type
||'|'||a.priority_code
||'|'||to_char(b.datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||b.operator
||'|'||a.category
||'|'||a.subcategory
||'|'||a.product_type
||'|'||a.folder
||'|'||to_char(a.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.close_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||a.du_cust_value
||'|'||a.DU_TT_TYPE
||'|'||a.assignment
||'|'||replace(replace(replace(resolution_code,chr(10)),chr(13)),chr(9))
||'|'||replace(replace(replace(resolution_type,chr(10)),chr(13)),chr(9))
||'|'||replace(replace(replace(resolution_area,chr(10)),chr(13)),chr(9))
||'|'||replace(replace(DBMS_LOB.SUBSTR(b.description, 150,1),chr(10)),chr(13))
||'|'||replace(replace(DBMS_LOB.SUBSTR(a.action, 150,1),chr(10)),chr(13))
||'|'||replace(replace(DBMS_LOB.SUBSTR(a.RESOLUTION , 1500,1),chr(10)),chr(13))
from activitym1 b,probsummarym1 a 
where trunc(b.datestamp+4/24)= trunc(sysdate-1) and 
b.type in ('Resolved','Rejected','ReAssigned','Rejected to Business')
and (b.description LIKE '%IT - Billing to%') and b."NUMBER"=a."NUMBER";




spool off;
quit;
EOF

echo "."| mail -v -s "Weekly Throughput report `date`" -a /hpsm/hpsm/ops/AS_Throughput_Test$datestr.txt nihalchand.dehury@du.ae
