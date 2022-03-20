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
spool Incidents_Reopened_HPSM$datestr.txt
-------------------Reopened Incident extract------------------------------------

select
'IncidentNo'
||'|'||'ReopenedDate'
||'|'||'ResolvedGroup'
||'|'||'Folder'
||'|'||'Siebel TT number'
||'|'||'Service type'
||'|'||'Category'
||'|'||'Area'
||'|'||'Subarea'
||'|'||'Type'
||'|'||'Folder'
||'|'||'ServiceRegion'
||'|'||'ServiceSubRegion'
||'|'||'ServiceBuildingName'
||'|'||'createdDate'
||'|'||'CustomerID'
||'|'||'AssigneeName'
||'|'||'Operator'
from Dual
union ALL
select
b."NUMBER"
||'|'||to_char(b.datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||substr(replace(replace(DBMS_LOB.SUBSTR(b.description, 2000,1),chr(10)),chr(13)),1,instr(b.description,'to')-1)
||'|'||a.folder
||'|'||a.reference_no
||'|'||a.du_service_type
||'|'||a.category
||'|'||a.subcategory
||'|'||a.product_type
||'|'||b.type
||'|'||a.folder
||'|'||a.fnl_service_region
||'|'||a.fnl_service_subregion
||'|'||a.fnl_service_buildingname
||'|'||to_char(a.open_time+4/24,'mm-dd-yyyy HH24:MI:SS')
||'|'||a.du_cust_accnumber
||'|'||a.assignee_name
||'|'||b.operator
from probsummarym1 a,activitym1 b where a."NUMBER"=b."NUMBER" and b.type='Reopened' and  a.folder='FMS' and ( b.datestamp+4/24>='01-Jul-2019' and b.datestamp+4/24<'01-Aug-2019');
spool off;
quit;
EOF
#/usr/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/reports/ ; prompt; recurse; mput Incidents_Reopened_HPSM$datestr.txt; exit;"
gzip Incidents_Reopened_HPSM$datestr.txt
#(echo "Please find attached the Reopened Incidents report"; uuencode Incidents_Reopened_HPSM$datestr.txt.gz Incidents_Reopened_HPSM$datestr.txt.gz)| mailx -s "HPSM Reopened Incidents Report for `date`" "priyesh.a@du.ae"
echo "." | mail -s "hello" -a Incidents_Reopened_HPSM$datestr.txt.gz priyesh.a@du.ae
