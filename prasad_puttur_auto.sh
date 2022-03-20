cd /hpsm/hpsm/ops/reports/
#datestr=`date "+%d%m%M"`
arr1=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)


for (( i = 7 ; i < 21 ; i++ ))
do
#datestr=`date "+%d%m%M"`
datestr=master_tt_
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
||'|'||'SiebelTTNo'
||'|'||'is_Master TT'
||'|'||'Master TT ID'
||'|'||'IncidentCreatedat'
||'|'||'IncidentStatus'
||'|'||'Opened By'
||'|'||'Assignee Name'
||'|'||'IncidentCategory'
||'|'||'IncidentArea'
||'|'||'IncidentSubArea'
||'|'||'SiebelTTCreatedAt'
||'|'||'CurrentResolverGroup'
||'|'||'Priority'
||'|'||'SiebelTTStatus'
||'|'||'CustomerType'
||'|'||'CustomerSegment'
||'|'||'CustomerService'
||'|'||'CustomerValue'
||'|'||'ContractId'
||'|'||'ServiceType'
||'|'||'SignatureAccount'
||'|'||'ServiceRegion'
||'|'||'SubRegion'
||'|'||'ServiceBuildingName'
||'|'||'CustomerID'
||'|'||'IsDealer'
||'|'||'ReopenCount'
||'|'||'ResolutionCategory'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'SiebelActivityId'
||'|'||'LastUpdatedTime'
||'|'||'ClosedTime'
||'|'||'ResolvedTime'
||'|'||'GAID'
||'|'||'ResolvedBy'
||'|'||'ReassignmentCount'
||'|'||'ResolutionAction'
||'|'||'Auto Routed'
||'|'||'SLA Startdate'
||'|'||'SLA Enddate'
||'|'||'SLA Remaining'
||'|'||'SLA Expiration'
||'|'||'SLA Breach'
||'|'||'is_rfo'
||'|'||'description'
from Dual
UNION ALL
select 
"NUMBER"
||'|'||REFERENCE_NO
||'|'||du_master_tt
||'|'||du_mastertt
||'|'||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||problem_status
||'|'||opened_by
||'|'||replace(replace(assignee_name,chr(10),' '),chr(13),' ')
||'|'||category
||'|'||subcategory
||'|'||product_type
||'|'||to_char(du_siebel_open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||assignment
||'|'||priority_code
||'|'||du_siebel_status
||'|'||du_cust_type
||'|'||du_cust_segment
||'|'||du_cust_service
||'|'||du_cust_value
||'|'||du_contract_id
||'|'||du_service_type
||'|'||du_signature_account
||'|'||fnl_service_region
||'|'||fnl_service_subregion
||'|'||fnl_service_buildingname
||'|'||du_cust_accnumber
||'|'||is_dealer
||'|'||du_reopenCount
||'|'||replace(replace(resolution_code,chr(10),' '),chr(13),' ')
||'|'||replace(replace(resolution_type,chr(10),' '),chr(13),' ')
||'|'||replace(replace(resolution_area,chr(10),' '),chr(13),' ')
||'|'||du_activity_ref_no
||'|'||to_char(update_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(close_time+4/24, 'mm/dd/yyyy HH24:MI:SS') 
||'|'||to_char(resolved_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||fnl_service_gaid
||'|'||resolved_by
||'|'||count
||'|'||resolution_action
||'|'||auto_assigned
||'|'||du_sla_start
||'|'||du_sla_end
||'|'||SLA_remaining
||'|'||SLA_Expire
||'|'||SLA_breach
||'|'||is_rfo
||'|'||dbms_lob.substr(brief_description,200)
from HPSM94BKPADMIN.probsummarym1 a where  ((open_time>=$fromdate) and  (open_time<$todate) ) and du_master_tt='t' ;

spool off;
quit;
EOF
#/hpsm/hpsm/ops/reports/custommonthly$datestr$fromdate-$todate.csv
sed -i $'s/\t/ /g' custommonthly$datestr$fromdate-$todate.csv
gzip custommonthly$datestr$fromdate-$todate.csv
#echo "."| mail -v -s "Please find attached report" -a /hpsm/hpsm/ops/reports/FMSIncident${datestr[$i]}to${datestr[$i+1]}.txt.gz priyesh.a@du.ae,ankur.saxena@du.ae
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\2018-2019\master\"; lcd /hpsm/hpsm/ops/reports/; prompt; recurse; mput custommonthly$datestr$fromdate-$todate.csv.gz; exit;"
done
