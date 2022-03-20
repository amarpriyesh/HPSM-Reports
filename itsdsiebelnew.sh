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
spool SIEBEL_TT$datestr.txt
-------------------ITSD Incident extract------------------------------------
select 
'IncidentNo'
||'|'||'SiebelTTNo'
||'|'||'IncidentCreatedat'
||'|'||'IncidentStatus'
||'|'||'Opened By'
||'|'||'Assignee Name'
||'|'||'IncidentCategory'
||'|'||'IncidentArea'
||'|'||'IncidentSubArea'
||'|'||'SiebelTTCreatedAt'
||'|'||'CurrentResolverGroup'
||'|'||'Priority'
||'|'||'SiebelTTStatus'
||'|'||'CustomerType'
||'|'||'CustomerSegment'
||'|'||'CustomerService'
||'|'||'CustomerValue'
||'|'||'ContractId'
||'|'||'ServiceType'
||'|'||'SignatureAccount'
||'|'||'ServiceRegion'
||'|'||'SubRegion'
||'|'||'ServiceBuildingName'
||'|'||'CustomerID'
||'|'||'IsDealer'
||'|'||'Folder'
||'|'||'ReopenCount'
||'|'||'ResolutionCategory'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'SiebelActivityId'
||'|'||'LastUpdatedTime'
||'|'||'ClosedTime'
||'|'||'ResolvedTime'
||'|'||'GAID'
||'|'||'ResolvedBy'
from Dual
UNION ALL
select 
"NUMBER"
||'|'||REFERENCE_NO
||'|'||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||problem_status
||'|'||opened_by
||'|'||replace(replace(assignee_name,chr(10),' '),chr(13),' ')
||'|'||category
||'|'||subcategory
||'|'||product_type
||'|'||to_char(du_siebel_open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||assignment
||'|'||priority_code
||'|'||du_siebel_status
||'|'||du_cust_type
||'|'||du_cust_segment
||'|'||du_cust_service
||'|'||du_cust_value
||'|'||du_contract_id
||'|'||du_service_type
||'|'||du_signature_account
||'|'||fnl_service_region
||'|'||fnl_service_subregion
||'|'||fnl_service_buildingname
||'|'||du_cust_accnumber
||'|'||is_dealer
||'|'||folder
||'|'||du_reopenCount
||'|'||replace(replace(resolution_code,chr(10),' '),chr(13),' ')
||'|'||replace(replace(resolution_type,chr(10),' '),chr(13),' ')
||'|'||replace(replace(resolution_area,chr(10),' '),chr(13),' ')
||'|'||du_activity_ref_no
||'|'||to_char(update_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(close_time+4/24, 'mm/dd/yyyy HH24:MI:SS') 
||'|'||to_char(resolved_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||fnl_service_gaid
||'|'||resolved_by
from 
probsummarym1
where folder = 'SIEBEL-CRM' and assignment in (select bucket from ebucket1) and  (resolved_time+4/24>=trunc(sysdate)  and  resolved_time+4/24<=(trunc(sysdate)+20/24)) ;

spool off;
quit;
EOF

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
spool ITSD_TT$datestr.txt
-------------------ITSD Incident extract------------------------------------
select 
'IncidentNo'
||'|'||'SiebelTTNo'
||'|'||'IncidentCreatedat'
||'|'||'IncidentStatus'
||'|'||'Opened By'
||'|'||'Assignee Name'
||'|'||'IncidentCategory'
||'|'||'IncidentArea'
||'|'||'IncidentSubArea'
||'|'||'SiebelTTCreatedAt'
||'|'||'CurrentResolverGroup'
||'|'||'Priority'
||'|'||'SiebelTTStatus'
||'|'||'CustomerType'
||'|'||'CustomerSegment'
||'|'||'CustomerService'
||'|'||'CustomerValue'
||'|'||'ContractId'
||'|'||'ServiceType'
||'|'||'SignatureAccount'
||'|'||'ServiceRegion'
||'|'||'SubRegion'
||'|'||'ServiceBuildingName'
||'|'||'CustomerID'
||'|'||'IsDealer'
||'|'||'Folder'
||'|'||'ReopenCount'
||'|'||'ResolutionCategory'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'SiebelActivityId'
||'|'||'LastUpdatedTime'
||'|'||'ClosedTime'
||'|'||'ResolvedTime'
||'|'||'GAID'
||'|'||'ResolvedBy'
from Dual
UNION ALL
select 
"NUMBER"
||'|'||REFERENCE_NO
||'|'||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||problem_status
||'|'||opened_by
||'|'||replace(replace(assignee_name,chr(10),' '),chr(13),' ')
||'|'||category
||'|'||subcategory
||'|'||product_type
||'|'||to_char(du_siebel_open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||assignment
||'|'||priority_code
||'|'||du_siebel_status
||'|'||du_cust_type
||'|'||du_cust_segment
||'|'||du_cust_service
||'|'||du_cust_value
||'|'||du_contract_id
||'|'||du_service_type
||'|'||du_signature_account
||'|'||fnl_service_region
||'|'||fnl_service_subregion
||'|'||fnl_service_buildingname
||'|'||du_cust_accnumber
||'|'||is_dealer
||'|'||folder
||'|'||du_reopenCount
||'|'||replace(replace(resolution_code,chr(10),' '),chr(13),' ')
||'|'||replace(replace(resolution_type,chr(10),' '),chr(13),' ')
||'|'||replace(replace(resolution_area,chr(10),' '),chr(13),' ')
||'|'||du_activity_ref_no
||'|'||to_char(update_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(close_time+4/24, 'mm/dd/yyyy HH24:MI:SS') 
||'|'||to_char(resolved_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||fnl_service_gaid
||'|'||resolved_by
from 
probsummarym1
where folder = 'ITSD' and assignment in (select bucket from ebucket1) and  (resolved_time+4/24>=trunc(sysdate)  and  resolved_time+4/24<=(trunc(sysdate)+20/24)) ;

spool off;
quit;
EOF

number1=`sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
select count(*)from probsummarym1 where folder = 'ITSD' and assignment in (select bucket from ebucket1) and (resolved_time+4/24>=trunc(sysdate)  and  resolved_time+4/24<=(trunc(sysdate)+20/24)) ;
quit;
EOF
`
number2=`sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
select count(*)from probsummarym1 where folder = 'SIEBEL-CRM' and assignment in (select bucket from ebucket1) and (resolved_time+4/24>=trunc(sysdate)  and resolved_time+4/24<=(trunc(sysdate)+20/24)) ;
quit;
EOF
`

gzip ITSD_TT$datestr.txt
gzip SIEBEL_TT$datestr.txt

echo -e "Dear All,\n\nPlease Find below number of tickets resolved\n\n Total ITSD Tickets Resolved: $number1\n\n Total SIEBEL Tickets Resolved: $number2 \n\nRegards \nHPSM Team"| mail -s "ITSD  SIEBEL tts for date $datestr" -a SIEBEL_TT$datestr.txt.gz -a ITSD_TT$datestr.txt.gz  priyesh.a@du.ae,ankur.saxena@du.ae,gunjan.mathur@du.ae,Achin.Tiwari@du.ae,Prasanna.Kumar@du.ae
