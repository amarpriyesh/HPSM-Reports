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
spool THJumbo_weekly.csv
-------------------THJumbo_weekly extract------------------------------------

select
'Incident ID'
||'|'||'RelatedInteraction'
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
C."NUMBER"
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
from incidentsm1 A, screlationm1 B, probsummarym1 C where C."NUMBER"=B.depend(+) and 
B.source=A.incident_id and C.resolved_time+4/24>=to_date('01/07/2015 00:00:00','DD/MM/YYYY HH24:MI:SS') and C.assignment='IT - Technical Hardware Support (Jumbo Support)'; 
spool off;
quit;
EOF
echo "."| mail -v -s "Technical Hardware Jumbo Support weekly Report for `date`" -a /hpsm/hpsm/ops/reports/THJumbo_weekly.csv THJumbo_weekly.csv nihalchand.dehury@du.ae
#( echo "Please find attached the Technical Hardware Jumbo Support weekly report"; uuencode THJumbo_weekly.csv THJumbo_weekly.csv)| mailx -s "Technical Hardware Jumbo Support weekly Report for `date`" "Jaya.Chandran@du.ae,nihalchand.dehury@du.ae"
