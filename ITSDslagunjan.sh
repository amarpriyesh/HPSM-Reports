cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/

datestr=`date "+%d%m%M"`
#datestr=master_tt_


sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
truncate table billing89m2;
insert into  billing89m2 (select
incident,
open_time,
max_update as close_time,
priority_code,
du_tt_type,
folder,
queue1,
timeToResolve247(open_time,max_update) as ttr,
timeToResolve_ITSD(open_time,max_update) as ttr_ITSD,
case when priority_code in ('3','4')  then ericssonTTRITSD(incident)  end as P34_PENDING,
case when priority_code in ('3','4')  then ericssonTTRITSD_Pen(incident)  end as P34,
case when priority_code in ('1','2')  then ericssonTTR247(incident)  end as P12
from
 (select
distinct(b."NUMBER") as incident,
(a.open_time+4/24) as open_time,
((select (max(k.datestamp+4/24)) from activitym1 k where (k.type='Resolved' or k.type='Rejected to Business' ) and k."NUMBER"=b."NUMBER" ) )as max_update,
priority_code,
du_tt_type,
folder,
a.assignment as queue1 from probsummarym1 a inner join  activitym1 b
on   a."NUMBER" = b."NUMBER"
where  a."NUMBER" in (select    distinct
b."NUMBER"
from activitym1 b inner join probsummarym1 a on (a."NUMBER"=b."NUMBER" ) where ( b.datestamp+4/24>=trunc(sysdate-7) and b.datestamp+4/24<trunc(sysdate)) and
b.type in ('Resolved','Rejected to Business') and folder ='ITSD' 
) and a."NUMBER" not like 'PDI_%') );

exit;
EOF




rm /hpsm/hpsm/ops/reports/89
sla=/hpsm/hpsm/ops/reports/89
echo "To: priyesh.a@du.ae,ankur.saxena@du.ae,Prasanna.Kumar@du.ae,ankur.saxena@du.ae,Gunjan.Mathur@du.ae,Neeraj.Sharma@du.ae,Sanjay.Sharma@du.ae,Bhavana.Tatti@du.ae,LaxmaReddy.Kompally@du.ae" >> $sla
echo "Subject: ITSD SLA Monthly Report $datestr" >> $sla


echo "MIME-Version: 1.0
Content-Type: multipart/mixed;
        boundary=\"XXXXboundary text\"" >>$sla
echo "--XXXXboundary text" >>$sla
echo "Content-Type: text/html" >> $sla
echo "<html><P><font color="blue">
Dear All,<br /><br />Please find below ITSD SLA status for $datestr resolved/rejected to business TTs <br />
<br /></font></P></html>" >> $sla

echo "<html>" >>$sla
echo "<TABLE border="1" bordercolor="BLACK">" >>$sla
echo "<TR><TH><font color="blue">P4Request</TH></font><TH><font color ="blue">P3Request</TH></font><TH><font color ="blue">P2Request</TH></font><TH><font color ="blue">P1Request</TH></font><TH><font color ="blue">P4Incident</TH></font><TH><font color ="blue">P3Incident</TH></font><TH><font color ="blue">P2Incident</TH></font><TH><font color ="blue">P1Incident</TH></font></TR>" >> $sla
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $sla
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;
select '<tr><td>'||P4SR||'</td><td>'||P3SR||'</td><td>'||P2SR||'</td><td>'||P1SR||'</td><td>'||P4IN||'</td><td>'||P3IN||'</td><td>'||P2IN||'</td><td>'||P1IN||'</td></tr>' from
(select round(sum(rp4)*100/NULLIF(sum(rp4tot),0),2) as P4SR ,round(sum(rp3)*100/NULLIF(sum(rp3tot),0),2) as P3SR ,round(sum(rp2)*100/NULLIF(sum(rp2tot),0),2) as P2SR,round(sum(rp1)*100/NULLIF(sum(rp1tot),0),2) as P1SR, round(sum(sp4)*100/NULLIF(sum(sp4tot),0),2) as P4IN, round(sum(sp3)*100/NULLIF(sum(sp3tot),0),2) as P3IN,round(sum(sp2)*100/NULLIF(sum(sp2tot),0),2) as P2IN,round(sum(sp1)*100/NULLIF(sum(sp1tot),0),2) as P1IN from
(select
case when  du_tt_type = 'Request'  and priority_code='4'  and P34_PENDING <= 18 then 1 else 0 end as rp4,
case when  du_tt_type = 'Request'  and priority_code='4'  then 1 else 0 end as rp4tot,
case when  du_tt_type = 'Request'  and priority_code='3'  and P34_PENDING <= 12 then 1 else 0 end as rp3,
case when  du_tt_type = 'Request'  and priority_code='3'  then 1 else 0 end as rp3tot,
case when  du_tt_type = 'Request'  and priority_code='2'  and P12 <= 8 then 1 else 0 end as rp2,
case when  du_tt_type = 'Request'  and priority_code='2'  then 1 else 0 end as rp2tot,
case when  du_tt_type = 'Request'  and priority_code='1'  and P12 <= 4 then 1 else 0 end as rp1,
case when  du_tt_type = 'Request'  and priority_code='1'  then 1 else 0 end as rp1tot,
case when  du_tt_type = 'Incident'  and priority_code='4'  and P34_PENDING <= 18 then 1 else 0 end as sp4,
case when  du_tt_type = 'Incident'  and priority_code='4'  then 1 else 0 end as sp4tot,
case when  du_tt_type = 'Incident'  and priority_code='3'  and P34_PENDING <= 12 then 1 else 0 end as sp3,
case when  du_tt_type = 'Incident'  and priority_code='3'  then 1 else 0 end as sp3tot,
case when  du_tt_type = 'Incident'  and priority_code='2'  and P12 <= 6 then 1 else 0 end as sp2,
case when  du_tt_type = 'Incident'  and priority_code='2'  then 1 else 0 end as sp2tot,
case when  du_tt_type = 'Incident'  and priority_code='1'  and P12 <= 3.5 then 1 else 0 end as sp1,
case when  du_tt_type = 'Incident'  and priority_code='1'  then 1 else 0 end as sp1tot
from billing89m2));
exit;
EOF

echo "</table>">>$sla
echo "</html>" >>$sla






echo "<html><P><font color="blue">
Thanks and Regards,<br /><br />HPSM TEAM<br />
<br /></font></P></html>" >> $sla


datestr=`date "+%d%m%y"`
echo "--XXXXboundary text" >>$sla
echo "Content-Type: text/plain" >> $sla
echo "Content-Disposition: attachement; filename=ITSD$datestr.csv" >> $sla

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
set define off
spool ITSD$datestr.csv
-------------------All Open TT Incident extract------------------------------------
select  
'IncidentNo'
||','||'open_time'
||','||'close_time'
||','||'priority_code'
||','||'du_tt_type'
||','||'folder'
||','||'queue'
||','||'ttr'
||','||'ttr_ITSD'
||','||'P34_PENDING'
||','||'P34'
||','||'P12'
from Dual
UNION ALL
select
incident
||','||to_char(open_time,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(close_time,'mm/dd/yyyy HH24:MI:SS')
||','||priority_code
||','||du_tt_type
||','||folder
||','||queue1
||','||ttr
||','||ttr_ITSD
||','||P34_PENDING
||','||P34
||','||P12
from billing89m2;
spool off;
quit;
EOF

echo "" >> $sla
cat ITSD$datestr.csv >> $sla

echo "--XXXXboundary text" >>$sla
cat $sla | /usr/lib/sendmail -t
done
