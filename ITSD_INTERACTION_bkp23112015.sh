cd
. ./.bash_profile
cd /hpsm/hpsm/ops/
REPORTFILE_Web=MC_report
recipient="nihalchand.dehury@du.ae"
#recipient="mohammed.rezwanali@du.ae,nihalchand.dehury@du.ae,Karthik.Reddy@du.ae,Rameya.Jeyakumar@du.ae,Nandini.Nagaraju@du.ae,Edward.Paul@du.ae,Nareen.Shaganti@du.ae,Praveen.Naidu@du.ae,Praveen.Singu@du.ae,Hari.Mandadapu@du.ae,Winner.Viagularaj@du.ae,Mohitha.Ambati@du.ae,Sankar.Kotla@du.ae,Mansoor.A@du.ae,Midhun.Antony@du.ae,Pratheek.Reddy@du.ae,mugtaba.ahmed@du.ae,Sofia.Begum@du.ae,Madhuri.J@du.ae,Mohamed.Imam@du.ae,Iqbal.Khan@du.ae,Kavitha.Rajput@du.ae"

MailSubject="ITSD Interaction TT Report(Web and Email) @ `date \"+%d/%m/%Y %H:%M\"`"

OUTPUTFLAG=HTML

echo "Subject: $MailSubject
To: $recipient
MIMEV=\"MIME-Version: 1.0
Content-Type: text/html
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
" > $REPORTFILE_Web




echo "<html><P><font color="blue">Dear All,<br /><br />Please find below ITSD Web interaction TT reports<B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br />****
******
**********
**********************************************<br /></P></html>" >> $REPORTFILE_Web

cat $REPORTFILE_Web
echo "<TABLE border="1">" >> $REPORTFILE_Web
echo "<TR><TH><font color="blue">Interaction No</TH></font><TH><font color ="blue">Opened By</TH></font><TH><font color ="blue">Location</TH></font>
<TH><font color="blue">Status</TH></font><TH><font color="blue">Category</TH></font><TH><font color="blue">Area</TH>
</font><TH><font color ="blue">SubArea</TH></font><TH><font color ="blue">OpenTime</TH></font>
<TH><font color ="blue">Age in Minutes</TH></font></TR>" >> $REPORTFILE_Web


sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_Web
set linesize 150;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;

select '<tr><td>'||incident_id||'</td><td align=center>'||du_fullname||'</td><td align=center>'||location||'</td><td align=center>'||open||'</td>
<td align=center>'||category||'</td><th>'||subcategory||'</th><td align=center>'||product_type||'</td><td>'||TO_CHAR(open_time+4/24,'DD-MON-YYYY HH24:MI:SS')||'</td>
<td>'||round(((sysdate)-to_date(TO_CHAR(open_time+4/24,'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS'))*(24*60),2)||'</td></tr>'
From incidentsm1 where du_interaction_owner is null 
and ((sysdate)-(open_time+4/24))>= (5/(24*60));

exit;
EOF


echo "</TABLE>" >> $REPORTFILE_Web
echo $NEWLINE
echo $NEWLINE


echo "<html><P><font color="blue"><br /><br />Please find below ITSD Email interaction TT reports<B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br />****
******
**********
**********************************************<br /></P></html>" >> $REPORTFILE_Web

cat $REPORTFILE_Web
echo "<TABLE border="1">" >> $REPORTFILE_Web
echo "<TR><TH><font color="blue">Interaction No</TH></font><TH><font color ="blue">Opened By</TH></font><TH><font color ="blue">Location</TH></font>
<TH><font color="blue">Status</TH></font><TH><font color="blue">Category</TH></font><TH><font color="blue">Area</TH>
</font><TH><font color ="blue">SubArea</TH></font><TH><font color ="blue">OpenTime</TH></font>
<TH><font color ="blue">Age in Minutes</TH></font></TR>" >> $REPORTFILE_Web


sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_Web
set linesize 150;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;

select '<tr><td>'||incident_id||'</td><td align=center>'||du_fullname||'</td><td align=center>'||location||'</td><td align=center>'||open||'</td>
<td align=center>'||category||'</td><th>'||subcategory||'</th><td align=center>'||product_type||'</td><td>'||TO_CHAR(open_time+4/24,'DD-MON-YYYY HH24:MI:SS')||'</td>
<td>'||round(((sysdate)-to_date(TO_CHAR(open_time+4/24,'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS'))*(24*60),2)||'</td></tr>'
 From incidentsm1 where du_interaction_owner ='email.log' and category = 'Email Tickets' and open='Open - Idle'
and ((sysdate)-(open_time+4/24))>= (5/(24*60));

exit;
EOF


echo "</TABLE>" >> $REPORTFILE_Web
echo $NEWLINE
echo $NEWLINE


#echo "<html><P><font color="blue">No: Of BCH Instances: $(ps -efx | grep bch | grep $3 | wc -l)</P></html>"

echo "<html><P><font color="blue">Regards,<br />HPSM Support Team<br /><br />This is system auto generated mail,Please do not reply<br /></P></html>" >> $REPORTFILE_Web

cat $REPORTFILE_Web
cnt=`grep 'SD' MC_report | wc -l`
if [ $cnt -gt 2 ]
then
cd /usr/sbin
sendmail -t < /hpsm/hpsm/ops/MC_report
fi
#exit 0
