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
spool RetailTTReport$datestr.csv
-------------------Retail TT extract------------------------------------

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
||'|'||'duFollowup'
||'|'||'InteractionSource'
||'|'||'Opened By'
||'|'||'ESS Flag'
||'|'||'Assignment Group'
||'|'||'Assignee Name'
||'|'||'Status'
||'|'||'Brief Description'
||'|'||'Description'
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
||'|'||A.du_followup_code
||'|'||A.callback_type
||'|'||A.opened_by
||'|'||A.ess_entry
||'|'||C.assignment
||'|'||C.assignee_name
||'|'||C.problem_status
||'|'||replace(replace(replace(DBMS_LOB.SUBSTR(C.brief_description, 2000,1),chr(10)),chr(13)),',',' ')
||'|'||replace(replace(replace(DBMS_LOB.SUBSTR(C.action, 2000,1),chr(10)),chr(13)),',',' ')
from incidentsm1 A, screlationm1 B, probsummarym1 C where A.incident_id=B.depend(+) and
B.source=C."NUMBER"(+) and C.problem_status not in ('Closed','Resolved') and (A.contact_email like 'rs.%' or A.du_email like 'rs.%') and A.category<>'service catalog';
spool off;
quit;
EOF



sed -i $'s/,/ /g' RetailTTReport$datestr.csv
sed -i $'s/|/,/g' RetailTTReport$datestr.csv

echo "Dear All

PFA the daily report of pending retail Incidents.

Best Regards,
HPSM Team"| mail -v -s "Daily Pending Retail TTs Report `date "+%d%m%y"`" -a /hpsm/hpsm/ops/reports/RetailTTReport$datestr.csv utkarsh.jauhari@du.ae,Shwetha.Ranjini@du.ae,Shadi.Trad@du.ae,Yasser.Fouad@du.ae,Preem.Kumar@du.ae


