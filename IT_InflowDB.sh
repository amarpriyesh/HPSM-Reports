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
spool IT_InflowDB$datestr.txt
-------------------History extract------------------------------------

select
'IncidentNo'
||'|'||'IncidentStatus'
||'|'||'IncidentCategory'
||'|'||'IncidentArea'
||'|'||'IncidentSubArea'
||'|'||'CurrentResolverGroup'
||'|'||'Priority'
||'|'||'CustomerType'
||'|'||'CustomerSegment'
||'|'||'CustomerService'
||'|'||'CustomerValue'
||'|'||'AssetNo'
||'|'||'ContractId'
||'|'||'ServiceType'
||'|'||'SignatureAccount'
||'|'||'CustomerName'
||'|'||'CustomerID'
||'|'||'OpenTime'
||'|'||'ResolvedBy'
||'|'||'LastUpdatedTime'
||'|'||'Folder'
||'|'||'TT Type'
||'|'||'Description'
||'|'||'LastUpdate'
from Dual
UNION ALL
select /*+ full(a) full(b) parallel(a,16) parallel(b,16)  */ distinct 
a."NUMBER"
||'|'||b.problem_status
||'|'||b.category
||'|'||b.subcategory
||'|'||b.product_type
||'|'||b.assignment
||'|'||b.priority_code
||'|'||b.du_cust_type
||'|'||b.du_cust_segment
||'|'||b.du_cust_service
||'|'||b.du_cust_value
||'|'||b.du_asset_number
||'|'||b.du_contract_id
||'|'||b.du_service_type
||'|'||b.du_signature_account
||'|'||b.full_name
||'|'||b.du_cust_accnumber
||'|'||to_char(b.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||b.resolved_by
||'|'||to_char(b.update_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||b.folder
||'|'||b.du_tt_type
||'|'||replace(replace(DBMS_LOB.SUBSTR(b.action, 1000,1),chr(10)),chr(13))
||'|'||replace(replace(DBMS_LOB.SUBSTR(b.update_action, 1000,1),chr(10)),chr(13))
from activitym1 a, probsummarym1 b where a."NUMBER"=b."NUMBER" and 
((a.type in ('ReAssigned', 'Rejected', 'Reopened') and (a.description LIKE '% to IT - Billing |%' or a.description LIKE '% to IT - GIS |%' 
or a.description LIKE '%to IT - ICS |%' or  a.description LIKE '%to IT - OSS-OPS-Fixed Mediation |%'
or a.description LIKE '%to IT - OSS-OPS-Mobile Mediation |%'
or a.description LIKE '%to IT - Payment Gateway' or a.description LIKE '%to IT - POS |%' or a.description LIKE '%to IT - Datawarehouse |%'
or a.description LIKE '%to IT - ERP |%' or a.description LIKE '%to IT - EAI |%' or  a.description LIKE '%to IT - EBusiness |%' or 
a.description LIKE '%to IT - OSS-OPS-Fault/Performance MGMT |%' or a.description LIKE '%to IT - OSS-OPS-Mobile Provisioning |%' or 
a.description LIKE '%to IT - OSS-OPS-Network Core Services |%' or a.description LIKE '%to IT - OSS-OPS-OAIM |%' or a.description LIKE '%to IT - CRM |%' 
or  a.description LIKE '%to IT - OSS-OPS- HPSM |%' or a.description LIKE '%to IT - OSS-OPS-Fixed Provisioning |%') and trunc(a.datestamp+4/24) = trunc(sysdate-5))
or
((b.assignment='IT - Billing' or b.assignment='IT - GIS' or b.assignment='IT - ICS' or b.assignment='IT - OSS-OPS-Fixed Mediation' or 
b.assignment='IT - OSS-OPS-Mobile Mediation' or b.assignment='IT - Payment Gateway'or b.assignment='IT - POS' or b.assignment='IT - Datawarehouse' or 
b.assignment='IT - ERP' or b.assignment='IT - EAI' or b.assignment='IT - EBusiness' or b.assignment='IT - OSS-OPS-Fault/Performance MGMT' or
b.assignment='IT - OSS-OPS-Mobile Provisioning' or b.assignment='IT - OSS-OPS-Network Core Services' or b.assignment='IT - OSS-OPS-OAIM' or
b.assignment='IT - CRM' or b.assignment='IT - OSS-OPS- HPSM' or b.assignment='IT - OSS-OPS-Fixed Provisioning')  and trunc(b.open_time) = trunc(sysdate-5) and b.problem_status='Open' )
or
 (a.type = 'Accepted' and trunc(b.open_time+4/24) = trunc(sysdate-5) and
(a.description LIKE '% to IT - Billing |%' or a.description LIKE '% to IT - GIS |%' or a.description LIKE '%to IT - ICS |%'
or  a.description LIKE '%to IT - OSS-OPS-Fixed Mediation |%'or  a.description LIKE '%to IT - OSS-OPS-Mobile Mediation |%'
or a.description LIKE '%to IT - Payment Gateway' or a.description LIKE '%to IT - POS |%'
or a.description LIKE '%to IT - Datawarehouse |%' or  a.description LIKE '%to IT - ERP |%'
or a.description LIKE '%to IT - EAI |%' or  a.description LIKE '%to IT - EBusiness |%'
or a.description LIKE '%to IT - OSS-OPS-Fault/Performance MGMT |%' or a.description LIKE '%to IT - OSS-OPS-Mobile Provisioning |%'
or a.description LIKE '%to IT - OSS-OPS-Network Core Services |%'or a.description LIKE '%to IT - OSS-OPS-OAIM |%'
or a.description LIKE '%to IT - CRM |%' or  a.description LIKE '%to IT - OSS-OPS- HPSM |%' or a.description LIKE '%to IT - OSS-OPS-Fixed Provisioning |%')
)
)
and b.du_master_tt is NULL;
spool off;
quit;
EOF
/usr/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/reports/ ; prompt; recurse; mput IT_InflowDB$datestr.txt; exit;"
