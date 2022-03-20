cd
. .profile
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
spool ITSD_last3months$datestr.txt
-------------------ITSD Incident extract------------------------------------
select
'RelatedIncident'
||'|'||'Interaction'
||'|'||'Folder'
||'|'||'Priority'
||'|'||'ResolverGroup'
||'|'||'Assigneename'
||'|'||'Status'
||'|'||'Source'
||'|'||'Interaction Owner'
||'|'||'Resolved By'
||'|'||'InteractionCategory'
||'|'||'InteractionArea'
||'|'||'InteractionSubArea'
||'|'||'Category'
||'|'||'Area'
||'|'||'SubArea'
||'|'||'DU_MASTERTTSTATUS'
||'|'||'OpenTime'
||'|'||'DU_SLA_END'
||'|'||'SLA Expiration'
||'|'||'Resolved_time'
||'|'||'Close_time'
||'|'||'Resolve ageing '
||'|'||'Close ageing '
||'|'||'firstResol'
||'|'||'Description'
from Dual
UNION ALL
select
distinct
B.source
||'|'||B.depend
||'|'||C.folder
||'|'||C.priority_code
||'|'||C.assignment
||'|'||C.assignee_name
||'|'||C.problem_status
||'|'||a.callback_type
||'|'||a.DU_INTERACTION_OWNER
||'|'||c.RESOLVED_BY
||'|'||a.category
||'|'||a.subcategory
||'|'||a.product_type
||'|'||C.category
||'|'||C.subcategory
||'|'||C.product_type
||'|'||C.DU_MASTERTTSTATUS
||'|'||to_char(C.open_time+4/24, 'mm-dd-yyyy HH24:MI:SS')
||'|'||to_char(C.DU_SLA_END+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(C.SLA_Expire+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(C.resolved_time+4/24, 'mm-dd-yyyy HH24:MI:SS')
||'|'||to_char(C.close_time+4/24, 'mm-dd-yyyy HH24:MI:SS')
||'|'|| ( case when c.resolved_time is not null then round ((sysdate-(c.resolved_time+4/24))*24)   else 0 end ) 
||'|'|| ( case when c.close_time is not null then round ((sysdate-(c.close_time+4/24))*24)   else 0  end  )
||'|'||(select case  when count(*) > 1 then 'false' when count(*) = 1   then 'true' else 'NA' end  from activitym1 where "NUMBER"=c."NUMBER"  and type='Resolved' )
||'|'||replace(replace(DBMS_LOB.SUBSTR(C.brief_description,100,1),chr(10)),chr(13))
from incidentsm1 A right join  screlationm1 B on (A.incident_id=B.depend)inner join  probsummarym1 C on  ( B.source=C."NUMBER" ) where  A.open_time+4/24 >='01-Apr-2018';
spool off;
quit;
EOF
gzip ITSD_last3months$datestr.txt
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\ITSD\"; lcd /hpsm/hpsm/ops/reports/; prompt; recurse; mput ITSD_last3months$datestr.txt.gz; exit;"
echo "." | mail -s "tt data" -a /hpsm/hpsm/ops/reports/ITSD_last3months$datestr.txt.gz priyesh.a@du.ae,ankur.saxena@du.ae
#( echo "Please find attached the ITSD Incidents report"; uuencode ITSDIncident_New$datestr.txt.gz ITSDIncident_New$datestr.txt.gz)| mailx -s "ITSD Incidents Report for `date`" "Yasser.Fouad@du.ae,Ali.Alkhatib@du.ae,Waleed.Ibrahim@du.ae,Hesham.Saidah@du.ae" 
