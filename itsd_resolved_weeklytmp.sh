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
spool itsd_resolved_weekly$datestr.txt
-------------------ITSD Folder TTs Open Weekly extract------------------------------------
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
where assignment  in('DXB ND TI - OD Implementation','DXB ND TI - IBS Implementation','DXB ND - Transport Implementation','DXB ND - FAN Implementation','DXB ND - WRAN Implementation','DXB ND - EM Implementation','DXB ND - CW Implementation','DXB Etisalat','NE ND TI - OD Implementation','NE ND TI - IBS Implementation','NE ND - Transport Implementation','NE ND - FAN Implementation','NE ND - WRAN Implementation','NE ND - EM Implementation','NE ND - CW Implementation','NE Etisalat','AUH/AAN ND TI - OD Implementation','AUH/AAN ND TI - IBS Implementation','AUH/AAN ND - Transport Implementation','AUH/AAN ND - FAN Implementation','AUH/AAN ND - WRAN Implementation','AUH/AAN ND - EM Implementation','AUH/AAN ND - CW Implementation','AUH/AAN Etisalat') and open_time+4/24 < trunc(sysdate,'D') and open_time+4/24 > '01-May-2018';
spool off;
quit;
EOF
gzip itsd_resolved_weekly$datestr.txt 
echo "Please find attached the ITSD Response Time weekly report."| mail -v -s "ITSD Response Time weekly Report" -a /hpsm/hpsm/ops/reports/itsd_resolved_weekly$datestr.txt.gz priyesh.a@du.ae,ankur.saxena@du.ae,Dounah.Solis1@du.ae,Alvin.Magsisi@du.ae,Sunil.Gaikwad@du.ae,Sajid.Rafiq@du.ae,Nader.Shahin@du.ae,Rajesh.Babu@du.ae,Antonio.Tugagao@du.ae,Khalid.Ahli@du.ae,Mohamed.Allam@du.ae,Adnan.Ahmed1@du.ae,Ayman.Abdelhamid1@du.ae



#( echo "Please find attached the ITSD Response Time weekly report"; uuencode itsd_resolved_weekly$datestr.txt.gz itsd_resolved_weekly$datestr.txt.gz)| mailx -s "ITSD Response Time weekly Report for `date`" "Nihalchand.Dehury@du.ae,michael.milad@du.ae,jamal.sheikdawood@du.ae"
