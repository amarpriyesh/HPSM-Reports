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
spool SiebelHPSMIncidents3months$datestr.txt
-------------------SIEBEL HPSM Incident extract------------------------------------

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
||'|'||'ReassignmentCount'
||'|'||'ResolutionAction'
||'|'||'Auto Routed'
||'|'||'SLA Startdate'
||'|'||'SLA Enddate'
||'|'||'SLA Remaining'
||'|'||'SLA Expiration'
||'|'||'SLA Breach'
||'|'||'is_Master TT'
||'|'||'Master TT ID'
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
||'|'||count
||'|'||resolution_action
||'|'||auto_assigned
||'|'||du_sla_start
||'|'||du_sla_end
||'|'||SLA_remaining
||'|'||SLA_Expire
||'|'||SLA_breach
||'|'||du_master_tt
||'|'||du_mastertt
from 
probsummarym1
where folder = 'SIEBEL-CRM'  and ((close_time+4/24>=to_date('01/07/2018 00:00:00','dd/mm/yyyy hh24:mi:ss') or (resolved_time+4/24>=to_date('01/07/2018 00:00:00','dd/mm/yyyy hh24:mi:ss')))  and (close_time+4/24<=to_date('01/10/2018 00:00:00','dd/mm/yyyy hh24:mi:ss') or (resolved_time+4/24<=to_date('01/10/2018 00:00:00','dd/mm/yyyy hh24:mi:ss')))  )  ;
spool off;
quit;
EOF
sed -i $'s/\t/ /g' SiebelHPSMIncidents3months$datestr.txt
gzip SiebelHPSMIncidents3months$datestr.txt
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\"; lcd /hpsm/hpsm/ops/reports; prompt; recurse; mput SiebelHPSMIncidents3months$datestr.txt.gz; exit;"
