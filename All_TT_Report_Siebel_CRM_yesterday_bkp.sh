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
spool ALL_TT_REPORT_SIEBEL_CRM1$datestr.csv
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
||'|'||'TT Type'
||'|'||'ClosedBy'
||'|'||'ResolvedBy'
||'|'||'ReassignmentCount'
||'|'||'ReopenCount'
||'|'||'SLA-START'
||'|'||'SLA-REMAINING'
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
||'|'||du_tt_type
||'|'||Closed_By
||'|'||Resolved_By
||'|'||Count
||'|'||du_reopencount
||'|'||to_char(DU_SLA_START+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||SLA_REMAINING
from
probsummarym1 A
where Assignment in ('IT - Billing','IT - CRM','IT - EAI','IT - EBusiness','IT - ICS','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT - OSS-OPS-Mobile Provisioning','IT - POS','IT - Payment Gateway','NOC - IN','Bill Shock','Campaign Mgmt') AND folder='SIEBEL-CRM' and open_time+4/24 >= trunc(sysdate-7);

spool off;
quit;
EOF
gzip ALL_TT_REPORT_SIEBEL_CRM1$datestr.csv
echo "."| mail -v -s " ALL TT REPORT for SIEBEL TTs for `date -d'yesterday'`" -a /hpsm/hpsm/ops/reports/ALL_TT_REPORT_SIEBEL_CRM1$datestr.csv.gz priyesh.a@du.ae
#echo "."| mail -v -s " ALL TT REPORT for `date`" -a /hpsm/hpsm/ops/reports/ALL_TT_REPORT$datestr.csv.gz ankur.saxena@du.ae,ankur.gahlaut@du.ae,priyesh.a@du.ae
#(echo "Please find attached TT report"; uuencode ALL_TT_REPORT$datestr.csv.gz ALL_TT_REPORT$datestr.csv.gz)| mailx -s " ALL TT REPORT for `date`" "ankur.saxena@du.ae,Rahul.Gupta1@du.ae,Vino.John@du.ae,ankur.gahlaut@du.ae"

