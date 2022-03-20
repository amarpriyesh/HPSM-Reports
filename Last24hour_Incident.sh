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
spool Last24Hour_Incident$datestr.txt
-------------------Last24Hour Incident extract------------------------------------

select
'IncidentNo'
||'|'||'IncidentCreatedat'
||'|'||'CloseTime'
||'|'||'ResolveTime'
||'|'||'Status'
||'|'||'OpenedBy'
||'|'||'AssigneeName'
||'|'||'Category'
||'|'||'Area'
||'|'||'SubArea'
||'|'||'AssignmentGroup'
||'|'||'Priority'
||'|'||'SLA'
||'|'||'SLAStatus'
from Dual
UNION ALL
select a."NUMBER"|| '|' ||to_char(a.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')||'|'||to_char(a.close_time+4/24,'mm/dd/yyyy HH24:MI:SS')||'|'||to_char(a.resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS')|| '|' ||a.problem_status|| '|' ||a.opened_by|| '|' ||a.assignee_name|| '|' ||a.category|| '|' ||a.subcategory|| '|' ||
a.product_type|| '|' ||a.assignment|| '|' ||a.priority_code|| '|' ||b.slo_name|| '|' ||
decode(b.current_status,1,'Breached',2,'Running',3,'Suspended',4,'Achived',5,'Inactive','Others') from probsummarym1 a,SLORESPONSEM1 b 
where a."NUMBER"=b.foreign_key and a.open_time<sysdate and a.open_time>sysdate-1;
spool off;
quit;
EOF
gzip Last24Hour_Incident$datestr.txt
echo "."| mail -v -s "Last24Hour Incidents Report for `date`" -a /hpsm/hpsm/ops/reports/Last24Hour_Incident$datestr.txt.gz Ramu.Yerra@du.ae,Balaji.jenjeti@du.ae,Nagendra.Kumar@du.ae,CustomerCareReportingTeam@du.ae
#( echo "Please find attached the Last24Hour Incidents report"; uuencode Last24Hour_Incident$datestr.txt.gz Last24Hour_Incident$datestr.txt.gz)| mailx -s "Last24Hour Incidents Report for `date`" "Ramu.Yerra@du.ae,Balaji.jenjeti@du.ae,Nagendra.Kumar@du.ae,CustomerCareReportingTeam@du.ae"
