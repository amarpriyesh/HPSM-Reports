cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/
datestr=`date "+%d%m%y"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
spool All_Incidents1$datestr.txt
-------------------All Incident extract------------------------------------

select
'IncidentNo'
||'|'||'Ref no'
||'|'||'IncidentStatus'
||'|'||'Opened By'
||'|'||'Folder'
||'|'||'Assignee Name'
||'|'||'IncidentCategory'
||'|'||'IncidentArea'
||'|'||'IncidentSubArea'
||'|'||'priority'
||'|'||'CurrentResolverGroup'
||'|'||'AssigneeName'
||'|'||'ResolutionCode'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
from Dual
union ALL
select
A."NUMBER"
||'|'||reference_no
||'|'||problem_status
||'|'||opened_by
||'|'||folder
||'|'||assignee_name
||'|'||category
||'|'||subcategory
||'|'||product_type
||'|'||priority_code
||'|'||assignment
||'|'||assignee_name
||'|'||resolution_code
||'|'||resolution_type
||'|'||resolution_area
||'|'||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(resolved_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
from
probsummarym1 A
where  open_time+4/24 >= to_date('01/10/2018 00:00:00','dd/mm/yyyy hh24:mi:ss') and folder='ITSD';
spool off;
quit;
EOF
#cp /hpsm/hpsm/ops/All_Incidents1$datestr.txt /hpsm/hpsm/ops/Billshock_All_Incidents$datestr.txt
#/usr/sfw/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/ ; prompt; recurse; mput All_Incidents$datestr.txt; exit;"

###FTP to Billing server for BSCS Dashboard Requirement#####
#cd /hpsm/hpsm/ops/
#ftp -n 172.21.27.13 <<EOF
#user $USER $PASS
#cd JBOSS/java_soft/BSCSTool_InputFiles/HPSMReports/
#put All_Incidents$datestr.txt
#put Billshock_All_Incidents$datestr.txt
#bye
#EOF

gzip All_Incidents1$datestr.txt
 echo "."| mail -s "All Incidents Report for" -a /hpsm/hpsm/ops/reports/All_Incidents1$datestr.txt priyesh.a@du.ae,ankur.saxena@du.ae
