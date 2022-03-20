cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/

REPORTFILE_ASIS=AS_reportNew41

recipient="ankur.saxena@du.ae,priyesh.a@du.ae"
#recipient="syed.asim@du.ae,Sachin.Kumar@du.ae,Mohit.Gangwar@du.ae,Shreya.Pahuja@du.ae,Amit.Pushp@du.ae,Rohit.Sharma2@du.ae,Rahul.Verma@du.ae,Nadeem.Ahmad@du.ae,pavithra.g2@du.ae,Ankit.Sharma@du.ae,Kanhaya.Singh@du.ae,Saubhagya.Khandual@du.ae,Trapti.Sharma@du.ae,priyesh.a@du.ae,Mayank.Srivastava1@du.ae,ankur.gahlaut1@du.ae,Pawan.Soobhri@du.ae,venkatesan.k@du.ae,priyesh.a@du.ae,leelandra.sunnam@du.ae,Ranga.Modadugu1@du.ae,kusum.kumari@du.ae,LaxmaReddy.Kompally@du.ae,gunjan.mathur@du.ae,Pavithra.G@du.ae,Sangeetha.Sathyanath1@du.ae,Sanjay.Sharma@du.ae,Tamer.awad@du.ae,Sangeetha.Sathyanath@du.ae,Hemanta.Patra@du.ae,Ratnesh.Jain@du.ae,Geet.Anand@du.ae,Deepak.Kumar1@du.ae,Srinivasa.Chakrvarhty@du.ae,Bismita.Nayak@du.ae,Sandeep.Gupta@du.ae,Tulika.ranjan@du.ae,Shailey.Narula@du.ae,Nitin.Gupta@du.ae,Sheikh.Ali@du.ae,Rami.Khairy@du.ae,VinayPratap.Singh@du.ae,Tirupathi.Reddy@du.ae,Sesikapoor.Chitturi@du.ae,Preem.Kumar@du.ae,Sandeep.Satpathy@du.ae,Venugopal.Thanuku@du.ae,Deependra.Sengar@du.ae,Anantharaman.Sekar@du.ae,Sharath.Kumar@du.ae,Sibadatta.Tripathy@du.ae,ratnesh.jain@du.ae,Prashant.Agarwal@du.ae,Deepak.saraswat@du.ae,Rahul.maheshwari@du.ae,himanshu.sharma@du.ae,ankur.saxena@du.ae,Vinit.Verma@du.ae,ramakrishnan.m@du.ae,Kumaraswamy.KP@du.ae,Murgeshswamy.Mathad@du.ae,vijay.s@du.ae,Harinder.Saini@du.ae,Malineni.Venkata@du.ae,Sunil.Paladugu@du.ae,Jyoti.Charupalli@du.ae,Rajiv.Sharma@du.ae,Priyanka.Jain@du.ae,nagendra.singh@du.ae,kunal.chandan@du.ae,ankur.gahlaut@du.ae,ravi.kalia@du.ae,shivanand.kumar@du.ae,bhawna.bhandari@du.ae,navneet.kaur@du.ae,khushbu.sharma@du.ae,soumi.mitra@du.ae,pavithra.g1@du.ae,gayatri.khosla@du.ae,Dharini.Nagarajan1@du.ae,Sanjay.Sharma1@du.ae,Lakshya.Adlakha1@du.ae,Ankit.Saroha@du.ae"
#recipient1="mohammed.rezwanali@du.ae"
#recipient1="vannamuthu@du.ae,Gagan.Atreya@du.ae,Neeraj.Sharma@du.ae,Tamer.Awad@du.ae,Sandra.Khouzam@du.ae,shadi.trad@du.ae"


MailSubject="All Open AS & IS TT Report @ `date \"+%d/%m/%Y %H:%M\"`"

OUTPUTFLAG=HTML

rm AS_reportNew41

echo "Subject: $MailSubject
To: $recipient
Cc: $recipient1
MIMEV=\"MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
" >> $REPORTFILE_ASIS

echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_ASIS
echo "Content-Type: text/html" >> $REPORTFILE_ASIS
echo "Content-Disposition: inline" >> $REPORTFILE_ASIS
echo "" >> $REPORTFILE_ASIS


echo "<html><P><font color="blue">Dear All,
<br /><br />Please find below AS & IS Open SEIBEL - CRM  TTs with Pending Input TTs in<B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br />
<br /></P></html>" >> $REPORTFILE_ASIS
echo "<TABLE border="1">" >> $REPORTFILE_ASIS

echo "<TR><TH><font color="blue">Resolver Group</TH></font><TH><font color ="blue">0 days</TH></font><TH><font color ="blue">1 days</TH></font><TH><font color ="blue">2days</TH></font><TH><font color="blue">3 days</TH></font><TH><font color="blue">4 days</TH></font><TH><font color="blue">5 days</TH></font><TH><font color="blue">(6-10)days</TH></font><TH><font color="blue">>10 days</TH></font><TH><font color="blue">Total</TH></TR>" >> $REPORTFILE_ASIS
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_ASIS
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select case when incidents > 0 then   '<tr><td>'||b.Name||'</td><td align=center>'|| nvl(Zero,0)||'</td><td align=center>'||nvl(One,0)||'</td><td align=center>'||nvl(Two,0)||'</td><td align=center>'|| nvl(Three,0)||'</td><td align=center>'|| nvl(four,0)||'</td><td align=center>'|| nvl(five,0)||'</td><td align=center>'|| nvl(six_ten,0)||'</td><td align=center>'|| nvl(greater_ten,0)||'</td><th>'||to_char( nvl(incidents,0))||'</th></tr>' else null end From (select  Assignment, sum(Zero) Zero,sum(One) One,sum(Two) Two,sum(Three) Three,sum(Four) Four,sum(Five) Five,sum(six_ten) six_ten,sum(greater_ten) greater_ten,sum(incidents) incidents from (
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
from HPSM94BKPADMIN.Probsummarym1
 where PROBLEM_STATUS not in ('Resolved','Closed','Rejected to Business') and folder in ('SIEBEL-CRM') and du_master_tt is NULL) group by Assignment) a right join (select distinct name from HPSM94BKPADMIN.AssignmentA1 where ( name in ('KMUCC Support','IT SMS GW','IT - DB Systems (L1)','IT - SAN (L1)','IT - Unix System (L1)','RSS Support Group','IT - BSCS Provisioning','IT - Managed Printing Service','IT - Technical Hardware Support (Jumbo Support)','IT - Dealer Hardware Support (Jumbo Support)','IAM Operations','IT - 2FA','FNL_OPs','IT - Remote Technical Support','IT - MNP Application Support','ITOC-Maximo-UAM','DuVerse Access','ITOC-Execution-IN','ITOC-Execution-Infra','ITOC-Execution-Apps','IT - Business Application Access','IT - Billing','IT DSP Application Support','IT - Interconnect Billing','IT - DB SAN UNIX Systems (L1)','IT - Enterprise Systems (L1)','NOC - IN','Bill Shock','Core - Mobile IN','IT-SQL DBA','IT - GIS','IT - ICS','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT - Corporate Technical Support Onshore','ITOC - User Access Management','IT- Payment Gateway','IT - POS','IT - Payment Gateway','IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT','IT - OSS-OPS- HPSM','IT - OSS-OPS-Mobile Provisioning','IT - OSS-OPS-Network Core Services','IT - OSS-OPS-OAIM','IT - CRM','IT - Backup Admin','IT Enterprise Services & Support','IT - System Admin UNIX','IT - Database Admin','IT - System Admin WINDOWS','IT - Enterprise Systems (HMC)','IT - SAN Admin','IT - Retail Technical Support','IT - TSD IT','IT - NOC','IT - EDMS','IT - Corporate Technical Support','IT - Mission Critical Enterprise Systems & Service','IT - Desktop & System Support','IT - Citrix Support','IT - Security','IT - Sharepoint','IT - IP TV','IT - Roadshow Technical Support','IAM - IN') or name like '%L2%'))b on a.Assignment=b.Name order by B.Name;
exit;
EOF

echo "</TABLE>" >> $REPORTFILE_ASIS

echo $NEWLINE
echo $NEWLINE


echo "<html><P><font color="blue">
<br /><br />Please find below AS & IS ITSD Open TT report  other than FMS  TTs and except Pending Input TTs in <B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br />
<br /></P></html>" >> $REPORTFILE_ASIS

echo "<TABLE border="1">" >> $REPORTFILE_ASIS

echo "<TR><TH><font color="blue">Resolver Group</TH></font><TH><font color ="blue">0 days</TH></font><TH><font color ="blue">1 days</TH></font><TH><font color ="blue">2days</TH></font><TH><font color="blue">3 days</TH></font><TH><font color="blue">4 days</TH></font><TH><font color="blue">5 days</TH></font><TH><font color="blue">(6-10)days</TH></font><TH><font color="blue">>10 days</TH></font><TH><font color="blue">Total</TH></TR>" >> $REPORTFILE_ASIS
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_ASIS
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select case when incidents > 0 then   '<tr><td>'||b.Name||'</td><td align=center>'|| nvl(Zero,0)||'</td><td align=center>'||nvl(One,0)||'</td><td align=center>'||nvl(Two,0)||'</td><td align=center>'|| nvl(Three,0)||'</td><td align=center>'|| nvl(four,0)||'</td><td align=center>'|| nvl(five,0)||'</td><td align=center>'|| nvl(six_ten,0)||'</td><td align=center>'|| nvl(greater_ten,0)||'</td><th>'||to_char( nvl(incidents,0))||'</th></tr>' else null end From (select  Assignment, sum(Zero) Zero,sum(One) One,sum(Two) Two,sum(Three) Three,sum(Four) Four,sum(Five) Five,sum(six_ten) six_ten,sum(greater_ten) greater_ten,sum(incidents) incidents from (
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
from HPSM94BKPADMIN.Probsummarym1
 where PROBLEM_STATUS not in ('Resolved','Closed','Rejected to Business','Pending Input') and folder in ('ITSD') and category not in ('FMS') and du_master_tt is NULL) group by Assignment) a right join (select distinct name from HPSM94BKPADMIN.AssignmentA1 where ( name in ('IT SMS GW','KMUCC Support','IT - Managed Printing Service','IT - DB Systems (L1)','RSS Support Group','IT - SAN (L1)','IT - Unix System (L1)','IT - BSCS Provisioning','IT - Technical Hardware Support (Jumbo Support)','IT - Dealer Hardware Support (Jumbo Support)','IAM Operations','IT - 2FA','IT - Remote Technical Support','FNL_OPs','DuVerse Access','IT - MNP Application Support','ITOC-Maximo-UAM','ITOC-Execution-IN','ITOC-Execution-Infra','ITOC-Execution-Apps','IT - Business Application Access','IT - Billing','IT DSP Application Support','IT - Interconnect Billing','IT - DB SAN UNIX Systems (L1)','IT - Enterprise Systems (L1)','NOC - IN','Bill Shock','Core - Mobile IN','IT-SQL DBA','IT - GIS','IT - ICS','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT - Corporate Technical Support Onshore','ITOC - User Access Management','IT- Payment Gateway','IT - POS','IT - Payment Gateway','IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT','IT - OSS-OPS- HPSM','IT - OSS-OPS-Mobile Provisioning','IT - OSS-OPS-Network Core Services','IT - OSS-OPS-OAIM','IT - CRM','IT - Backup Admin','IT Enterprise Services & Support','IT - System Admin UNIX','IT - Database Admin','IT - System Admin WINDOWS','IT - Enterprise Systems (HMC)','IT - SAN Admin','IT - Retail Technical Support','IT - TSD IT','IT - NOC','IT - EDMS','IT - Corporate Technical Support','IT - Mission Critical Enterprise Systems & Service','IT - Desktop & System Support','IT - Citrix Support','IT - Security','IT - Sharepoint','IT - IP TV','IT - Roadshow Technical Support','IAM - IN') or name like '%L2%'))b on a.Assignment=b.Name order by B.Name;
exit;
EOF

echo "</TABLE>" >> $REPORTFILE_ASIS

echo $NEWLINE
echo $NEWLINE

echo "<html><P><font color="blue">
<br /><br />Please find below AS & IS ITSD Pending Input TT report  other than FMS  TTs  in <B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br />
<br /></P></html>" >> $REPORTFILE_ASIS

echo "<TABLE border="1">" >> $REPORTFILE_ASIS

echo "<TR><TH><font color="blue">Resolver Group</TH></font><TH><font color ="blue">0 days</TH></font><TH><font color ="blue">1 days</TH></font><TH><font color ="blue">2days</TH></font><TH><font color="blue">3 days</TH></font><TH><font color="blue">4 days</TH></font><TH><font color="blue">5 days</TH></font><TH><font color="blue">(6-10)days</TH></font><TH><font color="blue">>10 days</TH></font><TH><font color="blue">Total</TH></TR>" >> $REPORTFILE_ASIS
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_ASIS
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select case when incidents > 0 then   '<tr><td>'||b.Name||'</td><td align=center>'|| nvl(Zero,0)||'</td><td align=center>'||nvl(One,0)||'</td><td align=center>'||nvl(Two,0)||'</td><td align=center>'|| nvl(Three,0)||'</td><td align=center>'|| nvl(four,0)||'</td><td align=center>'|| nvl(five,0)||'</td><td align=center>'|| nvl(six_ten,0)||'</td><td align=center>'|| nvl(greater_ten,0)||'</td><th>'||to_char( nvl(incidents,0))||'</th></tr>' else null end From (select  Assignment, sum(Zero) Zero,sum(One) One,sum(Two) Two,sum(Three) Three,sum(Four) Four,sum(Five) Five,sum(six_ten) six_ten,sum(greater_ten) greater_ten,sum(incidents) incidents from (
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
from HPSM94BKPADMIN.Probsummarym1
 where PROBLEM_STATUS  in ('Pending Input') and folder in ('ITSD') and category not in ('FMS') and du_master_tt is NULL) group by Assignment) a right join (select distinct name from HPSM94BKPADMIN.AssignmentA1 where ( name in ('IT SMS GW','IT - Remote Technical Support','IT - MNP Application Support','KMUCC Support','DuVerse Access','ITOC-Maximo-UAM','FNL_OPs','IT - BSCS Provisioning','RSS Support Group','IT - DB Systems (L1)','IT - SAN (L1)','IT - Unix System (L1)','ITOC-Execution-IN','ITOC-Execution-Infra','ITOC-Execution-Apps','IT - Business Application Access','IT - Managed Printing Service','IT - Technical Hardware Support (Jumbo Support)','IT - Dealer Hardware Support (Jumbo Support)','IAM Operations','IT - 2FA','IT - Billing','IT DSP Application Support','IT - DB SAN UNIX Systems (L1)','IT - Enterprise Systems (L1)','NOC - IN','IT - Interconnect Billing','Bill Shock','Core - Mobile IN','IT-SQL DBA','IT - GIS','IT - ICS','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT - Corporate Technical Support Onshore','ITOC - User Access Management','IT- Payment Gateway','IT - POS','IT - Payment Gateway','IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT','IT - OSS-OPS- HPSM','IT - OSS-OPS-Mobile Provisioning','IT - OSS-OPS-Network Core Services','IT - OSS-OPS-OAIM','IT - CRM','IT - Backup Admin','IT Enterprise Services & Support','IT - System Admin UNIX','IT - Database Admin','IT - System Admin WINDOWS','IT - Enterprise Systems (HMC)','IT - SAN Admin','IT - Retail Technical Support','IT - TSD IT','IT - NOC','IT - EDMS','IT - Corporate Technical Support','IT - Mission Critical Enterprise Systems & Service','IT - Desktop & System Support','IT - Citrix Support','IT - Security','IT - Sharepoint','IT - IP TV','IT - Roadshow Technical Support','IAM - IN') or name like '%L2%'))b on a.Assignment=b.Name order by B.Name;
exit;
EOF

echo "</TABLE>" >> $REPORTFILE_ASIS

echo $NEWLINE
echo $NEWLINE




echo "<html><P><font color="blue">
<br /><br />Please find below AS & IS   Open FMS TTs  report  including Pending Input TTs in<B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br />
<br /></P></html>" >> $REPORTFILE_ASIS

echo "<TABLE border="1">" >> $REPORTFILE_ASIS

echo "<TR><TH><font color="blue">Resolver Group</TH></font><TH><font color ="blue">0 days</TH></font><TH><font color ="blue">1 days</TH></font><TH><font color ="blue">2days</TH></font><TH><font color="blue">3 days</TH></font><TH><font color="blue">4 days</TH></font><TH><font color="blue">5 days</TH></font><TH><font color="blue">(6-10)days</TH></font><TH><font color="blue">>10 days</TH></font><TH><font color="blue">Total</TH></TR>" >> $REPORTFILE_ASIS
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_ASIS
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select case when incidents > 0 then  '<tr><td>'||b.Name||'</td><td align=center>'|| nvl(Zero,0)||'</td><td align=center>'||nvl(One,0)||'</td><td align=center>'||nvl(Two,0)||'</td><td align=center>'|| nvl(Three,0)||'</td><td align=center>'|| nvl(four,0)||'</td><td align=center>'|| nvl(five,0)||'</td><td align=center>'|| nvl(six_ten,0)||'</td><td align=center>'|| nvl(greater_ten,0)||'</td><th>'||to_char( nvl(incidents,0))||'</th></tr>' else null end From
(select  Assignment, sum(Zero) Zero,sum(One) One,sum(Two) Two,sum(Three) Three,sum(Four) Four,sum(Five) Five,sum(six_ten) six_ten,sum(greater_ten) greater_ten,sum(incidents) incidents from (
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
from HPSM94BKPADMIN.Probsummarym1
where PROBLEM_STATUS not in ('Resolved','Closed','Rejected to Business')  and category in ('FMS') and du_master_tt is NULL) group by Assignment) a right join (select distinct name from HPSM94BKPADMIN.AssignmentA1 where ( name in ('IT SMS GW','DuVerse Access','IT - Remote Technical Support','IT - MNP Application Support','KMUCC Support','ITOC-Maximo-UAM','FNL_OPs','ITOC-Execution-IN','IT - BSCS Provisioning','RSS Support Group','ITOC-Execution-Infra','ITOC-Execution-Apps','IT - DB Systems (L1)','IT - SAN (L1)','IT - Unix System (L1)','IT - Business Application Access','IT - Billing','IT DSP Application Support','IT - DB SAN UNIX Systems (L1)','IT - Enterprise Systems (L1)','NOC - IN','IT - Interconnect Billing','Bill Shock','IT - Managed Printing Service','IT - Technical Hardware Support (Jumbo Support)','IT - Dealer Hardware Support (Jumbo Support)','IAM Operations','IT - 2FA','Core - Mobile IN','IT-SQL DBA','IT - GIS','IT - ICS','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT - Corporate Technical Support Onshore','ITOC - User Access Management','IT- Payment Gateway','IT - POS','IT - Payment Gateway','IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT','IT - OSS-OPS- HPSM','IT - OSS-OPS-Mobile Provisioning','IT - OSS-OPS-Network Core Services','IT - OSS-OPS-OAIM','IT - CRM','IT - Backup Admin','IT Enterprise Services & Support','IT - System Admin UNIX','IT - Database Admin','IT - System Admin WINDOWS','IT - Enterprise Systems (HMC)','IT - SAN Admin','IT - Retail Technical Support','IT - TSD IT','IT - NOC','IT - EDMS','IT - Corporate Technical Support','IT - Mission Critical Enterprise Systems & Service','IT - Desktop & System Support','IT - Citrix Support','IT - Security','IT - Sharepoint','IT - IP TV','IT - Roadshow Technical Support','IAM - IN') or name like '%L2%')) b on a.Assignment=b.Name order by B.Name;

exit;
EOF

echo "</TABLE>" >> $REPORTFILE_ASIS


echo $NEWLINE
echo $NEWLINE
#datestr=`date "+%d%m%y%H%M"`
date1=`date "+%d%m%y%H%M"`

echo "<html><P><font color="blue">Regards,<br />HPSM Support Team<br /><br />This is system auto generated mail,Please do not reply<br /></P></html>" >> $REPORTFILE_ASIS
echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_ASIS
echo "Content-Type: text/plain" >> $REPORTFILE_ASIS
echo "Content-Disposition: attachement; filename=all_open_tt41$date1.csv" >> $REPORTFILE_ASIS
#date1=`date`
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
set define off
spool all_open_tt41$date1.csv
-------------------All Open TT Incident extract------------------------------------
Select
'IncidentNo'
||','||'IncidentStatus'
||','||'Location'
||','||'SiebelReference'
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
||','||'TTtype'
||','||'Pending Code'
||','||'Brief Description'
from Dual
union ALL
select
"NUMBER"
||','||problem_status
||','||location
||','||reference_no
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
||','||du_tt_type
||','||pending_code
||','||dbms_lob.substr(brief_description,300)
from
HPSM94BKPADMIN.probsummarym1 a
where a.problem_status not in('Rejected to Business','Closed','Resolved') and a.du_master_tt is NULL and  ( a.Assignment in ('IT SMS GW','ITOC-Maximo-UAM','DuVerse Access','ITOC-Execution-IN','ITOC-Execution-Infra','ITOC-Execution-Apps','IT - MNP Application Support','IT - Business Application Access','IT - Billing','IT - Corporate Technical Support Onshore','KMUCC Support','FNL_OPs','IT - Remote Technical Support','RSS Support Group','IT - BSCS Provisioning','ITOC - User Access Management','NOC - IN','Bill Shock','Core - Mobile IN','IT - DB Systems (L1)','IT - SAN (L1)','IT - Unix System (L1)','IT-SQL DBA','IT - GIS','IT - ICS','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT - Interconnect Billing','IT - Payment Gateway','IT - POS' ,'IT - Datawarehouse','IT - ERP','IT - EAI','IT DSP Application Support','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT','IT - Managed Printing Service','IT - Technical Hardware Support (Jumbo Support)','IT - Dealer Hardware Support (Jumbo Support)','IAM Operations','IT - 2FA','IT - OSS-OPS-Mobile Provisioning','IT - DB SAN UNIX Systems (L1)','IT - Enterprise Systems (L1)','IT - OSS-OPS-Network Core Services' ,'IT - OSS-OPS-OAIM' ,'IT - CRM','IT - OSS-OPS- HPSM','IT - Backup Admin','IT Enterprise Services & Support','IT - System Admin UNIX','IT - Database Admin','IT - System Admin WINDOWS','IT - Enterprise Systems (HMC)','IT - SAN Admin','IT - Retail Technical Support','IT - TSD IT','IT - NOC','IT - EDMS','IT - Corporate Technical Support','IT - Mission Critical Enterprise Systems & Service','IT - Desktop & System Support','IT - Citrix Support','IT - Security','IT - Sharepoint','IT - IP TV','IT - Roadshow Technical Support','IAM - IN') or a.assignment like '%L2%');
spool off;
quit;
EOF

#echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_ASIS
#echo "Content-Type: text/plain" >> $REPORTFILE_ASIS
#echo "Content-Disposition: attachement; filename=all_open_AS_tt1.csv" >> $REPORTFILE_ASIS
#echo "" >> $REPORTFILE_ASIS
echo "" >> $REPORTFILE_ASIS
cat all_open_tt41$date1.csv >> $REPORTFILE_ASIS
cat $REPORTFILE_ASIS | /usr/lib/sendmail -t
