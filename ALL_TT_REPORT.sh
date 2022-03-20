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
||'|'||'Opened By'
||'|'||'Assignee Name'
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
||'|'||'TT TYPE'
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
where Assignment in ('IT SSM Application Support','IT - Cognos','IT - Datawarehouse','IT - Teradata Database Admin','IT - OSS-OPS-Fault/Performance MGMT','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT - OPS duVerse support','DuVerse Access','IT - Billing','IT - CRM','IT - OSS (Service Assurance)','IT - OSS-OPS-Fault/Performance MGMT','IT - OSS-OPS-OPA','IT - EAI','IT - EBusiness','IT - EDMS','IT - ERP','IT - GIS','IT - ICS',
'IT - OSS-OPS- HPSM','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','Prime Application','IT - OSS-OPS-Mobile Provisioning','IT - OSS-OPS-OAIM','IT - POS','IT DSP Application Support','IT - Payment Gateway','IT - Business Application Access','IT - OSS (Service Assurance)','IT - MNMI (Application Support)','IT - MNP Application Support','IT - FMS','IT - ERP','NOC - IN','Bill Shock','Core - Mobile IN','IT - Enterprise Systems (HMC)','IT - OSS (Service Assurance)','IT Retail Business Application Support','IT - EDMS','IAM - IN') AND  open_time+4/24 >= to_date('01/01/2017 00:00:00','dd/mm/yyyy hh24:mi:ss');

spool off;
quit;
EOF
gzip ALL_TT_REPORT$datestr.csv
echo "."| mail -v -s " ALL TT REPORT for `date`" -a /hpsm/hpsm/ops/reports/ALL_TT_REPORT$datestr.csv.gz ankur.saxena@du.ae,ankur.gahlaut1@du.ae,Rahul.Gupta1@du.ae,Vino.John@du.ae,ankur.gahlaut@du.ae,sanjay.sharma@du.ae,gaurav.gupta@du.ae,shailey.narula@du.ae,ravi.kalia@du.ae,akash.beri@du.ae,kunal.chandan@du.ae,ashish.panditha@du.ae,balbir.sharma@du.ae
#echo "."| mail -v -s " ALL TT REPORT for `date`" -a /hpsm/hpsm/ops/reports/ALL_TT_REPORT$datestr.csv.gz ankur.saxena@du.ae,ankur.gahlaut@du.ae,priyesh.a@du.ae
#(echo "Please find attached TT report"; uuencode ALL_TT_REPORT$datestr.csv.gz ALL_TT_REPORT$datestr.csv.gz)| mailx -s " ALL TT REPORT for `date`" "ankur.saxena@du.ae,Rahul.Gupta1@du.ae,Vino.John@du.ae,ankur.gahlaut@du.ae"

