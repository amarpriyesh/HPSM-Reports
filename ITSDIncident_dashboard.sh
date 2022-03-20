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
spool ITSDIncident_Dashboard$datestr.txt
-------------------ITSD Incident extract------------------------------------
set ESCAPE '\'
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
||'|'||'ClosedTime'
||'|'||'UpdatedTime'
||'|'||'PendingWithVendor'
||'|'||'PendingWithCustomer'
||'|'||'PendingWithThirdParty'
||'|'||'Pending for Others'
||'|'||'Engaged with other task'
||'|'||'Pending for Transport'
||'|'||'Pending for Site Visit'
||'|'||'Pending for Hardware'
||'|'||'Pending for CR Implementation'
||'|'||'Pending for Testing'
||'|'||'Pending with Development/Planning'
||'|'||'Pending for Site Access'
||'|'||'BriefDescription'
||'|'||'Final Resolution'
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
||'|'||to_char(update_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS') from clocksm1 where name = 'Pending Vendor' and KEY_CHAR = "NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS') from clocksm1 where name = 'Pending Customer' and KEY_CHAR = "NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS') from clocksm1 where name = 'Pending Third Party' and KEY_CHAR = "NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS') from clocksm1 where name = 'Pending for Others' and KEY_CHAR = "NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS') from clocksm1 where name = 'Engaged with other task' and KEY_CHAR = "NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS') from clocksm1 where name = 'Pending for Transport' and KEY_CHAR = "NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS') from clocksm1 where name = 'Pending for Site Visit' and KEY_CHAR = "NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS') from clocksm1 where name = 'Pending for Hardware' and KEY_CHAR = "NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS') from clocksm1 where name = 'Pending for CR Implementation' and KEY_CHAR = "NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS') from clocksm1 where name = 'Pending for Testing' and KEY_CHAR = "NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS') from clocksm1 where name = 'Pending with Development/Planning' and KEY_CHAR = "NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS') from clocksm1 where name = 'Pending for Site Access' and KEY_CHAR = "NUMBER")
||'|'||REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(brief_description, 2000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' ')
||'|'||REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(resolution, 2000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' ')
from probsummarym1 
where (close_time+4/24=trunc(sysdate-1) or problem_status<>'Closed')
and ((folder='ITSD' and assignment not in ('IT - Technical VIP Support','IT - Technical Mobility Support'
,'IT - Corporate Domain \& Email Services','IT - Mission Critical Enterprise Systems \& Service'))
or (folder='TSRM' and assignment in ('IT - Corporate Technical Support','IT - Technical Support'))
or (is_dealer='t' and folder='SIEBEL-CRM'));
spool off;
quit;
EOF
/usr/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/reports/ ; prompt; recurse; mput ITSDIncident_Dashboard$datestr.txt; exit;"
