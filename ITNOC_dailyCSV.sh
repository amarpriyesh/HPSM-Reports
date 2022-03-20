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
spool ITNOC_daily$datestr.csv
-------------------IT NOC TT details extract------------------------------------
select
'IncidentNo'
||','||'IncidentStatus'
||','||'Opened By'
||','||'Element Type'
||','||'IncidentCategory'
||','||'IncidentArea'
||','||'IncidentSubArea'
||','||'CurrentResolverGroup'
||','||'Priority'
||','||'OpenTime'
||','||'ResolvedTime'
||','||'Folder'
||','||'TT type'
||','||'Alert type'
||','||'Incident type'
||','||'Escalation type'
||','||'Fault Start'
||','||'SLA End'
||','||'Title'
||','||'Description'
from Dual
UNION ALL
select
"NUMBER"
||','||problem_status
||','||replace(opened_by,',',' ')
||','||du_element
||','||category
||','||subcategory
||','||product_type
||','||assignment
||','||priority_code
||','||to_char(open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(RESOLVED_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||folder
||','||du_tt_type
||','||alert_type
||','||incident_type
||','||escalation_type
||','||to_char(fault_start+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(du_sla_end+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||replace(replace(replace(DBMS_LOB.SUBSTR(brief_description, 2000,1),chr(10)),chr(13)),',',' ')
||','||replace(replace(replace(DBMS_LOB.SUBSTR(action, 2000,1),chr(10)),chr(13)),',',' ')
from probsummarym1 where (opened_by in (select a.name from operatorm1 a,assignmenta1 b where a.name=b.operators and b.name ='IT - NOC') or
opened_by in (select a.contact_name from operatorm1 a,assignmenta1 b where a.name=b.operators and b.name ='IT - NOC'))
and trunc(open_time+4/24) = trunc(sysdate-1);
spool off;
quit;
EOF
/usr/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/reports/ ; prompt; recurse; mput ITNOC_daily$datestr.csv; exit;"
echo "."| mail -v -s "IT NOC TT details in CSV for `date`" -a /hpsm/hpsm/ops/reports/ITNOC_daily$datestr.csv IT.DCO@du.ae,utkarsh.jauhari@du.ae,ITNOC@du.ae,Vino.John@du.ae

#( echo "Please find the attached IT NOC TT details"; uuencode ITNOC_daily$datestr.txt ITNOC_daily$datestr.txt)| mailx -s "IT NOC TT details 
for `date`" "IT.DCO@du.ae,utkarsh.jauhari@du.ae,ITNOC@du.ae"
