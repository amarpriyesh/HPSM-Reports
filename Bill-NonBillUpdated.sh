cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/

fromdate="'01-Feb-2020'"
todate="'18-Feb-2020'"
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
truncate table billing89m;
insert into  billing89m  (select 
num,
ref_no,
queue1 as assignment,
'Billing' as source,
ot as open_time,
ct as close_time,
cust_val,
ttr,
case when cust_val in ('Platinum')  then Ettr end as PlatinumTTR,
case when cust_val not in ('Platinum')   then  Ettr end as NONPlatinumTTR from 
(select
incident as num,
open_time as ot,
max_update as ct,
cust_val,
ref_no,
queue1,
timeToResolve247(open_time,max_update) as ttr,
ericssonTTR247(incident) as Ettr
from
 (select
distinct(b."NUMBER") as incident,
(a.open_time+4/24) as open_time,
((select (max(k.datestamp+4/24)) from activitym1 k where (k.type='Resolved' or k.type='Rejected to Business' ) and k."NUMBER"=b."NUMBER" ) )as max_update,
a.du_cust_value as cust_val,
a.reference_no as ref_no,
a.assignment as queue1 from probsummarym1 a inner join  activitym1 b
on   a."NUMBER" = b."NUMBER"
where  a."NUMBER" in (select    distinct
b."NUMBER"
from activitym1 b inner join probsummarym1 a on (a."NUMBER"=b."NUMBER" ) inner join DU_BILLING_NONBILLING c on (a.CATEGORY=c.type and a.subcategory=C.AREA and a.product_type=C.sub_AREA) where ( b.datestamp+4/24>=$fromdate and b.datestamp+4/24<$todate) and
b.type in ('Resolved','Rejected to Business') and folder ='SIEBEL-CRM'   and c.source='BILLING'
and (b.description LIKE 'IT - Billing to%' or
b.description LIKE 'IT - CRM to%' or
b.description LIKE 'IT - OSS-OPS-OPA to%' or
b.description LIKE 'IT - EAI to%' or
b.description LIKE 'IT - EBusiness to%' or
b.description LIKE 'IT - EDMS to%' or
b.description LIKE 'IT - ERP to%' or
b.description LIKE 'IT - GIS to%' or
b.description LIKE 'IT - ICS to%' or
b.description LIKE 'IT - OSS-OPS-Fixed Mediation to%' or
b.description LIKE 'IT - OSS-OPS-Mobile Mediation to%' or
b.description LIKE 'IT - OSS-OPS-Mobile Provisioning to%' or
b.description LIKE 'IT - OSS-OPS-OAIM to%' or
b.description LIKE 'IT - POS to%' or
b.description LIKE 'IT DSP Application Support to%' or
b.description LIKE 'IT - Payment Gateway to%' or
b.description LIKE 'IT - Business Application Access to%' or
b.description LIKE 'IT - MNMI (Application Support) to%' or
b.description LIKE 'IT - MNP Application Support to%' or
b.description LIKE 'NOC - IN to%' or
b.description LIKE 'Bill Shock to%' or
b.description LIKE 'Core - Mobile IN to%' or
b.description LIKE '%IT - Enterprise Systems (HMC) to%')
)) ));

exit;
EOF

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
truncate table nonbilling89m;
insert into  nonbilling89m  (select 
num,
ref_no,
queue1 as assignment,
'NoNBilling' as source,
ot as open_time,
ct as close_time,
cust_val,
ttr,
case when cust_val in ('Platinum')  then Ettr end as PlatinumTTR,
case when cust_val not in ('Platinum')   then  Ettr end as NONPlatinumTTR from 
(select
incident as num,
open_time as ot,
max_update as ct,
cust_val,
ref_no,
queue1,
timeToResolve247(open_time,max_update) as ttr,
ericssonTTR247(incident) as Ettr
from
 (select
distinct(b."NUMBER") as incident,
(a.open_time+4/24) as open_time,
((select (max(k.datestamp+4/24)) from activitym1 k where (k.type='Resolved' or k.type='Rejected to Business' ) and k."NUMBER"=b."NUMBER" ) )as max_update,
a.du_cust_value as cust_val,
a.reference_no as ref_no,
a.assignment as queue1
from probsummarym1 a inner join  activitym1 b
on   a."NUMBER" = b."NUMBER"
where  a."NUMBER" in (select    distinct
b."NUMBER"
from activitym1 b inner join probsummarym1 a on (a."NUMBER"=b."NUMBER" )  where  ( b.datestamp+4/24>=$fromdate and b.datestamp+4/24<$todate) and b.type in ('Resolved','Rejected to Business') and folder ='SIEBEL-CRM'   and ((CATEGORY,subcategory,product_type) NOT IN (SELECT  /*+PARALLEL(5)*/  TYPE,AREA,SUB_AREA FROM DU_BILLING_NONBILLING WHERE SOURCE='BILLING' ))
and (b.description LIKE '%IT - Billing to%' or  
b.description LIKE '%IT - CRM to%' or 
b.description LIKE '%IT - OSS-OPS-OPA to%' or
b.description LIKE '%IT - EAI to%' or
b.description LIKE '%IT - EBusiness to%' or
b.description LIKE '%IT - EDMS to%' or
b.description LIKE '%IT - ERP to%' or
b.description LIKE '%IT - GIS to%' or
b.description LIKE '%IT - ICS to%' or
b.description LIKE '%IT - OSS-OPS-Fixed Mediation to%' or
b.description LIKE '%IT - OSS-OPS-Mobile Mediation to%' or
b.description LIKE '%IT - OSS-OPS-Mobile Provisioning to%' or
b.description LIKE '%IT - OSS-OPS-OAIM to%' or
b.description LIKE '%IT - POS to%' or
b.description LIKE '%IT DSP Application Support to%' or
b.description LIKE '%IT - Payment Gateway to%' or
b.description LIKE '%IT - Business Application Access to%' or
b.description LIKE '%IT - MNMI (Application Support) to%' or
b.description LIKE '%IT - MNP Application Support to%' or
b.description LIKE '%NOC - IN to%' or
b.description LIKE '%Bill Shock to%' or
b.description LIKE '%Core - Mobile IN to%' or 
b.description LIKE '%IT - Enterprise Systems (HMC) to%')
)) ));

exit;
EOF


rm /hpsm/hpsm/ops/reports/89
sla=/hpsm/hpsm/ops/reports/89
echo "To: priyesh.a@du.ae,ankur.saxena@du.ae,Gunjan.Mathur@du.ae,Neeraj.Sharma@du.ae,Sanjay.Sharma@du.ae,Gagan.Atreya@du.ae,Prasanna.Kumar@du.ae" >> $sla
echo "Subject: SLA 8/9 Report version 24x7  $fromdate-$todate" >> $sla


echo "MIME-Version: 1.0
Content-Type: multipart/mixed;
        boundary=\"XXXXboundary text\"" >>$sla
echo "--XXXXboundary text" >>$sla
echo "Content-Type: text/html" >> $sla
echo "<html><P><font color="blue">
Dear All,<br /><br />Please find below Billing sla 8/9 version 24x7 status for $fromdate-$todate resolved/rejected to business TTs <br />
<br /></font></P></html>" >> $sla

echo "<html>" >>$sla
echo "<TABLE border="1" bordercolor="BLACK">" >>$sla
echo "<TR><TH><font color="blue">plat</TH></font><TH><font color ="blue">breach_plat</TH></font><TH><font color ="blue">nonplat</TH></font><TH><font color ="blue">breach_nonplat</TH></font></TR>" >> $sla
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $sla
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;
 select '<tr><td>'||slab1_plat||'</td><td>'||breach_plat||'</td><td>'||slab1_nonplat||'</td><td>'||breach_nonplat||'</td></tr>' from
(select round(sum(platinumslab1)*100/sum(totplatinum),2) as  slab1_plat ,round(sum(breachplatinum)*100/sum(totplatinum),2) as breach_plat ,round(sum(nonplatinumslab1)*100/sum(totnonplatinum),2) as slab1_nonplat,round(sum(breachnonplatinum)*100/sum(totnonplatinum),2) as breach_nonplat from
(select
case when  cust_val in ('Platinum')  and (platinumttr<=8) then 1 else 0 end as platinumslab1,
case when  cust_val in ('Platinum')  and (platinumttr>8) then 1 else 0 end as breachplatinum,
case when  cust_val in ('Platinum')   then 1 else 0 end as totplatinum,
case when  cust_val not in ('Platinum')  and (nonplatinumttr<=12) then 1 else 0 end as nonplatinumslab1,
case when  cust_val not in ('Platinum')  and (nonplatinumttr>12) then 1 else 0 end as breachnonplatinum,
case when  cust_val not in ('Platinum')  then 1 else 0 end as totnonplatinum
from billing89m));
exit;
EOF

echo "</table>">>$sla
echo "</html>" >>$sla





#echo "Content-Type: text/html" >> $sla
echo "<html><P><font color="blue">
Dear All,<br /><br />Please find below NON Billing sla 8/9 version 24x7 status for $fromdate-$todate resolved/rejected to business TTs <br />
<br /></font></P></html>" >> $sla
echo "<html>" >>$sla
echo "<TABLE border="1" bordercolor="BLACK">" >>$sla
echo "<TR><TH><font color="blue">slab1_plat</TH></font><TH><font color ="blue">slab2_plat</TH></font><TH><font color ="blue">breach_plat</TH></font><TH><font color ="blue">slab1_nonplat</TH></font><TH><font color ="blue">slab2_nonplat</TH></font><TH><font color ="blue">breach_nonplat</TH></font></TR>" >> $sla
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $sla
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;
 select '<tr><td>'||slab1_plat||'</td><td>'||slab2_plat||'</td><td>'||breach_plat||'</td><td>'||slab1_nonplat||'</td><td>'||slab2_nonplat||'</td><td>'||breach_nonplat||'</td></tr>' from
(select round(sum(platinumslab1)*100/sum(totplatinum),2) as  slab1_plat ,round(sum(platinumslab2)*100/sum(totplatinum),2) as slab2_plat,round(sum(breachplatinum)*100/sum(totplatinum),2) as breach_plat , round(sum(nonplatinumslab1)*100/sum(totnonplatinum),2) as slab1_nonplat,round(sum(nonplatinumslab2)*100/sum(totnonplatinum),2) as slab2_nonplat,round(sum(breachnonplatinum)*100/sum(totnonplatinum),2) as breach_nonplat from
(select
case when  cust_val in ('Platinum')  and (platinumttr<=6) then 1 else 0 end as platinumslab1,
case when  cust_val in ('Platinum')  and ((platinumttr<=16 )) then 1 else 0 end as platinumslab2,
case when  cust_val in ('Platinum')  and (platinumttr>16) then 1 else 0 end as breachplatinum,
case when  cust_val in ('Platinum')  then 1 else 0 end as totplatinum,
case when  cust_val not in ('Platinum')  and (nonplatinumttr<=12) then 1 else 0 end as nonplatinumslab1,
case when  cust_val not in ('Platinum') and ( (nonplatinumttr<=18 )) then 1 else 0 end as nonplatinumslab2,
case when  cust_val not in ('Platinum')  and (nonplatinumttr>18) then 1 else 0 end as breachnonplatinum,
case when  cust_val not in ('Platinum')  then 1 else 0 end as totnonplatinum
from nonbilling89m));
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
echo "Content-Disposition: attachement; filename=sla_89_billing_$datestr.csv" >> $sla

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
set define off
spool sla_89_billing_$datestr$fromdate-$todate.csv
-------------------All Open TT Incident extract------------------------------------
select  
'IncidentNo'
||','||'Ref_no'
||','||'OpenTime'
||','||'CloseTime'
||','||'assignment'
||','||'Customer Value'
||','||'source'
||','||'Time_to_resolve'
||','||'Platinum_ttr'
||','||'NONPlatinum_ttr'
from Dual
UNION ALL
select
num
||','||ref_no
||','||open_time
||','||close_time
||','||assignment
||','||cust_val
||','||source
||','||ttr
||','||platinumttr
||','||nonplatinumttr
from billing89m;
spool off;
quit;
EOF

echo "" >> $sla
cat sla_89_billing_$datestr$fromdate-$todate.csv >> $sla



echo "--XXXXboundary text" >>$sla
echo "Content-Type: text/plain" >> $sla
echo "Content-Disposition: attachement; filename=sla_89_nonbilling_$datestr$fromdate-$todate.csv" >> $sla

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
set define off
spool sla_89_nonbilling_$datestr$fromdate-$todate.csv

select  
'IncidentNo'
||','||'Ref_no'
||','||'OpenTime'
||','||'CloseTime'
||','||'assignment'
||','||'Customer Value'
||','||'source'
||','||'Time_to_resolve'
||','||'Platinum_ttr'
||','||'NONPlatinum_ttr'
from Dual
UNION ALL
select
num
||','||ref_no
||','||open_time
||','||close_time
||','||assignment
||','||cust_val
||','||source
||','||ttr
||','||platinumttr
||','||nonplatinumttr
from nonbilling89m;
spool off;
quit;
EOF

echo "" >> $sla
cat sla_89_nonbilling_$datestr$fromdate-$todate.csv >> $sla
echo "--XXXXboundary text" >>$sla
cat $sla | /usr/lib/sendmail -t

