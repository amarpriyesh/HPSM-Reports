cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/

REPORTFILE_ASIS=PendingDevReport
#recipient="ankur.saxena@du.ae,priyesh.a@du.ae"
recipient="Osama.Anaqwah@du.ae,Prakash.M@du.ae,priyesh.a@du.ae,Ahmed.Jurmut1@du.ae,marwan.abdoh@du.ae,yasir.khattak1@du.ae,Imed.Bahloul@du.ae,Ahmed.Aqil@du.ae,Kamel.Amireche@du.ae,Kamel.Amireche@du.ae,Ratnesh.Jain@du.ae,Sandeep.Gupta@du.ae,Shailey.Rahul.Maheshwari@du.ae,Priyanka.Jain@du.ae,Rajashree.Bhatt@du.ae,Amer.Radwan@du.ae,Moatasem.Salama@du.ae,Mohamed.Alshemsi@du.ae,Beethin.Chakraborty@du.ae,Shahid.Bashir@du.ae,Shadi.Trad@du.ae,Kareem.AlQady@du.ae,Shyam.Nath@du.ae,Mohammad.Rasheed@du.ae,Muhammad.Yaseen@du.ae,LaxmaReddy.Kompally@du.ae,sandeep.gupta@du.ae,prasad.meesala@du.ae,lalit.gupta@du.ae,lakshmi.thevar@du.ae,ITOperationsEricssonOnsiteApps@du.ae,Ravikumar.Yadav@du.ae,Dhanasekar.Jeyaram@du.ae,Abid.ali@du.ae,Munagavasa.Rohit@du.ae,Kunal.Chandan@du.ae,Balbir.Sharma@du.ae,Rahul.Maheshwari@du.ae,Sandeep.Bhati@du.ae,Nadeem.Ahmad@du.ae,Nayan.Arya@du.ae,Gaurab.Rakshit1@du.ae,Yogesh.Lekhak1@du.ae,Sunil.Sonkusare@du.ae,Raghu.Chennuri1@du.ae,lalit.sharda2@du.ae,Prashant.Lokhande@du.ae"
recipient1="Ibrahim.Jebai@du.ae,Ibrahim.AlHammadi@du.ae,Rehan.Yasin@du.ae,Neeraj.Sharma@du.ae"
MailSubject="All Pending Dev TTs Report @ `date \"+%d/%m/%Y %H:%M\"`"

OUTPUTFLAG=HTML

rm PendingDevReport

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_ASIS
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;
-------------------Create Temp Table------------------------------------
create table TempTable1 as (select
"NUMBER",problem_status,pending_code,priority_code,assignment,assignee_name,OPEN_TIME,opened_by,category,subcategory,product_type,du_cust_accnumber,du_cust_value,du_contract_id,du_asset_number,DU_REOPENCOUNT,du_previous_assignment,"COUNT",(REPLACE(REPLACE (REPLACE (DBMS_LOB.SUBSTR ( brief_description, 2000, 1),CHR (10),' '),CHR (13),' '),CHR (9),' ')) as brief_description
from
HPSM94BKPADMIN.probsummarym1 a
where a.problem_status in ('Open','Accepted','In Progress','Pending Input','Rejected','ReAssigned','Reopened') and (upper(a.assignment) in ('SD_CPE','eShop_Dev','IT - PRIME - DEV','IT - OSS-DEV-Fixed Mediation','PM-CR ATOS - DEV TT','IT - IHTD','IT Staging Ops L3 TT','IT - BSCS (BILLING) - DEV','IT - BSS STREAMSERVE - DEV','IT - BSS POWERBILL - DEV','IT - BSS IN - DEV','DCS - DEV','IT - BSS STRONGMAIL - DEV','IT - PAYMENT GATEWAY - DEV','IT - POS - DEV','RA - MONETA - DEV','IT - ICS - DEV','IT - SIEBEL (CRM)  ATOS','IT - OMP - DEV','IT DSP DEV','IT - ESS MNMI - DEV','IT - EAI - DEV','IT - OSS-DEV-FIXED PROVISIONING','IT - OSS-DEV-MOBILE PROVISIONING','IT - OSS-DEV-MOBILE MEDIATION','IT - GIS - DEV','IT - OSS-DEV-OAIM','IT - OSS-DEV-NPG','MSDP - DEV','IT - DEV - IDASHBOARDS','IT - OSS-DEV- HPSM','CAMPAIGN MANAGEMENT - DEV','IT - EDMS - DEV','IT - ESS DUVERSE - DEV','IT - DATAWAREHOUSE - DEV','CUSTOMER PROFITABILITY - DEV','IT - ICM DEV','IT - ERP - DEV','IT - DEV - INTRANET','IT - EBUSINESS - DEV','DQ - DEV','UCM - DEV','IT - IWV - DEV','IT - ESS MOI - DEV') or a.assignment like '%Ops L3%' or assignment like 'IT - Siebel (CRM)%Atos' or assignment like '%eShop_Dev%' or assignment in ('FNL_DEV','FNL_SDM') or assignment in ('IT BSS Ops L4 TT','IT ESS Ops L4 TT','IT OSS Ops L4 TT','IT Dev SFA')) and open_time>='01-NOV-2015');

exit;
EOF

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
Dear All,<br /><br />Please find below Pending Dev TT report on `date +%d/%m/%y-%X`<br />
<br /></P></html>" >> $REPORTFILE_ASIS 

echo "<TABLE border="1">" >> $REPORTFILE_ASIS
 
echo "<TR><TH><font color="blue">Resolver Group</TH></font><TH><font color ="blue">0 days</TH></font><TH><font color ="blue">1 days</TH></font><TH><font color ="blue">2days</TH></font><TH><font color="blue">3 days</TH></font><TH><font color="blue">4 days</TH></font><TH><font color="blue">5 days</TH></font><TH><font color="blue">(6-10)days</TH></font><TH><font color="blue">10-15 days</TH></font><TH><font color="blue">15-20 days</TH></font><TH><font color="blue">20 - 30days</TH></font><TH><font color="blue">>30 days</TH></font><TH><font color="blue">Total</TH></TR>" >> $REPORTFILE_ASIS 
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_ASIS
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td>'||b.Name||'</td><td align=center>'|| nvl(Zero,0)||'</td><td align=center>'||nvl(One,0)||'</td><td align=center>'||nvl(Two,0)||'</td><td align=center>'|| nvl(Three,0)||'</td><td align=center>'|| nvl(four,0)||'</td><td align=center>'|| nvl(five,0)||'</td><td align=center>'|| nvl(six_ten,0)||'</td><td align=center>'|| nvl(eleven_fifteen,0)||'</td><td align=center>'|| nvl(sixteen_twenty,0)||'</td><td align=center>'|| nvl(twentyOne_thirty,0)||'</td><td align=center>'|| nvl(greater_thirty,0)||'</td><th>'||to_char( nvl(incidents,0))||'</th></tr>' From (select  Assignment, sum(Zero) Zero,sum(One) One,sum(Two) Two,sum(Three) Three,sum(Four) Four,sum(Five) Five,sum(six_ten) six_ten,sum(eleven_fifteen) eleven_fifteen,sum(sixteen_twenty) sixteen_twenty,sum(twentyOne_thirty) twentyOne_thirty,sum(greater_thirty) greater_thirty,sum(incidents) incidents from (
  select
  Assignment
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 0  then 1 else 0 end  Zero
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 1  then 1 else 0 end  One
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 2  then 1 else 0 end  Two
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 3  then 1 else 0 end  Three
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 4  then 1 else 0 end  Four
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 5  then 1 else 0 end  Five
  ,case when floor(trunc(sysdate+1)-(open_time+4/24)) between 6 and 10  then 1 else 0 end  six_ten
  ,case when floor(trunc(sysdate+1)-(open_time+4/24)) between 11 and 15  then 1 else 0 end  eleven_fifteen 
  ,case when floor(trunc(sysdate+1)-(open_time+4/24)) between 16 and 20  then 1 else 0 end  sixteen_twenty
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) between 21 and 30  then 1 else 0 end  twentyOne_thirty
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) > 30  then 1 else 0 end  greater_thirty
  , 1 Incidents
from HPSM94BKPADMIN.TempTable1
 where PROBLEM_STATUS not in ('Resolved','Closed','Rejected to Business') and open_time>='01-NOV-2015') group by Assignment) a, (select distinct name from HPSM94BKPADMIN.AssignmentA1 where upper(name) in ('IT - BSCS (BILLING) - DEV','eShop_Dev','IT - OSS-DEV-Fixed Mediation','IT - PRIME - DEV','IT Staging Ops L3 TT','IT - BSS STREAMSERVE - DEV','IT - BSS POWERBILL - DEV','DCS - DEV','IT - BSS STRONGMAIL - DEV','IT - PAYMENT GATEWAY - DEV','IT - POS - DEV','RA - MONETA - DEV','IT - ICS - DEV','IT - SIEBEL (CRM)  ATOS','IT - OMP - DEV','IT DSP DEV','IT - ESS MNMI - DEV','IT - EAI - DEV','IT - OSS-DEV-FIXED PROVISIONING','IT - OSS-DEV-MOBILE PROVISIONING','IT - OSS-DEV-MOBILE MEDIATION','IT - GIS - DEV','IT - OSS-DEV-OAIM','IT - OSS-DEV-NPG','MSDP - DEV','IT - DEV - IDASHBOARDS','IT - OSS-DEV- HPSM','CAMPAIGN MANAGEMENT - DEV','IT - EDMS - DEV','IT - ESS DUVERSE - DEV','IT - DATAWAREHOUSE - DEV','CUSTOMER PROFITABILITY - DEV','IT - ICM DEV','IT - ERP - DEV','IT - DEV - INTRANET','IT - EBUSINESS - DEV','DQ - DEV','UCM - DEV','IT - IWV - DEV','IT - ESS MOI - DEV','IT BSS Ops L4 TT','IT ESS Ops L4 TT','IT OSS Ops L4 TT','IT Dev SFA') or name like 'eShop_Dev' or name like 'IT - Siebel (CRM)%Atos') b where a.Assignment=b.Name order by B.Name; 
exit;
EOF

echo "</TABLE>" >> $REPORTFILE_ASIS

echo $NEWLINE

echo "<html><P><font color="blue">
<br /><br />Please find below Pending Operations L3 Tickets as on `date +%d/%m/%y-%X`<br />
<br /></P></html>" >> $REPORTFILE_ASIS

echo "<TABLE border="1">" >> $REPORTFILE_ASIS
 
echo "<TR><TH><font color="blue">Resolver Group</TH></font><TH><font color ="blue">0 days</TH></font><TH><font color ="blue">1 days</TH></font><TH><font color ="blue">2days</TH></font><TH><font color="blue">3 days</TH></font><TH><font color="blue">4 days</TH></font><TH><font color="blue">5 days</TH></font><TH><font color="blue">(6-10)days</TH></font><TH><font color="blue">10-15 days</TH></font><TH><font color="blue">15-20 days</TH></font><TH><font color="blue">20 - 30days</TH></font><TH><font color="blue">>30 days</TH></font><TH><font color="blue">Total</TH></TR>" >> $REPORTFILE_ASIS 
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_ASIS
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td>'||b.Name||'</td><td align=center>'|| nvl(Zero,0)||'</td><td align=center>'||nvl(One,0)||'</td><td align=center>'||nvl(Two,0)||'</td><td align=center>'|| nvl(Three,0)||'</td><td align=center>'|| nvl(four,0)||'</td><td align=center>'|| nvl(five,0)||'</td><td align=center>'|| nvl(six_ten,0)||'</td><td align=center>'|| nvl(eleven_fifteen,0)||'</td><td align=center>'|| nvl(sixteen_twenty,0)||'</td><td align=center>'|| nvl(twentyOne_thirty,0)||'</td><td align=center>'|| nvl(greater_thirty,0)||'</td><th>'||to_char( nvl(incidents,0))||'</th></tr>' From (select  Assignment, sum(Zero) Zero,sum(One) One,sum(Two) Two,sum(Three) Three,sum(Four) Four,sum(Five) Five,sum(six_ten) six_ten,sum(eleven_fifteen) eleven_fifteen,sum(sixteen_twenty) sixteen_twenty,sum(twentyOne_thirty) twentyOne_thirty,sum(greater_thirty) greater_thirty,sum(incidents) incidents from (
  select
  Assignment
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 0  then 1 else 0 end  Zero
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 1  then 1 else 0 end  One
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 2  then 1 else 0 end  Two
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 3  then 1 else 0 end  Three
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 4  then 1 else 0 end  Four
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 5  then 1 else 0 end  Five
  ,case when floor(trunc(sysdate+1)-(open_time+4/24)) between 6 and 10  then 1 else 0 end  six_ten
  ,case when floor(trunc(sysdate+1)-(open_time+4/24)) between 11 and 15  then 1 else 0 end  eleven_fifteen 
  ,case when floor(trunc(sysdate+1)-(open_time+4/24)) between 16 and 20  then 1 else 0 end  sixteen_twenty
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) between 21 and 30  then 1 else 0 end  twentyOne_thirty
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) > 30  then 1 else 0 end  greater_thirty
  , 1 Incidents
from HPSM94BKPADMIN.TempTable1
 where PROBLEM_STATUS not in ('Resolved','Closed','Rejected to Business') and open_time>='01-NOV-2015') group by Assignment) a right join (select distinct name from HPSM94BKPADMIN.AssignmentA1 where name like '%Ops L3%') b on a.Assignment=b.Name order by B.Name; 
exit;
EOF

echo "</TABLE>" >> $REPORTFILE_ASIS

echo $NEWLINE

echo "<html><P><font color="blue">
<br /><br />Please find below Pending L4 Tickets as on `date +%d/%m/%y-%X`<br />
<br /></P></html>" >> $REPORTFILE_ASIS

echo "<TABLE border="1">" >> $REPORTFILE_ASIS
 
echo "<TR><TH><font color="blue">Resolver Group</TH></font><TH><font color ="blue">0 days</TH></font><TH><font color ="blue">1 days</TH></font><TH><font color ="blue">2days</TH></font><TH><font color="blue">3 days</TH></font><TH><font color="blue">4 days</TH></font><TH><font color="blue">5 days</TH></font><TH><font color="blue">(6-10)days</TH></font><TH><font color="blue">10-15 days</TH></font><TH><font color="blue">15-20 days</TH></font><TH><font color="blue">20 - 30days</TH></font><TH><font color="blue">>30 days</TH></font><TH><font color="blue">Total</TH></TR>" >> $REPORTFILE_ASIS 
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_ASIS
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;
select '<tr><td>'||a.assignment||'</td><td align=center>'|| nvl(Zero,0)||'</td><td align=center>'||nvl(One,0)||'</td><td align=center>'||nvl(Two,0)||'</td><td align=center>'|| nvl(Three,0)||'</td><td align=center>'|| nvl(four,0)||'</td><td align=center>'|| nvl(five,0)||'</td><td align=center>'|| nvl(six_ten,0)||'</td><td align=center>'|| nvl(eleven_fifteen,0)||'</td><td align=center>'|| nvl(sixteen_twenty,0)||'</td><td align=center>'|| nvl(twentyOne_thirty,0)||'</td><td align=center>'|| nvl(greater_thirty,0)||'</td><th>'||to_char( nvl(incidents,0))||'</th></tr>' From (select  Assignment, sum(Zero) Zero,sum(One) One,sum(Two) Two,sum(Three) Three,sum(Four) Four,sum(Five) Five,sum(six_ten) six_ten,sum(eleven_fifteen) eleven_fifteen,sum(sixteen_twenty) sixteen_twenty,sum(twentyOne_thirty) twentyOne_thirty,sum(greater_thirty) greater_thirty,sum(incidents) incidents from (
  select
  Assignment
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 0  then 1 else 0 end  Zero
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 1  then 1 else 0 end  One
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 2  then 1 else 0 end  Two
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 3  then 1 else 0 end  Three
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 4  then 1 else 0 end  Four
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 5  then 1 else 0 end  Five
  ,case when floor(trunc(sysdate+1)-(open_time+4/24)) between 6 and 10  then 1 else 0 end  six_ten
  ,case when floor(trunc(sysdate+1)-(open_time+4/24)) between 11 and 15  then 1 else 0 end  eleven_fifteen
  ,case when floor(trunc(sysdate+1)-(open_time+4/24)) between 16 and 20  then 1 else 0 end  sixteen_twenty
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) between 21 and 30  then 1 else 0 end  twentyOne_thirty
  ,case when floor(trunc(sysdate+1)-(open_time+4/24)) > 30  then 1 else 0 end  greater_thirty
  , 1 Incidents
from HPSM94BKPADMIN.probsummarym1
 where PROBLEM_STATUS not in ('Resolved','Closed','Rejected to Business') and open_time>='01-NOV-2015' and assignment in ('IT BSS Ops L4 TT','IT OSS Ops L4 TT','IT ESS Ops L4 TT')) group by Assignment) a   order by A.assignment;
exit;
EOF

echo "</TABLE>" >> $REPORTFILE_ASIS

echo $NEWLINE

echo "<html><P><font color="blue">
<br /><br />Please find below Pending Design Issues or External Dependency TTs as on `date +%d/%m/%y-%X`<br />
<br /></P></html>" >> $REPORTFILE_ASIS

echo "<TABLE border="1">" >> $REPORTFILE_ASIS
 
echo "<TR><TH><font color="blue">Resolver Group</TH></font><TH><font color ="blue">0 days</TH></font><TH><font color ="blue">1 days</TH></font><TH><font color ="blue">2days</TH></font><TH><font color="blue">3 days</TH></font><TH><font color="blue">4 days</TH></font><TH><font color="blue">5 days</TH></font><TH><font color="blue">(6-10)days</TH></font><TH><font color="blue">10-15 days</TH></font><TH><font color="blue">15-20 days</TH></font><TH><font color="blue">20 - 30days</TH></font><TH><font color="blue">>30 days</TH></font><TH><font color="blue">Total</TH></TR>" >> $REPORTFILE_ASIS 
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_ASIS
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td>'||b.Name||'</td><td align=center>'|| nvl(Zero,0)||'</td><td align=center>'||nvl(One,0)||'</td><td align=center>'||nvl(Two,0)||'</td><td align=center>'|| nvl(Three,0)||'</td><td align=center>'|| nvl(four,0)||'</td><td align=center>'|| nvl(five,0)||'</td><td align=center>'|| nvl(six_ten,0)||'</td><td align=center>'|| nvl(eleven_fifteen,0)||'</td><td align=center>'|| nvl(sixteen_twenty,0)||'</td><td align=center>'|| nvl(twentyOne_thirty,0)||'</td><td align=center>'|| nvl(greater_thirty,0)||'</td><th>'||to_char( nvl(incidents,0))||'</th></tr>' From (select  Assignment, sum(Zero) Zero,sum(One) One,sum(Two) Two,sum(Three) Three,sum(Four) Four,sum(Five) Five,sum(six_ten) six_ten,sum(eleven_fifteen) eleven_fifteen,sum(sixteen_twenty) sixteen_twenty,sum(twentyOne_thirty) twentyOne_thirty,sum(greater_thirty) greater_thirty,sum(incidents) incidents from (
  select
  Assignment
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 0  then 1 else 0 end  Zero
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 1  then 1 else 0 end  One
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 2  then 1 else 0 end  Two
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 3  then 1 else 0 end  Three
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 4  then 1 else 0 end  Four
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 5  then 1 else 0 end  Five
  ,case when floor(trunc(sysdate+1)-(open_time+4/24)) between 6 and 10  then 1 else 0 end  six_ten
  ,case when floor(trunc(sysdate+1)-(open_time+4/24)) between 11 and 15  then 1 else 0 end  eleven_fifteen 
  ,case when floor(trunc(sysdate+1)-(open_time+4/24)) between 16 and 20  then 1 else 0 end  sixteen_twenty
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) between 21 and 30  then 1 else 0 end  twentyOne_thirty
  ,case when floor(trunc(sysdate+1)-(open_time+4/24)) > 30  then 1 else 0 end  greater_thirty
  , 1 Incidents
from HPSM94BKPADMIN.TempTable1
 where PROBLEM_STATUS not in ('Resolved','Closed','Rejected to Business') and open_time>='01-NOV-2015') group by Assignment) a right join (select distinct name from HPSM94BKPADMIN.AssignmentA1 where name in ('SD_CPE','IT - BSS IN - Dev','IT - IHTD','PM-CR Atos - Dev TT')) b on a.Assignment=b.Name order by B.Name; 
exit;
EOF

echo "</TABLE>" >> $REPORTFILE_ASIS

echo $NEWLINE

echo "<html><P><font color="blue">
<br /><br />Please find below Pending TTs on FNL groups as on `date +%d/%m/%y-%X`<br />
<br /></P></html>" >> $REPORTFILE_ASIS

echo "<TABLE border="1">" >> $REPORTFILE_ASIS
 
echo "<TR><TH><font color="blue">Resolver Group</TH></font><TH><font color ="blue">0 days</TH></font><TH><font color ="blue">1 days</TH></font><TH><font color ="blue">2days</TH></font><TH><font color="blue">3 days</TH></font><TH><font color="blue">4 days</TH></font><TH><font color="blue">5 days</TH></font><TH><font color="blue">(6-10)days</TH></font><TH><font color="blue">10-15 days</TH></font><TH><font color="blue">15-20 days</TH></font><TH><font color="blue">20 - 30days</TH></font><TH><font color="blue">>30 days</TH></font><TH><font color="blue">Total</TH></TR>" >> $REPORTFILE_ASIS 
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_ASIS
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td>'||b.Name||'</td><td align=center>'|| nvl(Zero,0)||'</td><td align=center>'||nvl(One,0)||'</td><td align=center>'||nvl(Two,0)||'</td><td align=center>'|| nvl(Three,0)||'</td><td align=center>'|| nvl(four,0)||'</td><td align=center>'|| nvl(five,0)||'</td><td align=center>'|| nvl(six_ten,0)||'</td><td align=center>'|| nvl(eleven_fifteen,0)||'</td><td align=center>'|| nvl(sixteen_twenty,0)||'</td><td align=center>'|| nvl(twentyOne_thirty,0)||'</td><td align=center>'|| nvl(greater_thirty,0)||'</td><th>'||to_char( nvl(incidents,0))||'</th></tr>' From (select  Assignment, sum(Zero) Zero,sum(One) One,sum(Two) Two,sum(Three) Three,sum(Four) Four,sum(Five) Five,sum(six_ten) six_ten,sum(eleven_fifteen) eleven_fifteen,sum(sixteen_twenty) sixteen_twenty,sum(twentyOne_thirty) twentyOne_thirty,sum(greater_thirty) greater_thirty,sum(incidents) incidents from (
  select
  Assignment
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 0  then 1 else 0 end  Zero
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 1  then 1 else 0 end  One
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 2  then 1 else 0 end  Two
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 3  then 1 else 0 end  Three
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 4  then 1 else 0 end  Four
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) = 5  then 1 else 0 end  Five
  ,case when floor(trunc(sysdate+1)-(open_time+4/24)) between 6 and 10  then 1 else 0 end  six_ten
  ,case when floor(trunc(sysdate+1)-(open_time+4/24)) between 11 and 15  then 1 else 0 end  eleven_fifteen 
  ,case when floor(trunc(sysdate+1)-(open_time+4/24)) between 16 and 20  then 1 else 0 end  sixteen_twenty
  , case when floor(trunc(sysdate+1)-(open_time+4/24)) between 21 and 30  then 1 else 0 end  twentyOne_thirty
  ,case when floor(trunc(sysdate+1)-(open_time+4/24)) > 30  then 1 else 0 end  greater_thirty
  , 1 Incidents
from HPSM94BKPADMIN.TempTable1
 where PROBLEM_STATUS not in ('Resolved','Closed','Rejected to Business') and open_time>='01-NOV-2015') group by Assignment) a right join (select distinct name from HPSM94BKPADMIN.AssignmentA1 where name in ('FNL_DEV','FNL_SDM')) b on a.Assignment=b.Name order by B.Name; 
exit;
EOF

echo "</TABLE>" >> $REPORTFILE_ASIS

echo "<html><P><font color="blue">
<br /><br />Please find below Reassignment TT Count as on `date +%d/%m/%y-%X`<br />
<br /></P></html>" >> $REPORTFILE_ASIS

echo $NEWLINE
echo $NEWLINE

echo "<TABLE border="1">" >> $REPORTFILE_ASIS
 
echo "<TR><TH><font color="blue">Number of times Reassigned</TH></font><TH><font color ="blue">Count</TH></TR>" >> $REPORTFILE_ASIS 
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_ASIS
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;
select '<tr><td><font color="blue">Reassign Count less than 3</font></td><td>'||count(*)||'</td></tr>' from TempTable1 where "COUNT"<3 and assignment not in ('FNL_DEV','FNL_OPs','FNL_SDM');
select '<tr><td><font color="blue">Reassign Count between 3 and 5</font></td><td>'||count(*)||'</td></tr>' from TempTable1 where "COUNT">=3 and "COUNT"<6 and assignment not in ('FNL_DEV','FNL_OPs','FNL_SDM');
select '<tr><td><font color="blue">Reassign Count between 6 and 8</font></td><td>'||count(*)||'</td></tr>' from TempTable1 where "COUNT">=6 and "COUNT"<9 and assignment not in ('FNL_DEV','FNL_OPs','FNL_SDM');
select '<tr><td><font color="blue">Reassign Count between 9 and 12</font></td><td>'||count(*)||'</td></tr>' from TempTable1 where "COUNT">=9 and "COUNT"<13 and assignment not in ('FNL_DEV','FNL_OPs','FNL_SDM');
select '<tr><td><font color="blue">Reassign Count more than 12</font></td><td>'||count(*)||'</td></tr>' from TempTable1 where "COUNT">=13 and assignment not in ('FNL_DEV','FNL_OPs','FNL_SDM');
exit;
EOF

echo "</TABLE>" >> $REPORTFILE_ASIS

echo "<html><P><font color="blue">
<br /><br />Please find below Aging  TT Count as on `date +%d/%m/%y-%X`<br />
<br /></P></html>" >> $REPORTFILE_ASIS

echo $NEWLINE
echo $NEWLINE

echo "<TABLE border="1">" >> $REPORTFILE_ASIS
 
echo "<TR><TH><font color="blue">Aging of TTs in Days</TH></font><TH><font color ="blue">Count</TH></TR>" >> $REPORTFILE_ASIS 
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_ASIS
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;
select '<tr><td><font color="blue">Aging in 10 to 15</font></td><td>'||count(*)||'</td></tr>' from TempTable1 where ((to_date(trunc(sysdate),' dd-mon-yyyy HH24:MI SS')-TO_DATE(open_time+4/24,'DD-MON-YYYY HH24:MI')) between 10 and 15) and assignment not in ('FNL_DEV','FNL_OPs','FNL_SDM');
select '<tr><td><font color="blue">Aging in 15 to 20</font></td><td>'||count(*)||'</td></tr>' from TempTable1 where ((to_date(trunc(sysdate),' dd-mon-yyyy HH24:MI SS')-TO_DATE(open_time+4/24,'DD-MON-YYYY HH24:MI')) between 15 and 20)  and assignment not in ('FNL_DEV','FNL_OPs','FNL_SDM');
select '<tr><td><font color="blue">Aging in 20 to 30</font></td><td>'||count(*)||'</td></tr>' from TempTable1 where ((to_date(trunc(sysdate),' dd-mon-yyyy HH24:MI SS')-TO_DATE(open_time+4/24,'DD-MON-YYYY HH24:MI')) between 20 and 30) and assignment not in ('FNL_DEV','FNL_OPs','FNL_SDM');
select '<tr><td><font color="blue">Aging in  30 +</font></td><td>'||count(*)||'</td></tr>' from TempTable1 where ((to_date(trunc(sysdate),' dd-mon-yyyy HH24:MI SS')-TO_DATE(open_time+4/24,'DD-MON-YYYY HH24:MI')) > 30 )  and assignment not in ('FNL_DEV','FNL_OPs','FNL_SDM');
exit;
EOF

echo "</TABLE>" >> $REPORTFILE_ASIS

echo $NEWLINE
echo $NEWLINE
echo $NEWLINE
echo "<html><P><font color="blue">Best Regards,<br />HPSM Support Team<br /><br />This is system auto generated mail,Please do not reply<br /></P></html>" >> $REPORTFILE_ASIS 
echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_ASIS
echo "Content-Type: text/plain" >> $REPORTFILE_ASIS
echo "Content-Disposition: attachement; filename=Pending_Dev_TT.csv" >> $REPORTFILE_ASIS

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
set define off
spool Pending_Dev_TT.csv
-------------------All Open TT Incident extract------------------------------------
Select
'IncidentNo'
||','||'IncidentStatus'
||','||'PendingCode'
||','||'priority'
||','||'CurrentResolverGroup'
||','||'AssigneeName'
||','||'OpenTime'
||','||'OpenedBy'
||','||'Category'
||','||'Area'
||','||'SubArea'
||','||'Customer Accountnumber'
||','||'Customer Value'
||','||'Contrtact ID'
||','||'Asset number'
||','||'Current Age of TT (No.of days)'
||','||'Assigned Time'
||','||'previous_assignment'
||','||'Reopen Count'
||','||'Reassign Count'
||','||'Brief Description'
from Dual
union ALL
select
"NUMBER"
||','||problem_status
||','||(case when problem_status='Pending Input' then pending_code else '' end)
||','||priority_code
||','||assignment
||','||assignee_name
||','||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||opened_by
||','||category
||','||subcategory
||','||product_type
||','||du_cust_accnumber
||','||du_cust_value
||','||du_contract_id
||','||du_asset_number
||','||(to_date(trunc(sysdate),' dd-mon-yyyy HH24:MI SS')-TO_DATE(open_time+4/24,'DD-MON-YYYY HH24:MI'))
||','||(select to_char(max(datestamp+4/24),'mm/dd/yyyy HH24:MI:SS') from activitym1 where "NUMBER"=a."NUMBER" and type in ('Rejected','ReAssigned','Reopened','Open','Rejected to Business'))
||','||du_previous_assignment
||','||DU_REOPENCOUNT
||','||"COUNT"
||','||(REPLACE(REPLACE (REPLACE (DBMS_LOB.SUBSTR ( brief_description, 2000, 1),CHR (10),' '),CHR (13),' '),CHR (9),' '))
from
HPSM94BKPADMIN.TempTable1 a
where a.problem_status in ('Open','Accepted','In Progress','Pending Input','Rejected','ReAssigned','Reopened') and (upper(a.assignment) in ('SD_CPE','eShop_Dev','IT - PRIME - DEV','IT Staging Ops L3 TT','IT - PRIME - DEV','IT - BSCS (BILLING) - DEV','IT - BSS STREAMSERVE - DEV','IT - IHTD','PM-CR ATOS - DEV TT','IT - BSS POWERBILL - DEV','IT - OSS-DEV-Fixed Mediation','IT - BSS IN - DEV','DCS - DEV','IT - BSS STRONGMAIL - DEV','IT - PAYMENT GATEWAY - DEV','IT - POS - DEV','RA - MONETA - DEV','IT - ICS - DEV','IT - SIEBEL (CRM)  ATOS','IT - OMP - DEV','IT DSP DEV','IT - ESS MNMI - DEV','IT - EAI - DEV','IT - OSS-DEV-FIXED PROVISIONING','IT - OSS-DEV-MOBILE PROVISIONING','IT - OSS-DEV-MOBILE MEDIATION','IT - GIS - DEV','IT - OSS-DEV-OAIM','IT - OSS-DEV-NPG','MSDP - DEV','IT - DEV - IDASHBOARDS','IT - OSS-DEV- HPSM','CAMPAIGN MANAGEMENT - DEV','IT - EDMS - DEV','IT - ESS DUVERSE - DEV','IT - DATAWAREHOUSE - DEV','CUSTOMER PROFITABILITY - DEV','IT - ICM DEV','IT - ERP - DEV','IT - DEV - INTRANET','IT - EBUSINESS - DEV','DQ - DEV','UCM - DEV','IT - IWV - DEV','IT - ESS MOI - DEV') or a.assignment like '%Ops L3%' or assignment like 'IT - Siebel (CRM)%Atos' or assignment like 'eShop_Dev' or assignment in ('FNL_DEV','FNL_SDM') or a.assignment in ('IT BSS Ops L4 TT','IT ESS Ops L4 TT','IT OSS Ops L4 TT','IT Dev SFA')) and open_time>='01-NOV-2015';
spool off;
quit;
EOF

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_ASIS
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;
DROP TABLE TempTable1 PURGE;
exit;
EOF

echo "" >> $REPORTFILE_ASIS
cat Pending_Dev_TT.csv >> $REPORTFILE_ASIS
cat $REPORTFILE_ASIS | /usr/lib/sendmail -t
