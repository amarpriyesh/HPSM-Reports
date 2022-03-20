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
spool OLA_FLM$datestr.txt
-------------------FMS Incident extract------------------------------------
select
'IncidentNo'
||'|'||'Assignment'
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
||'|'||a.assignment
||'|'||to_char(A.OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||replace(replace(B.name,chr(10),' '),chr(13),' ')
||'|'||(B.closed_total -to_date('01014000000000','ddmmyyyyhh24miss'))*24*60
||'|'||A.problem_status
||'|'||A.assignment
||'|'||to_char(A.RESOLVED_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||A.folder
from
probsummarym1 A, clocksm1 B
where A."NUMBER"=B.key_char and ((A.close_time+4/24 >= to_date('01/10/2017 00:00:00','dd/mm/yyyy hh24:mi:ss') and
A.close_time+4/24 <to_date('04/10/2018 00:00:00','dd/mm/yyyy hh24:mi:ss'))
or (A.open_time+4/24 >= to_date('01/10/2017 00:00:00','dd/mm/yyyy hh24:mi:ss') and
 A.open_time+4/24 < to_date('04/10/2016 00:00:00','dd/mm/yyyy hh24:mi:ss'))) and B.key_char LIKE 'IM%' and (assignment  like '%FLM%Mobile%' or assignment like  '%Civil%Mobile%' or assignment  like '%FLM%Wireless%');
spool off;
quit;
EOF
gzip OLA_FLM$datestr.txt
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\OLA Reports\"; lcd /hpsm/hpsm/ops/reports; prompt; recurse; mput OLA_FLM$datestr.txt.gz; exit;"
