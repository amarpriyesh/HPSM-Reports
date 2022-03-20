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
spool ALL_OPENITSD_TT_REPORT$datestr.txt
-------------------TT extract------------------------------------


select
'IncidentNo'
||'|'||'IncidentStatus'
||'|'||'Folder'
||'|'||'ResolverGroup'
||'|'||'AssigneeName'
||'|'||'OpenTime'
||'|'||'UpdatedTime'
||'|'||'Title'
||'|'||'Description'
from Dual
union ALL
select
"NUMBER"
||'|'||problem_status
||'|'||folder
||'|'||assignment
||'|'||assignee_name
||'|'||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(update_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(brief_description, 1000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' ')
||'|'||REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(action, 1000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' ')
from
HPSM94BKPADMIN.probsummarym1 
where (folder='ITSD' or assignment in ('IT - CRM - L2', 'IT - Billing - L2')) and problem_status not in ('Resolved', 'Closed');

spool off;
quit;
EOF
sed -i $'s/\t/ /g' ALL_OPENITSD_TT_REPORT$datestr.txt
gzip ALL_OPENITSD_TT_REPORT$datestr.txt
echo "."| mail -v -s "Please find attached ITSD OPEN TT report" -a /hpsm/hpsm/ops/reports/ALL_OPENITSD_TT_REPORT$datestr.txt.gz bhavana.tatti@du.ae,shwetha.ranjini@du.ae, priyesh.a@du.ae
