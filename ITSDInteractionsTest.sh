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
spool ITSDInteraction$datestr.txt
-------------------ITSD Interaction extract------------------------------------

select
'IncidentNo'
||'|'||'RelatedIncident'
||'|'||'InteractionOwner'
||'|'||'ContactEmail'
||'|'||'duEmail'
||'|'||'InteractionStatus'
||'|'||'InteractionCategory'
||'|'||'InteractionArea'
||'|'||'InteractionSubArea'
||'|'||'Priority'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'ClosedTime'
||'|'||'duFollowup'
||'|'||'InteractionSource'
||'|'||'Opened By'
||'|'||'ESS Flag'
||'|'||'ResolutionCode'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'Resolved By'
||'|'||'SLA Remaining'
||'|'||'FinalSolution'
from Dual
UNION ALL
select
A.incident_id
||'|'||B.source
||'|'||A.du_interaction_owner
||'|'||A.contact_email
||'|'||A.du_email
||'|'||A.open
||'|'||replace(A.category,'
','')
||'|'||replace(A.subcategory,'
','')
||'|'||replace(replace(A.product_type,chr(10)),chr(13))
||'|'||A.priority_code
||'|'||to_char(A.open_time+4/24, 'mm-dd-yyyy HH24:MI:SS') 
||'|'||to_char(A.resolve_time+4/24, 'mm-dd-yyyy HH24:MI:SS') 
||'|'||to_char(A.close_time+4/24, 'mm-dd-yyyy HH24:MI:SS') 
||'|'||A.du_followup_code 
||'|'||A.callback_type 
||'|'||A.opened_by 
||'|'||A.ess_entry
||'|'||replace(A.resolution_code,'
','') 
||'|'||replace(A.resolution_type,'
','')
||'|'||replace(A.resolution_area,'
','')
||'|'||C.resolved_by
||'|'||C.sla_remaining
||'|'||replace(replace(DBMS_LOB.SUBSTR(A.resolution,1000,1),chr(10)),chr(13))
from incidentsm1 A, screlationm1 B, probsummarym1 C where A.incident_id=B.depend(+) and
B.source=C."NUMBER"(+) and ((A.open_time+4/24)>='01-Jun-2016') and ((A.open_time+4/24)<='31-Jul-2016') and A.category<>'service catalog';
spool off;
quit;
EOF
gzip ITSDInteraction$datestr.txt


