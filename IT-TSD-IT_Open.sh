cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/
REPORTFILE=IT_TSD_Report
#recipient="nihalchand.dehury@du.ae"
recipient="Rameya.Jeyakumar@du.ae,Nandini.Nagaraju@du.ae,Shwetha.Ranjini@du.ae,Edward.Paul@du.ae,Praveen.Naidu@du.ae,Praveen.Singu@du.ae,Winner.Viagularaj@du.ae,Mohitha.Ambati@du.ae,Sankar.Kotla@du.ae,Mansoor.A@du.ae,Midhun.Antony@du.ae,Mugtaba.Ahmed@du.ae,Madhuri.J@du.ae,Mohamed.Imam@du.ae,Iqbal.Khan@du.ae,Kavitha.Rajput@du.ae,Ramana.Reddy@du.ae,HariKrishna.Reddy@du.ae,Kamalakar.Mamidala@du.ae,Aruna.Pradhan@du.ae,Hari.Mandadapu@du.ae,Nareen.Shaganti@du.ae,Sofia.Begum@du.ae,BalaMurali.Krishna@du.ae"

MailSubject="ITSD Incident-NULL Q TT Report  @ `date \"+%d/%m/%Y %H:%M\"`"

OUTPUTFLAG=HTML

echo "Subject: $MailSubject
To: $recipient
MIMEV=\"MIME-Version: 1.0
Content-Type: text/html
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
" > $REPORTFILE




echo "<html><P><font color="blue">Dear All,<br /><br />Please find below IT TSD IT TT report<B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X
`<br />****
******
**********
**********************************************<br /></P></html>" >> $REPORTFILE

cat $REPORTFILE
echo "<TABLE border="1">" >> $REPORTFILE
echo "<TR><TH><font color="blue">Incident Number</TH></font><TH><font color ="blue">Opened By</TH></font><TH><font color ="blue">Location</TH></font>
<TH><font color="blue">Status</TH></font><TH><font color="blue">Assignee</TH></font>
<TH><font color="blue">Category</TH></font><TH><font color="blue">Area</TH>
</font><TH><font color ="blue">SubArea</TH></font><TH><font color ="blue">OpenTime</TH></font>
<TH><font color ="blue">Age in Minutes</TH></font></TR>" >> $REPORTFILE

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE
set linesize 150;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;

select '<tr><td>'||a."NUMBER"||'</td><td align=center>'||b.du_fullname||'</td><td align=center>'||b.location||'</td>
<td align=center>'||a.problem_status||'</td><td align=center>'||a.assignee_name||'</td><td align=center>'||a.category||'</td><td>'||a.subcategory||'</td>
<td align=center>'||a.product_type||'</td><td>'||TO_CHAR(a.open_time+4/24,'DD-MON-YYYY HH24:MI:SS')||'</td>
<td>'||round(((sysdate)-to_date(TO_CHAR(a.UPDATE_TIME+4/24,'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS'))*(24*60),2)||'</td></tr>'
from probsummarym1 a,incidentsm1 b ,screlationm1 c
where b.incident_id=c.depend(+) and 
c.source=a."NUMBER" and a.problem_status not in ('Closed','Resolved','Rejected to Business') 
and a.assignment='IT - TSD IT' and (a.assignee_name is null or a.problem_status in ('Accepted','In Progress'))
and round(((sysdate)-to_date(TO_CHAR(a.update_time+4/24,'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS'))*(24*60),2)>30;

exit;
EOF


echo "</TABLE>" >> $REPORTFILE
echo $NEWLINE
echo $NEWLINE


echo "<html><P><font color="blue"><br /><br />Please find below IT – Corporate Technical Support TT report<B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br />********************
******
**********
**********************************************<br /></P></html>" >> $REPORTFILE

cat $REPORTFILE
echo "<TABLE border="1">" >> $REPORTFILE
echo "<TR><TH><font color="blue">Incident Number</TH></font><TH><font color ="blue">Priority</TH></font><TH><font color ="blue">Resolver Group</TH></font>
<TH><font color="blue">Status</TH></font><TH><font color="blue">Assignee</TH></font><TH><font color="blue">TT Type</TH>
</font><TH><font color ="blue">OpenTime</TH></font>
<TH><font color ="blue">Age in Minutes</TH></font></TR>" >> $REPORTFILE


sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE
set linesize 150;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;

select '<tr><td>'||a."NUMBER"||'</td><td align=center>'||a.priority_code||'</td>
<td align=center>'||a.assignment||'</td><td align=center>'||a.problem_status||'</td>
<td align=center>'||a.assignee_name||'</td><td>'||a.du_tt_type||'</td><td>'||TO_CHAR(a.open_TIME+4/24,'DD-MON-YYYY HH24:MI:SS')||'</td>
<td>'||round(((sysdate)-to_date(TO_CHAR(a.UPDATE_time+4/24,'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS'))*(24*60),2)||'</td></tr>'
from probsummarym1 a
where a.problem_status not in ('Closed','Resolved','Rejected to Business') 
and a.assignment='IT - Corporate Technical Support' and (a.assignee_name is null or a.problem_status in ('Accepted','In Progress'))
and round(((sysdate)-to_date(TO_CHAR(a.update_time+4/24,'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS'))*(24*60),2)>30;
exit;
EOF


echo "</TABLE>" >> $REPORTFILE
echo $NEWLINE
echo $NEWLINE



echo "<html><P><font color="blue">Regards,<br />HPSM Support Team<br /><br />This is system auto generated mail,Please do not reply<br /></P></html>" >> $REP
ORTFILE

cat $REPORTFILE
cnt=`grep 'IM' IT_TSD_Report | wc -l`
if [ $cnt -gt 2 ]
then
cd /usr/sbin
sendmail -t < /hpsm/hpsm/ops/IT_TSD_Report
fi
#exit 0
