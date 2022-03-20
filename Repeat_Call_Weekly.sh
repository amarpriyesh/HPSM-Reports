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
spool Repeat_Call_Weekly$datestr.csv
-------------------History extract------------------------------------
select
'IncidentNo'
||'|'||'IM Ticketno'
||'|'||'Assignment'
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
||'|'||'Title'
from Dual
UNION ALL
select
A.incident_id
||'|'||C."NUMBER"
||'|'||C.assignment
||'|'||A.du_interaction_owner
||'|'||A.contact_email
||'|'||A.du_email
||'|'||A.open
||'|'||replace(A.category,'','')
||'|'||replace(A.subcategory,'','')
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
||'|'||replace(replace(DBMS_LOB.SUBSTR(A.title,1000,1),chr(10)),chr(13))
from incidentsm1 A, screlationm1 B, probsummarym1 C where A.incident_id=B.depend(+) and 
B.source=C."NUMBER"(+) and A.open_time>trunc(sysdate-7) and A.category<>'service catalog' and A.title like 'REPEAT%' ;
spool off;
quit;
EOF
gzip Repeat_Call_Weekly$datestr.csv
echo "."| mail -v -s " Repeat Call Weekly Report for `date`" -a /hpsm/hpsm/ops/reports/Repeat_Call_Weekly$datestr.csv.gz priyesh.a@du.ae,ankur.saxena@du.ae,neeraj.sharma@du.ae
#(echo "Please find attached TT report"; uuencode NOC_Throughput_Daily$datestr.csv.gz NOC_Throughput_Daily$datestr.csv.gz)| mailx -s " NOC Throughput Daily Report for `date`" "mohammed.rezwanali@du.ae,MuhammadImran.Khan@du.ae,Michael.Milad@du.ae,anand.agarwal@du.ae,tsd.carrier@du.ae"
