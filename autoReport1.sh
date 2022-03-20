
cd /hpsm/hpsm/ops/reports/

arr1=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)


for (( i = 7 ; i < 21 ; i++ ))
do

if [ $i -lt 11 ]
then
fromdate="'01-${arr1[$i]}-2018'"
todate="'01-${arr1[$i+1]}-2018'"
elif [ $i -eq 11 ]
then
fromdate="'01-${arr1[$i]}-2018'"
todate="'01-${arr1[$i+1]}-2019'"
else
fromdate="'01-${arr1[$i]}-2019'"
todate="'01-${arr1[$i+1]}-2019'"
echo $todate
fi

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
set define off
spool custommonthly$fromdate-$todate.csv
select
'IncidentNo'
||'|'||'Priority'
||'|'||'IncidentCreatedat'
||'|'||'ResolverGroup'
||'|'||'Folder'
||'|'||'reference_no'
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
||'|'||a.folder
||'|'||a.reference_no
||'|'||a.problem_status
||'|'||to_char(a.resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS') 
||'|'||a.resolution_code 
||'|'||a.resolution_type 
||'|'||a.resolution_area 
||'|'||replace(replace(DBMS_LOB.SUBSTR(brief_description, 200,1),chr(10)),chr(13))
from HPSM94BKPADMIN.probsummarym1 a where  ((open_time>=$fromdate) and  (open_time<$todate) ) ;

spool off;
quit;
EOF
#/hpsm/hpsm/ops/reports/custommonthly$fromdateto$todate.csv
sed -i $'s/\t/ /g' custommonthly$fromdate-$todate.csv
gzip custommonthly$fromdate-$todate.csv
#echo "."| mail -v -s "Please find attached report" -a /hpsm/hpsm/ops/reports/FMSIncident${datestr[$i]}to${datestr[$i+1]}.txt.gz priyesh.a@du.ae,ankur.saxena@du.ae
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\2018-2019\"; lcd /hpsm/hpsm/ops/reports/; prompt; recurse; mput custommonthly$fromdate-$todate.csv.gz; exit;"


done
