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
spool SiebelHPSMIncidents_Oct2015$datestr.txt
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
||'|'||'AssetNo'
||'|'||'ContractId'
||'|'||'ServiceType'
||'|'||'SignatureAccount'
||'|'||'CustomerName'
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
||'|'||assignee_name
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
||'|'||du_asset_number
||'|'||du_contract_id
||'|'||du_service_type
||'|'||du_signature_account
||'|'||replace(full_name,'|')
||'|'||fnl_service_region
||'|'||fnl_service_subregion
||'|'||fnl_service_buildingname
||'|'||du_cust_accnumber
||'|'||is_dealer
||'|'||du_reopenCount
||'|'||resolution_code
||'|'||resolution_type
||'|'||resolution_area
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
where folder = 'SIEBEL-CRM' and open_time+4/24>=to_date('01/10/2015 00:00:00','dd/mm/yyyy hh24:mi:ss') 
and open_time+4/24<to_date('15/11/2015 00:00:00','dd/mm/yyyy hh24:mi:ss');
spool off;
quit;
EOF
gzip SiebelHPSMIncidents_Oct2015$datestr.txt
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\"; lcd /hpsm/hpsm/ops/reports; prompt; recurse; mput SiebelHPSMIncidents_Oct2015$datestr.txt.gz; exit;"
