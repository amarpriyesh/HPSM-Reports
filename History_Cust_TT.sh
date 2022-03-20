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
spool history_cust_TT$datestr.txt
-------------------History extract------------------------------------

select 
'SysDate'
||'|'||'IncidentNo'
||'|'||'Category'
||'|'||'Area'
||'|'||'SubArea'
||'|'||'Priority'
||'|'||'ResolverGroup'
||'|'||'ResolvedBy'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'ActivityType'
||'|'||'UpdateTime'
||'|'||'CloseTime'
||'|'||'ResolutionCategory'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'Folder'
||'|'||'Customer Value'
||'|'||'Reopen COunt'
||'|'||'TTType'
||'|'||'Action'
from Dual
UNION ALL
select
trunc(sysdate-1)
||'|'||b."NUMBER"
||'|'||a.category
||'|'||a.subcategory
||'|'||a.product_type
||'|'||a.priority_code
||'|'||a.assignment
||'|'||a.resolved_by
||'|'||to_char(a.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||b.type
||'|'||to_char(b.datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.close_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||a.resolution_code
||'|'||a.resolution_type
||'|'||a.resolution_area
||'|'||a.folder
||'|'||a.du_cust_value
||'|'||a.du_reopencount
||'|'||a.du_tt_type
||'|'||replace(replace(DBMS_LOB.SUBSTR(description, 200,1),chr(10)),chr(13))
from probsummarym1 a, activitym1 b 
where  a."NUMBER" = b."NUMBER"  
and b.type in ('Open','ReAssigned','Assigned','Accepted','In Progress','Rejected',
'Rejected to Business','Resolved','Closed','Reopened','Pending Input','Auto Closure')
and a."NUMBER" in (select distinct
b."NUMBER"
from activitym1 b,probsummarym1 a where trunc(b.datestamp+4/24)=trunc(sysdate-1) and
b.type in ('Resolved','Rejected to Business') and folder ='SIEBEL-CRM' and 
((subcategory='Excess Charges' and product_type not in ('Activation delay','Other','Long Session','Pro Rata Charge')) 
or (subcategory='Billing "&" Payment' and product_type='Final Bill') or 
((subcategory='Fixed Services' and product_type not in ('Final Bill','ATC','Bandwidth On Demand','Monthly charges dispute',
'Payment Dispute','Promo Dispute')) and (subcategory='Fixed Services' and product_type not like 'Ref%d-Service Fault/Goodwill')) or 
(subcategory='MNP' and product_type not in ('Payment Dispute','Promo Dispute','Refund','Usage Dispute')) or
(subcategory='Mobile Prepaid' and product_type='Roaming Data Bundle') or 
(subcategory='Mobile Service' and product_type not in ('1233 Rewards/Free Units','1233 Rewards/No Response',
'1233 Rewards/Wrong Info','Business Rewards','CUG Charging Issue','Migration Adjustment','Monthly charges dispute',
'Payment Dispute','Promo Dispute','Refund - Goodwill','Refund- Roaming','Smartphone Rewards','Transfer Dispute','Usage Dispute','VAS Dispute')) or
(subcategory='Mobile Service - Payment' and product_type not in ('Cheque Dispute','Double Payment-Refund',
'Open Amount Mismatch','Paid-Not reflected','Payment Re-Allocation')) or ((category='Data Dispute (Billing)' and subcategory <>'Excess Charges') 
and (category='Dispute (Billing)' and subcategory not in ('Billing "&" Payment','Fixed Services','MNP','Mobile Prepaid','Mobile Service','Mobile Service - Payment')))
 or category not in ('Dispute (Billing)','Data Dispute (Billing)')) 
and (b.description LIKE '%IT - Billing to%' or b.description LIKE '%IT - GIS to%'
or b.description LIKE '%IT - ICS to%' or b.description LIKE '%IT - OSS-OPS-Fixed Mediation to%'
or b.description LIKE '%IT - OSS-OPS-Mobile Mediation to%' or b.description LIKE '%IT - Payment Gateway to%'
or b.description LIKE '%IT - POS to%' or b.description LIKE'%IT - Datawarehouse to%'
or b.description LIKE '%IT - ERP to%' or b.description LIKE '%IT - EAI to%'
or b.description LIKE '%IT - EBusiness to%' or b.description LIKE '%IT - OSS-OPS-Fault/Performance MGMT to%'
or b.description LIKE '%IT - OSS-OPS-Mobile Provisioning to%' or b.description LIKE'%IT - OSS-OPS-Network Core Services to%'
or b.description LIKE'%IT - OSS-OPS-OAIM to%' or b.description LIKE'%IT - CRM to%'
or b.description LIKE '%IT - OSS-OPS- HPSM to%' or b.description LIKE '%IT - OSS-OPS-Fixed Provisioning to%') and b."NUMBER"=a."NUMBER");
spool off;
quit;
EOF
/usr/sfw/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/reports/ ; prompt; recurse; mput history_cust_TT$datestr.txt; exit;"
