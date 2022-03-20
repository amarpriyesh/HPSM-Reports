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
set define off
spool RFOIncidents$datestr.csv
-------------------RFO Incident extract------------------------------------
select
'Incident ID'
||'|'||'Opened By'
||'|'||'Open Time'
||'|'||'Resolved Time'
||'|'||'Priority Code'
||'|'||'Problem Status'
||'|'||'Assignment'
||'|'||'Assignee Name'
||'|'||'System Application'
||'|'||'RFO Services'
||'|'||'Incident Start'
||'|'||'Incident End'
||'|'||'Incident Duration'
||'|'||'Impact Type'
||'|'||'Impact Severity'
||'|'||'First Resol'
||'|'||'Root Cause'
||'|'||'Incident History'
||'|'||'Action'
from dual
union all
SELECT 
a."NUMBER"
||'|'||opened_by
||'|'||to_char(open_time+4/24,'MM/DD/YYYY HH:MI AM')
||'|'||to_char(resolved_time+4/24,'MM/DD/YYYY HH:MI AM')
||'|'||priority_code
||'|'||problem_status
||'|'||assignment
||'|'||assignee_name
||'|'||replace(sysapplication,',',' ')
||'|'||replace(rfo_services,',',' ')
||'|'||to_char(inci_start+4/24,'MM/DD/YYYY HH:MI AM')
||'|'||to_char(inci_end+4/24,'MM/DD/YYYY HH:MI AM')
||'|'||to_char(inci_duration,'MM/DD/YYYY HH:MI')
||'|'||impact_type
||'|'||impact_severity
||'|'||(select case  when count(*) > 1 then 'false' when count(*) = 1   then 'true' else 'NA' end  from activitym1 where "NUMBER"=a."NUMBER"  and type='Resolved' )
||'|'||(REPLACE(REPLACE (REPLACE (DBMS_LOB.SUBSTR (root_cause,100, 1),CHR (10),' '),CHR (13),' '),CHR (9),' '))
||'|'||(REPLACE(REPLACE (REPLACE (DBMS_LOB.SUBSTR (inci_history,500, 1),CHR (10),' '),CHR (13),' '),CHR (9),' '))
||'|'||REPLACE(REPLACE (REPLACE (DBMS_LOB.SUBSTR (rfo_action,500, 1),CHR (10),' '),CHR (13),' '),CHR (9),' ') 
FROM probsummarym1 a
WHERE is_rfo = 't'  and open_time>'01-Jan-2019';


spool off;
quit;
EOF
gzip RFOIncidents$datestr.csv

echo "." | mail -s "RFO incident report last 4 months" -a /hpsm/hpsm/ops/reports/RFOIncidents$datestr.csv.gz priyesh.a@du.ae,ankur.saxena@du.ae,Ahmed.Jurmut1@du.ae,shadi.trad@du.ae 
#/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\RFOReports\"; lcd /hpsm/hpsm/ops/; prompt; recurse; mput RFOIncidents$datestr.csv; exit;"
