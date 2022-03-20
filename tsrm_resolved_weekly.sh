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
spool tsrm_resolved_weekly$datestr.txt
-------------------TSRM Folder TTs Open Weekly extract------------------------------------
select 
'IncidentNo'
||'|'||'IncidentCreatedat'
||'|'||'TTOpenedBy'
||'|'||'FMSReferenceNo'
||'|'||'duAlarmDate'
||'|'||'MessageGroup'
||'|'||'Domain'
||'|'||'duNetwork'
||'|'||'duSolution'
||'|'||'duElement'
||'|'||'duVendor'
||'|'||'IncidentCategory'
||'|'||'IncidentArea'
||'|'||'IncidentSubArea'
||'|'||'Priority'
||'|'||'IncidentStatus'
||'|'||'CurrentResolverGroup'
||'|'||'AssignmentName'
||'|'||'Count'
||'|'||'SLAStartDate'
||'|'||'SLAEndDate'
||'|'||'SLABreach'
||'|'||'Resolvedgroup'
||'|'||'ResolvedTime'
||'|'||'ClosedTime'
||'|'||'ResolutionCode'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'AffectedNetwork'
||'|'||'AffectedSegment'
||'|'||'LogicalName'
||'|'||'CarrierName'
||'|'||'Alarm Date/Time'
||'|'||'BriefDescription'
||'|'||'Description'
from Dual
UNION ALL
select
"NUMBER" 
||'|'|| to_char(open_time+4/24,'mm-dd-yyyy HH24:MI:SS')
||'|'|| opened_by
||'|'|| fms_reference_no
||'|'|| du_alarm_date
||'|'|| msg_group
||'|'|| domain
||'|'|| du_network
||'|'|| du_solution
||'|'|| du_element
||'|'|| du_vendor
||'|'|| category
||'|'|| subcategory
||'|'|| product_type
||'|'|| priority_code
||'|'|| problem_status
||'|'|| assignment
||'|'|| assignee_name
||'|'|| count
||'|'|| to_char(du_sla_start+4/24, 'mm-dd-yyyy HH24:MI:SS')
||'|'|| to_char(du_sla_end+4/24, 'mm-dd-yyyy HH24:MI:SS')
||'|'|| sla_breach
||'|'|| resolved_group
||'|'|| to_char(resolved_time+4/24, 'mm-dd-yyyy HH24:MI:SS')
||'|'|| to_char(close_time+4/24, 'mm-dd-yyyy HH24:MI:SS')
||'|'|| resolution_code
||'|'|| resolution_type
||'|'|| resolution_area
||'|'|| affected_network
||'|'|| affected_segment
||'|'|| logical_name
||'|'|| carrier_name
||'|'|| du_alarm_date 
||'|'||REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(brief_description, 1000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' ')
||'|'||REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(action, 1000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' ')
from probsummarym1 
where folder in('TSRM') and resolved_time+4/24 < trunc(sysdate,'D') and resolved_time+4/24 > trunc(sysdate-7,'D');
spool off;
quit;
EOF
gzip tsrm_resolved_weekly$datestr.txt 
echo "Please find attached the TSRM Response Time weekly report."| mail -v -s "TSRM Response Time weekly Report" -a /hpsm/hpsm/ops/reports/tsrm_resolved_weekly$datestr.txt.gz nihalchand.dehury@du.ae,michael.milad@du.ae,jamal.sheikdawood@du.ae,mohammed.rezwanali@du.ae

#( echo "Please find attached the TSRM Response Time weekly report"; uuencode tsrm_resolved_weekly$datestr.txt.gz tsrm_resolved_weekly$datestr.txt.gz)| mailx -s "TSRM Response Time weekly Report for `date`" "Nihalchand.Dehury@du.ae,michael.milad@du.ae,jamal.sheikdawood@du.ae"
