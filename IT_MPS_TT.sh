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
spool IT_MPS_TT$datestr.csv
-------------------IT MPS extract------------------------------------
set ESCAPE '\'
select 
'IncidentNo'
||'|'||'Related SD'
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
||'|'||'TT Type'
||'|'||'Pending Reason'
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
||'|'||'Update Action'
from Dual
UNION ALL
select
"NUMBER"
||'|'||incident_id
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
||'|'||du_tt_type
||'|'||pending_code
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
||'|'||trim(replace(replace(replace(DBMS_LOB.SUBSTR(update_action, 400,1),chr(10)),chr(13)),','))
from probsummarym1 
where assignment='IT - Managed Printing Service' and (((open_time+4/24) between TO_DATE(TO_CHAR(add_months(sysdate,-1), 'YYYY-MM-DD'),'YYYY-MM-DD') and TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD')) or ((close_time+4/24) between TO_DATE(TO_CHAR(add_months(sysdate,-1), 'YYYY-MM-DD'),'YYYY-MM-DD') and TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD')));
spool off;
quit;
EOF

sed -i $'s/,/ /g' IT_MPS_TT$datestr.csv
sed -i $'s/|/,/g' IT_MPS_TT$datestr.csv

echo "Dear All

PFA the monthly report of MPS Incidents.

Best Regards,
HPSM Team"| mail -v -s "IT Managed Printing Services TTs Report" -a /hpsm/hpsm/ops/reports/IT_MPS_TT$datestr.csv utkarsh.jauhari@du.ae,shadi.trad@du.ae,Ali.Alkhatib@du.ae

