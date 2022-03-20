cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/
USER=nrs
PASS=nrs123
datestr=`date "+%d%m%y"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
spool All_Incidents$datestr.txt
-------------------All Incident extract------------------------------------

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
||'|'||'AssigneeName'
||'|'||'ResolutionCode'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'OpenTime'
||'|'||'ClosedTime'
||'|'||'ResolvedTime'
||'|'||'Type'
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
||'|'||assignee_name
||'|'||resolution_code
||'|'||resolution_type
||'|'||resolution_area
||'|'||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(close_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(NVL((decode(problem_status,'Resolved',(select min(C.datestamp)+4/24 from 
activitym1 C where C."NUMBER" = A."NUMBER" and C.type = 'Resolved'),'Closed',
(select min(C.datestamp)+4/24 from activitym1 C where C."NUMBER" = A."NUMBER" and C.type = 'Resolved'),NULL
)),resolved_time+4/24),'mm/dd/yyyy HH24:MI:SS')
||'|'||folder
from
probsummarym1 A
where a.problem_status<>'Resolved' and a.problem_status<>'Closed' 
and open_time > to_date('01/01/2011 00:00:00','dd/mm/yyyy hh24:mi:ss');
spool off;
quit;
EOF

gzip All_Incidents$datestr.txt
echo "."| mail -v -s "All Incidents Report for `date`" -a /hpsm/hpsm/ops/reports/All_Incidents$datestr.txt.gz ankur.saxena@du.ae
