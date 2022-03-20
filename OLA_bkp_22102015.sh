cd . ./home/hpsm/.bash_profile
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
spool OLA_Apr15_Onwards$datestr.txt
-------------------FMS Incident extract------------------------------------
select
'IncidentNo'
||'|'||'OpenTime'
||'|'||'Name'
||'|'||'TimeSpent'
||'|'||'HPSMStatus'
||'|'||'CurrentResolverGroup'
||'|'||'ResolvedTime'
||'|'||'Folder'
from Dual
union ALL
select
A."NUMBER"
||'|'||to_char(A.OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||B.name
||'|'||(B.closed_total -to_date('01014000000000','ddmmyyyyhh24miss'))*24*60
||'|'||A.problem_status
||'|'||A.assignment
||'|'||to_char(A.RESOLVED_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||A.folder
from
probsummarym1 A, clocksm1 B
where A."NUMBER"=B.key_char and (A.close_time+4/24 >= to_date('01/08/2015 00:00:00','dd/mm/yyyy hh24:mi:ss')
or A.open_time+4/24 >= to_date('01/08/2015 00:00:00','dd/mm/yyyy hh24:mi:ss'))
and B.key_char LIKE 'IM%';
spool off;
quit;
EOF
gzip OLA_Apr15_Onwards$datestr.txt
/usr/sfw/bin/smbclient \\\\172.22.31.31\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\OLA Reports\"; lcd /hpsm/hpsm/ops/; prompt; recurse; mput OLA_Apr15_Onwards$datestr.txt.gz; exit;"
