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
spool SIM_SWAP_ISSUE_REPORT$datestr.csv
-------------------SIM SWAP details extract------------------------------------
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
where category='Business Application' and subcategory='DSP'and product_type='SIM Swap Issue';

spool off;
quit;
EOF
echo "Dear All,

PFA the Swim Swap Issues TT Report.

BestRegards,
HPSM Team"| mail -v -s "ALL SIM SWAP Issue TT REPORT for `date`" -a /hpsm/hpsm/ops/reports/SIM_SWAP_ISSUE_REPORT$datestr.csv shadi.trad@du.ae,Yasser.Fouad@du.ae,Waleed.Ibrahim@du.ae,Preem.Kumar@du.ae,ankur.saxena@du.ae
