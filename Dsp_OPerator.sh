cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/

REPORTFILE_AS=AS_reportoperator2
dt=`date +%H%M`

#recipient="nihalchand.dehury@du.ae"

recipient="ankur.saxena@du.ae,priyesh.a@du.ae"

MailSubject="All DSP TT Report wrt Assignee  "

OUTPUTFLAG=HTML

rm AS_reportoperator2

echo "Subject: $MailSubject
To: $recipient
MIMEV=\"MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw" 
Content-Disposition: inline
" >> $REPORTFILE_AS

echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_AS
echo "Content-Type: text/html" >> $REPORTFILE_AS
echo "Content-Disposition: inline" >> $REPORTFILE_AS
echo "" >> $REPORTFILE_AS

echo "<html><P><font color="blue">
Dear All,<br /><br />Please find below DSP TTs report w.r.t operator<br />
<br /></P></html>" >> $REPORTFILE_AS 


echo "<TABLE border="1">" >> $REPORTFILE_AS 
echo "<TR><TH><font color="blue">Assignee Name</TH></font><TH><font color ="blue">Resolved</TH></font><TH><font color ="blue">Rejected</TH></font><TH><font color="blue">Reassigned</TH></font><TH><font color="blue">Rejected to Business</TH></font><TH><font color="blue">Pending Input</TH></font><TH><font color="blue">Total</TH></TR>" >> $REPORTFILE_AS 


sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_AS
set linesize 2000;
set trimspool on;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td>'||x.operator||'</td><td align=center>'||sum(Resolved)||'</td><td align=center>'||sum(Rejected) ||'</td><td align=center>'||sum(ReAssigned) ||'</td><td align=center>'||sum(RTB) ||'</td><td align=center>'||sum(PI) ||'</td><th>'||count(*) ||'</th></tr>'from (select b.operator, case when (b.type='Resolved') then 1 else 0 end Resolved , case when (b.type='Rejected') then 1 else 0 end Rejected ,case when (b.type='ReAssigned') then 1 else 0 end ReAssigned , case when (b.type='Rejected to Business') then 1 else 0 end RTB ,case when (b.type='Pending Input') then 1 else 0 end PI from activitym1 b , probsummarym1 a where  b."NUMBER"=a."NUMBER" and a.update_time+4/24> trunc(sysdate) and b.datestamp+4/24>trunc(sysdate) and b.type in ('Resolved', 'Rejected','ReAssigned','Rejected to Business','Pending Input') and (b.description LIKE '%IT DSP Application Support to%')) x group by x.operator;

exit;
EOF

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_AS
set linesize 2000;
set trimspool on;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td><b>Total</b></td><td align=center><b>'||sum(Resolved)||'</b></td><td align=center><b>'||sum(Rejected) ||'</b></td><td align=center><b>'||sum(ReAssigned) ||'</b></td><td align=center><b>'||sum(RTB) ||'</b></td><td align=center><b>'||sum(PI) ||'</b></td><th>'||count(*) ||'</th></tr>'from (select case when (b.type='Resolved') then 1 else 0 end Resolved , case when (b.type='Rejected') then 1 else 0 end Rejected ,case when (b.type='ReAssigned') then 1 else 0 end ReAssigned , case when (b.type='Rejected to Business') then 1 else 0 end RTB ,case when (b.type='Pending Input') then 1 else 0 end PI from activitym1 b , probsummarym1 a where  b."NUMBER"=a."NUMBER" and a.update_time+4/24> trunc(sysdate) and b.datestamp+4/24> trunc(sysdate) and b.type in ('Resolved', 'Rejected','ReAssigned','Rejected to Business','Pending Input') and (b.description LIKE '%IT DSP Application Support to%')); 

exit;
EOF


echo "</TABLE>" >> $REPORTFILE_AS

echo $NEWLINE
echo $NEWLINE

echo "<html><P><font color="blue">Regards,<br />HPSM Support Team<br /><br />This is system auto generated mail,Please do not reply<br /></P></html>" >> $REPORTFILE_AS
echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_AS

cat $REPORTFILE_AS | /usr/lib/sendmail -t


