cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/

REPORTFILE_ASIS=PendingDevReport

recipient="Ibrahim.Jebai@du.ae,John.Mathew@du.ae,Mohamed.Alshemsi@du.ae,Amr.Sorour@du.ae,Rajashree.Bhatt@du.ae,Gagan.Atreya@du.ae,Rishi.Ghai@du.ae,utkarsh.jauhari@du.ae,ITOperationsEricssonOnsiteApps@du.ae"
recipient1="Ibrahim.AlHammadi@du.ae,Moatasem.Salama@du.ae,Kapil.Kalra@du.ae,Ravinder.Agrawal@du.ae,Neeraj.Sharma@du.ae"

MailSubject="All Pending Dev TTs Report @ `date \"+%d/%m/%Y %H:%M\"`"

OUTPUTFLAG=HTML

rm PendingDevReport

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
 where PROBLEM_STATUS not in ('Resolved','Closed','Rejected to Business') and trunc(open_time)>='01-Nov-2015') group by Assignment) a, (select distinct name from HPSM94BKPADMIN.AssignmentA1 where upper(name) like '%DEV%' or name like 'IT - Siebel (CRM)%Atos' or name='IT - Billing BSCS - ATOS' or name like '%Ops L3%') b where a.Assignment=b.Name order by B.Name; 
exit;
EOF

echo "</TABLE>" >> $REPORTFILE_ASIS

echo $NEWLINE

echo $NEWLINE
echo "<html><P><font color="blue">Regards,<br />HPSM Support Team<br /><br />This is system auto generated mail,Please do not reply<br /></P></html>" >> $REPORTFILE_ASIS 
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
||','||'Reassign Count'
||','||'Brief Description'
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
||','||"COUNT"
||','||(REPLACE(REPLACE (REPLACE (DBMS_LOB.SUBSTR ( brief_description, 2000, 1),CHR (10),' '),CHR (13),' '),CHR (9),' '))
from
HPSM94BKPADMIN.probsummarym1 a
where a.problem_status in('Open','Accepted','In Progress','Pending Input','Rejected','ReAssigned','Reopened') and (upper(a.assignment) like '%DEV%' or assignment like 'IT - Siebel (CRM)%Atos' or a.assignment='IT - Billing BSCS - ATOS' or a.assignment like '%Ops L3%') and trunc(open_time)>='01-Nov-2015';
spool off;
quit;
EOF

echo "" >> $REPORTFILE_ASIS
cat Pending_Dev_TT.csv >> $REPORTFILE_ASIS
cat $REPORTFILE_ASIS | /usr/lib/sendmail -t
