cd
. ./.bash_profile
cd /hpsm/hpsm/ops/

arr1=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)

for (( i = 0 ; i < 12 ; i++ ))
do


datestr[$i]="'01-${arr1[$i]}-2018'"

done

for (( i = 0 ; i < 11 ; i++ ))
do

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
set define off
spool FMSIncidentOLA1${datestr[$i]}to${datestr[$i+1]}.txt
-------------------FMS Incident extract------------------------------------
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
||'|'||replace(replace(B.name,chr(10),' '),chr(13),' ')
||'|'||(B.closed_total -to_date('01014000000000','ddmmyyyyhh24miss'))*24*60
||'|'||A.problem_status
||'|'||A.assignment
||'|'||to_char(A.RESOLVED_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||replace(A.folder,chr(10),' ')
from
probsummarym1 A, clocksm1 B
where A."NUMBER"=B.key_char and folder='FMS' and  ((resolved_time+4/24>=${datestr[$i]}) and  (resolved_time+4/24<${datestr[$i+1]}) );
spool off;
quit;
EOF
/hpsm/hpsm/ops/reports/custom/FMSIncidentOLA1${datestr[$i]}to${datestr[$i+1]}.txt
gzip FMSIncidentOLA1${datestr[$i]}to${datestr[$i+1]}.txt
#echo "."| mail -v -s "Please find attached report" -a /hpsm/hpsm/ops/reports/FMSIncident${datestr[$i]}to${datestr[$i+1]}.txt.gz priyesh.a@du.ae,ankur.saxena@du.ae
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\FMSReports\"; lcd /hpsm/hpsm/ops/; prompt; recurse; mput FMSIncidentOLA1${datestr[$i]}to${datestr[$i+1]}.txt.gz; exit;"
done
