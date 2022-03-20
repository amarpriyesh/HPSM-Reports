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
spool ALL_TT_REPORT$datestr.csv
-------------------TT extract------------------------------------


select
'IncidentNo'
||'|'||'IncidentStatus'
||'|'||'Opened_By'
||'|'||'Assignee_Name'
||'|'||'IncidentCategory'
||'|'||'IncidentArea'
||'|'||'IncidentSubArea'
||'|'||'priority'
||'|'||'CurrentResolverGroup'
||'|'||'CustomerValue'
||'|'||'AssigneeName'
||'|'||'ResolutionCode'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'OpenTime'
||'|'||'ClosedTime'
||'|'||'ResolvedTime'
||'|'||'Type'
||'|'||'ClosedBy'
||'|'||'ResolvedBy'
||'|'||'ReassignmentCount'
||'|'||'ReopenCount'
||'|'||'SLA-START'
||'|'||'SLA-REMAINING'
||'|'||'TT_TYPE'
from Dual
union ALL
select
A."NUMBER"
||'|'||problem_status
||'|'||opened_by
||'|'||assignee_name
||'|'||category
||'|'||subcategory
||'|'||product_type
||'|'||priority_code
||'|'||assignment
||'|'||du_cust_value
||'|'||assignee_name
||'|'||resolution_code
||'|'||resolution_type
||'|'||resolution_area
||'|'||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(close_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(Resolved_Time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||folder
||'|'||Closed_By
||'|'||Resolved_By
||'|'||Count
||'|'||du_reopencount
||'|'||to_char(DU_SLA_START+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||SLA_REMAINING
||'|'||du_tt_type
from
probsummarym1 A
where Assignment in ('FNL_OPs','IT - Content Portal Application Support','IT - Database Admin','IT - Interconnect Billing','IT - OSS-OPS- HPSM - L2','IT - OSS-OPS-Fault/Performance MGMT - L2','IT - OSS-OPS-Fixed Provisioning','KMUCC Support','KMUCC Support - L2','eShop_L1','eShop_L2','IT SSM Application Support','IT APIGateway ops','IT - BSCS Provisioning','IT - Cognos','RSS Support Group','IT - Datawarehouse','IT - Teradata Database Admin','IT - OSS-OPS-Fault/Performance MGMT','IT - DB Systems (L1)','IT - SAN (L1)','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT - OPS duVerse support','DuVerse Access','IT - Billing','IT - CRM','IT - OSS (Service Assurance)','IT - OSS-OPS-Fault/Performance MGMT','IT - OSS-OPS-OPA','IT - EAI','IT - EBusiness','IT - EDMS','IT - ERP','IT - GIS','IT - ICS','IT - OSS-OPS- HPSM','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','Prime Application','IT - OSS-OPS-Mobile Provisioning','IT - OSS-OPS-OAIM','IT - POS','IT DSP Application Support','IT - Payment Gateway','IT - Business Application Access','IT - OSS (Service Assurance)','IT - MNMI (Application Support)','IT - MNP Application Support','IT - FMS','IT - ERP','NOC - IN','Bill Shock','Core - Mobile IN','IT - Enterprise Systems (HMC)','IT - OSS (Service Assurance)','IT Retail Business Application Support','IT - EDMS','IAM - IN','Bill Shock - L2','Campaign Mgmt - L2','Core - Mobile IN - L2','DuVerse Access - L2','FNL_OPs - L2','IAM - IN - L2','IT - Billing - L2','IT - Business Application Access - L2','IT - CRM - L2','IT - Cognos - L2','IT - Content Portal Application Support - L2','IT - Datawarehouse - L2','IT - EAI - L2','IT - EBusiness - L2','IT - EDMS - L2','IT - ERP - L2','IT - GIS - L2','IT - ICS - L2','IT - Incentive Compensation Management - L2','IT - Interconnect Billing - L2','IT - MNMI (Application Support) - L2','IT - MNP Application Support - L2','IT - OSS-OPS-Fixed Mediation - L2','IT - OSS-OPS-Fixed Provisioning - L2','IT - OSS-OPS-Mobile Mediation - L2','IT - Power Billing','IT - Power Billing - L2','IT - OSS-OPS-Mobile Provisioning - L2','IT - OSS-OPS-OAIM - L2','IT - POS - L2','IT - Payment Gateway - L2','IT DSP Application Support - L2','IT SMS GW - L2','ITOC-Execution-Apps - L2','ITOC-Execution-IN - L2','ITOC-Execution-Infra - L2','NOC - IN - L2','RA - Moneta - Ops - L2') AND open_time+4/24 >= trunc(sysdate-60);

spool off;
quit;
EOF
gzip ALL_TT_REPORT$datestr.csv
echo "."| mail -v -s " ALL TT REPORT for `date`" -a /hpsm/hpsm/ops/reports/ALL_TT_REPORT$datestr.csv.gz ankur.saxena@du.ae,ankur.gahlaut1@du.ae,ankit.saxena1@du.ae,priyesh.a@du.ae,abid.ali@du.ae,gunjan.mathur@du.ae,harshal.choudhari@du.ae,Shreya.Pahuja@du.ae,Sachin.Kumar@du.ae,Gagan.Atreya@du.ae,sanjay.sharma@du.ae,shailey.narula@du.ae,ravi.kalia@du.ae,akash.beri@du.ae,kunal.chandan@du.ae,balbir.sharma@du.ae
#echo "."| mail -v -s " ALL TT REPORT for `date`" -a /hpsm/hpsm/ops/reports/ALL_TT_REPORT$datestr.csv.gz priyesh.a@du.ae,ankur.gahlaut@du.ae
#(echo "Please find attached TT report"; uuencode ALL_TT_REPORT$datestr.csv.gz ALL_TT_REPORT$datestr.csv.gz)| mailx -s " ALL TT REPORT for `date`" "ankur.saxena@du.ae,Rahul.Gupta1@du.ae,Vino.John@du.ae,ankur.gahlaut@du.ae"

