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
spool Monthly_UAM$datestr.txt
-------------------Monthly UAM Report extract------------------------------------
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
where (A.open_time+4/24) >= trunc(trunc(sysdate,'MM')-1,'MM')
and (A.open_time+4/24) < trunc(sysdate,'MM');
spool off;
quit;
EOF
gzip Monthly_UAM$datestr.txt 
echo "."| mail -v -s "Please find attached Monthly UAM report" -a /hpsm/hpsm/ops/reports/Monthly_UAM$datestr.txt.gz nihalchand.dehury@du.ae,Akram.Ibrahim@du.ae,Buthaina.AlMas@du.ae
##( echo "Please find the attached Monthly UAM report"; uuencode Monthly_UAM$datestr.txt.gz Monthly_UAM$datestr.txt.gz)| mailx -s "Monthly UAM reportfor `date`" "nihalchand.dehury@du.ae,Akram.Ibrahim@du.ae"
