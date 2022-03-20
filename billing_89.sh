cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
truncate table billing89;
insert into  billing89  (select
a.incident as num,
a.open_time as ot,
a.max_update as ct,
cust_val,
timeToResolve(a.open_time,a.max_update) as ttr,
case when timeToResolve(a.open_time,a.max_update) >12 and cust_val in ('Platinum','VIP','Gold')  then ericssonTTR(a.incident) else 0 end as PlatinumTTR,
case when timeToResolve(a.open_time,a.max_update) >24 and cust_val not in ('Platinum','VIP','Gold')   then ericssonTTR(a.incident) else 0 end as NONPlatinumTTR
 from
 (select
distinct(b."NUMBER") as incident,
(a.open_time+4/24) as open_time,
((select (max(k.datestamp+4/24)) from activitym1 k where (k.type='Resolved' or k.type='Rejected to Business' ) and k."NUMBER"=b."NUMBER" ) )as max_update,
a.du_cust_value as cust_val
from probsummarym1 a inner join  activitym1 b
on   a."NUMBER" = b."NUMBER"
where  a."NUMBER" in (select    distinct
b."NUMBER"
from activitym1 b inner join probsummarym1 a on (a."NUMBER"=b."NUMBER" ) inner join DU_BILLING_NONBILLING c on (a.CATEGORY=c.type and a.subcategory=C.AREA and a.product_type=C.sub_AREA) where  trunc(b.datestamp+4/24)=trunc(sysdate-1) and
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
)) a);

exit;
EOF

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
truncate table nonbilling89;
insert into  nonbilling89  (select
a.incident as num,
a.open_time as ot,
a.max_update as ct,
cust_val,
timeToResolve(a.open_time,a.max_update) as ttr,
case when timeToResolve(a.open_time,a.max_update) >6 and cust_val in ('Platinum','VIP','Gold')   then ericssonTTR(a.incident) else 0 end as PlatinumTTR,
case when timeToResolve(a.open_time,a.max_update) >12 and cust_val not in ('Platinum','VIP','Gold')   then ericssonTTR(a.incident) else 0 end as NONPlatinumTTR
 from
 (select
distinct(b."NUMBER") as incident,
(a.open_time+4/24) as open_time,
((select (max(k.datestamp+4/24)) from activitym1 k where (k.type='Resolved' or k.type='Rejected to Business' ) and k."NUMBER"=b."NUMBER" ) )as max_update,
a.du_cust_value as cust_val
from probsummarym1 a inner join  activitym1 b
on   a."NUMBER" = b."NUMBER"
where  a."NUMBER" in (select    distinct
b."NUMBER"
from activitym1 b inner join probsummarym1 a on (a."NUMBER"=b."NUMBER" )  where  trunc(b.datestamp+4/24)=trunc(sysdate-1) and
b.type in ('Resolved','Rejected to Business') and folder ='SIEBEL-CRM'   and ((CATEGORY,subcategory,product_type) NOT IN (SELECT  /*+PARALLEL(5)*/  TYPE,AREA,SUB_AREA FROM DU_BILLING_NONBILLING WHERE SOURCE='BILLING' ))
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
)) a);

exit;
EOF


rm /hpsm/hpsm/ops/reports/89
sla=/hpsm/hpsm/ops/reports/89
echo "To: priyesh.a@du.ae" >> $sla
echo "Subject: SLA 8/9 Report" >> $sla


echo "MIME-Version: 1.0
Content-Type: multipart/mixed;
        boundary=\"XXXXboundary text\"" >>$sla
echo "--XXXXboundary text" >>$sla
echo "Content-Type: text/html" >> $sla



echo "<html><P><font color="blue">
Dear All,<br /><br />Please find below Billing sla 8/9 status for last day resolved/rejected to business TTs <br />
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
(select round(sum(platinumslab1)*100/sum(totplatinum),2) as  slab1_plat ,round(sum(platinumslab2)*100/sum(totplatinum),2) as slab2_plat,round(sum(breachplatinum)*100/sum(totplatinum),2) as breach_plat ,round(sum(nonplatinumslab1)*100/sum(totnonplatinum),2) as slab1_nonplat,round(sum(nonplatinumslab2)*100/sum(totnonplatinum),2) as slab2_nonplat,round(sum(breachnonplatinum)*100/sum(totnonplatinum),2) as breach_nonplat from
(select
case when  cust_val in ('Platinum','VIP','Gold')  and (ttr<=12 or platinumttr<=12) then 1 else 0 end as platinumslab1,
case when  cust_val in ('Platinum','VIP','Gold')  and ((ttr<=24 ) or (platinumttr<=24 )) then 1 else 0 end as platinumslab2,
case when  cust_val in ('Platinum','VIP','Gold')  and (ttr>24 and  platinumttr>24) then 1 else 0 end as breachplatinum,
case when  cust_val in ('Platinum','VIP','Gold')   then 1 else 0 end as totplatinum,
case when  cust_val not in ('Platinum','VIP','Gold')  and (ttr<=24 or nonplatinumttr<=24) then 1 else 0 end as nonplatinumslab1,
case when  cust_val not in ('Platinum','VIP','Gold')  and ((ttr<=48 ) or (nonplatinumttr<=48 )) then 1 else 0 end as nonplatinumslab2,
case when  cust_val not in ('Platinum','VIP','Gold')  and (ttr>48 and nonplatinumttr>48) then 1 else 0 end as breachnonplatinum,
case when  cust_val not in ('Platinum','VIP','Gold')  then 1 else 0 end as totnonplatinum
from billing89));
exit;
EOF

echo "</table>">>$sla
echo "</html>" >>$sla





echo "Content-Type: text/html" >> $sla
echo "<html><P><font color="blue">
Dear All,<br /><br />Please find below NON Billing sla 8/9 status for last day resolved/rejected to business TTs <br />
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
case when  cust_val in ('Platinum','VIP','Gold')  and (ttr<=6 or platinumttr<=6) then 1 else 0 end as platinumslab1,
case when  cust_val in ('Platinum','VIP','Gold')  and ((ttr<=12 ) or (platinumttr<=12 )) then 1 else 0 end as platinumslab2,
case when  cust_val in ('Platinum','VIP','Gold')  and (ttr>12 and  platinumttr>12) then 1 else 0 end as breachplatinum,
case when  cust_val in ('Platinum','VIP','Gold')  then 1 else 0 end as totplatinum,
case when  cust_val not in ('Platinum','VIP','Gold')  and (ttr<=12 or nonplatinumttr<=12) then 1 else 0 end as nonplatinumslab1,
case when  cust_val not in ('Platinum','VIP','Gold') and ((ttr<=24 ) or (nonplatinumttr<=24 )) then 1 else 0 end as nonplatinumslab2,
case when  cust_val not in ('Platinum','VIP','Gold')  and (ttr>24 and nonplatinumttr>24) then 1 else 0 end as breachnonplatinum,
case when  cust_val not in ('Platinum','VIP','Gold')  then 1 else 0 end as totnonplatinum
from nonbilling89));
exit;
EOF

echo "</table>">>$sla
echo "</html>" >>$sla



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
spool sla_89_billing_$datestr.csv
-------------------All Open TT Incident extract------------------------------------
select  
'IncidentNo'
||','||'OpenTime'
||','||'CloseTime'
||','||'Customer Value'
||','||'Time_to_resolve'
||','||'Platinum_ttr'
||','||'NONPlatinum_ttr'
from Dual
UNION ALL
select
num
||','||ot
||','||ct
||','||cust_val
||','||ttr
||','||platinumttr
||','||nonplatinumttr
from billing89;
spool off;
quit;
EOF

echo "" >> $sla
cat sla_89_billing_$datestr.csv >> $sla

------------------------------Non Billing----------------------------

echo "--XXXXboundary text" >>$sla
echo "Content-Type: text/plain" >> $sla
echo "Content-Disposition: attachement; filename=sla_89_nonbilling_$datestr.csv" >> $sla

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
set define off
spool sla_89_nonbilling_$datestr.csv
-------------------All Open TT Incident extract------------------------------------
select  
'IncidentNo'
||','||'OpenTime'
||','||'CloseTime'
||','||'Customer Value'
||','||'Time_to_resolve'
||','||'Platinum_ttr'
||','||'NONPlatinum_ttr'
from Dual
UNION ALL
select
num
||','||ot
||','||ct
||','||cust_val
||','||ttr
||','||platinumttr
||','||nonplatinumttr
from nonbilling89;
spool off;
quit;
EOF

echo "" >> $sla
cat sla_89_nonbilling_$datestr.csv >> $sla
echo "--XXXXboundary text" >>$sla
cat $sla | /usr/lib/sendmail -t
