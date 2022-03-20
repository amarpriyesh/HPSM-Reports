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
spool ITSDInteractionDB-mar-tilldate$datestr.txt
-------------------ITSD Interaction extract------------------------------------

select
'IncidentNo'
||'|'||'InteractionStatus'
||'|'||'Resolved by'
||'|'||'InteractionCategory'
||'|'||'InteractionArea'
||'|'||'InteractionSubArea'
||'|'||'Priority'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'ClosedTime'
||'|'||'InteractionSource'
||'|'||'Title'
||'|'||'Email'
||'|'||'Opened_by'
||'|'||'SLA_Remaining'
||'|'||'Assignment'
||'|'||'ESS Flag'
||'|'||'RelatedIncident'
||'|'||'du_interaction_owner'
||'|'||'du_followup_code'
||'|'||'ResolutionCode'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'Response Time'
||'|'||'Contact Email'
||'|'||'Requester Email'
||'|'||'Pending Input Time Spent'
||'|'||'Resolution'
from Dual
UNION ALL
select
A.incident_id
||'|'||A.open
||'|'||c.resolved_by
||'|'||A.category
||'|'||A.subcategory
||'|'||A.product_type
||'|'||A.priority_code
||'|'||to_char(A.open_time+4/24, 'mm-dd-yyyy HH24:MI:SS') 
||'|'||to_char(A.resolve_time+4/24, 'mm-dd-yyyy HH24:MI:SS') 
||'|'||to_char(A.close_time+4/24, 'mm-dd-yyyy HH24:MI:SS') 
||'|'||A.callback_type
||'|'||A.du_title
||'|'||A.du_email
||'|'||c.opened_by
||'|'||replace ((select A.response_time-to_timestamp('1/1/4000','MM/DD/YYYY') diff from dual),'0000000','0')
||'|'||C.assignment
||'|'||A.ess_entry 
||'|'||B.source
||'|'||A.du_interaction_owner 
||'|'||A.du_followup_code
||'|'||A.resolution_code 
||'|'||A.resolution_type
||'|'||A.resolution_area
||'|'||replace ((select A.response_time-to_timestamp('1/1/4000','MM/DD/YYYY') diff from dual),'0000000','0') 
||'|'||A.contact_email
||'|'||A.du_email
||'|'||(select sum((closed_total -to_date('01014000000000','ddmmyyyyhh24miss'))*24*60) from clocksm1 where name like '%.Pending Input%' and clocksm1.key_char=C."NUMBER")
||'|'||replace(replace(replace(DBMS_LOB.SUBSTR(C.brief_description, 200,1),chr(10)),chr(13)),'
','')
from incidentsm1 A, screlationm1 B, probsummarym1 C where A.incident_id=B.depend(+) and
B.source=C."NUMBER"(+) and (  A.open_time+4/24>='01-Feb-2018') ;
spool off;
quit;
EOF
gzip ITSDInteractionDB-mar-tilldate$datestr.txt

echo "."| mail -s "report" -a /hpsm/hpsm/ops/reports/ITSDInteractionDB-mar-tilldate$datestr.txt.gz priyesh.a@du.ae,Shwetha.Ranjini@du.ae,ankur.saxena@du.ae
#/usr/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/reports/ ; prompt; recurse; mput ITSDInteractionDB$datestr.txt; exit;"
#/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\"; lcd /hpsm/hpsm/ops/reports; prompt; recurse; mput ITSDInteractionDB-mar-tilldate$datestr.txt.gz; exit;"
