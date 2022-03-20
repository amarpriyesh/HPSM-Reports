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
spool RetailIncidents$datestr.csv
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
||','||'Category'
||','||'Area'
||','||'SubArea'
||','||'Description'
||','||'Resolution'
||','||'Resolved By'
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
||','||category
||','||subcategory
||','||product_type
||','||(REPLACE(REPLACE (REPLACE (DBMS_LOB.SUBSTR (action, 2000, 1),CHR (10),' '),CHR (13),' '),CHR (9),' ')) 
||','||(REPLACE(REPLACE (REPLACE (DBMS_LOB.SUBSTR (resolution, 2000, 1),CHR (10),' '),CHR (13),' '),CHR (9),' '))
FROM probsummarym1 a
WHERE assignment='IT - OSS-OPS- HPSM' and open_time+4/24>to_date(sysdate-1,'DD-MM-YYYY');


spool off;
quit;
EOF

/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\RetailReports\"; lcd /hpsm/hpsm/ops/; prompt; recurse; mput RetailIncidents$datestr.csv; exit;"
