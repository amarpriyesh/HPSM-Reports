cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/
REPORTFILE_open=open_reportNew41

recipient="ankur.saxena@du.ae,priyesh.a@du.ae"
#recipient="priyesh.a@du.ae,neeraj.sharma@du.ae,rahul.gupta1@du.ae,gagan.atreya@du.ae,sanjay.sharma@du.ae,tanuj.kumar@du.ae,ashish.panditha@du.ae"
#recipient1="ankur.saxena@du.ae"

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


sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_open
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td>'||g.assignment||'</td><td align=center>'||sum(g.jan)||'</td><td align=center>'||sum(g.feb) ||'</td><td align=center>'||sum(g.mar) ||'</td><td align=center>'||sum(g.apr)||'</td><td align=center>'||sum(g.may) ||'</td><td align=center>'||sum(g.jun) ||'</td><td align=center>'|| sum(g.jul) ||'</td><td align=center>'|| sum(g.aug) ||'</td><td align=center>'||sum(g.sep) ||'</td><td align=center>'||sum(g.oct)||'</td><td align=center>'||sum(g.nov)||'</td><td align=center>'||sum(g.dec) ||'</td><td align=center>'||sum(g.tot) ||'</td><td align=center>'||sum(g.itsd) ||'</td><td align=center>'||sum(g.fms) ||'</td><td align=center>'||sum(g.siebel_crm) ||'</td><td align=center>'||sum(g.tsrm)||'</td><td align=center>'||sum(g.tsrm_itsd)||'</td><td align=center>'||sum(g.fms_itsd)||'</td><td align=center>'||sum(g.siebel_dealer) ||'</td></tr>' from (select * from tmp_hpsmresolved_itsd  UNION  select b.assignment,sum(b.jan) as jan,sum(b.feb) as feb,sum(b.mar) as mar,sum(b.apr) as apr,sum(b.may) as may,sum(b.jun) as jun, sum(b.jul) as jul, sum(b.aug) as aug,sum(b.sep) as sep,sum(b.oct) as oct,sum(b.nov) as nov,sum(b.dec) as dec,sum(b.tot) as tot,sum(b.itsd) as itsd,sum(b.fms) as fms,sum(b.siebel_crm) as siebel_crm,sum(b.tsrm) as tsrm,sum(b.tsrm_itsd)  as tsrm_itsd ,sum(b.fms_itsd)  as fms_itsd ,sum(b.siebel_dealer)  as siebel_dealer from  (select assignment  as assignment,0 as jan ,
0 as feb ,
0 as mar ,
0 as apr ,
0 as may ,
0 as jun ,
0 as jul ,
0 as aug ,
0 as sep ,
case when ( trunc(resolved_time+4/24) >=('01-Oct-2017') and  trunc(resolved_time+4/24) <('01-Nov-2017'))   then 1 else 0 end as oct ,
case when ( trunc(resolved_time+4/24) >=('01-Nov-2017') and  trunc(resolved_time+4/24) <('01-Dec-2017'))   then 1 else 0 end as nov ,
case when ( trunc(resolved_time+4/24) >=('01-Dec-2017') and  trunc(resolved_time+4/24) <('01-Jan-2018'))   then 1 else 0 end as dec ,
case  when ( trunc(resolved_time+4/24) >=('01-Jan-2017') and  trunc(resolved_time+4/24) <('01-Jan-2018'))   then 1  else 0 end as tot ,
case  when folder='ITSD'  then 1  else 0 end as itsd ,
case  when folder='FMS'  then 1  else 0 end as fms ,
case  when folder='SIEBEL-CRM'  then 1  else 0 end as siebel_crm,
case  when folder='TSRM'  then 1  else 0 end as tsrm,
case  when (folder='TSRM' and assignment in ('IT - Corporate Technical Support','IT - Technical Support'))  then 1  else 0 end as tsrm_itsd,
case  when (folder='FMS' and assignment='IT - TSD IT')  then 1  else 0 end as fms_itsd,
case  when (folder='SIEBEL-CRM' and is_dealer='t')  then 1  else 0 end as siebel_dealer
from  probsummarym1 where  resolved_time>='01-Oct-2017' and folder='ITSD'  ) b  group by b.assignment ) g where (upper(g.assignment) not like '%DEV%' and upper(g.assignment) not like '%L2%' and upper(g.assignment) not like '%L3%' and upper(g.assignment) not like '%L4%' and upper(g.assignment) not like '%ATOS%' and upper(g.assignment) like '%IT%')  group by g.assignment   ;
exit;
EOF

echo "</TABLE>" >> $REPORTFILE_open


#echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_open
#echo "Content-Type: text/plain" >> $REPORTFILE_open
#echo "" >> $REPORTFILE_open
echo "" >> $REPORTFILE_open
cat $REPORTFILE_open | /usr/lib/sendmail -t
