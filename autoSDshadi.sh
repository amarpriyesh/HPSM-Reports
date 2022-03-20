cd /hpsm/hpsm/ops/reports/
#datestr=`date "+%d%m%M"`
arr1=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)


for (( i = 12 ; i < 21 ; i++ ))
do
datestr=`date "+%d%m%M"`
#datestr=master_tt_
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
'IncidentNo'
||'|'||'InteractionOwner'
||'|'||'ContactEmail'
||'|'||'duEmail'
||'|'||'InteractionStatus'
||'|'||'InteractionCategory'
||'|'||'InteractionArea'
||'|'||'InteractionSubArea'
||'|'||'Priority'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'ClosedTime'
||'|'||'InteractionSource'
||'|'||'Opened By'
||'|'||'ESS Flag'
||'|'||'RelatedIncident'
||'|'||'ResolutionCode'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'Resolved By'
||'|'||'Response Time'
||'|'||'FinalSolution'
from Dual
UNION ALL
select
A.incident_id
||'|'||A.du_interaction_owner
||'|'||A.contact_email
||'|'||A.du_email
||'|'||A.open
||'|'||replace(A.category,'
','')
||'|'||replace(A.subcategory,'
','')
||'|'||replace(replace(A.product_type,chr(10)),chr(13))
||'|'||A.priority_code
||'|'||to_char(A.open_time+4/24, 'mm-dd-yyyy HH24:MI:SS')
||'|'||to_char(A.resolve_time+4/24, 'mm-dd-yyyy HH24:MI:SS')
||'|'||to_char(A.close_time+4/24, 'mm-dd-yyyy HH24:MI:SS')
||'|'||A.callback_type
||'|'||A.opened_by
||'|'||A.ess_entry
||'|'||B.source
||'|'||replace(A.resolution_code,'
','')
||'|'||replace(A.resolution_type,'
','')
||'|'||replace(A.resolution_area,'
','')
||'|'||C.resolved_by
||'|'||replace ((select A.response_time-to_timestamp('1/1/4000','MM/DD/YYYY') diff from dual),'0000000','0')
||'|'||replace(replace(DBMS_LOB.SUBSTR(c.brief_description,500,1),chr(10)),chr(13))
from incidentsm1 A, screlationm1 B, probsummarym1 C where A.incident_id=B.depend(+) and
B.source=C."NUMBER"(+) and  ((A.open_time>=$fromdate) and  (A.open_time<$todate) );

spool off;
quit;
EOF
#/hpsm/hpsm/ops/reports/custommonthly$datestr$fromdate-$todate.csv
sed -i $'s/\t/ /g' custommonthly$datestr$fromdate-$todate.csv
gzip custommonthly$datestr$fromdate-$todate.csv
#mv custommonthly$datestr$fromdate-$todate.csv SD$datestr$fromdate-$todate.csv
#echo "."| mail -v -s "Please find attached report" -a /hpsm/hpsm/ops/reports/FMSIncident${datestr[$i]}to${datestr[$i+1]}.txt.gz priyesh.a@du.ae,ankur.saxena@du.ae
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\2018-2019\"; lcd /hpsm/hpsm/ops/reports/; prompt; recurse; mput custommonthly$datestr$fromdate-$todate.csv.gz; exit;"
done
