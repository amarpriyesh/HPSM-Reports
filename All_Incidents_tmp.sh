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
spool All_Incidents$datestr.txt
-------------------All Incident extract------------------------------------

select
'IncidentNo'
||'|'||'IncidentStatus'
||'|'||'Opened By'
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
||'|'||'ClosedTime'
||'|'||'ResolvedTime'
||'|'||'Type'
from Dual
union ALL
select
A."NUMBER"
||'|'||problem_status
||'|'||opened_by
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
||'|'||to_char(close_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(resolved_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||folder
from
probsummarym1 A
where (a.open_time >='01-Jun-2018' and a.open_time <'01-JUl-2018') ;
spool off;
quit;
EOF


# assignment in ('TSD - Bitstream','WIPRO - FNL - Field','TCS - FNL - Field','TCS - FNL','WIPRO - FNL','Fixed Core - NGN','TCS - FNL - Field','WIPRO - FNL','TCS - CSA - Field','WIPRO - CSA - Field','WIPRO - CSA','TCS - CSA','NOC - FAN','Transport Operations IP Agg','FNL Access Provider TT','Network Operation IP SDP','FNL Access Seeker TT','Huawei-GPON','ALU-GPON','CSM - Fixed Consumer SA','CSM - Dubai Fixed Consumer SA','FAN Operations - IP Fixed Access','FLM - Fiber Maintenance','Transport - IX Operations','Transport - IP Fixed Access','NOC - International Voice Services','NOC - Consumer','CSM Consumer SF','CSM - Order Management Desk Consumer','CSM - Consumer Provisioning and Incidents','CSM - Consumer Activation','Core - National Switching ');
#spool off;
#quit;
#EOF
gzip All_Incidents$datestr.txt
echo "."| mail -s "PFA two months HPSM TT dump" -a /hpsm/hpsm/ops/reports/All_Incidents$datestr.txt.gz priyesh.a@du.ae
#/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\ITSD\"; lcd /hpsm/hpsm/ops/reports/; prompt; recurse; mput All_Incidents12016$datestr.txt.gz; exit;"
