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
spool CUstomerTT_Inflow$datestr.txt
-------------------CUstomerTT_Inflow extract------------------------------------

select
'Incident No'
||'|'||'Inflow Time'
||'|'||'Folder'
||'|'||'Status'
||'|'||'Description'
from Dual
UNION ALL
select b."NUMBER"
||'|'||to_char(a.datestamp+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||b.folder
||'|'||b.problem_status
||'|'||replace(replace(DBMS_LOB.SUBSTR(a.description, 100,1),chr(10)),chr(13))
from 
probsummarym1 b,activitym1 a where
a."NUMBER"=b."NUMBER" and b.Folder='SIEBEL-CRM' and a.type in ('Open','Reopened','ReAssigned','Rejected') 
and b.problem_status not in ('Resolved','Closed')
and (a.description LIKE '% to IT - Billing |%' or a.description LIKE '% to IT - GIS |%' 
or a.description LIKE '%to IT - ICS |%' or  a.description LIKE '%to IT - OSS-OPS-Fixed Mediation |%' or  a.description LIKE '%to IT - OSS-OPS-Mobile Mediation |%' or 
a.description LIKE '%to IT - Payment Gateway |%' or a.description LIKE '%to IT - POS |%' or a.description LIKE '%to IT - Datawarehouse |%' or 
a.description LIKE '%to IT - ERP |%' or a.description LIKE '%to IT - EAI |%' or  a.description LIKE '%to IT - EBusiness |%' 
or a.description LIKE '%to IT - OSS-OPS-Fault/Performance MGMT |%' or a.description LIKE '%to IT - OSS-OPS-Mobile Provisioning |%' 
or a.description LIKE '%to IT - OSS-OPS-Network Core Services |%' or a.description LIKE '%to IT - OSS-OPS-OAIM |%' 
or a.description LIKE '%to IT - CRM |%' or  a.description LIKE '%to IT - OSS-OPS- HPSM |%' or a.description LIKE '%to IT - OSS-OPS-Fixed Provisioning |%');
spool off;
quit;
EOF
/usr/sfw/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/reports/ ; prompt; recurse; mput CUstomerTT_Inflow$datestr.txt; exit;"
