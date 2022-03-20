cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/

REPORTFILE_open=open_reportNew41

#recipient="ankur.saxena@du.ae"
recipient="priyesh.a@du.ae,neeraj.sharma@du.ae,rahul.gupta1@du.ae,gagan.atreya@du.ae,sanjay.sharma@du.ae,tanuj.kumar@du.ae,ashish.panditha@du.ae"
recipient1="ankur.saxena@du.ae"

MailSubject="Open Hourly TT report @ `date \"+%d/%m/%Y %H:%M\"`"

OUTPUTFLAG=HTML

rm open_reportNew41

echo "Subject: $MailSubject
To: $recipient
Cc: $recipient1
MIMEV=\"MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw" 
Content-Disposition: inline
" >> $REPORTFILE_open

echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_open
echo "Content-Type: text/html" >> $REPORTFILE_open
echo "Content-Disposition: inline" >> $REPORTFILE_open
echo "" >> $REPORTFILE_open

echo "<html><P><font color="blue">
Dear All,<br /><br />Please find below Hourly Open TTs Report  in  <B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br />
<br /></P></html>" >> $REPORTFILE_open

echo "<TABLE border="1">" >> $REPORTFILE_open
 
echo "<TR><TH><font color="blue">Resolver Group</TH></font><TH><font color ="blue">0 to 6 HR</TH></font><TH><font color ="blue">6 to 9 HR</TH></font><TH><font color ="blue">9 to 11 HR</TH></font><TH><font color="blue">11 to 13 HR</TH></font><TH><font color="blue">13 to 15 HR</TH></font><TH><font color="blue">15 to 17 HR</TH></font><TH><font color="blue">17 to 19 HR</TH></font><TH><font color="blue">19 to 21 HR</TH></font><TH><font color="blue">21 to 24 HR</TH></font><TH><font color="blue">Total</TH></TR>" >> $REPORTFILE_open 
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_open
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td>'||b.assignment||'</td><td align=center>'||sum(b.dsp_6)||'</td><td align=center>'||sum(b.dsp_9)||'</td><td align=center>'||sum(b.dsp_11)||'</td><td align=center>'|| sum(b.dsp_13)||'</td><td align=center>'||sum(b.dsp_15)||'</td><td align=center>'|| sum(b.dsp_17)||'</td><td align=center>'|| sum(b.dsp_19)||'</td><td align=center>'|| sum(b.dsp_21) ||'</td><td align=center>'||sum(b.dsp_24)||'</td><th>'||sum(b.dsp_tot)||'</th></tr>'  
 from  (select
distinct("NUMBER") as nm1,
case when  description like '%Incident Opened with IT DSP Application Support Assignment%' then 'IT DSP Application Support' when  description like '%Incident Opened with IT - CRM Assignment%' then 'IT - CRM' when  description like '%Incident Opened with IT - Billing Assignment%' then 'IT - Billing' else   NULL end   as assignment,
case when ( datestamp+4/24 >(trunc(sysdate)+0.001/24) and  datestamp+4/24 <=(trunc(sysdate)+6/24))   then 1 else 0 end as dsp_6 ,
case when ( datestamp+4/24 >(trunc(sysdate)+6/24) and  datestamp+4/24 <=(trunc(sysdate)+9/24))   then 1 else 0 end as dsp_9 ,
case when ( datestamp+4/24 >(trunc(sysdate)+9/24) and  datestamp+4/24 <=(trunc(sysdate)+11/24))   then 1 else 0 end as dsp_11 ,
case when ( datestamp+4/24 >(trunc(sysdate)+11/24) and  datestamp+4/24 <=(trunc(sysdate)+13/24))   then 1 else 0 end as dsp_13 ,
case when ( datestamp+4/24 >(trunc(sysdate)+13/24) and  datestamp+4/24 <=(trunc(sysdate)+15/24))   then 1 else 0 end as dsp_15 ,
case when ( datestamp+4/24 >(trunc(sysdate)+15/24) and  datestamp+4/24 <=(trunc(sysdate)+17/24))   then 1 else 0 end as dsp_17 ,
case when ( datestamp+4/24 >(trunc(sysdate)+17/24) and  datestamp+4/24 <=(trunc(sysdate)+19/24))   then 1 else 0 end as dsp_19 ,
case when ( datestamp+4/24 >(trunc(sysdate)+19/24) and  datestamp+4/24 <=(trunc(sysdate)+21/24))   then 1 else 0 end as dsp_21 ,
case when ( datestamp+4/24 >(trunc(sysdate)+21/24) and  datestamp+4/24 <=(trunc(sysdate)+24/24))   then 1 else 0 end as dsp_24 ,
case when ( datestamp+4/24 >(trunc(sysdate)+0.001/24) and  datestamp+4/24 <(sysdate ))   then 1  else 0 end as dsp_tot 
from activitym1 where datestamp+4/24>(trunc(sysdate)+0.001/24) and type  ='Initial Assignment Group' and (description like '%Incident Opened with IT DSP Application Support Assignment%' or description like '%Incident Opened with IT - CRM Assignment%' or description like '%Incident Opened with IT - Billing Assignment%') ) b group by b.assignment ;
exit;
EOF

echo "</TABLE>" >> $REPORTFILE_open


#echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_open
#echo "Content-Type: text/plain" >> $REPORTFILE_open
#echo "" >> $REPORTFILE_open
echo "" >> $REPORTFILE_open
cat $REPORTFILE_open | /usr/lib/sendmail -t
