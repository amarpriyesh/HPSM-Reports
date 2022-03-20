cd /hpsm/hpsm/ops/reports/
#datestr=`date "+%d%m%M"`
arr1=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)


for (( i = 12 ; i < 17 ; i++ ))
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
'Incident ID'
||','||'Time Stamp'
||','||'operator'
||','||'Message'
||','||'Request ID'
||','||'Product Name'
||','||'Priority'
||','||'AS/AP'
||','||'Rejection Reason'
||','||'Issue Description'
from dual
union all
select
b."NUMBER"
||','||to_char(a.datestamp+4/24,'dd/mm/yyyy HH:mi AM')
||','||a.operator
||','||decode(a.type,'Resolved',concat(a.type,concat(' ',b.resolution_area)),a.type)
||','||b.reference_no
||','||b.du_affected_service
||','||b.priority_code
||','||decode(b.folder,'I\&W-Etisalat','AP','AS')
||','||(select replace(replace(DBMS_LOB.SUBSTR(c.description, 1500,1),chr(10)),chr(13)) from activitym1 c where type='Rejecti
on Reason' and c."NUMBER"=a."NUMBER" and a.datestamp=c.datestamp)
||','||replace(replace(replace(DBMS_LOB.SUBSTR(b.action, 1500,1),chr(10)),chr(13)),',','')
from activitym1 a,probsummarym1 b
where a."NUMBER"=b."NUMBER" and ((b.folder ='FMS' and du_solution='Access Seeker') or folder in ('I\&W-Etisalat'))
and (a.type like 'FNL%' or  a.type in ('Open','Resolved','Rejection Reason','Accepted','In Progress','Pending Input','ReAssigned','Rejected to Business','Reopened','Closed')) and
 ((a.datestamp+4/24>=$fromdate) and  (a.datestamp+4/24<$todate) )  ;


spool off;
quit;
EOF
#/hpsm/hpsm/ops/reports/custommonthly$datestr$fromdate-$todate.csv
sed -i $'s/\t/ /g' custommonthly$datestr$fromdate-$todate.csv
#gzip custommonthly$datestr$fromdate-$todate.csv
#echo "."| mail -v -s "Please find attached report" -a /hpsm/hpsm/ops/reports/FMSIncident${datestr[$i]}to${datestr[$i+1]}.txt.gz priyesh.a@du.ae,ankur.saxena@du.ae
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\FNL AS AP\"; lcd /hpsm/hpsm/ops/reports/; prompt; recurse; mput custommonthly$datestr$fromdate-$todate.csv; exit;"
done
