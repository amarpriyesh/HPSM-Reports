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
spool Retail_daily$datestr.csv
-------------------Retail details extract------------------------------------
select
'IncidentNo'
||','||'IncidentStatus'
||','||'Opened By'
||','||'IncidentCategory'
||','||'IncidentArea'
||','||'IncidentSubArea'
||','||'CurrentResolverGroup'
||','||'Priority'
||','||'OpenTime'
||','||'ResolvedTime'
||','||'Folder'
||','||'Title'
||','||'Description'
||','||'Is_SLA_Breach'
||','||'SLA_Start'
||','||'SLA_End'
from Dual
UNION ALL
select
"NUMBER"
||','||problem_status
||','||replace(opened_by,',',' ')
||','||category
||','||subcategory
||','||product_type
||','||assignment
||','||priority_code
||','||to_char(open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(RESOLVED_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||folder
||','||replace(replace(replace(DBMS_LOB.SUBSTR(brief_description, 2000,1),chr(10)),chr(13)),',',' ')
||','||replace(replace(replace(DBMS_LOB.SUBSTR(action, 2000,1),chr(10)),chr(13)),',',' ')
||','||sla_breach
||','||to_char(du_sla_start+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(du_sla_end+4/24,'mm/dd/yyyy HH24:MI:SS')
from probsummarym1 where assignment='IT Retail Business Application Support' and trunc(open_time+4/24) >= trunc(sysdate-1);
spool off;
quit;
EOF
echo "."| mail -v -s "IT Retail TT details for `date`" -a /hpsm/hpsm/ops/reports/Retail_daily$datestr.csv utkarsh.jauhari@du.ae,Shadi.Trad@du.ae,Ali.Alkhatib@du.ae,Yasser.Fouad@du.ae

