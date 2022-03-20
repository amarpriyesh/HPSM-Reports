
cd /hpsm/hpsm/ops/reports/

arr1=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)

for (( i = 0 ; i < 12 ; i++ ))
do


datestr[$i]="'01-${arr1[$i]}-2016'"

done
datestr[12]="'01-Jan-2017'"

for (( i = 0 ; i < 12 ; i++ ))
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
spool AllIncidents${datestr[$i]}to${datestr[$i+1]}.txt
select
'IncidentNo'
||'|'||'Priority'
||'|'||'IncidentCreatedat'
||'|'||'ResolverGroup'
||'|'||'IncidentStatus'
||'|'||'ResolvedTime'
||'|'||'ResolutionCategory'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'Description'
from Dual
UNION ALL
select
a."NUMBER"
||'|'||a.priority_code
||'|'||to_char(a.open_time+4/24,'mm/dd/yyyy HH24:MI:SS') 
||'|'||a.assignment
||'|'||a.problem_status
||'|'||to_char(a.resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS') 
||'|'||a.resolution_code 
||'|'||a.resolution_type 
||'|'||a.resolution_area 
||'|'||replace(replace(DBMS_LOB.SUBSTR(brief_description, 200,1),chr(10)),chr(13))
from HPSM94BKPADMIN.probsummarym1 a where  ((open_time>=${datestr[$i]}) and  (open_time<${datestr[$i+1]}) );

spool off;
quit;
EOF
/hpsm/hpsm/ops/reports/AllIncidents${datestr[$i]}to${datestr[$i+1]}
sed -i $'s/\t/ /g' AllIncidents${datestr[$i]}to${datestr[$i+1]}.txt
gzip AllIncidents${datestr[$i]}to${datestr[$i+1]}.txt
#echo "."| mail -v -s "Please find attached report" -a /hpsm/hpsm/ops/reports/FMSIncident${datestr[$i]}to${datestr[$i+1]}.txt.gz priyesh.a@du.ae,ankur.saxena@du.ae
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\FMSReports\"; lcd /hpsm/hpsm/ops/reports/; prompt; recurse; mput AllIncidents${datestr[$i]}to${datestr[$i+1]}.txt.gz; exit;"


done
