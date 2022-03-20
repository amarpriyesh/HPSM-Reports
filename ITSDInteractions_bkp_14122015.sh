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
B.source=C."NUMBER"(+) and (trunc(A.close_time+4/24)>=trunc(sysdate-74)or open<>'Closed') and A.category<>'service catalog';
spool off;
quit;
EOF
gzip ITSDInteraction$datestr.txt
#(echo "Please find attached TT report"; uuencode  ITSDInteraction$datestr.txt.gz ITSDInteraction$datestr.txt.gz)| mailx -s " TT Report for `date`" "nihalchand.dehury@du.ae,mohammed.rezwanali@du.ae,Edward.Paul@du.ae,Iqbal.Khan@du.ae,Mansoor.A@du.ae,Midhun.Antony@du.ae,Praveen.Singu@du.ae,Sankar.Kotla@du.ae,Winner.Viagularaj@du.ae,ServiceDesk@du.ae"
echo "."| mail -v -s "Please find attached ITSD Interaction TT report" -a /hpsm/hpsm/ops/reports/ITSDInteraction$datestr.txt.gz nihalchand.dehury@du.ae,mohammed.rezwanali@du.ae,Edward.Paul@du.ae,Iqbal.Khan@du.ae,Mansoor.A@du.ae,Midhun.Antony@du.ae,Praveen.Singu@du.ae,Sankar.Kotla@du.ae,Winner.Viagularaj@du.ae,ServiceDesk@du.ae
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"ITSD HPSM Reports\Interaction Reports\"; lcd /hpsm/hpsm/ops/reports/; prompt; recurse; mput ITSDInteraction$datestr.txt.gz; exit;"
