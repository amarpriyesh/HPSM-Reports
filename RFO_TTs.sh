cd . ./home/hpsm/.bash_profile
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
spool RFO_TTs$datestr.csv
-------------------RFO TTs Report extract------------------------------------
select
'IncidentNo'
||','||'Master TT Y/N'
||','||'Priority'
||','||'Assignment Group'
||','||'Current Status'
||','||'System/Application'
||','||'Services Affected'
||','||'Incident Start Time'
||','||'Incident End Time'
||','||'Impact Duration'
||','||'Impact Type'
||','||'Impact Severity'
||','||'Incident History'
||','||'Team/Staff Involved'
||','||'Count of Linked Interactions'
||','||'Root Cause'
||','||'Resolution'
||','||'Recommendation/Preventive Actions'
||','||'Opened By'
||','||'Open Time'
||','||'Resolved Time'
||','||'Assignee'
||','||'Issue Description'
from Dual
union All
select
a."NUMBER"
||','||decode (a.DU_MASTER_TT,'t','Y','N')
||','||a.priority_code
||','||a.assignment
||','||problem_status
||','||replace(a.sysapplication,',','')
||','||replace(a.rfo_services,',','')
||','||to_char(a.inci_start+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(a.inci_end+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||replace ((select a.inci_duration-to_timestamp('1/1/4000','MM/DD/YYYY') diff from dual),'0000000','0')
||','||a.impact_type
||','||a.impact_severity
||','||replace(REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(a.inci_history, 2000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' '),',','')
||','||replace(a.staff_involved,',','')
||','||(select count(*) from incidentsm1 c, screlationm1 B where c.incident_id=B.depend(+) and B.source=a."NUMBER" )
||','||replace(a.root_cause,',','')
||','||replace(a.rfo_resolution,',','')
||','||replace(REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(a.rfo_action, 2000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' '),',','')
||','||a.opened_by
||','||to_char(a.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(a.resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||a.assignee_name
||','||replace(REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(a.action, 2000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' '),',','')
from
probsummarym1 a where is_rfo ='t' and 
(a.close_time+4/24 >=trunc(trunc(sysdate,'MM')-1,'MM') or  problem_status<>'Closed') and folder='ITSD' ;
spool off;
quit;
EOF
( echo "Please find attached RFO TTs Report"; uuencode RFO_TTs$datestr.csv RFO_TTs$datestr.csv)| mailx -s "RFO TTs Report for `date`" "nihalchand.dehury@du.ae"
exit;"
