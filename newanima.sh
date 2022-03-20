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
spool HPSMIncidentsRFO12$datestr.txt
-------------------SIEBEL HPSM Incident extract------------------------------------
select 
'NUMBER'
||'|'||'OPENED_BY'
||'|'||'OPEN_TIME'
||'|'||'RESOLVED_TIME'
||'|'||'PRIORITY_CODE'
||'|'||'ASSIGNMENT'
||'|'||'ASSIGNEE_NAME'
||'|'||'SYSAPPLICATION'
||'|'||'RFO_SERVICES'
||'|'||'INCI_START'
||'|'||'INCI_END'
||'|'||'INCI_DURATION'
||'|'||'IMPACT_TYPE'
||'|'||'IMPACT_SEVERITY'
||'|'||'INCI_HISTORY'
||'|'||'STAFF_INVOLVED'
||'|'||'ROOT_CAUSE'
||'|'||'RFO_RESOLUTION'
||'|'||'RFO_ACTION'
||'|'||'IS_RFO'
||'|'||'brief_description'
from Dual
UNION ALL
select 
b."NUMBER" 
||'|'||b.OPENED_BY
||'|'||to_char(b.OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(b.resolved_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||(b.PRIORITY_CODE)
||'|'||(b.ASSIGNMENT)
||'|'||(b.ASSIGNEE_NAME)
||'|'||(b.SYSAPPLICATION)
||'|'||(b.RFO_SERVICES)
||'|'||to_char(b.INCI_START+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(b.INCI_END+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(b.INCI_DURATION+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||(b.IMPACT_TYPE)
||'|'||(b.IMPACT_SEVERITY)
||'|'||(b.INCI_HISTORY)
||'|'||(b.STAFF_INVOLVED)
||'|'||b.ROOT_CAUSE
||'|'||b.RFO_RESOLUTION
||'|'||b.RFO_ACTION
||'|'||b.IS_RFO
||'|'||replace(replace(DBMS_LOB.SUBSTR(a.brief_description, 200,1),chr(10)),chr(13))
from HPSM94BKPADMIN.INCIDENTS_OUTAGES b left join probsummarym1 a on b."NUMBER"=a."NUMBER" where b.OPEN_TIME >= '1-Jan-2018' and b.OPEN_TIME <= '31-March-2018';
spool off;
quit;
EOF
sed -i $'s/\t/ /g' HPSMIncidentsRFO12$datestr.txt
gzip HPSMIncidentsRFO12$datestr.txt
echo "."| mail -s "helo" -a HPSMIncidentsRFO12$datestr.txt.gz priyesh.a@du.ae
