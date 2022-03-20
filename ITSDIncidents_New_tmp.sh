cd
. .profile
cd /hpsm/hpsm/ops/reports
datestr=`date "+%d%m%y%H%M"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
spool ITSDIncident_New_jul-oct$datestr.txt
-------------------ITSD Incident extract------------------------------------

select 
'IncidentNo'
||'|'||'IsDealer'
||'|'||'IncidentStatus'
||'|'||'Opened By'
||'|'||'Assignee Name'
||'|'||'IncidentCategory'
||'|'||'IncidentArea'
||'|'||'IncidentSubArea'
||'|'||'Priority'
||'|'||'CurrentResolverGroup'
||'|'||'AssigneeName'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'closedTime'
||'|'||'BriefDescription'
from Dual
UNION ALL
select
"NUMBER"
||'|'||is_dealer
||'|'||problem_status
||'|'||opened_by
||'|'||assignee_name
||'|'||category
||'|'||subcategory
||'|'||product_type
||'|'||priority_code
||'|'||assignment
||'|'||assignee_name
||'|'||to_char(open_time+4/24,'mm-dd-yyyy HH24:MI:SS')
||'|'||to_char(resolved_time+4/24,'mm-dd-yyyy HH24:MI:SS')
||'|'||to_char(close_time+4/24,'mm-dd-yyyy HH24:MI:SS') 
||'|'||REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(brief_description, 2000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' ')
from probsummarym1 
where  (open_time>=to_date('01/07/2018 00:00:00','dd/mm/yyyy hh24:mi:ss') and open_time<to_date('01/11/2018 00:00:00','dd/mm/yyyy hh24:mi:ss') );
spool off;
quit;
EOF
gzip ITSDIncident_New_jul-oct$datestr.txt
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\ITSD\"; lcd /hpsm/hpsm/ops/reports/; prompt; recurse; mput ITSDIncident_New_jul-oct$datestr.txt.gz; exit;"
#( echo "Please find attached the ITSD Incidents report"; uuencode ITSDIncident_New$datestr.txt.gz ITSDIncident_New$datestr.txt.gz)| mailx -s "ITSD Incidents Report for `date`" "Yasser.Fouad@du.ae,osama.asadi@du.ae,Ali.Alkhatib@du.ae,Waleed.Ibrahim@du.ae,Hesham.Saidah@du.ae" 
