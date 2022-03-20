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
set headsep off
set linesize 20000
set feedback off
set echo off
spool Billshockusers$datestr.txt
-------------------Billshock Users Incident extract------------------------------------

select
'IncidentNo'
||'|'||'Type'
||'|'||'Date'
||'|'||'Operator'
||'|'||'Category'
||'|'||'Area'
||'|'||'SubArea'
||'|'||'OpenTime'
from Dual
union ALL
select distinct
b."NUMBER"
||'|'||b.type
||'|'||to_char(b.datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||b.operator
||'|'||a.category
||'|'||a.subcategory
||'|'||a.product_type
||'|'||a.open_time
from activitym1 b,probsummarym1 a where trunc(b.datestamp+4/24)=trunc(sysdate-1)
and  b.type in ('Resolved','Rejected','ReAssigned','Rejected to Business','Pending Input')
and (b.description LIKE '%Bill Shock to%') and b."NUMBER"=a."NUMBER";
spool off;
quit;
EOF

####FTP to Billing Server for BSCS Dashboard Requirement###
cd /hpsm/hpsm/ops/
ftp -n 172.21.27.13 <<EOF
user $USER $PASS
cd JBOSS/java_soft/BSCSTool_InputFiles/HPSMReports/
put Billshockusers$datestr.txt
bye
EOF
