cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/

REPORTFILE_AS=AS_reportNew4

###recipient="nihalchand.dehury@du.ae"


recipient="Adinarayana.Usurupat@du.ae,LaxmaReddy.Kompally@du.ae,Bismita.Nayak@du.ae,Sindhura@du.ae,Jyothy.ch@du.ae,Nirmala.Pydala@du.ae,Pushpa.Adusumalli@du.ae,Anuj.Rastogi@du.ae,Nikky.Priya@du.ae,M.Ravindra@du.ae,Chinmay.Pattanaik@du.ae,Anandkumar.Pacha@du.ae,Ramyakrishna.Gandi@du.ae,Venugopal.Bogineni@du.ae,Saikrishna.JV@du.ae,Kanakadurga.D@du.ae,Gouthami.K@du.ae,Spandana.Chennupati@du.ae,Balakrishna.N@du.ae,Jangiti.Jyothy@du.ae,Kalyana.Chakravarthy@du.ae,Munagavalasa.Rohit@du.ae,JyothiSaroja.Daggu@du.ae,Phanindra.Boddu@du.ae,Ashfaque.Mohammad@du.ae,Mounika.Chalasani@du.ae,Vijay.sridhar@du.ae,Sirisha.Pinnamsetty@du.ae,Chandramouli.Kemburu@du.ae,Satish.Malla@du.ae,nagaiah.gudavalli@du.ae,madhu.alluri@du.ae,rajeesha.korlana@du.ae,anjaneyulu.t@du.ae,srinivas.podugu@du.ae,nagaiahbabu.g@du.ae,Nitesh.Kumar@du.ae,Swati.Samaiya@du.ae,Prabhasini.Mohanty@du.ae,Rahul.Singh@du.ae,BhanuPrasad@du.ae,sarabh.pulavarthi@du.ae,vinay.bussa@du.ae,ajit.gudimetla@du.ae,Radhika.Varakavi@du.ae,Madhu.Alluri@du.ae,Sridhar.SIRIGIRI@du.ae,Neelambaram.Devivara@du.ae,SivaChaitanya.Kalavala@du.ae,Kiranmai.Bondili@du.ae,Arunakumari.K@du.ae,D.KanakaDurga@du.ae,Shaji.Uddin@du.ae,Rajeswar.Singh@du.ae,Venkat.ReddyT@du.ae,Leela.Vishnumolakala@du.ae,Srinivas.Sabbella@du.ae,Sesikapoor.Chitturi@du.ae,Kshirodarnba.Sahu@du.ae,Shiva.Lagishetty@du.ae,Raja.Banda@du.ae,Sandeep.Thenkudy@du.ae,Swati.Samaiya@du.ae,Hemanta.Patra@du.ae,nagasiva.krishna@du.ae,iqbal.khan@du.ae,rajesh.peddaboina@du.ae,aruna.pradhan@du.ae,syed.irfan@du.ae,syed.faheemuddin@du.ae,rama.medagam@du.ae,uttam.sahoo@du.ae,nareen.shaganti@du.ae,sameer.chirumamilla@du.ae,ramprasad.anumalasetty@du.ae,mahendar.dharmapuri@du.ae,praveen.singu@du.ae,chandrasekhar.k@du.ae,sai.narender@du.ae,hari.mandadapu@du.ae,satyam.gosala@du.ae,kamalakar.mamidala@du.ae,IT.DCO@du.ae,akhil.thatipamula@du.ae,Syed.InthiyazAhmed@du.ae,vijay.modepalli@du.ae,praveen.naidu@du.ae,abhishek.sangam@du.ae,sathyanarayan.murthy@du.ae,edward.paul@du.ae,khasimbi.shaik@du.ae,goli.ramakumar@du.ae,kiran.kollipara@du.ae,sandeep.joshi@du.ae,rajesh.joga@du.ae,syed.inthiyazahmed@du.ae,swarup.dutta@du.ae,debanjan.nag@du.ae,lakshmi.narasimham@du.ae,kiran.bashaboina@du.ae,phaneendra.govindu@du.ae,divya.muniganti@du.ae,muralidhar.kasagna@du.ae,Balaji.jenjeti@du.ae,Pradeep.Bontala@du.ae,Prajeesh.Olacheri@du.ae,Bonny.Jose@du.ae,Asif.Khan@du.ae,Chandra.Rokaha@du.ae,Syed.kashifuddin@du.ae,srinivas.rao@du.ae,rupesh.hota@du.ae,Winner.Viagularaj@du.ae,Ramana.Reddy@du.ae,HariKrishna.Reddy@du.ae,Chiru.Sagiraju@du.ae,Sahil.Bajaj@du.ae,Srinivas.Banoth@du.ae,Abdul.Rub@du.ae,Abdul.Samad@du.ae,Arshad.Mubarak@du.ae,Ashraf.Mohammed@du.ae,Shihab.Panakkatu@du.ae"

recipient1="Nagendra.Kumar@du.ae,Raghu.Nandan@du.ae,sankar.hemadri@du.ae,saravanan.duraisamy@du.ae"

MailSubject="All Open AS & IS TT Report @ `date \"+%d/%m/%Y %H:%M\"`"

OUTPUTFLAG=HTML

rm AS_reportNew4

echo "Subject: $MailSubject
To: $recipient
Cc: $recipient1
MIMEV=\"MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw" 
Content-Disposition: inline
" >> $REPORTFILE_AS

echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_AS
echo "Content-Type: text/html" >> $REPORTFILE_AS
echo "Content-Disposition: inline" >> $REPORTFILE_AS
echo "" >> $REPORTFILE_AS

echo "<html><P><font color="blue">
Dear All,<br /><br />Please find below AS & IS Open TT report other than FMS & Pending Input TTs in <B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br />
<br /></P></html>" >> $REPORTFILE_AS 

echo "<TABLE border="1">" >> $REPORTFILE_AS
 
echo "<TR><TH><font color="blue">Resolver Group</TH></font><TH><font color ="blue">0 days</TH></font><TH><font color ="blue">1 days</TH></font><TH><font color ="blue">2
days</TH></font><TH><font color="blue">3 days</TH></font><TH><font color="blue">4 days</TH></font><TH><font color="blue">5 days</TH></font><TH><font color="blue">(6-10) days</TH></font><TH><font color="blue">>10 days</TH></font><TH><font color="blue">Total</TH></TR>" >> $REPORTFILE_AS

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_AS
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td>'||b.Name||'</td><td align=center>'|| nvl(Zero,0)||'</td><td align=center>'||nvl(One,0)||'</td><td align=center>'||nvl(Two,0)||'</td><td align=center>'|
| nvl(Three,0)||'</td><td align=center>'|| nvl(four,0)||'</td><td align=center>'|| nvl(five,0)||'</td><td align=center>'|| nvl(six_ten,0)||'</td><td align=center>'|| nvl(greater_ten,0)||'</td><th>'||to_char( nvl(incidents,0))||'</th></tr>'
 From
(select  Assignment, sum(Zero) Zero,sum(One) One,sum(Two) Two,sum(Three) Three,sum(Four) Four,sum(Five) Five,sum(six_ten) six_ten,sum(greater_ten) greater_ten,sum(incidents) incidents
  from (
  select
  Assignment
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 0,1,0) Zero
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 1,1,0) One
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 2,1,0) Two
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 3,1,0) Three 
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 4,1,0) Four 
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 5,1,0) Five
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 6,1, 7,1, 8,1, 9,1, 10,1,0) six_ten 
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 0,0, 1,0, 2,0, 3,0, 4,0,5,0,6,0,7,0,8,0,9,0,10,0,1) greater_ten 
  , 1 Incidents
from smadmin.Probsummarym1
 where PROBLEM_STATUS not in ('Resolved','Closed','Pending Input','Rejected to Business') and category not in ('FMS') and du_master_tt is NULL)
group by Assignment) a right join (select distinct name from smadmin.AssignmentA1 where name in ('IT - Mission Critical Enterprise Systems & Service','IT - Billing','IT - GIS','IT - ICS','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT- Payment Gateway','IT - POS','IT - Payment Gateway','IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT','IT - OSS-OPS- HPSM','IT - OSS-OPS-Mobile Provisioning','IT - OSS-OPS-Network Core Services','IT - OSS-OPS-OAIM','IT - CRM','IT - Backup Admin','IT - Desktop & System Support','IT - System Admin UNIX','IT - Database Admin','IT - System Admin WINDOWS','IT - Enterprise Systems (HMC)','IT - SAN Admin','IT - Retail Technical Support','IT - TSD IT','IT - NOC','IT - EDMS','IT - Corporate Technical Support'))b on a.Assignment=b.Name order by B.Name;

exit;
EOF

echo "</TABLE>" >> $REPORTFILE_AS

echo $NEWLINE
echo $NEWLINE

echo "<html><P><font color="blue">
<br /><br />Please find below AS & IS Pending Input TTs report including FMS TTs in <B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br />
<br /></P></html>" >> $REPORTFILE_AS

echo "<TABLE border="1">" >> $REPORTFILE_AS

echo "<TR><TH><font color="blue">Resolver Group</TH></font><TH><font color ="blue">0 days</TH></font><TH><font color ="blue">1 days</TH></font><TH><font color ="blue">2days</TH></font><TH><font color="blue">3 days</TH></font><TH><font color="blue">4 days</TH></font><TH><font color="blue">5 days</TH></font><TH><font color="blue">(6-10)days</TH></font><TH><font color="blue">>10 days</TH></font><TH><font color="blue">Total</TH></TR>" >> $REPORTFILE_AS

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_AS
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td>'||b.Name||'</td><td align=center>'|| nvl(Zero,0)||'</td><td align=center>'||nvl(One,0)||'</td><td align=center>'||nvl(Two,0)||'</td><td align=center>'|| nvl(Three,0)||'</td><td align=center>'|| nvl(four,0)||'</td><td align=center>'|| nvl(five,0)||'</td><td align=center>'|| nvl(six_ten,0)||'</td><td align=center>'|| nvl(greater_ten,0)||'</td><th>'||to_char( nvl(incidents,0))||'</th></tr>'
 From
(select  Assignment, sum(Zero) Zero,sum(One) One,sum(Two) Two,sum(Three) Three,sum(Four) Four,sum(Five) Five,sum(six_ten) six_ten,sum(greater_ten) greater_ten,sum(incidents) incidents
  from (
  select
  Assignment
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 0,1,0) Zero
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 1,1,0) One
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 2,1,0) Two
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 3,1,0) Three
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 4,1,0) Four
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 5,1,0) Five
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 6,1,7,1, 8,1, 9,1, 10,1,0) six_ten
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 0,0, 1,0, 2,0, 3,0, 4,0,5,0,6,0,7,0,8,0,9,0,10,0,1) greater_ten
  , 1 Incidents
from smadmin.Probsummarym1
where PROBLEM_STATUS in ('Pending Input') and du_master_tt is NULL) group by Assignment) a right join (select distinct name from smadmin.AssignmentA1 where name in ('IT - Mission Critical Enterprise Systems & Service','IT - Billing','IT - GIS','IT - ICS','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT - Payment Gateway','IT- Payment Gateway','IT - POS','IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT','IT - OSS-OPS- HPSM','IT - OSS-OPS-Mobile Provisioning','IT - OSS-OPS-Network Core Services','IT - OSS-OPS-OAIM','IT - CRM','IT - Backup Admin','IT - Desktop & System Support','IT - System Admin UNIX','IT - Database Admin','IT - System Admin WINDOWS','IT - Enterprise Systems (HMC)','IT - SAN Admin','IT - Retail Technical Support','IT - TSD IT','IT - NOC','IT - EDMS','IT - Corporate Technical Support') )
 b on a.Assignment=b.Name order by B.Name;

exit;
EOF

echo "</TABLE>" >> $REPORTFILE_AS


echo $NEWLINE
echo $NEWLINE

echo "<html><P><font color="blue">
<br /><br />Please find below AS & IS Open FMS TTs report other than pending input TTs in <B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br />
<br /></P></html>" >> $REPORTFILE_AS

echo "<TABLE border="1">" >> $REPORTFILE_AS

echo "<TR><TH><font color="blue">Resolver Group</TH></font><TH><font color ="blue">0 days</TH></font><TH><font color ="blue">1 days</TH></font><TH><font color ="blue">2days</TH></font><TH><font color="blue">3 days</TH></font><TH><font color="blue">4 days</TH></font><TH><font color="blue">5 days</TH></font><TH><font color="blue">(6-10)days</TH></font><TH><font color="blue">>10 days</TH></font><TH><font color="blue">Total</TH></TR>" >> $REPORTFILE_AS

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_AS
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td>'||b.Name||'</td><td align=center>'|| nvl(Zero,0)||'</td><td align=center>'||nvl(One,0)||'</td><td align=center>'||nvl(Two,0)||'</td><td align=center>'|| nvl(Three,0)||'</td><td align=center>'|| nvl(four,0)||'</td><td align=center>'|| nvl(five,0)||'</td><td align=center>'|| nvl(six_ten,0)||'</td><td align=center>'|| nvl(greater_ten,0)||'</td><th>'||to_char( nvl(incidents,0))||'</th></tr>'
 From
(select  Assignment, sum(Zero) Zero,sum(One) One,sum(Two) Two,sum(Three) Three,sum(Four) Four,sum(Five) Five,sum(six_ten) six_ten,sum(greater_ten) greater_ten,sum(incidents) incidents
  from (
  select
  Assignment
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 0,1,0) Zero
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 1,1,0) One
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 2,1,0) Two
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 3,1,0) Three
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 4,1,0) Four
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 5,1,0) Five
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 6,1, 7,1, 8,1, 9,1, 10,1,0) six_ten
  ,decode (floor(trunc(sysdate+1)-(open_time+4/24)), 0,0, 1,0, 2,0, 3,0, 4,0,5,0,6,0,7,0,8,0,9,0,10,0,1) greater_ten
  , 1 Incidents
from smadmin.Probsummarym1 
 where PROBLEM_STATUS not in ('Resolved','Closed','Pending Input','Rejected to Business') and category in ('FMS') and du_master_tt is NULL) group by Assignment) a right join (select distinct name from smadmin.AssignmentA1 where name in ('IT - Mission Critical Enterprise Systems & Service','IT - Billing','IT - GIS','IT - ICS','IT - Payment Gateway','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT- Payment Gateway','IT - POS','IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT','IT - OSS-OPS- HPSM','IT - OSS-OPS-Mobile Provisioning','IT - OSS-OPS-Network Core Services','IT - OSS-OPS-OAIM','IT - CRM','IT - Backup Admin','IT - Desktop & System Support','IT - System Admin UNIX','IT - Database Admin','IT - System Admin WINDOWS','IT - Enterprise Systems (HMC)','IT - SAN Admin','IT - Retail Technical Support','IT - TSD IT','IT - NOC','IT - EDMS','IT - Corporate Technical Support') ) b on a.Assignment=b.Name order by B.Name;

exit;
EOF

echo "</TABLE>" >> $REPORTFILE_AS

echo $NEWLINE
echo $NEWLINE

echo "<html><P><font color="blue">Regards,<br />HPSM Support Team<br /><br />This is system auto generated mail,Please do not reply<br /></P></html>" >> $REPORTFILE_AS

echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_AS
echo "Content-Type: text/plain" >> $REPORTFILE_AS
echo "Content-Disposition: attachement; filename=all_open_tt4.csv" >> $REPORTFILE_AS

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
||','||du_contract_id
||','||du_asset_number
||','||(to_date(trunc(sysdate),' dd-mon-yyyy HH24:MI SS')-TO_DATE(open_time+4/24,'DD-MON-YYYY HH24:MI'))
||','||(select max(to_char(datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')) from activitym1 where "NUMBER"=a."NUMBER" and (type='ReAssigned' or type='Reopened'or type='Open'))
||','||DU_REOPENCOUNT
||','||folder
from
smadmin.probsummarym1 a
where a.problem_status not in('Rejected to Business','Closed','Resolved') and a.du_master_tt is NULL and a.Assignment in ('IT - Mission Critical Enterprise Systems & Service','IT - Billing','IT - GIS','IT - ICS','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT - Payment Gateway','IT - POS' ,'IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT','IT - OSS-OPS-Mobile Provisioning' ,'IT - OSS-OPS-Network Core Services' ,'IT - OSS-OPS-OAIM' ,'IT - CRM','IT - OSS-OPS- HPSM','IT - Backup Admin','IT - Desktop & System Support','IT - System Admin UNIX','IT - Database Admin','IT - System Admin WINDOWS','IT - Enterprise Systems (HMC)','IT - SAN Admin','IT - Retail Technical Support','IT - TSD IT','IT - NOC','IT - EDMS','IT - Corporate Technical Support');
spool off;
quit;
EOF

#echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_AS
#echo "Content-Type: text/plain" >> $REPORTFILE_AS
#echo "Content-Disposition: attachement; filename=all_open_AS_tt1.csv" >> $REPORTFILE_AS
#echo "" >> $REPORTFILE_AS
echo "" >> $REPORTFILE_AS
cat all_open_tt4.csv >> $REPORTFILE_AS
cat $REPORTFILE_AS | /usr/lib/sendmail -t

