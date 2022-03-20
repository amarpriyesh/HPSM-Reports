tr=`date "+%d%m%y%H%M"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
spool InteractionOct2016.csv
-------------------Retail TT extract------------------------------------
select
'IncidentNo'
||'|'||'InteractionOwner'
||'|'||'ContactEmail'
||'|'||'duEmail'
||'|'||'InteractionStatus'
||'|'||'InteractionCategory'
||'|'||'InteractionArea'
||'|'||'InteractionSubArea'
||'|'||'Priority'
||'|'||'Titile'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'ClosedTime'
||'|'||'duFollowup'
||'|'||'InteractionSource'
||'|'||'Opened By'
||'|'||'ESS Flag'
||'|'||'SLA Remaining'
||'|'||'RelatedIncident'
||'|'||'ResolutionCode'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'Resolved By'
||'|'||'Response Time'
||'|'||'FinalSolution'
from Dual
UNION ALL
select
A.incident_id
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
||'|'||A.title
||'|'||to_char(A.open_time+4/24, 'mm-dd-yyyy HH24:MI:SS') 
||'|'||to_char(A.resolve_time+4/24, 'mm-dd-yyyy HH24:MI:SS') 
||'|'||to_char(A.close_time+4/24, 'mm-dd-yyyy HH24:MI:SS') 
||'|'||A.du_followup_code 
||'|'||A.callback_type 
||'|'||A.opened_by 
||'|'||A.ess_entry
||'|'||replace ((select A.sla_remaining-to_timestamp('1/1/4000','MM/DD/YYYY') diff from dual),'0000000','0') 
||'|'||B.source 
||'|'||replace(A.resolution_code,'
','') 
||'|'||replace(A.resolution_type,'
','')
||'|'||replace(A.resolution_area,'
','')
||'|'||C.resolved_by
||'|'||replace ((select A.response_time-to_timestamp('1/1/4000','MM/DD/YYYY') diff from dual),'0000000','0') 
||'|'||replace(replace(DBMS_LOB.SUBSTR(A.resolution,1000,1),chr(10)),chr(13))
from incidentsm1 A, screlationm1 B, probsummarym1 C where A.incident_id=B.depend(+) and
B.source=C."NUMBER"(+) and trunc(A.close_time+4/24) >= to_date('01/10/2016 00:00:00','dd/mm/yyyy HH24:MI:SS') and
trunc(A.close_time+4/24) < to_date('01/11/2016 00:00:00','dd/mm/yyyy HH24:MI:SS') and A.category<>'service catalog';

spool off;
quit;
EOF


