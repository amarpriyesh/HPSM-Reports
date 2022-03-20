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
spool THJumbo_quarterly.csv
-------------------THJumbo_weekly extract------------------------------------

select
'InteractionNo'
||'|'||'RelatedIncident'
||'|'||'LineManager'
||'|'||'Opened By'
||'|'||'RecipientName'
||'|'||'ResolverGroup'
||'|'||'MobileNumber'
||'|'||'EmployeeID'
||'|'||'Location'
||'|'||'Titile'
||'|'||'Assigneename'
||'|'||'Status'
||'|'||'Area'
||'|'||'SubArea'
||'|'||'OpenTime'
||'|'||'Brief Description'
||'|'||'Designation'
||'|'||'Department'
from Dual
UNION ALL
select
A.incident_id
||'|'||B.source
||'|'||A.du_line_manager
||'|'||A.opened_by
||'|'||A.du_fullname
||'|'||C.assignment
||'|'||A.du_home_phone
||'|'||A.du_employee_id
||'|'||A.du_location
||'|'||A.title
||'|'||C.assignee_name
||'|'||C.problem_status
||'|'||C.subcategory
||'|'||C.product_type
||'|'||to_char(C.open_time+4/24, 'mm-dd-yyyy HH24:MI:SS')
||'|'||replace(replace(DBMS_LOB.SUBSTR(C.action, 3000,1),chr(10)),chr(13))
||'|'||A.DU_TITLE
||'|'||A.DU_DEPARTMENT
from incidentsm1 A, screlationm1 B, probsummarym1 C where A.incident_id=B.depend(+) and 
B.source=C."NUMBER" and C.problem_status in ('Closed','Resolved') and C.assignment='IT - Technical Hardware Support (Jumbo Support)' and C.resolved_time>'31-Dec-2015'; 
spool off;
quit;
EOF
echo "."| mail -v -s "Technical Hardware Jumbo Support weekly Report for `date`" -a /hpsm/hpsm/ops/reports/THJumbo_quarterly.csv ankur.saxena@du.ae
