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
spool IT_Throughput$datestr.txt
-------------------History extract------------------------------------

select
'IncidentNo'
||'|'||'Type'
||'|'||'Date'
||'|'||'Operator'
||'|'||'Category'
||'|'||'Area'
||'|'||'SubArea'
||'|'||'Folder'
||'|'||'OpenTime'
||'|'||'Cust Value'
||'|'||'Description'
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
||'|'||a.folder
||'|'||to_char(a.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||a.du_cust_value
||'|'||replace(replace(DBMS_LOB.SUBSTR(b.description, 1500,1),chr(10)),chr(13))
from activitym1 b,probsummarym1 a where (b.datestamp+4/24 < trunc(sysdate) and b.datestamp+4/24 >= trunc(sysdate-1)) and
b.type in ('Resolved','Rejected','ReAssigned','Rejected to Business')
and (b.description LIKE '%IT - Billing to%' or b.description LIKE '%IT - GIS to%'
or b.description LIKE '%IT - ICS to%' or b.description LIKE '%IT - OSS-OPS-Fixed Mediation to%'
or b.description LIKE '%IT - OSS-OPS-Mobile Mediation to%' or b.description LIKE '%IT - Payment Gateway to%'
or b.description LIKE '%IT - POS to%' or b.description LIKE'%IT - Datawarehouse to%'
or b.description LIKE '%IT - ERP to%' or b.description LIKE '%IT - EAI to%'
or b.description LIKE '%IT - EBusiness to%' or b.description LIKE '%IT - OSS-OPS-Fault/Performance MGMT to%'
or b.description LIKE '%IT - OSS-OPS-Mobile Provisioning to%' or b.description LIKE'%IT - OSS-OPS-Network Core Services to%'
or b.description LIKE'%IT - OSS-OPS-OAIM to%' or b.description LIKE'%IT - CRM to%'
or b.description LIKE '%IT - OSS-OPS- HPSM to%' or b.description LIKE '%IT - OSS-OPS-Fixed Provisioning to%') and b."NUMBER"=a."NUMBER";
spool off;
quit;
EOF
/usr/sfw/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/reports/ ; prompt; recurse; mput IT_Throughput$datestr.txt; exit;"
