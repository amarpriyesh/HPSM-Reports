cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/
REPORTFILE=MC_report
#recipient="nihalchand.dehury@du.ae,Anusha.y@du.ae"
recipient="Rameya.Jeyakumar@du.ae,Nandini.Nagaraju@du.ae,nihalchand.dehury@du.ae,Edward.Paul@du.ae,Nareen.Shaganti@du.ae,Praveen.Naidu@du.ae,Praveen.Singu@du.ae,Hari.Mandadapu@du.ae,Winner.Viagularaj@du.ae,Mohitha.Ambati@du.ae,,Sankar.Kotla@du.ae,Mansoor.A@du.ae,Midhun.Antony@du.ae,Mugtaba.Ahmed@du.ae,Sofia.Begum@du.ae,Madhuri.J@du.ae,Mohamed.Imam@du.ae,Iqbal.Khan@du.ae,Kavitha.Rajput@du.ae"

MailSubject="IT User Access Request TT Report @ `date \"+%d/%m/%Y %H:%M\"`"

OUTPUTFLAG=HTML

echo "Subject: $MailSubject
To: $recipient
MIMEV=\"MIME-Version: 1.0
Content-Type: text/html
Content-Transfer-Encoding: 7bit
Content-Disposition: inline " > $REPORTFILE




echo "<html><P><font color="blue">Dear All,<br /><br />Please find below IT User Access Request TT reports<B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br />****
******
**********
**********************************************<br /></P></html>" >> $REPORTFILE

cat $REPORTFILE
echo "<TABLE border="1">" >> $REPORTFILE
echo "<TR><TH><font color="blue">Incident No</TH></font><TH><font color ="blue">Status</TH>
</font><TH><font color ="blue">Category</TH></font><TH><font color="blue">Area</TH>
</font><TH><font color="blue">SubArea</TH></font><TH><font color ="blue">OpenTime</TH>
</font><TH><font color ="blue">Age in Minutes</TH></font></TR>" >> $REPORTFILE


sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE
set linesize 150;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;


select '<tr><td>'||"NUMBER"||'</td><td align=center>'||problem_status||'</td>
<td align=center>'||decode(category,'UAM',uamcategory,category)||'</td><td align=center>'||decode(subcategory,'UAM',uamsubcategory,subcategory)||'</td>
<td align=center>'||decode(product_type,'UAM',uamproducttype,product_type)||'</td><th>'||(open_time+4/24)||'</th>
<td>'||round(((sysdate)-to_date(TO_CHAR(open_time+4/24,'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS'))*(24*60),2)||'</td></tr>'
from probsummarym1 where assignment in('IT - User Access Request') and problem_status not in ('Resolved','Closed','Rejected');

exit;
EOF


echo "</TABLE>" >> $REPORTFILE
echo $NEWLINE
echo $NEWLINE


#echo "<html><P><font color="blue">No: Of BCH Instances: $(ps -efx | grep bch | grep $3 | wc -l)</P></html>"

echo "<html><P><font color="blue">Regards,<br />HPSM Support Team<br /><br />This is system auto generated mail,Please do not reply<br /></P></html>" >> $REPORTFILE
cat $REPORTFILE
cnt=`grep IM MC_report | wc -l`
echo $cnt
if [ $cnt -gt 1 ]
then
cd /usr/sbin
sendmail -t < /hpsm/hpsm/ops/MC_report
fi
#exit 0 
