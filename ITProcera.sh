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
spool ITProcera$datestr.xls
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
||'|'||to_char(NVL((decode(problem_status,'Resolved',(select min(C.datestamp)+4/24 from 
activitym1 C where C."NUMBER" = A."NUMBER" and C.type = 'Resolved'),'Closed',
(select min(C.datestamp)+4/24 from activitym1 C where C."NUMBER" = A."NUMBER" and C.type = 'Resolved'),NULL
)),resolved_time+4/24),'mm/dd/yyyy HH24:MI:SS')
||'|'||folder
from
probsummarym1 A
where assignment in ('Intelligent Traffic Analysis - VOIP','Intelligent Traffic - Procera');
spool off;
quit;
EOF
gzip ITProcera$datestr.xls
echo -e " Dear All,\n\n PFA for Intelligent Traffic Report. \n\n Regards \n HPSM Team"| mail -v -s "Intelligent Traffic  Report for `date`" -a /hpsm/hpsm/ops/reports/ITProcera$datestr.xls.gz priyesh.a@du.ae,ankur.saxena@du.ae,Yasser.Fouad@du.ae
#( echo "Please find attached the All Open Incidents report"; uuencode All_Incidents$datestr.txt.gz All_Incidents$datestr.txt.gz)| mailx -s "All Incidents Report for `date`" "Sriram.Choragudi@du.ae,Saravanan.Duraisamy@du.ae,Gopalakrishna.a@du.ae,Ramu.Yerra@du.ae,Balaji.jenjeti@du.ae,Nagendra.Kumar@du.ae,Srividya.Vish@du.ae,Sai.Narender@du.ae,ravikanth.ghanta@du.ae,Leela.Vishnumolakala@du.ae,Imran.M@du.ae"
