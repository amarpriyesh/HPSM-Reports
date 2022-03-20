cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/

REPORTFILE_AS=AS_reportoperator
dt=`date +%H%M`

recipient="nihalchand.dehury@du.ae,raghu.nandan@du.ae,Leela.Vishnumolakala@du.ae,BhanuPrasad@du.ae,Srinivas.Sabbella@du.ae,nagendra.kumar@du.ae,Radhika.Varakavi@du.ae"

###recipient="Neelima.V@du.ae,raghu.nandan@du.ae,nihalchand.dehury@du.ae,Mounika.Chalasani@du.ae,Satish.Malla@du.ae,Leela.Vishnumolakala@du.ae,Nitesh.Kumar@du.ae,Swati.Samaiya@du.ae,Prabhasini.Mohanty@du.ae,Rahul.Singh@du.ae,BhanuPrasad@du.ae,Srinivas.Sabbella@du.ae,d.kanakadurga@du.ae,Hemanta.Patra@du.ae,Munagavalasa.Rohit@du.ae,nagendra.kumar@du.ae"


MailSubject="All AS Customer Reopen Yesterday TT Report wrt group  @ `date \"+%d/%m/%Y %H:%M\"`"

OUTPUTFLAG=HTML

rm AS_reportoperator 

echo "Subject: $MailSubject
To: $recipient
MIMEV=\"MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw" 
Content-Disposition: inline
" >> $REPORTFILE_AS

echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_AS
echo "Content-Type: text/html" >> $REPORTFILE_AS
echo "Content-Disposition: inline" >> $REPORTFILE_AS
echo "" >> $REPORTFILE_AS

echo "<html><P><font color="blue">
Dear All,<br /><br />All AS Customer Reopen Yesterday TT Report<B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br /><br /></P></html>" >> $REPORTFILE_AS 


echo "<TABLE border="1">" >> $REPORTFILE_AS 
echo "<TR><TH><font color="blue">Assignment Group</TH></font><TH><font color="blue">Reopen Count</TH></TR>" >> $REPORTFILE_AS 

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_AS
set linesize 2000;
set trimspool on;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td>'||DBMS_LOB.SUBSTR(trim(substr(a.description, (instr(a.description,'to')+3) ,(instr(a.description,'|')-instr(a.description,'to'))-3)))
||'</td><th>'||count(*) ||'</th></tr>'
from probsummarym1 b,activitym1 a where
a."NUMBER"=b."NUMBER" and b.Folder='SIEBEL-CRM' and
((subcategory='Excess Charges' and product_type not in ('Activation delay
','Other','Long Session','Pro Rata Charge')) 
or (subcategory like 'Billing%Payment' and product_type='Final Bill') or 
((subcategory='Fixed Services' and product_type not in ('Final Bill','ATC','Bandwidth On Demand','Monthly charges dispute',
'Payment Dispute','Promo Dispute')) and (subcategory='Fixed Services' and product_type not like 'Ref%d-Service Fault/Goodwill')) or 
(subcategory='MNP' and product_type not in ('Payment Dispute','Promo Dispute','Refund','Usage Dispute')) or
(subcategory='Mobile Prepaid' and product_type='Roaming Data Bundle') or 
(subcategory='Mobile Service' and product_type not in ('1233 Rewards/Free Units','1233 Rewards/No Response',
'1233 Rewards/Wrong Info','Business Rewards','CUG Charging Issue','Migration Adjustment','Monthly charges dispute',
'Payment Dispute','Promo Dispute','Refund - Goodwill','Refund- Roaming','Smartphone Rewards','Transfer Dispute','Usage Dispute','VAS Dispute')) or
(subcategory='Mobile Service - Payment' and product_type not in ('Cheque Dispute','Double Payment-Refund',
'Open Amount Mismatch','Paid-Not reflected','Payment Re-Allocation')) or ((category='Data Dispute (Billing)' and subcategory <>'Excess Charges') 
and (category='Dispute (Billing)' and (subcategory not like 'Billing%Payment' and subcategory not in ('Fixed Services','MNP',
'Mobile Prepaid','Mobile Service','Mobile Service - Payment'))))
 or category not in ('Dispute (Billing)','Data Dispute (Billing)'))
and a.type in ('Reopened') and trunc(a.datestamp+4/24)=trunc(sysdate-1)
and DBMS_LOB.SUBSTR(trim(substr(a.description, (instr(a.description,'to')+3) ,(instr(a.description,'|')-instr(a.description,'to'))-3))) 
in ('IT - Billing','IT - GIS','to IT - ICS','IT - OSS-OPS-Fixed Mediation', 'IT - OSS-OPS-Mobile Mediation',
'IT - Payment Gateway','IT - POS','IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT'
,'IT - OSS-OPS-Mobile Provisioning','IT - OSS-OPS-Network Core Services','IT - OSS-OPS-OAIM','IT - CRM','IT - OSS-OPS- HPSM') 
group by DBMS_LOB.SUBSTR(trim(substr(a.description, (instr(a.description,'to')+3) ,(instr(a.description,'|')-instr(a.description,'to'))-3)));
exit;
EOF


echo "</TABLE>" >> $REPORTFILE_AS

echo $NEWLINE
echo $NEWLINE

echo "<html><P><font color="blue">Regards,<br />HPSM Support Team<br /><br />This is system auto generated mail,Please do not reply<br /></P></html>" >> $REPORTFILE_AS
echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_AS
echo "Content-Type: text/plain" >> $REPORTFILE_AS
echo "Content-Disposition: attachement; filename=all_open_AS_tt5.csv">>$REPORTFILE_AS
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
set define off
spool all_open_AS_tt5.csv 
-------------------All Open TT Incident extract------------------------------------

select
'IncidentNo'
||','||'Type'
||','||'Date'
||','||'Operator'
||','||'Category'
||','||'Area'
||','||'SubArea'
||','||'OpenTime'
||','||'Folder'
||','||'Customer Value'
from Dual
union ALL
select distinct
a."NUMBER"
||','||a.type
||','||to_char(a.datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||a.operator
||','||b.category
||','||b.subcategory
||','||b.product_type
||','||b.open_time
||','||b.folder
||','||b.du_cust_value
from probsummarym1 b,activitym1 a where
a."NUMBER"=b."NUMBER" and b.Folder='SIEBEL-CRM' and
((subcategory='Excess Charges' and product_type not in ('Activation delay
','Other','Long Session','Pro Rata Charge')) 
or (subcategory like 'Billing%Payment' and product_type='Final Bill') or 
((subcategory='Fixed Services' and product_type not in ('Final Bill','ATC','Bandwidth On Demand','Monthly charges dispute',
'Payment Dispute','Promo Dispute')) and (subcategory='Fixed Services' and product_type not like 'Ref%d-Service Fault/Goodwill')) or 
(subcategory='MNP' and product_type not in ('Payment Dispute','Promo Dispute','Refund','Usage Dispute')) or
(subcategory='Mobile Prepaid' and product_type='Roaming Data Bundle') or 
(subcategory='Mobile Service' and product_type not in ('1233 Rewards/Free Units','1233 Rewards/No Response',
'1233 Rewards/Wrong Info','Business Rewards','CUG Charging Issue','Migration Adjustment','Monthly charges dispute',
'Payment Dispute','Promo Dispute','Refund - Goodwill','Refund- Roaming','Smartphone Rewards','Transfer Dispute','Usage Dispute','VAS Dispute')) or
(subcategory='Mobile Service - Payment' and product_type not in ('Cheque Dispute','Double Payment-Refund',
'Open Amount Mismatch','Paid-Not reflected','Payment Re-Allocation')) or ((category='Data Dispute (Billing)' and subcategory <>'Excess Charges') 
and (category='Dispute (Billing)' and (subcategory not like 'Billing%Payment' and subcategory not in ('Fixed Services','MNP',
'Mobile Prepaid','Mobile Service','Mobile Service - Payment'))))
 or category not in ('Dispute (Billing)','Data Dispute (Billing)'))
and a.type in ('Reopened') and trunc(a.datestamp+4/24)=trunc(sysdate-1)
and DBMS_LOB.SUBSTR(trim(substr(a.description, (instr(a.description,'to')+3) ,(instr(a.description,'|')-instr(a.description,'to'))-3))) 
in ('IT - Billing','IT - GIS','to IT - ICS','IT - OSS-OPS-Fixed Mediation', 'IT - OSS-OPS-Mobile Mediation',
'IT - Payment Gateway','IT - POS','IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT'
,'IT - OSS-OPS-Mobile Provisioning','IT - OSS-OPS-Network Core Services','IT - OSS-OPS-OAIM','IT - CRM','IT - OSS-OPS- HPSM'); 

spool off;
quit;
EOF
echo "" >> $REPORTFILE_AS
cat all_open_AS_tt5.csv >> $REPORTFILE_AS
cat $REPORTFILE_AS | /usr/lib/sendmail -t
