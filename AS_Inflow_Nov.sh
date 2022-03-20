cd
. ./.bash_profile
cd /hpsm/hpsm/ops/
datestr=`date "+%d%m%y%H%M"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
set define off
spool AS_Inflow_Nov2015.txt
-------------------Inflow Incident extract------------------------------------



select
'Incident No'
||'|'||'Open Time'
||'|'||'Datestamp Time'
||'|'||'Inflow Time'
||'|'||'Priority'
||'|'||'Category'
||'|'||'Subcategory'
||'|'||'Product Type'
||'|'||'Type'
||'|'||'Customer Value'
||'|'||'Folder'
||'|'||'Status'
||'|'||'Description'
from Dual
UNION ALL
select b."NUMBER"
||'|'||to_char(b.open_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.datestamp+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||decode(a.type,'Accepted',to_char(b.open_time+4/24, 'mm/dd/yyyy HH24:MI:SS'),to_char(a.datestamp+4/24, 'mm/dd/yyyy HH24:MI:SS'))
||'|'||b.priority_code
||'|'||category
||'|'||subcategory
||'|'||product_type
||'|'||a.type
||'|'||b.du_cust_value
||'|'||b.folder
||'|'||b.problem_status
||'|'||replace(replace(DBMS_LOB.SUBSTR(a.description, 100,1),chr(10)),chr(13))
from activitym1 a, probsummarym1 b where a."NUMBER"=b."NUMBER" and 
(
(a.type in ('ReAssigned', 'Rejected', 'Reopened') and (a.description LIKE '% to IT - Billing |%' or a.description LIKE '% to IT - GIS |%' 
or a.description LIKE '%to IT - ICS |%' or  a.description LIKE '%to IT - OSS-OPS-Fixed Mediation |%'
or  a.description LIKE '%to IT - OSS-OPS-Mobile Mediation |%'
or a.description LIKE '%to IT - Payment Gateway |%' or a.description LIKE '%to IT - POS |%' or a.description LIKE '%to IT - Datawarehouse |%' or 
a.description LIKE '%to IT - ERP |%' or a.description LIKE '%to IT - EAI |%' or  a.description LIKE '%to IT - EBusiness |%' or 
a.description LIKE '%to IT - OSS-OPS-Fault/Performance MGMT |%' or a.description LIKE '%to IT - OSS-OPS-Mobile Provisioning |%' or 
a.description LIKE '%to IT - OSS-OPS-Network Core Services |%' or a.description LIKE '%to IT - OSS-OPS-OAIM |%' or a.description LIKE '%to IT - CRM |%' 
or  a.description LIKE '%to IT - OSS-OPS- HPSM |%' or  a.description LIKE '%to IT - OSS-OPS-Fixed Provisioning |%') and 
(a.datestamp+4/24 >= to_date('01/11/2015 00:00:00','dd/mm/yyyy hh24:mi:ss') 
and a.datestamp+4/24 < to_date('01/12/2015 00:00:00','dd/mm/yyyy hh24:mi:ss'))
)
or
((b.assignment='IT - Billing' or b.assignment='IT - GIS' or b.assignment='IT - ICS' or b.assignment='IT - OSS-OPS-Fixed Mediation' or 
b.assignment='IT - OSS-OPS-Mobile Mediation' or b.assignment='IT - Payment Gateway'or b.assignment='IT - POS' or b.assignment='IT - Datawarehouse' or 
b.assignment='IT - ERP' or b.assignment='IT - EAI' or b.assignment='IT - EBusiness' or b.assignment='IT - OSS-OPS-Fault/Performance MGMT' or 
b.assignment='IT - OSS-OPS-Mobile Provisioning' or b.assignment='IT - OSS-OPS-Network Core Services' or b.assignment='IT - OSS-OPS-OAIM' or 
b.assignment='IT - CRM' or b.assignment='IT - OSS-OPS- HPSM' or b.assignment='IT - OSS-OPS-Fixed Provisioning')  and 
(b.open_time+4/24 >= to_date('01/11/2015 00:00:00','dd/mm/yyyy hh24:mi:ss') and 
b.open_time+4/24 < to_date('01/12/2015 00:00:00','dd/mm/yyyy hh24:mi:ss'))
 and b.problem_status='Open' )
or
(a.type = 'Accepted' and 
(b.open_time+4/24 >= to_date('01/11/2015 00:00:00','dd/mm/yyyy hh24:mi:ss') and 
b.open_time+4/24 < to_date('01/12/2015 00:00:00','dd/mm/yyyy hh24:mi:ss'))
and
(a.description LIKE '%to IT - Billing | Open to Accepted%' or a.description LIKE '%to IT - GIS | Open to Accepted%' 
or a.description LIKE '%to IT - ICS | Open to Accepted%'or  a.description LIKE '%to IT - OSS-OPS-Fixed Mediation | Open to Accepted%'
or  a.description LIKE '%to IT - OSS-OPS-Mobile Mediation | Open to Accepted%' or a.description LIKE '%to IT - Payment Gateway | Open to Accepted%' 
or a.description LIKE '%to IT - POS | Open to Accepted%' 
or a.description LIKE '%to IT - Datawarehouse | Open to Accepted%' or  a.description LIKE '%to IT - ERP | Open to Accepted%'
or a.description LIKE '%to IT - EAI | Open to Accepted%' or  a.description LIKE '%to IT - EBusiness | Open to Accepted%'
or a.description LIKE '%to IT - OSS-OPS-Fault/Performance MGMT | Open to Accepted%' 
or a.description LIKE '%to IT - OSS-OPS-Mobile Provisioning | Open to Accepted%'
or a.description LIKE '%to IT - OSS-OPS-Network Core Services | Open to Accepted%'
or a.description LIKE '%to IT - OSS-OPS-OAIM | Open to Accepted%' or a.description LIKE '%to IT - CRM | Open to Accepted%' 
or  a.description LIKE '%to IT - OSS-OPS- HPSM | Open to Accepted%' or  a.description LIKE '%to IT - OSS-OPS-Fixed Provisioning | Open to Accepted%')
)
)
and b.du_master_tt is NULL;


spool off;
quit;
EOF
#FMSIncident_TTs.sh FMSIncident_ResolvedMar15
echo "."| mail -v -s "Inflow report for `date`" -a /hpsm/hpsm/ops/AS_Inflow_Nov2015.txt mohammed.rezwanali@du.ae,nihalchand.dehury@du.ae
