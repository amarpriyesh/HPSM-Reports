cd
. .profile
cd /hpsm/hpsm/ops/
datestr=`date "+%d%m%y%H%M"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
spool Test_ITSDIncident_New$datestr.txt
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
||'|'||'Folder'
||'|'||'CurrentResolverGroup'
||'|'||'AssigneeName'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'ClosedTime'
||'|'||'UpdatedTime'
||'|'||'PendingWithVendor'
||'|'||'PendingWithCustomer'
||'|'||'PendingWithThirdParty'
||'|'||'PendingWithSiteAccess'
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
||'|'||folder
||'|'||assignment
||'|'||assignee_name
||'|'||to_char(open_time+4/24,'mm-dd-yyyy HH24:MI:SS')
||'|'||to_char(resolved_time+4/24,'mm-dd-yyyy HH24:MI:SS')
||'|'||to_char(close_time+4/24,'mm-dd-yyyy HH24:MI:SS') 
||'|'||to_char(update_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS') from clocksm1 where name = 'Pending Vendor' and KEY_CHAR = "NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS') from clocksm1 where name = 'Pending Customer' and KEY_CHAR = "NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS') from clocksm1 where name = 'Pending Third Party' and KEY_CHAR = "NUMBER")
||'|'||(select (extract(day from total)-1)||' '||to_char (total,'HH24:MI:SS') from clocksm1 where name = 'Pending Site Access' and KEY_CHAR = "NUMBER")
||'|'||REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(brief_description, 2000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' ')
from probsummarym1 
where open_time>to_date('15/10/2015 00:00:00','dd/mm/yyyy hh24:mi:ss') and priority_code in ('1','2'); 
spool off;
quit;
EOF
gzip Test_ITSDIncident_New$datestr.txt
( echo "Please find attached the ITSD Incidents report"; uuencode Test_ITSDIncident_New$datestr.txt.gz Test_ITSDIncident_New$datestr.txt.gz)| mailx -s "ITSD Incidents Report for `date`" "mohammed.rezwanali@du.ae" 
