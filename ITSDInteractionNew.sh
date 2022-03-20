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
spool ITSDInteractionNew$datestr.txt
-------------------ITSD Interaction extract------------------------------------

select
'IncidentNo'
||'|'||'InteractionOwner'
||'|'||'ContactEmail'
||'|'||'duEmail'
||'|'||'Title'
||'|'||'Office'
||'|'||'Location'
||'|'||'InteractionStatus'
||'|'||'InteractionCategory'
||'|'||'InteractionArea'
||'|'||'InteractionSubArea'
||'|'||'Priority'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'ClosedTime'
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
||'|'||A.du_title
||'|'||A.location
||'|'||A.user_location
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
||'|'||replace(replace(DBMS_LOB.SUBSTR(A.resolution,500,1),chr(10)),chr(13))
from incidentsm1 A, screlationm1 B, probsummarym1 C where A.incident_id=B.depend(+) and
B.source=C."NUMBER"(+) and (trunc(A.close_time+4/24)=trunc(sysdate-1) or open<>'Closed') and A.open_time+4/24>'01-Jan-2020';
spool off;
quit;
EOF
sed -i $'s/\t/ /g' ITSDInteractionNew$datestr.txt
gzip ITSDInteractionNew$datestr.txt
echo "."| mail -v -s "Please find attached ITSD Interaction TT report" -a /hpsm/hpsm/ops/reports/ITSDInteractionNew$datestr.txt.gz bhavana.tatti@du.ae,Waleed.Ibrahim@du.ae,shwetha.ranjini@du.ae,Ankur.Saxena@du.ae
