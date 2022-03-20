cd
. ./.bash_profile
cd /hpsm/hpsm/ops/
datestr=`date "+%d%m%y%H%M"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
set define off
spool FMSIncident$datestr.txt
-------------------FMS Incident extract------------------------------------


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
||'|'||'PendingCode'
||'|'||'PendingReason'
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
||'|'|| pending_code
||'|'|| (select REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(description, 30,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' ') from activitym1 b where a."NUMBER"=b."NUMBER" and b.type='Pending Reason' and rownum=1 )
||'|'|| to_char(du_sla_start+4/24, 'mm-dd-yyyy HH24:MI:SS')
||'|'|| to_char(du_sla_end+4/24, 'mm-dd-yyyy HH24:MI:SS')
||'|'|| sla_breach
||'|'|| resolved_group
||'|'|| to_char(resolved_time+4/24, 'mm-dd-yyyy HH24:MI:SS')
||'|'|| to_char(close_time+4/24, 'mm-dd-yyyy HH24:MI:SS')
||'|'|| resolution_code
||'|'|| resolution_type
||'|'|| replace(replace(resolution_area,chr(10),' '),chr(13),' ')
||'|'|| affected_network
||'|'|| affected_segment
||'|'|| replace(logical_name,'|',' ')
||'|'|| replace(replace(carrier_name,chr(10),' '),chr(13),' ')
||'|'|| du_alarm_date 
||'|'||REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(brief_description, 500,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' '),'|',' '),'\',' ')
from probsummarym1 a
where (open_time>='01-Jan-2018')  and assignment in ('PSD - Managed Services','PSD MS Fulfillment') ;

spool off;
quit;
EOF

sed -i $'s/\t/ /g' FMSIncident$datestr.txt
gzip FMSIncident$datestr.txt
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\FMSReports\"; lcd /hpsm/hpsm/ops/; prompt; recurse; mput FMSIncident$datestr.txt.gz; exit;"


