cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/custom/

arr1=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)

for (( i = 0 ; i < 12 ; i++ ))
do


datestr[$i]="'01-${arr1[$i]}-2017'"

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
spool FMSIncident1${datestr[$i]}to${datestr[$i+1]}.txt
-------------------FMS Incident extract------------------------------------


select 
'IncidentNo'
||'|'||'IncidentCreatedat'
||'|'||'TTOpenedBy'
||'|'||'FMSReferenceNo'
||'|'||'duAlarmDate'
||'|'||'MessageGroup'
||'|'||'Domain'
||'|'||'duNetwork'
||'|'||'duSolution'
||'|'||'duElement'
||'|'||'duVendor'
||'|'||'IncidentCategory'
||'|'||'IncidentArea'
||'|'||'IncidentSubArea'
||'|'||'Priority'
||'|'||'IncidentStatus'
||'|'||'CurrentResolverGroup'
||'|'||'AssignmentName'
||'|'||'Count'
||'|'||'PendingCode'
||'|'||'SLABreach'
||'|'||'Resolvedgroup'
||'|'||'ResolvedTime'
||'|'||'ClosedTime'
||'|'||'BriefDescription'
from Dual
UNION ALL
select
"NUMBER"
||'|'|| to_char(open_time+4/24,'mm-dd-yyyy HH24:MI:SS')
||'|'|| opened_by
||'|'|| fms_reference_no
||'|'|| du_alarm_date
||'|'|| msg_group
||'|'|| domain
||'|'|| du_network
||'|'|| du_solution
||'|'|| du_element
||'|'|| du_vendor
||'|'|| category
||'|'|| subcategory
||'|'|| product_type
||'|'|| priority_code
||'|'|| problem_status
||'|'|| assignment
||'|'|| assignee_name
||'|'|| count
||'|'|| pending_code
||'|'|| sla_breach
||'|'|| resolved_group
||'|'|| to_char(resolved_time+4/24, 'mm-dd-yyyy HH24:MI:SS')
||'|'|| to_char(close_time+4/24, 'mm-dd-yyyy HH24:MI:SS')
||'|'||REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(brief_description, 1000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' '),'|',' '),'\',' ')
from probsummarym1 a
where (folder in('FMS') and ((close_time>=${datestr[$i]}) and  (close_time<${datestr[$i+1]}) )or problem_status<>'Closed');

spool off;
quit;
EOF
/hpsm/hpsm/ops/reports/custom/FMSIncident1${datestr[$i]}to${datestr[$i+1]}
sed -i $'s/\t/ /g' FMSIncident1${datestr[$i]}to${datestr[$i+1]}.txt
gzip FMSIncident1${datestr[$i]}to${datestr[$i+1]}.txt
#echo "."| mail -v -s "Please find attached report" -a /hpsm/hpsm/ops/reports/FMSIncident${datestr[$i]}to${datestr[$i+1]}.txt.gz priyesh.a@du.ae,ankur.saxena@du.ae
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\FMSReports\"; lcd /hpsm/hpsm/ops/reports/custom/; prompt; recurse; mput FMSIncident1${datestr[$i]}to${datestr[$i+1]}.txt.gz; exit;"
done
