cd
. ./.bash_profile
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
set define off
spool RFOIncidents$datestr.csv
-------------------RFO Incident extract------------------------------------
select
'Incident ID'
||','||'Opened By'
||','||'Open Time'
||','||'Resolved Time'
||','||'Priority Code'
||','||'Problem Status'
||','||'Assignment'
||','||'Assignee Name'
||','||'System Application'
||','||'RFO Services'
||','||'Incident Start'
||','||'Incident End'
||','||'Incident Duration'
||','||'Impact Type'
||','||'Impact Severity'
||','||'Incident History'
||','||'Staff Involved'
||','||'Root Cause'
||','||'RFO Resolution'
||','||'Action'
from dual
union all
SELECT 
a."NUMBER"
||','||opened_by
||','||to_char(open_time+4/24,'MM/DD/YYYY HH:MI AM')
||','||to_char(resolved_time+4/24,'MM/DD/YYYY HH:MI AM')
||','||priority_code
||','||problem_status
||','||assignment
||','||assignee_name
||','||replace(sysapplication,',',' ')
||','||replace(rfo_services,',',' ')
||','||to_char(inci_start+4/24,'MM/DD/YYYY HH:MI AM')
||','||to_char(inci_end+4/24,'MM/DD/YYYY HH:MI AM')
||','||to_char(inci_duration,'MM/DD/YYYY HH:MI')
||','||impact_type
||','||impact_severity
||','||(REPLACE(REPLACE (REPLACE (DBMS_LOB.SUBSTR (inci_history, 2000, 1),CHR (10),' '),CHR (13),' '),CHR (9),' ')) 
||','||staff_involved
||','||root_cause
||','||rfo_resolution
||','||REPLACE(REPLACE (REPLACE (DBMS_LOB.SUBSTR (rfo_action, 2000, 1),CHR (10),' '),CHR (13),' '),CHR (9),' ') 
FROM probsummarym1 a
WHERE is_rfo = 't' AND a.priority_code IN ('1', '2', '3') and open_time>'01-JAN-2016';


spool off;
quit;
EOF

/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\RFOReports\"; lcd /hpsm/hpsm/ops/; prompt; recurse; mput RFOIncidents$datestr.csv; exit;"
