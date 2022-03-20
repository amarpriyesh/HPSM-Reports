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
spool DealerIncident$datestr.txt
-------------------ITSD Incident extract------------------------------------

select 
'IncidentNo'
||'|'||'DealerID'
||'|'||'IncidentStatus'
||'|'||'Opened By'
||'|'||'Assignee Name'
||'|'||'IncidentCategory'
||'|'||'IncidentArea'
||'|'||'IncidentSubArea'
||'|'||'Priority'
||'|'||'BriefDescription'
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
from Dual
UNION ALL
select
"NUMBER"
||'|'||du_dealer_id
||'|'||problem_status
||'|'||opened_by
||'|'||assignee_name
||'|'||category
||'|'||subcategory
||'|'||product_type
||'|'||priority_code
||'|'||brief_description
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
from probsummarym1 
where folder='SIEBEL-CRM' and is_dealer='t';
spool off;
quit;
EOF
/usr/sfw/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/reports/ ; prompt; recurse; mput DealerIncident$datestr.txt; exit;"
gzip DealerIncident$datestr.txt
( echo "Please find attached the Dealer Incidents report"; uuencode DealerIncident$datestr.txt.gz DealerIncident$datestr.txt.gz)| mailx -s "Dealer Incidents Report for `date`" "nihalchand.dehury@du.ae,ServiceDesk@du.ae"
