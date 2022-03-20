cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/
REPORTFILE=Reopen_Report
##recipient="nihalchand.dehury@du.ae,anusha.y@du.ae"
recipient="nihalchand.dehury@du.ae,anusha.y@du.ae,Edward.Paul@du.ae,Nareen.Shaganti@du.ae,Praveen.Naidu@du.ae,Shwetha.Ranjini@du.ae,Praveen.Singu@du.ae,Hari.Mandadapu@du.ae,Mohitha.Ambati@du.ae,Sankar.Kotla@du.ae,Mansoor.A@du.ae,Midhun.Antony@du.ae,Mugtaba.Ahmed@du.ae,Sofia.Begum@du.ae,Madhuri.J@du.ae,Mohamed.Imam@du.ae,Kavitha.Rajput@du.ae,Iqbal.Khan@du.ae,Winner.Viagularaj@du.ae"

MailSubject="Daily Reopen TTs @ `date \"+%d/%m/%Y %H:%M\"`"

OUTPUTFLAG=HTML

echo "Subject: $MailSubject
To: $recipient
MIMEV=\"MIME-Version: 1.0
Content-Type: text/html
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
" > $REPORTFILE



echo "<html><P><font color="blue"><br /><br />Please find below Reopen TT report<B><U> for Today </U></B> as on `date +%d/%m/%y-%X`<br 
/>
****
******
**********
**********************************************<br /></P></html>" >> $REPORTFILE

cat $REPORTFILE
echo "<TABLE border="1">" >> $REPORTFILE
echo "<TR><TH><font color="blue">Incident No</TH></font><TH><font color ="blue">Interaction No</TH></font><TH><font color ="blue">Status</TH></font>
<TH><font color="blue">Priority</TH></font><TH><font color="blue">Opened By</TH>
</font><TH><font color ="blue">Reopen Time</TH></font><TH><font color ="blue">Assignee</TH></font>
<TH><font color ="blue">Resolver Group</TH></font></TR>" >> $REPORTFILE


sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE
set linesize 150;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;

select '<tr><td align=center>'||b."NUMBER"||'</td><td align=center>'||a.incident_id||'</td><td align=center>'||a.open||'</td>
<td align=center>'||b.priority_code||'</td><td>'||a.OPENED_BY||'</td>
<td align=center>'||to_char(b.REOPEN_TIME+4/24, 'mm/dd/yyyy HH24:MI:SS')||'</td><td align=center>'||b.ASSIGNEE_NAME||'</td>
<td align=center>'||b.assignment||'</td></tr>'
from incidentsm1 a,probsummarym1 b,screlationm1 c
where a.incident_id=c.depend(+) and
c.source=b."NUMBER" and trunc(b.REOPEN_TIME)=trunc(sysdate-1) and b.folder='ITSD'
and (a.RESOLVE_TIME >b.REOPEN_TIME or open not in ('Closed','Resolved'));

exit;
EOF


echo "</TABLE>" >> $REPORTFILE
echo $NEWLINE
echo $NEWLINE


echo "<html><P><font color="blue">Regards,<br />HPSM Support Team<br /><br />This is system auto generated mail,Please do not reply<br /></P></html>" >> $REP
ORTFILE

cat $REPORTFILE
cnt=`grep 'SD' Reopen_Report | wc -l`
if [ $cnt -gt 2 ]
then
cd /usr/sbin
sendmail -t < /hpsm/hpsm/ops/Reopen_Report
fi
#exit 0
