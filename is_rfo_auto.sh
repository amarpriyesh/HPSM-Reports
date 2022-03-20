cd /hpsm/hpsm/ops/reports/
datestr=`date "+%d%m%M"`
arr1=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)


for (( i = 0 ; i < 21 ; i++ ))
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
spool custommonthly$datestr$fromdate-$todate.csv
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
||'|'||'Is_rfo'
||'|'||'Root Cause'
||'|'||'Incident History'
||'|'||'RFO resolution'
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
||'|'||is_rfo
||'|'||(REPLACE(REPLACE (REPLACE (DBMS_LOB.SUBSTR (root_cause,100, 1),CHR (10),' '),CHR (13),' '),CHR (9),' '))
||'|'||(REPLACE(REPLACE (REPLACE (DBMS_LOB.SUBSTR (inci_history,500, 1),CHR (10),' '),CHR (13),' '),CHR (9),' '))
||'|'||REPLACE(REPLACE (REPLACE (DBMS_LOB.SUBSTR (rfo_resolution,500, 1),CHR (10),' '),CHR (13),' '),CHR (9),' ')
from HPSM94BKPADMIN.probsummarym1 a where  ((open_time>=$fromdate) and  (open_time<$todate) ) ;

spool off;
quit;
EOF
#/hpsm/hpsm/ops/reports/custommonthly$datestr$fromdate-$todate.csv
sed -i $'s/\t/ /g' custommonthly$datestr$fromdate-$todate.csv
gzip custommonthly$datestr$fromdate-$todate.csv
#echo "."| mail -v -s "Please find attached report" -a /hpsm/hpsm/ops/reports/FMSIncident${datestr[$i]}to${datestr[$i+1]}.txt.gz priyesh.a@du.ae,ankur.saxena@du.ae
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\2018-2019\"; lcd /hpsm/hpsm/ops/reports/; prompt; recurse; mput custommonthly$datestr$fromdate-$todate.csv.gz; exit;"

done
