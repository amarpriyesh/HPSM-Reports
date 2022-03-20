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
spool SiebelHPSMIncidents$datestr.txt
-------------------SIEBEL HPSM Incident extract------------------------------------

select 
'IncidentNo'
||'|'||'SiebelTTNo'
||'|'||'TTType'
||'|'||'IncidentCreatedate'
||'|'||'IncidentStatus'
||'|'||'Opened By'
||'|'||'Assignee Name'
||'|'||'IncidentCategory'
||'|'||'IncidentArea'
||'|'||'IncidentSubArea'
||'|'||'CurrentResolverGroup'
||'|'||'Priority'
||'|'||'IsDealer'
||'|'||'ClosedTime'
||'|'||'ResolvedTime'
||'|'||'ResolvedBy'
||'|'||'SLA Startdate'
||'|'||'SLA Enddate'
||'|'||'SLA Remaining'
from Dual
UNION ALL
select 
"NUMBER"
||'|'||REFERENCE_NO
||'|'||folder
||'|'||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||problem_status
||'|'||opened_by
||'|'||replace(replace(assignee_name,chr(10),' '),chr(13),' ')
||'|'||category
||'|'||subcategory
||'|'||product_type
||'|'||assignment
||'|'||priority_code
||'|'||is_dealer
||'|'||to_char(close_time+4/24, 'mm/dd/yyyy HH24:MI:SS') 
||'|'||to_char(resolved_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||resolved_by
||'|'||du_sla_start
||'|'||du_sla_end
||'|'||SLA_remaining
from 
probsummarym1
where open_time>='23-APR-2016';
spool off;
quit;
EOF
sed -i $'s/\t/ /g' SiebelHPSMIncidents$datestr.txt
gzip SiebelHPSMIncidents$datestr.txt
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\"; lcd /hpsm/hpsm/ops/reports; prompt; recurse; mput SiebelHPSMIncidents$datestr.txt.gz; exit;"
