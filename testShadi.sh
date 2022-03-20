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
spool HPSMIncidentsRFO1$datestr.xls
-------------------SIEBEL HPSM Incident extract------------------------------------
select 
'NUMBER'
||'|'||'OPENED_BY'
||'|'||'OPEN_TIME'
||'|'||'RESOLVED_TIME'
||'|'||'PRIORITY_CODE'
||'|'||'ASSIGNMENT'
||'|'||'ASSIGNEE_NAME'
||'|'||'SYSAPPLICATION'
||'|'||'RFO_SERVICES'
||'|'||'INCI_START'
||'|'||'INCI_END'
||'|'||'INCI_DURATION'
||'|'||'IMPACT_TYPE'
||'|'||'IMPACT_SEVERITY'
||'|'||'STAFF_INVOLVED'
||'|'||'ROOT_CAUSE'
||'|'||'RFO_RESOLUTION'
||'|'||'RFO_ACTION'
||'|'||'IS_RFO'
||'|'||'brief_description'
from Dual
UNION ALL
select 
b."NUMBER" 
||'|'||b.OPENED_BY
||'|'||to_char(b.OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(b.resolved_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(b.PRIORITY_CODE)
||'|'||to_char(b.ASSIGNMENT)
||'|'||to_char(b.ASSIGNEE_NAME)
||'|'||to_char(b.SYSAPPLICATION)
||'|'||to_char(b.RFO_SERVICES)
||'|'||to_char(b.INCI_START+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(b.INCI_END+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(b.INCI_DURATION+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(b.IMPACT_TYPE)
||'|'||to_char(b.IMPACT_SEVERITY)
||'|'||to_char(b.STAFF_INVOLVED)
||'|'||to_char(b.ROOT_CAUSE)
||'|'||to_char(b.RFO_RESOLUTION)
||'|'||to_char(b.RFO_ACTION)
||'|'||to_char(b.IS_RFO)
||'|'||replace(replace(DBMS_LOB.SUBSTR(a.brief_description, 200,1),chr(10)),chr(13))
from HPSM94BKPADMIN.INCIDENTS_OUTAGES b left join probsummarym1 a on b."NUMBER"=a."NUMBER" where b.OPEN_TIME >= '1-Dec-2018' and b.OPEN_TIME <'31-Dec-2018';
spool off;
quit;
EOF
sed -i $'s/\t/ /g' HPSMIncidentsRFO1$datestr.xls
gzip HPSMIncidentsRFO1$datestr.xls

/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\Service Operations\"; lcd /hpsm/hpsm/ops/reports; prompt; recurse; mput HPSMIncidentsRFO1$datestr.xls.gz; exit;"
 
 
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
spool HPSMIncidentsITSD1$datestr.xls
-------------------SIEBEL HPSM Incident extract------------------------------------
select
'IncidentNo'
||'|'||'IncidentStatus'
||'|'||'Opened_By'
||'|'||'Assignee_Name'
||'|'||'IncidentCategory'
||'|'||'IncidentArea'
||'|'||'IncidentSubArea'
||'|'||'priority'
||'|'||'CurrentResolverGroup'
||'|'||'CustomerValue'
||'|'||'AssigneeName'
||'|'||'ResolutionCode'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'OpenTime'
||'|'||'ClosedTime'
||'|'||'ResolvedTime'
||'|'||'Type'
||'|'||'ClosedBy'
||'|'||'ResolvedBy'
||'|'||'ReassignmentCount'
||'|'||'ReopenCount'
||'|'||'SLA-START'
||'|'||'SLA-REMAINING'
||'|'||'TT_TYPE'
||'|'||'description'
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
||'|'||du_cust_value
||'|'||assignee_name
||'|'||resolution_code
||'|'||resolution_type
||'|'||resolution_area
||'|'||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(close_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(Resolved_Time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||folder
||'|'||Closed_By
||'|'||Resolved_By
||'|'||Count
||'|'||du_reopencount
||'|'||to_char(DU_SLA_START+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||SLA_REMAINING
||'|'||du_tt_type
||'|'||replace(replace(DBMS_LOB.SUBSTR(brief_description, 200,1),chr(10)),chr(13))
from
probsummarym1 A
where OPEN_TIME >= '1-Dec-2018' and OPEN_TIME <'31-Dec-2018' and folder= 'ITSD';
spool off;
quit;
EOF
sed -i $'s/\t/ /g' HPSMIncidentsITSD1$datestr.xls
gzip HPSMIncidentsITSD1$datestr.xls
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\Service Operations\"; lcd /hpsm/hpsm/ops/reports; prompt; recurse; mput HPSMIncidentsITSD1$datestr.xls.gz; exit;"

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
spool HPSMIncidentsSIEBEL1$datestr.xls
-------------------SIEBEL HPSM Incident extract------------------------------------
select
'IncidentNo'
||'|'||'IncidentStatus'
||'|'||'Opened_By'
||'|'||'Assignee_Name'
||'|'||'IncidentCategory'
||'|'||'IncidentArea'
||'|'||'IncidentSubArea'
||'|'||'priority'
||'|'||'CurrentResolverGroup'
||'|'||'CustomerValue'
||'|'||'AssigneeName'
||'|'||'ResolutionCode'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'OpenTime'
||'|'||'ClosedTime'
||'|'||'ResolvedTime'
||'|'||'Type'
||'|'||'ClosedBy'
||'|'||'ResolvedBy'
||'|'||'ReassignmentCount'
||'|'||'ReopenCount'
||'|'||'SLA-START'
||'|'||'SLA-REMAINING'
||'|'||'TT_TYPE'
||'|'||'brief_description'
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
||'|'||du_cust_value
||'|'||assignee_name
||'|'||resolution_code
||'|'||resolution_type
||'|'||resolution_area
||'|'||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(close_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(Resolved_Time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||folder
||'|'||Closed_By
||'|'||Resolved_By
||'|'||Count
||'|'||du_reopencount
||'|'||to_char(DU_SLA_START+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||SLA_REMAINING
||'|'||du_tt_type
||'|'||replace(replace(DBMS_LOB.SUBSTR(brief_description, 200,1),chr(10)),chr(13))
from
probsummarym1 A
where OPEN_TIME >= '1-Dec-18' and OPEN_TIME < '31-Dec-2018' and folder='SIEBEL-CRM' ;
spool off;
quit;
EOF
sed -i $'s/\t/ /g' HPSMIncidentsSIEBEL1$datestr.xls
gzip HPSMIncidentsSIEBEL1$datestr.xls
echo "Incident Reports and RFO "| mail -s "Incidents Report and RFO" -a HPSMIncidentsRFO1$datestr.xls.gz -a HPSMIncidentsITSD1$datestr.xls.gz -a HPSMIncidentsSIEBEL1$datestr.xls.gz gsHPSM@du.ae,Anima.Ankur@du.ae
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\"; lcd /hpsm/hpsm/ops/reports; prompt; recurse; mput HPSMIncidentsSIEBEL1$datestr.xls.gz; exit;"
