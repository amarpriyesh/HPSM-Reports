cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/
USER=nrs
PASS=nrs123
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
||'|'||to_char(NVL((decode(problem_status,'Resolved',(select min(C.datestamp)+4/24 from 
activitym1 C where C."NUMBER" = A."NUMBER" and C.type = 'Resolved'),'Closed',
(select min(C.datestamp)+4/24 from activitym1 C where C."NUMBER" = A."NUMBER" and C.type = 'Resolved'),NULL
)),resolved_time+4/24),'mm/dd/yyyy HH24:MI:SS')
||'|'||folder
from
probsummarym1 A
where a.problem_status<>'Resolved' and a.problem_status<>'Closed' 
and open_time > to_date('01/01/2011 00:00:00','dd/mm/yyyy hh24:mi:ss');
spool off;
quit;
EOF
cp /hpsm/hpsm/ops/All_Incidents$datestr.txt /hpsm/hpsm/ops/Billshock_All_Incidents$datestr.txt
/usr/sfw/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/ ; prompt; recurse; mput All_Incidents$datestr.txt; exit;"

###FTP to Billing server for BSCS Dashboard Requirement#####
cd /hpsm/hpsm/ops/
ftp -n 172.21.27.13 <<EOF
user $USER $PASS
cd JBOSS/java_soft/BSCSTool_InputFiles/HPSMReports/
put All_Incidents$datestr.txt
#put Billshock_All_Incidents$datestr.txt
bye
EOF

gzip All_Incidents$datestr.txt
echo "."| mail -v -s "All Incidents Report for `date`" -a /hpsm/hpsm/ops/reports/All_Incidents$datestr.txt.gz mohammed.rezwanali@du.ae,Sriram.Choragudi@du.ae,Saravanan.Duraisamy@du.ae,Gopalakrishna.a@du.ae,Ramu.Yerra@du.ae,Balaji.jenjeti@du.ae,Nagendra.Kumar@du.ae,Srividya.Vish@du.ae,Sai.Narender@du.ae,ravikanth.ghanta@du.ae,Leela.Vishnumolakala@du.ae,Imran.M@du.ae
#( echo "Please find attached the All Open Incidents report"; uuencode All_Incidents$datestr.txt.gz All_Incidents$datestr.txt.gz)| mailx -s "All Incidents Report for `date`" "Sriram.Choragudi@du.ae,Saravanan.Duraisamy@du.ae,Gopalakrishna.a@du.ae,Ramu.Yerra@du.ae,Balaji.jenjeti@du.ae,Nagendra.Kumar@du.ae,Srividya.Vish@du.ae,Sai.Narender@du.ae,ravikanth.ghanta@du.ae,Leela.Vishnumolakala@du.ae,Imran.M@du.ae"
