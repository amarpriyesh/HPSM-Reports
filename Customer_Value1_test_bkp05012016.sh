cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/

REPORTFILE_AS_New=AS_report_New

recipient="ankur.saxena@du.ae,rajubhai.patel@du.ae,gaurav.gupta@du.ae,tulika.ranjan@du.ae,ramdas.pawar@du.ae,tanay.pandey@du.ae,anuj.tyagi@du.ae,nihalchand.dehury@du.ae,mohammed.rezwanali@du.ae,Adinarayana.Usurupat@du.ae,Ramanjaneyulu.C@du.ae,Apoorva.Kunapareddy@du.ae,Nirmala.Pydala@du.ae,Sindhura@du.ae,Bismita.Nayak@du.ae,Jyothy.ch@du.ae,Pushpa.Adusumalli@du.ae,Anuj.Rastogi@du.ae,Nikky.Priya@du.ae,JyothiSaroja.Daggu@du.ae,Phanindra.Boddu@du.ae,Ashfaque.Mohammad@du.ae,Phani.Divya@du.ae,Shiva.Lagishetty@du.ae,Ramyakrishna.Gandi@du.ae,Anandkumar.Pacha @du.ae,Venugopal.Bogineni@du.ae,Saikrishna.JV@du.ae,Meher.Nikita@du.ae,BalaKrishna.N@du.ae,Kanakadurga.D@du.ae,Jangiti.Jyothy@du.ae,Leela.Vishnumolakala@du.ae,Mounika.Chalasani@du.ae,Neelima.V@du.ae,Nitesh.Kumar@du.ae,Swati.Samaiya@du.ae,Nagasiva.Krishna@du.ae,ITBillingTTSupport@du.ae,Lokesh.Ongolu@du.ae,Akhila.C@du.ae,Radhika.Varakavi@du.ae,Vinay.Bussa@du.ae,Radhika.Khaitan@du.ae,SivaChaitanya.Kalavala@du.ae,Farookh.Laddaf@du.ae,Kiranmai.Bondili@du.ae,Kshirodarnba.Sahu@du.ae,Sirisha.Pinnamsetty@du.ae,Gouthami.K@du.ae,Chinmay.Pattanaik@du.ae,M.Ravindra@du.ae,Chandramouli.Kemburu@du.ae,Leelavathi.Gandholi@du.ae,Sridhar.SIRIGIRI@du.ae,Divya.Ganji@du.ae"

#recipient="mohammed.rezwanali@du.ae,nihalchand.dehury@du.ae"

recipient1="Raghu.Nandan@du.ae,Neelima.V@du.ae,Nagendra.Kumar@du.ae,Srinivas.Sabbella@du.ae,LaxmaReddy.Kompally@du.ae"
#recipient1="mohammed.rezwanali@du.ae"
MailSubject="All Open Platinum / Diamond Customer TT Report  @ `date \"+%d/%m/%Y %H:%M\"`"

OUTPUTFLAG=HTML

rm AS_report_New

echo "Subject: $MailSubject
To: $recipient
Cc: $recipient1
MIMEV=\"MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw" 
Content-Disposition: inline
" >> $REPORTFILE_AS_New

echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_AS_New
echo "Content-Type: text/html" >> $REPORTFILE_AS_New
echo "Content-Disposition: inline" >> $REPORTFILE_AS_New

echo "" >> $REPORTFILE_AS_New
echo "<html><P><font color="blue">
Dear All,<br /><br />All Open Platinum / Diamond Customer TT Report<B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br /><br /></P></html>" >> $REPORTFILE_AS_New

echo "<TABLE border="1">" >> $REPORTFILE_AS_New
echo "<TR><TH><font color="blue">Resolver Group</TH></font><TH><font color ="blue">(0-2) Hours</TH></font><TH><font color ="blue">(2-3) Hours</TH></font>
<TH><font color="blue">(4) Hours</TH></font><TH><font color ="blue">(5) Hours</TH></font><TH><font color ="blue">(6) Hours</TH></font>
<TH><font color="blue">>6 hours</TH></font><TH><font color="blue">Total</TH></TR>" >> $REPORTFILE_AS_New

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_AS_New
set linesize 150;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td>'||b.Name||'</td><td align=center>'|| nvl(Zero_Two,0)||'</td><td align=center>'||nvl(Two_Three,0)||'</td>
<td align=center>'||nvl(Four,0)||'</td><td align=center>'||nvl(Five,0)||'</td><td align=center>'||nvl(Six,0)||'</td>
<td align=center>'|| nvl(greater_Six,0)||'</td><th>'||to_char( nvl(incidents,0))||'</th>'
 From
(select  Assignment, sum(Zero_Two) Zero_Two ,sum(Two_Three) Two_Three ,sum(Four) Four,sum(Five) Five,sum(Six) Six,sum(Greater_Six) Greater_Six,sum(incidents) incidents
  from (
  select
  Assignment
  ,decode (round(((sysdate-(open_time+4/24)))*24), 0,1,1,1,0) Zero_Two
  ,decode (round(((sysdate-(open_time+4/24)))*24), 2,1,3,1,0) Two_Three
  ,decode (round(((sysdate-(open_time+4/24)))*24), 4,1,0) Four
  ,decode (round(((sysdate-(open_time+4/24)))*24), 5,1,0) Five
  ,decode (round(((sysdate-(open_time+4/24)))*24), 6,1,0) Six
  ,decode (round(((sysdate-(open_time+4/24)))*24), 0,0,1,0,2,0,3,0,4,0,5,0,6,0,1) Greater_Six
  , 1 Incidents
  from HPSM94BKPADMIN.Probsummarym1
 where PROBLEM_STATUS not in ('Resolved','Closed','Pending Input','Rejected to Business','Rejected') and folder in ('SIEBEL-CRM') 
and du_master_tt is NULL and du_cust_value in('Platinum','Diamond') and (
(subcategory='Excess Charges' and product_type not in ('Activation delay','Other','Long Session','Pro Rata Charge'))
or (subcategory='Billing & Payment' and product_type='Final Bill')
or (
    (subcategory='Fixed Services' and product_type not in ('Final Bill','ATC','Bandwidth On Demand',
    'Monthly charges dispute','Payment Dispute','Promo Dispute')) 
    and (subcategory='Fixed Services' and product_type not like 'Ref%d-Service Fault/Goodwill')
    )
or (subcategory='MNP' and product_type not in ('Payment Dispute','Promo Dispute','Refund','Usage Dispute'))
or (subcategory='Mobile Prepaid' and product_type='Roaming Data Bundle')
or (subcategory='Mobile Service' and product_type not in ('1233 Rewards/Free Units','1233 Rewards/No Response',
'1233 Rewards/Wrong Info','Business Rewards','CUG Charging Issue','Migration Adjustment','Monthly charges dispute',
'Payment Dispute','Promo Dispute','Refund - Goodwill','Refund- Roaming','Smartphone Rewards','Transfer Dispute','Usage Dispute','VAS Dispute'))
or (subcategory='Mobile Service - Payment' and product_type not in ('Cheque Dispute','Double Payment-Refund',
'Open Amount Mismatch','Paid-Not reflected','Payment Re-Allocation'))
or (subcategory='Bill Dispute' and product_type not in ('Monthly Benefits','Monthly recurring charges',
'Other Credits and Charges','Upgrade/Downgrade Failure','Usage - International Calls','Usage - National Calls','Usage - VAS Services'))
or (subcategory='Billing' and product_type not in ('Change Credit Limit','Monthly recurring charges',
'Other Credits and Charges','Power Bill - Dispute Charges','Power Bill -Mismatch-invoice','Usage - International Calls'
,'Usage - National Calls','Usage - VAS Services','Final Bill'))
or (subcategory='Dispute' and product_type not in ('Usage - International Data','Usage - International Roaming'
,'Usage - National Data','Usage - National Roaming','Usage -International Calls','Usage -National Calls',
'Usage -Others','Usage -SMS-International','Usage -SMS-National','CUG charges','Usage - BB Service',
'Usage - International Calls','Usage - National Calls','Usage - VAS - Others','Usage - VAS -National Calls',
'Usage - VAS -SMS-International','Usage - VAS -SMS-National','Usage -VAS-International Calls','Incorrect OCC posted',
'Monthly recurring charges','OCC not posted','Usage - VAS -Mobile TV','Usage - VAS -My Radio'))
or (subcategory='Enterprise Fixed Account' and product_type not in ('Amendment- Credit Limit','Payment Allocation'))
or (subcategory='Home Services' and product_type not in ('Amendment- Credit Limit','Payment Arrangement'))
or (subcategory='Mobile Service' and product_type not in ('Amendment- Credit Limit','Payment Arrangement'))
or (subcategory='Dispute - Offers' and product_type not in ('Bulk SMS','Diamond Plan','CallHome For Less Offer'
,'Daily Saver Bundle Offer','Double Data Recharge Offer','Recharge Promotion','WOW Offer'))
or (subcategory='Payment' and product_type not in ('Allocation Issue','Amount not reflecting',
'Double Payment - Refund','Incorrect Account','Over Payment - Refund','Roaming - Refund'))
or (
     (category='Data Dispute (Billing)' and subcategory <>'Excess Charges')
     and (category='Dispute (Billing)' and subcategory not in ('Billing & Payment','Fixed Services',
      'MNP','Mobile Prepaid','Mobile Service','Mobile Service - Payment'))
     and (category='CON_Fixed_Billing' and subcategory not in ('Bill Dispute','Payment'))
     and (category='CON_Fixed_Serv_ Req' and subcategory not in ('Billing','Payment'))
     and (category='CON_Mobile_PostPaid_Billing' and subcategory not in ('Dispute','Dispute - Benefits','Payment'))
     and (category='ENT_Fixed_Billing' and subcategory not in ('Power Bill','Billing','Payment'))
     and (category='ENT_Fixed_Serv_ Req' and subcategory<>'Billing')
     and (category='ENT_Mobile_PostPaid_Billing' and subcategory not in ('Dispute','Dispute - Offers','Payment'))
     and (category='ENT_Mobile_Postpaid_Serv_Req' and subcategory<>'Billing')
     and (category='ENT_Mobile_PrePaid_Billing' and subcategory not in ('Dispute','Dispute - Offers'))
   )
or category not in ('Dispute (Billing)','Data Dispute (Billing)','CON_Fixed_Billing','CON_Fixed_Serv_ Req',
'CON_Mobile_PostPaid_Billing','Collections Billing','ENT_Fixed_Billing','ENT_Fixed_Serv_ Req','ENT_Mobile_PostPaid_Billing'
,'ENT_Mobile_Postpaid_Serv_Req','ENT_Mobile_PrePaid_Billing')
)) group by Assignment) a right join
 (select distinct name from HPSM94BKPADMIN.AssignmentA1 where name in ('IT - Billing','IT - GIS','IT - ICS' ,'IT - OSS-OPS-Fixed Mediation'
,'IT - OSS-OPS-Mobile Mediation','IT - Payment Gateway',
  'IT - POS' ,'IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT',
'IT - OSS-OPS- HPSM','IT - OSS-OPS-Mobile Provisioning' ,'IT - OSS-OPS-Network Core Services' ,'IT - OSS-OPS-OAIM' ,'IT - CRM', 'Bill Shock',
'NOC - IN', 'IT SMS GW','Campaign Mgmt') ) b
on a.Assignment=b.Name order by B.Name;

exit;
EOF


echo "</TABLE>" >> $REPORTFILE_AS_New

echo $NEWLINE
echo $NEWLINE

--------------------------------------------------------


--------------------------------------------------


echo $NEWLINE
echo $NEWLINE

echo "<html><P><font color="blue">Regards,<br />HPSM Support Team<br />
<br />This is system auto generated mail,Please do not reply<br /></P></html>" >> $REPORTFILE_AS_New

echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_AS_New
echo "Content-Type: text/plain" >> $REPORTFILE_AS_New
echo "Content-Disposition: attachement; filename=all_open_AS_tt2.csv" >> $REPORTFILE_AS_New

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
set define off
spool all_open_AS_tt2.csv
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
||','||'Contrtact ID'
||','||'Asset number'
||','||'Current Age of TT (No.of Hours)'
||','||'Folder'
||','||'Customer Value'
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
||','||du_contract_id
||','||du_asset_number
||','||round(((sysdate-(open_time+4/24)))*24)
||','||folder
||','||du_cust_value
from
HPSM94BKPADMIN.probsummarym1
where problem_status not in('Rejected to Business','Closed','Resolved','Rejected','Pending Input') and du_master_tt is NULL and folder in ('SIEBEL-CRM') 
and du_cust_value in ('Platinum','Diamond') and (
(subcategory='Excess Charges' and product_type not in ('Activation delay','Other','Long Session','Pro Rata Charge'))
or (subcategory='Billing & Payment' and product_type='Final Bill')
or (
    (subcategory='Fixed Services' and product_type not in ('Final Bill','ATC','Bandwidth On Demand',
    'Monthly charges dispute','Payment Dispute','Promo Dispute')) 
    and (subcategory='Fixed Services' and product_type not like 'Ref%d-Service Fault/Goodwill')
    )
or (subcategory='MNP' and product_type not in ('Payment Dispute','Promo Dispute','Refund','Usage Dispute'))
or (subcategory='Mobile Prepaid' and product_type='Roaming Data Bundle')
or (subcategory='Mobile Service' and product_type not in ('1233 Rewards/Free Units','1233 Rewards/No Response',
'1233 Rewards/Wrong Info','Business Rewards','CUG Charging Issue','Migration Adjustment','Monthly charges dispute',
'Payment Dispute','Promo Dispute','Refund - Goodwill','Refund- Roaming','Smartphone Rewards','Transfer Dispute','Usage Dispute','VAS Dispute'))
or (subcategory='Mobile Service - Payment' and product_type not in ('Cheque Dispute','Double Payment-Refund',
'Open Amount Mismatch','Paid-Not reflected','Payment Re-Allocation'))
or (subcategory='Bill Dispute' and product_type not in ('Monthly Benefits','Monthly recurring charges',
'Other Credits and Charges','Upgrade/Downgrade Failure','Usage - International Calls','Usage - National Calls','Usage - VAS Services'))
or (subcategory='Billing' and product_type not in ('Change Credit Limit','Monthly recurring charges',
'Other Credits and Charges','Power Bill - Dispute Charges','Power Bill -Mismatch-invoice','Usage - International Calls'
,'Usage - National Calls','Usage - VAS Services','Final Bill'))
or (subcategory='Dispute' and product_type not in ('Usage - International Data','Usage - International Roaming'
,'Usage - National Data','Usage - National Roaming','Usage -International Calls','Usage -National Calls',
'Usage -Others','Usage -SMS-International','Usage -SMS-National','CUG charges','Usage - BB Service',
'Usage - International Calls','Usage - National Calls','Usage - VAS - Others','Usage - VAS -National Calls',
'Usage - VAS -SMS-International','Usage - VAS -SMS-National','Usage -VAS-International Calls','Incorrect OCC posted',
'Monthly recurring charges','OCC not posted','Usage - VAS -Mobile TV','Usage - VAS -My Radio'))
or (subcategory='Enterprise Fixed Account' and product_type not in ('Amendment- Credit Limit','Payment Allocation'))
or (subcategory='Home Services' and product_type not in ('Amendment- Credit Limit','Payment Arrangement'))
or (subcategory='Mobile Service' and product_type not in ('Amendment- Credit Limit','Payment Arrangement'))
or (subcategory='Dispute - Offers' and product_type not in ('Bulk SMS','Diamond Plan','CallHome For Less Offer'
,'Daily Saver Bundle Offer','Double Data Recharge Offer','Recharge Promotion','WOW Offer'))
or (subcategory='Payment' and product_type not in ('Allocation Issue','Amount not reflecting',
'Double Payment - Refund','Incorrect Account','Over Payment - Refund','Roaming - Refund'))
or (
     (category='Data Dispute (Billing)' and subcategory <>'Excess Charges')
     and (category='Dispute (Billing)' and subcategory not in ('Billing & Payment','Fixed Services',
      'MNP','Mobile Prepaid','Mobile Service','Mobile Service - Payment'))
     and (category='CON_Fixed_Billing' and subcategory not in ('Bill Dispute','Payment'))
     and (category='CON_Fixed_Serv_ Req' and subcategory not in ('Billing','Payment'))
     and (category='CON_Mobile_PostPaid_Billing' and subcategory not in ('Dispute','Dispute - Benefits','Payment'))
     and (category='ENT_Fixed_Billing' and subcategory not in ('Power Bill','Billing','Payment'))
     and (category='ENT_Fixed_Serv_ Req' and subcategory<>'Billing')
     and (category='ENT_Mobile_PostPaid_Billing' and subcategory not in ('Dispute','Dispute - Offers','Payment'))
     and (category='ENT_Mobile_Postpaid_Serv_Req' and subcategory<>'Billing')
     and (category='ENT_Mobile_PrePaid_Billing' and subcategory not in ('Dispute','Dispute - Offers'))
   )
or category not in ('Dispute (Billing)','Data Dispute (Billing)','CON_Fixed_Billing','CON_Fixed_Serv_ Req',
'CON_Mobile_PostPaid_Billing','Collections Billing','ENT_Fixed_Billing','ENT_Fixed_Serv_ Req','ENT_Mobile_PostPaid_Billing'
,'ENT_Mobile_Postpaid_Serv_Req','ENT_Mobile_PrePaid_Billing')
) and Assignment in ('IT - Billing','IT - GIS','IT - ICS','IT - OSS-OPS-Fixed Mediation'
,'IT - OSS-OPS-Mobile Mediation','IT - Payment Gateway',
  'IT - POS' ,'IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT',
'IT - OSS-OPS-Mobile Provisioning' ,'IT - OSS-OPS-Network Core Services' ,'IT - OSS-OPS-OAIM' ,'IT - CRM','Bill Shock', 'IT SMS GW','Campaign Mgmt');
spool off;
quit;
EOF

#echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_AS_New
#echo "Content-Type: text/plain" >> $REPORTFILE_AS_New
#echo "Content-Disposition: attachement; filename=all_open_AS_tt2.csv" >> $REPORTFILE_AS_New
#echo "" >> $REPORTFILE_AS_New
echo "" >> $REPORTFILE_AS_New
cat all_open_AS_tt2.csv >> $REPORTFILE_AS_New
cat $REPORTFILE_AS_New | /usr/lib/sendmail -t
