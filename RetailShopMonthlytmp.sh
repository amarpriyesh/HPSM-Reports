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
spool custom$datestr.csv
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
||'|'||A.category
||'|'||A.subcategory
||'|'||A.product_type
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
B.source=C."NUMBER"(+)  and (A.contact_email like 'rs.%' or A.du_email like 'rs.%')and (c.open_time+4/24>='01-Jul-2018') and A.category<>'service catalog';
spool off;
quit;
EOF



sed -i $'s/,/ /g' custom$datestr.csv
sed -i $'s/|/,/g' custom$datestr.csv
gzip custom$datestr.csv
echo "Dear All

PFA requested  report  .

Best Regards,
HPSM Team"| mail -v -s "Retail Shop  TTs Report `date "+%d%m%y"`" -a /hpsm/hpsm/ops/reports/custom$datestr.csv.gz priyesh.a@du.ae,ankur.saxena@du.ae,Shadi.Trad@du.ae
#/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Repor"; lcd /hpsm/hpsm/ops/reports; prompt; recurse; mput OLA_Jul.txt.gz; exit;"
#/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\"; lcd /hpsm/hpsm/ops/reports; prompt; recurse; mput custom$datestr.csv.gz; exit;"
