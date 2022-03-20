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
spool history_openTTs$datestr.txt
-------------------History extract------------------------------------
select
'SysDate'
||'|'||'IncidentNo'
||'|'||'Category'
||'|'||'Area'
||'|'||'SubArea'
||'|'||'Customer Accountnumber'
||'|'||'Contrtact ID'
||'|'||'Asset number'
||'|'||'Reopen Count'
||'|'||'du_master_tt'
||'|'||'Priority'
||'|'||'ResolverGroup'
||'|'||'Assignee'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'ActivityType'
||'|'||'UpdateTime'
||'|'||'CloseTime'
||'|'||'Folder'
||'|'||'TT Type'
||'|'||'Action'
from Dual
UNION ALL
select
trunc(sysdate)
||'|'||b."NUMBER"
||'|'||a.category
||'|'||a.subcategory
||'|'||a.product_type
||'|'||a.du_cust_accnumber
||'|'||a.du_contract_id
||'|'||a.du_asset_number
||'|'||a.DU_REOPENCOUNT
||'|'||a.du_master_tt
||'|'||a.priority_code
||'|'||a.assignment
||'|'||a.assignee_name
||'|'||to_char(a.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||b.type
||'|'||to_char(b.datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.close_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||a.folder
||'|'||a.du_tt_type
||'|'||replace(replace(DBMS_LOB.SUBSTR(description, 200,1),chr(10)),chr(13))
from probsummarym1 a, activitym1 b where a."NUMBER"=b."NUMBER" and 
a.problem_status not in ('Resolved','Closed') and b.type in ('Open','ReAssigned','Assigned','Accepted','In Progress','Rejected',
'Rejected to Business','Resolved','Reopened','Pending Input');
spool off;
quit;
EOF
#gzip history_openTTs$datestr.txt
#(echo "Please find attached the Open TTs History report"; uuencode history_openTTs$datestr.txt.gz history_openTTs$datestr.txt.gz)|mailx -s "HPSM Open TTs History Report for `date`" "Sriram.Choragudi@du.ae"
/usr/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/reports/ ; prompt; recurse; mput history_openTTs$datestr.txt; exit;"
