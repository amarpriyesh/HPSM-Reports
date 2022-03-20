. ./.bash_profile
cd /hpsm/hpsm/ops/reports/
datestr=`date "+%d%m%y%H%M"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
set define off
spool all_open_tt4.csv
-------------------All Open TT Incident extract------------------------------------
Select
'IncidentNo'
||','||'IncidentStatus'
||','||'priority'
||','||'CurrentResolverGroup'
||','||'AssigneeName'
||','||'OpenTime'
||','||'Category'
||','||'Area'
||','||'SubArea'
||','||'Customer Accountnumber'
||','||'Customer Value'
||','||'Contrtact ID'
||','||'Asset number'
||','||'Current Age of TT (No.of days)'
||','||'Assigned Time'
||','||'Reopen Count'
||','||'Folder'
from Dual
union ALL
select
"NUMBER"
||','||problem_status
||','||priority_code
||','||assignment
||','||assignee_name
||','||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||category
||','||subcategory
||','||product_type
||','||du_cust_accnumber
||','||du_cust_value
||','||du_contract_id
||','||du_asset_number
||','||(to_date(trunc(sysdate),' dd-mon-yyyy HH24:MI SS')-TO_DATE(open_time+4/24,'DD-MON-YYYY HH24:MI'))
||','||(select max(to_char(datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')) from activitym1 where "NUMBER"=a."NUMBER" and (type='ReAssigned' or type='Reopened'or type='Open'))
||','||DU_REOPENCOUNT
||','||folder
from
HPSM94BKPADMIN.probsummarym1 a
where a.problem_status in('Open','Accepted','In Progress','Pending Input','Rejected','ReAssigned','Reopened') and a.du_master_tt is NULL and a.Assignment in ('IT - Billing','NOC - IN','Bill Shock','Core - Mobile IN','IT-SQL DBA','IT - GIS','IT - ICS','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT - Payment Gateway','IT - POS' ,'IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT','IT - OSS-OPS-Mobile Provisioning','IT - OSS-OPS-Network Core Services' ,'IT - OSS-OPS-OAIM' ,'IT - CRM','IT - OSS-OPS- HPSM','IT - Backup Admin','IT Enterprise Services & Support','IT - System Admin UNIX','IT - Database Admin','IT - System Admin WINDOWS','IT - Enterprise Systems (HMC)','IT - SAN Admin','IT - Retail Technical Support','IT - TSD IT','IT - NOC','IT - EDMS','IT - Corporate Technical Support','IT - Mission Critical Enterprise Systems & Service','IT - Desktop & System Support','IT - Citrix Support','IT - Security','IT - Sharepoint','IT - IP TV','IT - Roadshow Technical Support');
spool off;
quit;
EOF

echo "."| mail -v -s "Pending TTs for `date`" -a /hpsm/hpsm/ops/reports/all_open_tt4.csv utkarsh.jauhari@du.ae


