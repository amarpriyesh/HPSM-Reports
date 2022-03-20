cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/

REPORTFILE_ASIS=AS_reportNew4

#recipient="ankur.saxena@du.ae"
recipient="LaxmaReddy.Kompally@du.ae,Pavithra.G@du.ae,Sangeetha.Sathyanath1@du.ae,Sonali.Rawat@du.ae,Sanjay.Sharma@du.ae,Abhinav.rajpoot@du.ae,Rahul.Gupta1@du.ae,Sangeetha.Sathyanath@du.ae,Hemanta.Patra@du.ae,Joshi.Manasi@du.ae,Dinesh.Verma@du.ae,Anjalee.Singh@du.ae,Ratnesh.Jain@du.ae,Kushagra.Gupta@du.ae,Ilika.Srivastava@du.ae,Geet.Anand@du.ae,Deepak.Kumar1@du.ae,Srinivasa.Chakrvarhty@du.ae,Bismita.Nayak@du.ae,Srinivasa.Chakrvarhty@du.ae,Sandeep.Gupta@du.ae,Rajubhai.patel@du.ae,Tulika.ranjan@du.ae,Tanay.pandey@du.ae,Shailey.Narula@du.ae,Mayank.Srivastava@du.ae,Goldy.Kumar@du.ae,Nitin.Gupta@du.ae,Sheikh.Ali@du.ae,suman.chowdhary@du.ae,Rami.Khairy@du.ae,Sachin.Mittal@du.ae,Tamanna.Kataria@du.ae,rohit.sharma@du.ae,VinayPratap.Singh@du.ae,Anuj.Garg@du.ae,Malkeet.singh@du.ae,vijay.laxmi.singh@du.ae,Tirupathi.Reddy@du.ae,amit.shah@du.ae,Utkarsh.Jauhari@du.ae,Sesikapoor.Chitturi1@du.ae,Preem.Kumar@du.ae,Sandeep.Satpathy@du.ae,Venugopal.Thanuku@du.ae,Deependra.Sengar@du.ae,Anantharaman.Sekar@du.ae,Sharath.Kumar@du.ae,Sibadatta.Tripathy@du.ae,Ramdas.Pawar@du.ae,Gaurav.Gupta@du.ae,sudipta.roy@du.ae,ratnesh.jain@du.ae,satish.malla@du.ae,Prashant.Agarwal@du.ae,Danish.Habib@du.ae,Yash.B@du.ae,Deepak.saraswat@du.ae,Rahul.maheshwari@du.ae,Yash.B@du.ae,Sneha.Sinha@du.ae,himanshu.sharma@du.ae,ankur.saxena@du.ae,Shivani.Jarial@du.ae,Vinit.Verma@du.ae,ramakrishnan.m@du.ae,Kumaraswamy.KP@du.ae,Murgeshswamy.Mathad@du.ae,vijay.s@du.ae,Harinder.Saini@du.ae,Malineni.Venkata@du.ae,Sunil.Paladugu@du.ae,Jyoti.Charupalli@du.ae,Vino.John@du.ae,Rajiv.Sharma@du.ae,Dinesh.Verma@du.ae,Priyanka.Jain@du.ae,nagendra.singh@du.ae" 
#recipient1="mohammed.rezwanali@du.ae"
recipient1="Kapil.Kalra@du.ae,Anuj.Tyagi@du.ae,vinay.sethi1@du.ae,Ravinder.Agrawal@du.ae,vikas.k@du.ae,vannamuthu@du.ae,Layeeq.Pasha@du.ae,Gagan.Atreya@du.ae,Neeraj.Sharma@du.ae"

MailSubject="All Open AS & IS TT Report @ `date \"+%d/%m/%Y %H:%M\"`"

OUTPUTFLAG=HTML

rm AS_reportNew4

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

echo "<html><P><font color="blue">
Dear All,<br /><br />Please find below AS & IS Open TT report other than FMS & Pending Input TTs in <B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br />
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

select '<tr><td>'||b.Name||'</td><td align=center>'|| nvl(Zero,0)||'</td><td align=center>'||nvl(One,0)||'</td><td align=center>'||nvl(Two,0)||'</td><td align=center>'|| nvl(Three,0)||'</td><td align=center>'|| nvl(four,0)||'</td><td align=center>'|| nvl(five,0)||'</td><td align=center>'|| nvl(six_ten,0)||'</td><td align=center>'|| nvl(greater_ten,0)||'</td><th>'||to_char( nvl(incidents,0))||'</th></tr>' From (select  Assignment, sum(Zero) Zero,sum(One) One,sum(Two) Two,sum(Three) Three,sum(Four) Four,sum(Five) Five,sum(six_ten) six_ten,sum(greater_ten) greater_ten,sum(incidents) incidents from (
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
 where PROBLEM_STATUS not in ('Resolved','Closed','Pending Input','Rejected to Business') and category not in ('FMS') and du_master_tt is NULL) group by Assignment) a right join (select distinct name from HPSM94BKPADMIN.AssignmentA1 where name in ('IT - MNP Application Support','ITOC-Maximo-UAM','ITOC-Execution-IN','ITOC-Execution-Infra','ITOC-Execution-Apps','IT - Business Application Access','IT - Billing','IT DSP Application Support','NOC - IN','Bill Shock','Core - Mobile IN','IT-SQL DBA','IT - GIS','IT - ICS','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT - Corporate Technical Support Onshore','ITOC - User Access Management','IT- Payment Gateway','IT - POS','IT - Payment Gateway','IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT','IT - OSS-OPS- HPSM','IT - OSS-OPS-Mobile Provisioning','IT - OSS-OPS-Network Core Services','IT - OSS-OPS-OAIM','IT - CRM','IT - Backup Admin','IT Enterprise Services & Support','IT - System Admin UNIX','IT - Database Admin','IT - System Admin WINDOWS','IT - Enterprise Systems (HMC)','IT - SAN Admin','IT - Retail Technical Support','IT - TSD IT','IT - NOC','IT - EDMS','IT - Corporate Technical Support','IT - Mission Critical Enterprise Systems & Service','IT - Desktop & System Support','IT - Citrix Support','IT - Security','IT - Sharepoint','IT - IP TV','IT - Roadshow Technical Support'))b on a.Assignment=b.Name order by B.Name; 
exit;
EOF

echo "</TABLE>" >> $REPORTFILE_ASIS

echo $NEWLINE
echo $NEWLINE

echo "<html><P><font color="blue">
<br /><br />Please find below AS & IS Pending Input TTs report including FMS TTs in <B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br />
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

select '<tr><td>'||b.Name||'</td><td align=center>'|| nvl(Zero,0)||'</td><td align=center>'||nvl(One,0)||'</td><td align=center>'||nvl(Two,0)||'</td><td align=center>'|| nvl(Three,0)||'</td><td align=center>'|| nvl(four,0)||'</td><td align=center>'|| nvl(five,0)||'</td><td align=center>'|| nvl(six_ten,0)||'</td><td align=center>'|| nvl(greater_ten,0)||'</td><th>'||to_char( nvl(incidents,0))||'</th></tr>' From
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
where PROBLEM_STATUS in ('Pending Input') and du_master_tt is NULL) group by Assignment) a right join (select distinct name from HPSM94BKPADMIN.AssignmentA1 where name in ('IT - MNP Application Support','ITOC-Maximo-UAM','ITOC-Execution-IN','ITOC-Execution-Infra','ITOC-Execution-Apps','IT - Business Application Access','IT - Billing','NOC - IN','Bill Shock','Core - Mobile IN','IT-SQL DBA','IT - GIS','IT - ICS','IT - OSS-OPS-Fixed Mediation','IT DSP Application Support','IT - OSS-OPS-Mobile Mediation','IT - Corporate Technical Support Onshore','ITOC - User Access Management','IT - Payment Gateway','IT- Payment Gateway','IT - POS','IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT','IT - OSS-OPS- HPSM','IT - OSS-OPS-Mobile Provisioning','IT - OSS-OPS-Network Core Services','IT - OSS-OPS-OAIM','IT - CRM','IT - Backup Admin','IT Enterprise Services & Support','IT - System Admin UNIX','IT - Database Admin','IT - System Admin WINDOWS','IT - Enterprise Systems (HMC)','IT - SAN Admin','IT - Retail Technical Support','IT - TSD IT','IT - NOC','IT - EDMS','IT - Corporate Technical Support','IT - Mission Critical Enterprise Systems & Service','IT - Desktop & System Support','IT - Citrix Support','IT - Security','IT - Sharepoint','IT - IP TV','IT - Roadshow Technical Support') ) b on a.Assignment=b.Name order by B.Name; 
exit;
EOF

echo "</TABLE>" >> $REPORTFILE_ASIS


echo $NEWLINE
echo $NEWLINE

echo "<html><P><font color="blue">
<br /><br />Please find below AS & IS Open FMS TTs report other than pending input TTs in<B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br />
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

select '<tr><td>'||b.Name||'</td><td align=center>'|| nvl(Zero,0)||'</td><td align=center>'||nvl(One,0)||'</td><td align=center>'||nvl(Two,0)||'</td><td align=center>'|| nvl(Three,0)||'</td><td align=center>'|| nvl(four,0)||'</td><td align=center>'|| nvl(five,0)||'</td><td align=center>'|| nvl(six_ten,0)||'</td><td align=center>'|| nvl(greater_ten,0)||'</td><th>'||to_char( nvl(incidents,0))||'</th></tr>' From
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
where PROBLEM_STATUS not in ('Resolved','Closed','Pending Input','Rejected to Business') and category in ('FMS') and du_master_tt is NULL) group by Assignment) a right join (select distinct name from HPSM94BKPADMIN.AssignmentA1 where name in ('IT - MNP Application Support','ITOC-Maximo-UAM','ITOC-Execution-IN','ITOC-Execution-Infra','ITOC-Execution-Apps','IT - Business Application Access','IT - Billing','IT - Corporate Technical Support Onshore','ITOC - User Access Management','NOC - IN','Bill Shock','Core - Mobile IN','IT-SQL DBA','IT - GIS','IT DSP Application Support','IT - ICS','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT - Payment Gateway','IT- Payment Gateway','IT - POS','IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT','IT - OSS-OPS- HPSM','IT - OSS-OPS-Mobile Provisioning','IT - OSS-OPS-Network Core Services','IT - OSS-OPS-OAIM','IT - CRM','IT - Backup Admin','IT - Desktop & System Support','IT - System Admin UNIX','IT - Database Admin','IT - System Admin WINDOWS','IT - Enterprise Systems (HMC)','IT - SAN Admin','IT - Retail Technical Support','IT - TSD IT','IT - NOC','IT - EDMS','IT - Corporate Technical Support','IT - Mission Critical Enterprise Systems & Service','IT - Desktop & System Support','IT - Citrix Support','IT - Security','IT - Sharepoint','IT - IP TV','IT - Roadshow Technical Support') ) b on a.Assignment=b.Name order by B.Name;

exit;
EOF

echo "</TABLE>" >> $REPORTFILE_ASIS


echo $NEWLINE
echo $NEWLINE
echo "<html><P><font color="blue">Regards,<br />HPSM Support Team<br /><br />This is system auto generated mail,Please do not reply<br /></P></html>" >> $REPORTFILE_ASIS 
echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_ASIS
echo "Content-Type: text/plain" >> $REPORTFILE_ASIS
echo "Content-Disposition: attachement; filename=all_open_tt4.csv" >> $REPORTFILE_ASIS

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
set define off
spool all_open_tt4.csv
-------------------All Open TT Incident extract------------------------------------
Select
'IncidentNo'
||','||'IncidentStatus'
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
from Dual
union ALL
select
"NUMBER"
||','||problem_status
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
from
HPSM94BKPADMIN.probsummarym1 a
where a.problem_status not in('Rejected to Business','Closed','Resolved') and a.du_master_tt is NULL and a.Assignment in ('ITOC-Maximo-UAM','ITOC-Execution-IN','ITOC-Execution-Infra','ITOC-Execution-Apps','IT - MNP Application Support','IT - Business Application Access','IT - Billing','IT - Corporate Technical Support Onshore','ITOC - User Access Management','NOC - IN','Bill Shock','Core - Mobile IN','IT-SQL DBA','IT - GIS','IT - ICS','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT - Payment Gateway','IT - POS' ,'IT - Datawarehouse','IT - ERP','IT - EAI','IT DSP Application Support','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT','IT - OSS-OPS-Mobile Provisioning','IT - OSS-OPS-Network Core Services' ,'IT - OSS-OPS-OAIM' ,'IT - CRM','IT - OSS-OPS- HPSM','IT - Backup Admin','IT Enterprise Services & Support','IT - System Admin UNIX','IT - Database Admin','IT - System Admin WINDOWS','IT - Enterprise Systems (HMC)','IT - SAN Admin','IT - Retail Technical Support','IT - TSD IT','IT - NOC','IT - EDMS','IT - Corporate Technical Support','IT - Mission Critical Enterprise Systems & Service','IT - Desktop & System Support','IT - Citrix Support','IT - Security','IT - Sharepoint','IT - IP TV','IT - Roadshow Technical Support');
spool off;
quit;
EOF

#echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_ASIS
#echo "Content-Type: text/plain" >> $REPORTFILE_ASIS
#echo "Content-Disposition: attachement; filename=all_open_AS_tt1.csv" >> $REPORTFILE_ASIS
#echo "" >> $REPORTFILE_ASIS
echo "" >> $REPORTFILE_ASIS
cat all_open_tt4.csv >> $REPORTFILE_ASIS
cat $REPORTFILE_ASIS | /usr/lib/sendmail -t
