cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/

echo "" >> REPORTFILE_AS_New
echo "<html><P><font color="blue">
Dear All,<br /><br />Please find below AS Customer Open Excluded TT report <B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br /><br /></P></html>" >> REPORTFILE_AS_New

echo "<TABLE border="1">" >> REPORTFILE_AS_New
echo "<TR><TH><font color="blue">Resolver Group</TH></font><TH><font color ="blue">(0-3) Hours</TH></font><TH><font color ="blue">(3-5) Hours</TH></font><TH><font color="blue">(5-7) Hours</TH></font><TH><font color ="blue">(7-9) Hours</TH></font><TH><font color ="blue">(9-11) Hours</TH></font><TH><font color ="blue">(12-14) Hours</TH></font><TH><font color="blue">>14 hours</TH></font><TH><font color="blue">Total</TH></TR>" >> REPORTFILE_AS_New

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> REPORTFILE_AS_New
set linesize 150;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td>'||b.Name||'</td><td align=center>'|| nvl(Zero_Three,0)||'</td><td align=center>'||nvl(Three_Five,0)||'</td><td align=center>'||nvl(Five_Seve
n,0)||'</td><td align=center>'||nvl(Seven_Nine,0)||'</td><td align=center>'||nvl(Nine_Eleven,0)||'</td><td align=center>'||nvl(Twl_Fort,0)||'</td><td align=c
enter>'|| nvl(Greater_Fort,0)||'</td><th>'||to_char( nvl(incidents,0))||'</th>'
 from
(select  Assignment, sum(Zero_Three) Zero_Three ,sum(Three_Five) Three_Five ,sum(Five_Seven) Five_Seven,
sum(Seven_Nine) Seven_Nine,sum(Nine_Eleven) Nine_Eleven,sum(Twl_Fort) Twl_Fort,sum(Greater_Fort) Greater_Fort,sum(incidents) incidents
  from (
  select
  Assignment
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24))*24, 0,1,1,1,2,1,0) Zero_Three
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24))*24, 3,1,4,1,0) Three_Five
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24))*24, 5,1,6,1,0) Five_Seven
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24))*24, 7,1,8,1,0) Seven_Nine
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24))*24, 9,1,10,1,11,1,0) Nine_Eleven
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24))*24, 12,1,13,1,14,1,0) Twl_Fort
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24))*24, 0,0,1,0,2,0,3,0,4,0,5,0,6,0,7,0,8,0,9,0,10,0,11,0,12,0,13,0,14,0,1) Greater_Fort
  , 1 Incidents
  from HPSM94BKPADMIN.Probsummarym1
 where PROBLEM_STATUS not in ('Resolved','Closed','Pending Input','Rejected to Business','Rejected') and folder in ('SIEBEL-CRM') 
and du_master_tt is NULL and ((subcategory='Excess Charges' and product_type  in ('Activation delay','Other','Long Session','Pro Rata Charge')) 
or (subcategory='Billing & Payment' and product_type='Final Bill') or 
(subcategory='Fixed Services' and product_type  in ('Final Bill','ATC','Bandwidth On Demand','Monthly charges dispute',
'Payment Dispute','Promo Dispute')) or (subcategory='Fixed Services' and product_type  like 'Ref%d-Service Fault/Goodwill') or 
(subcategory='MNP' and product_type  in ('Payment Dispute','Promo Dispute','Refund','Usage Dispute')) or
(subcategory='Mobile Prepaid' and product_type='Roaming Data Bundle') or 
(subcategory='Mobile Service' and product_type  in ('1233 Rewards/Free Units','1233 Rewards/No Response',
'1233 Rewards/Wrong Info','Business Rewards','CUG Charging Issue','Migration Adjustment','Monthly charges dispute',
'Payment Dispute','Promo Dispute','Refund - Goodwill','Refund- Roaming','Smartphone Rewards','Transfer Dispute','Usage Dispute','VAS Dispute')) or
(subcategory='Mobile Service - Payment' and product_type  in ('Cheque Dispute','Double Payment-Refund',
'Open Amount Mismatch','Paid- reflected','Payment Re-Allocation')))) group by Assignment) a right join
 (select distinct name from HPSM94BKPADMIN.AssignmentA1 where name in ('IT - Billing','IT - GIS','IT - ICS' ,'IT - OSS-OPS-Fixed Mediation'
,'IT - OSS-OPS-Mobile Mediation','IT - Payment Gateway',
  'IT - POS' ,'IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT',
'IT - OSS-OPS- HPSM','IT - OSS-OPS-Mobile Provisioning' ,'IT - OSS-OPS-Network Core Services' ,'IT - OSS-OPS-OAIM' ,'IT - CRM', 'Bill Shock',
'NOC - IN', 'IT SMS GW','Campaign Mgmt') ) b
on a.Assignment=b.Name order by B.Name;


exit;
EOF
