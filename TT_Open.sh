cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/

REPORTFILE_OPEN=AS_reportopen

recipient="utkarsh.jauhari@du.ae"

MailSubject="TTs Opened on Day @ `date -d '1 day ago' \"+%d/%m/%Y \"` per hour details"

OUTPUTFLAG=HTML

rm AS_reportopen

echo "Subject: $MailSubject
To: $recipient
Cc: $recipient1
MIMEV=\"MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
" >> $REPORTFILE_OPEN

echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_OPEN
echo "Content-Type: text/html" >> $REPORTFILE_OPEN
echo "Content-Disposition: inline" >> $REPORTFILE_OPEN
echo "" >> $REPORTFILE_OPEN

echo "<html><P><font color="blue">
Dear All,<br /><br />Please find below the TT opened last day per hour<br />
<br /></P></html>" >> $REPORTFILE_OPEN

echo "<TABLE border="1">" >> $REPORTFILE_OPEN

echo "<TR><TH><font color="blue">Resolver Group</TH></font><TH><font color ="blue">0 hour</TH></font><TH><font color ="blue">1 hour</TH></font><TH><font color ="blue">2
hour</TH></font><TH><font color="blue">3 hour</TH></font><TH><font color="blue">4 hour</TH></font><TH><font color="blue">5 hour</TH></font><TH><font color="blue">6 hour</TH></font><TH><font color="blue">7 hour</TH></font><TH><font color="blue">8 hour</TH></font><TH><font color="blue">9 hour</TH></font><TH><font color="blue">10 hour</TH></font><TH><font color="blue">11 hour</TH></font><TH><font color="blue">12 hour</TH></font><TH><font color="blue">13 hour</TH></font><TH><font color="blue">14 hour</TH></font><TH><font color="blue">15 hour</TH></font><TH><font color="blue">16 hour</TH></font><TH><font color="blue">17 hour</TH></font><TH><font color="blue">18 hour</TH></font><TH><font color="blue">19 hour</TH></font><TH><font color="blue">20 hour</TH></font><TH><font color="blue">21 hour</TH></font><TH><font color="blue">22 hour</TH></font><TH><font color="blue">23 hour</TH></font><TH><font color="blue">Total</TH></TR>" >> $REPORTFILE_OPEN
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_OPEN
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td>'||b.Name||'</td><td align=center>'|| nvl(Zero,0)||'</td><td align=center>'||nvl(One,0)||'</td><td align=center>'||nvl(Two,0)||'</td><td align=center>'|| nvl(Three,0)||'</td><td align=center>'|| nvl(Four,0)||'</td><td align=center>'|| nvl(Five,0)||'</td><td align=center>'|| nvl(Six,0)||'</td><td align=center>'|| nvl(Seven,0)||'</td><td align=center>'|| nvl(Eight,0)||'</td><td align=center>'|| nvl(Nine,0)||'</td><td align=center>'|| nvl(Ten,0)||'</td><td align=center>'|| nvl(Eleven,0)||'</td><td align=center>'|| nvl(Twelve,0)||'</td><td align=center>'|| nvl(Thirteen,0)||'</td><td align=center>'|| nvl(Fourteen,0)||'</td><td align=center>'|| nvl(Fifteen,0)||'</td><td align=center>'|| nvl(Sixteen,0)||'</td><td align=center>'|| nvl(Seventeen,0)||'</td><td align=center>'|| nvl(Eighteen,0)||'</td><td align=center>'|| nvl(Nineteen,0)||'</td><td align=center>'|| nvl(Twenty,0)||'</td><td align=center>'|| nvl(TwentyOne,0)||'</td><td align=center>'|| nvl(TwentyTwo,0)||'</td><td align=center>'|| nvl(TwentyThree,0)||'</td><th>'||to_char( nvl(incidents,0))||'</th></tr>' From
(select  Assignment, sum(Zero) Zero,sum(One) One,sum(Two) Two,sum(Three) Three,sum(Four) Four,sum(Five) Five,sum(Six) Six,sum(Seven) Seven,sum(Eight) Eight,sum(Nine) Nine,sum(Ten) Ten,sum(Eleven) Eleven,sum(Twelve) Twelve,sum(Thirteen) Thirteen,sum(Fourteen) Fourteen,sum(Fifteen) Fifteen,sum(Sixteen) Sixteen,sum(Seventeen) Seventeen,sum(Eighteen) Eighteen,sum(Nineteen) Nineteen,sum(Twenty) Twenty,sum(TwentyOne) TwentyOne,sum(TwentyTwo) TwentyTwo,sum(TwentyThree) TwentyThree,sum(incidents) incidents from (
  select
  Assignment
  ,decode (to_char((open_time+4/24),'HH24'),0,1,0) Zero
  ,decode (to_char((open_time+4/24),'HH24'),1,1,0) One
  ,decode (to_char((open_time+4/24),'HH24'),2,1,0) Two
  ,decode (to_char((open_time+4/24),'HH24'),3,1,0) Three
  ,decode (to_char((open_time+4/24),'HH24'),4,1,0) Four
  ,decode (to_char((open_time+4/24),'HH24'),5,1,0) Five
  ,decode (to_char((open_time+4/24),'HH24'),6,1,0) Six
  ,decode (to_char((open_time+4/24),'HH24'),7,1,0) Seven
  ,decode (to_char((open_time+4/24),'HH24'),8,1,0) Eight
  ,decode (to_char((open_time+4/24),'HH24'),9,1,0) Nine
  ,decode (to_char((open_time+4/24),'HH24'),10,1,0) Ten
  ,decode (to_char((open_time+4/24),'HH24'),11,1,0) Eleven
  ,decode (to_char((open_time+4/24),'HH24'),12,1,0) Twelve
  ,decode (to_char((open_time+4/24),'HH24'),13,1,0) Thirteen
  ,decode (to_char((open_time+4/24),'HH24'),14,1,0) Fourteen
  ,decode (to_char((open_time+4/24),'HH24'),15,1,0) Fifteen
  ,decode (to_char((open_time+4/24),'HH24'),16,1,0) Sixteen
  ,decode (to_char((open_time+4/24),'HH24'),17,1,0) Seventeen
  ,decode (to_char((open_time+4/24),'HH24'),18,1,0) Eighteen
  ,decode (to_char((open_time+4/24),'HH24'),19,1,0) Nineteen
  ,decode (to_char((open_time+4/24),'HH24'),20,1,0) Twenty
  ,decode (to_char((open_time+4/24),'HH24'),21,1,0) TwentyOne
  ,decode (to_char((open_time+4/24),'HH24'),22,1,0) TwentyTwo
  ,decode (to_char((open_time+4/24),'HH24'),23,1,0) TwentyThree
  , 1 Incidents
from HPSM94BKPADMIN.Probsummarym1
where (open_time+4/24) between (TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD') - 1) and TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD')) group by Assignment) a right join (select distinct name from HPSM94BKPADMIN.AssignmentA1 where name in ('IT - MNP Application Support','ITOC-Maximo-UAM','ITOC-Execution-IN','ITOC-Execution-Infra','ITOC-Execution-Apps','IT - Business Application Access','IT - Billing','IT - Corporate Technical Support Onshore','ITOC - User Access Management','NOC - IN','Bill Shock','Core - Mobile IN','IT-SQL DBA','IT - GIS','IT DSP Application Support','IT - ICS','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT - Payment Gateway','IT- Payment Gateway','IT - POS','IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OSS-OPS-Fault/Performance MGMT','IT - OSS-OPS- HPSM','IT - OSS-OPS-Mobile Provisioning','IT - OSS-OPS-Network Core Services','IT - OSS-OPS-OAIM','IT - CRM','IT - Backup Admin','IT - Desktop & System Support','IT - System Admin UNIX','IT - Database Admin','IT - System Admin WINDOWS','IT - Enterprise Systems (HMC)','IT - SAN Admin','IT - Retail Technical Support','IT - TSD IT','IT - NOC','IT - EDMS','IT - Corporate Technical Support','IT - Mission Critical Enterprise Systems & Service','IT - Desktop & System Support','IT - Citrix Support','IT - Security','IT - Sharepoint','IT - IP TV','IT - Roadshow Technical Support','IAM - IN') ) b on a.Assignment=b.Name order by B.Name;

exit;
EOF

echo "</TABLE>" >> $REPORTFILE_OPEN


cat $REPORTFILE_OPEN | /usr/lib/sendmail -t

