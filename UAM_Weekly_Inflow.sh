cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/
USER=nrs
PASS=nrs123
datestr=`date "+%d%m%y"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
spool UAM_Weekly$datestr.csv
-------------------Weekly UAM TT Incident extract------------------------------------




select
'IncidentNo'
||','||'Status'
||','||'Opened By'
||','||'Assignee Name'
||','||'Category'
||','||'Subcategory'
||','||'Product Type'
||','||'Priority Code'
||','||'Current Resolver Group'
||','||'Resolution Code'
||','||'Resolution Type'
||','||'Resolution Area'
||','||'Open Time'
||','||'Resolved Time'
||','||'Close Time'
||','||'TimeSpent'
||','||'Operator'
||','||'Inflow Time'
||','||'Operator'
from dual
union all
select 
key_char
||','||b.problem_status
||','||b.opened_by
||','||b.assignee_name
||','||replace(replace(replace(DBMS_LOB.SUBSTR(b.category,1000,1),chr(10)),chr(9)),chr(13))
||','||replace(replace(replace(DBMS_LOB.SUBSTR(b.subcategory,1000,1),chr(10)),chr(9)),chr(13))
||','||replace(replace(replace(DBMS_LOB.SUBSTR(b.product_type,1000,1),chr(10)),chr(9)),chr(13))
||','||b.priority_code
||','||b.assignment
||','||b.resolution_code
||','||b.resolution_type
||','||b.resolution_area
||','||to_char(b.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(b.resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(b.close_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||(to_date(to_char(total,'ddmmyyyyhh24miss'),'ddmmyyyyhh24miss')-to_date('01014000000000','ddmmyyyyhh24miss'))*24*60
||','||du_assignment
||','||to_char(((close_date+4/24)-(total-to_date('01014000000000','ddmmyyyyhh24miss'))),'mm/dd/yyyy HH24:MI:SS')
||','||name 
from clocksm1 a,probsummarym1 b
where a.key_char=b."NUMBER" and a.name in ('akram.ibrahim','bushra.meraj','gabi.mansour','prashant.j','hussam.gebriel','auhood.alali','cdukxp6t')
and ((close_date+4/24)-(to_date(to_char(total,'ddmmyyyyhh24miss'),'ddmmyyyyhh24miss')-to_date('01014000000000','ddmmyyyyhh24miss')))< trunc(sysdate,'DD')
and ((close_date+4/24)-(to_date(to_char(total,'ddmmyyyyhh24miss'),'ddmmyyyyhh24miss')-to_date('01014000000000','ddmmyyyyhh24miss'))) >= trunc(trunc(sysdate,'DD')-7);

spool off;
quit;
EOF
echo "."| mail -v -s "Please find attached weekly UAM Incidents report" -a /hpsm/hpsm/ops/reports/UAM_Weekly$datestr.csv Hussam.Gebriel@du.ae,Akram.Ibrahim@du.ae,ankur.saxena@du.ae
#( echo "Please find attached weekly UAM Incidents report"; uuencode UAM_Weekly$datestr.csv UAM_Weekly$datestr.csv)| mailx -s "weekly UAM TT Report for Last Week" "Nihalchand.Dehury@du.ae,Hussam.Gebriel@du.ae,Akram.Ibrahim@du.ae,mohammed.rezwanali@du.ae"
