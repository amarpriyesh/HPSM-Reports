cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/
USER=nrs
PASS=nrs123
datestr=`date "+%d%m%y"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
spool Network_Core_Services_Weekly$datestr.csv
-------------------Weekly Network Core Services TT Incident extract------------------------------------
select
'IncidentNo'
||','||'Type'
||','||'Date'
||','||'Operator'
||','||'Category'
||','||'Area'
||','||'SubArea'
||','||'Folder'
||','||'OpenTime'
||','||'ResolvedBy'
||','||'ResolvedTime'
||','||'FinalResolution'
||','||'ReAssignmentReason'
||','||'BriefDescription'
||','||'Description'
from Dual
union ALL
select /*+ full(a) full(b) parallel(a,16) parallel(b,16)  */  distinct
b."NUMBER"
||','||b.type
||','||to_char(b.datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||b.operator
||','||a.category
||','||a.subcategory
||','||a.product_type
||','||a.folder
||','||to_char(a.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||a.resolved_by
||','||a.resolved_time
||','||replace(replace(replace(DBMS_LOB.SUBSTR(a.resolution, 200,1),chr(10)),chr(13)),chr(9))
||','||replace(replace(DBMS_LOB.SUBSTR(b.description, 150,1),chr(10)),chr(13))
||','||a.brief_description
||','||replace(replace(DBMS_LOB.SUBSTR(a.action, 150,1),chr(10)),chr(13))
from activitym1 b,probsummarym1 a where (b.datestamp+4/24 < trunc(sysdate,'D') and b.datestamp+4/24 > trunc(sysdate-7,'D')) and
b.type in ('Resolved','Rejected','Rejected to Business','Reassignment reason') and 
(b.description LIKE '%IT - OSS-OPS-Network Core Services to%') and b."NUMBER"=a."NUMBER";

spool off;
quit;
EOF
echo "."| mail -v -s "weekly Network Core Services TT Report for Last Week" -a /hpsm/hpsm/ops/reports/Network_Core_Services_Weekly$datestr.csv Nihalchand.Dehury@du.ae,Anusha.y@du.ae,Sandeep.Thenkudy@du.ae
#( echo "Please find attached weekly Network Core Services Incidents report"; uuencode Network_Core_Services_Weekly$datestr.csv Network_Core_Services_Weekly$datestr.csv)| mailx -s "weekly Network Core Services TT Report for Last Week" "Nihalchand.Dehury@du.ae,Anusha.y@du.ae,Sandeep.Thenkudy@du.ae"
