cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/
REPORTFILE1=Followup_report
#recipient="nihalchand.dehury@du.ae"
#recipient="mohammed.rezwanali@du.ae,Karthik.Reddy@du.ae,Rameya.Jeyakumar@du.ae,Nandini.Nagaraju@du.ae,Edward.Paul@du.ae,Nareen.Shaganti@du.ae,Praveen.Naidu@du.ae,Praveen.Singu@du.ae,Hari.Mandadapu@du.ae,Mohitha.Ambati@du.ae,Sankar.Kotla@du.ae,Mansoor.A@du.ae,Midhun.Antony@du.ae,Mugtaba.Ahmed@du.ae,Sofia.Begum@du.ae,Madhuri.J@du.ae,Mohamed.Imam@du.ae,Kavitha.Rajput@du.ae,Iqbal.Khan@du.ae,Winner.Viagularaj@du.ae"
MailSubject="ITSD Interaction TT Report(Followup) @ `date \"+%d/%m/%Y %H:%M\"`"

OUTPUTFLAG=HTML

echo "Subject: $MailSubject
To: $recipient
MIMEV=\"MIME-Version: 1.0
Content-Type: text/html
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
" > $REPORTFILE1



echo "<html><P><font color="blue"><br /><br />Please find below ITSD Followup interaction TT report<B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br/>
****
******
**********
**********************************************<br /></P></html>" >> $REPORTFILE1

cat $REPORTFILE1
echo "<TABLE border="1">" >> $REPORTFILE1
echo "<TR><TH><font color="blue">Incident No</TH></font><TH><font color ="blue">Interaction No</TH></font><TH><font color ="blue">Status</TH></font>
<TH><font color="blue">Priority</TH></font><TH><font color="blue">Age of IM(In days)</TH></font><TH><font color="blue">Opened By</TH>
</font><TH><font color ="blue">Open Time</TH></font><TH><font color ="blue">Assignee</TH></font>
<TH><font color ="blue">Resolver Group</TH></font><TH><font color ="blue">Follow up Count</TH></font>
<TH><font color ="blue">Follow up Description</TH></font></TR>" >> $REPORTFILE1


sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE1
set linesize 150;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;

select '<tr><td align=center>'||b."NUMBER"||'</td><td align=center>'||a.incident_id||'</td><td align=center>'||a.open||'</td>
<td align=center>'||b.priority_code||'</td><td align=center>'||round(sysdate-(b.open_time+4/24),2)||'</td><td>'||a.OPENED_BY||'</td>
<td align=center>'||to_char(a.OPEN_TIME+4/24, 'mm/dd/yyyy HH24:MI:SS')||'</td><td align=center>'||b.ASSIGNEE_NAME||'</td>
<td align=center>'||b.assignment||'</td><td align=center>'||(select count(*) from screlationm1 d where d.source=b."NUMBER")||'</td>
<td align=center>'||a.TITLE||'</td></tr>'
from incidentsm1 a,probsummarym1 b,screlationm1 c
where a.incident_id=c.depend(+) and c.source=b."NUMBER" and
a.du_followup_code in ('Solution Available','Request within SLA','Request Breached SLA') 
and ((sysdate)-(a.open_time+4/24))<= (30/(24*60));

exit;
EOF


echo "</TABLE>" >> $REPORTFILE1
echo $NEWLINE
echo $NEWLINE


#echo "<html><P><font color="blue">No: Of BCH Instances: $(ps -efx | grep bch | grep $3 | wc -l)</P></html>"

echo "<html><P><font color="blue">Regards,<br />HPSM Support Team<br /><br />This is system auto generated mail,Please do not reply<br /></P></html>" >> $REPORTFILE1

cat $REPORTFILE1
cnt=`grep 'SD' Followup_report | wc -l`
if [ $cnt -gt 2 ]
then
cd /usr/sbin
/usr/sbin/sendmail -t < /hpsm/hpsm/ops/reports/Followup_report
fi
#exit 0
