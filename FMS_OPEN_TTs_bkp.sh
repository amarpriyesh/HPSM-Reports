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
spool FMS_OPENTTs$datestr.csv
-------------------FMS OPEN TTs details extract------------------------------------
Select
'IncidentNo'
||','||'IncidentStatus'
||','||'priority'
||','||'CurrentResolverGroup'
||','||'OpenTime'
||','||'OpenedBy'
||','||'Current Age of TT (No.of days)'
||','||'Brief Description'
from Dual
union ALL
select
"NUMBER"
||','||problem_status
||','||priority_code
||','||assignment
||','||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||opened_by
||','||(to_date(trunc(sysdate),' dd-mon-yyyy HH24:MI')-TO_DATE(open_time+4/24,'DD-MON-YYYY HH24:MI'))
||','||(REPLACE(REPLACE (REPLACE (DBMS_LOB.SUBSTR ( brief_description, 200, 1),CHR (10),' '),CHR (13),' '),CHR (9),' '))
from
probsummarym1 a
where folder ='FMS' and priority_code not in ('4','3') and
problem_status not in ('Closed','Resolved') and opened_by in 
('cbdixbsm','cbdixmv4','cbdipehp','cbdiphe1','cbdiamf2','cbdivg12','cbdi1ion','cbdiowdo','cbdil65g','cbdi6xub','cbdifzlx','cbdihd7a');

spool off;
quit;
EOF



mail -s "hello" -a FMS_OPENTTs$datestr.csv priyesh.a@du.ae
