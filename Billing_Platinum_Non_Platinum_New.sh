cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/

REPORTFILE_BILLING=BILLING_report

recipient="utkarsh.jauhari@du.ae"
recipient1=""
MailSubject="Billing (Platinum & Non Platinum) Report @ `date \"+%d/%m/%Y %H:%M\"`"

OUTPUTFLAG=HTML

rm BILLING_report

echo "Subject: $MailSubject
To: $recipient
Cc: $recipient1
MIMEV=\"MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw" 
Content-Disposition: inline
" >> $REPORTFILE_BILLING

echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_BILLING
echo "Content-Type: text/html" >> $REPORTFILE_BILLING
echo "Content-Disposition: inline" >> $REPORTFILE_BILLING
echo "" >> $REPORTFILE_BILLING

echo "<html><P><font color="blue">
Dear All,<br /><br />Please find below Billing Platinum and Non-Platinum Report as on `date -d'yesterday' +%d/%m/%y`<br />
<br /></P></html>" >> $REPORTFILE_BILLING 

echo "<html><P><font color="blue">
<B><U>Platinum:</U></B>
<br /></P></html>" >> $REPORTFILE_BILLING

echo "<TABLE border="1">" >> $REPORTFILE_BILLING

echo "<TR><TH><font color ="blue">Resolved Within 12 Hours (Count)</TH></font><TH><font color ="blue">Resolved Within 12 Hours (%)</TH></font><TH><font color ="blue">Resolved After 12 Hours (Count)</TH></font><TH><font color ="blue">Resolved After 12 Hours(%)</TH></font><TH><font color ="blue">To Be Resolved (Count)</TH></font><TH><font color ="blue">To Be Resolved(%)</TH></font></TR>" >>$REPORTFILE_BILLING 
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_BILLING
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td align=center>'|| nvl(SLA,0)||'</td><td align=center>'|| nvl(SLA1,0)||'%'||'</td><td align=center>'||nvl(NOSLA,0)||'</td><td align=center>'||nvl(NOSLA1,0)||'%'||'</td><td align=center>'|| nvl(NA,0)||'</td><td align=center>'|| nvl(NA1,0)||'%'||'</td></tr>' 
From (select SLA,round((SLA/nullif((SLA+NOSLA+NA),0))*100,2) as SLA1,NOSLA,round((NOSLA/nullif((SLA+NOSLA+NA),0))*100,2) as NOSLA1,NA,round((NA/nullif((SLA+NOSLA+NA),0))*100,2) as NA1 from (
  select
count (case when
 (to_char(a.resolved_time+4/24, 'yyyymmddHH24MISS')is not null and (a.open_time+4/24 + interval '12' HOUR)>a.resolved_time+4/24)then 3 else null end) as SLA,
count (case when 
(to_char(a.resolved_time+4/24, 'yyyymmddHH24MISS')is null and ((a.open_time+4/24 + interval '12' HOUR)<sysdate and a.problem_status!='Pending Input')) or
 (to_char(a.resolved_time+4/24, 'yyyymmddHH24MISS')is not null and (a.open_time+4/24 + interval '12' HOUR)<a.resolved_time+4/24)then 2 else null end) as NOSLA,
 count(case when to_char(a.resolved_time+4/24, 'yyyymmddHH24MISS')is null and ((a.open_time+4/24 + interval '12' HOUR)>sysdate or a.problem_status='Pending Input') then 1 else null end) as NA
from probsummarym1 a, activitym1 b
where  a."NUMBER" = b."NUMBER"
and a.problem_status not in ('Reopened','Rejected','Rejected to Business') and b.type='Open' and a."NUMBER" in (select /*+PARALLEL(5)*/ distinct
b."NUMBER"
from HPSM94BKPADMIN.Probsummarym1 a, HPSM94BKPADMIN.activitym1 b 
 where (a.open_time+4/24) >= TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD') and
 folder ='SIEBEL-CRM' 
and (CATEGORY,subcategory,product_type) IN (SELECT  /*+PARALLEL(5)*/  TYPE,AREA,SUB_AREA FROM DU_BILLING_NONBILLING WHERE 
SOURCE='BILLING' )
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
b.description LIKE '%Core - Mobile IN to%')
and b."NUMBER"=a."NUMBER") and du_cust_value='Platinum'));

 
exit;
EOF
echo "</TABLE>" >> $REPORTFILE_BILLING
echo $NEWLINE
echo $NEWLINE
echo "<html><P><font color="blue">
<B><U>Non Platinum:</U></B>
<br /></P></html>" >> $REPORTFILE_BILLING
echo "<TABLE border="1">" >> $REPORTFILE_BILLING
echo "<TR><TH><font color ="blue">Resolved Within 24 Hours (Count)</TH></font><TH><font color ="blue">Resolved Within 24 Hours (%)</TH></font><TH><font color ="blue">Resolved After 24 Hours (Count)</TH></font><TH><font color ="blue">Resolved After 24 Hours(%)</TH></font><TH><font color ="blue">To Be Resolved (Count)</TH></font><TH><font color ="blue">To Be Resolved(%)</TH></font></TR>" >> $REPORTFILE_BILLING 
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_BILLING
set linesize 1500;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td align=center>'|| nvl(SLA,0)||'</td><td align=center>'|| nvl(SLA1,0)||'%'||'</td><td align=center>'||nvl(NOSLA,0)||'</td><td align=center>'||nvl(NOSLA1,0)||'%'||'</td><td align=center>'|| nvl(NA,0)||'</td><td align=center>'|| nvl(NA1,0)||'%'||'</td></tr>' 
From (select SLA,round((SLA/nullif((SLA+NOSLA+NA),0))*100,2) as SLA1,NOSLA,round((NOSLA/nullif((SLA+NOSLA+NA),0))*100,2) as NOSLA1,NA,round((NA/nullif((SLA+NOSLA+NA),0))*100,2) as NA1 from (
  select
count (case when
 (to_char(a.resolved_time+4/24, 'yyyymmddHH24MISS')is not null and (a.open_time+4/24 + interval '24' HOUR)>a.resolved_time+4/24)then 3 else null end) as SLA,
count (case when 
(to_char(a.resolved_time+4/24, 'yyyymmddHH24MISS')is null and ((a.open_time+4/24 + interval '24' HOUR)<sysdate and a.problem_status!='Pending Input')) or
 (to_char(a.resolved_time+4/24, 'yyyymmddHH24MISS')is not null and (a.open_time+4/24 + interval '24' HOUR)<a.resolved_time+4/24)then 2 else null end) as NOSLA,
 count(case when to_char(a.resolved_time+4/24, 'yyyymmddHH24MISS')is null and ((a.open_time+4/24 + interval '24' HOUR)>sysdate or a.problem_status='Pending Input') then 1 else null end) as NA
from probsummarym1 a, activitym1 b
where  a."NUMBER" = b."NUMBER"
and a.problem_status not in ('Reopened','Rejected','Rejected to Business') and b.type='Open' and a."NUMBER" in (select /*+PARALLEL(5)*/ distinct
b."NUMBER"
from HPSM94BKPADMIN.Probsummarym1 a, HPSM94BKPADMIN.activitym1 b 
 where (a.open_time+4/24) >= TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD') and
 folder ='SIEBEL-CRM' 
and (CATEGORY,subcategory,product_type) IN (SELECT  /*+PARALLEL(5)*/  TYPE,AREA,SUB_AREA FROM DU_BILLING_NONBILLING WHERE 
SOURCE='BILLING' )
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
b.description LIKE '%Core - Mobile IN to%')
and b."NUMBER"=a."NUMBER") and du_cust_value!='Platinum'));

 
exit;
EOF
echo "</TABLE>" >> $REPORTFILE_BILLING
echo $NEWLINE
echo $NEWLINE
echo "<html><P><font color="blue"><B><U>Note:</U></B> This report does not include Reopened, Rejected and Rejected to Business TTs.<br /><br />Regards,<br />HPSM Support Team<br /><br />This is system auto generated mail,Please do not reply.<br /></P></html>" >> $REPORTFILE_BILLING 
echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_BILLING
echo "Content-Type: text/plain" >> $REPORTFILE_BILLING
echo "Content-Disposition: attachement; filename=BILLING_PLATINUM.csv" >> $REPORTFILE_BILLING

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
set define off
spool BILLING_PLATINUM.csv
-------------------BILLING------------------------------------
select  /*+PARALLEL(5)*/ 
'IncidentNo'
||'|'||'Status'
||'|'||'Category'
||'|'||'Area'
||'|'||'SubArea'
||'|'||'Priority'
||'|'||'ResolverGroup'
||'|'||'ResolvedBy'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'CloseTime'
||'|'||'Folder'
||'|'||'Customer Value'
||'|'||'Reopen COunt'
||'|'||'TTType'
||'|'||'ReassignmentCount'
||'|'||'Resolved_Within_12_hours'
from Dual
UNION ALL
select  /*+PARALLEL(5)*/ 
a."NUMBER"
||'|'||a.problem_status
||'|'||a.category
||'|'||a.subcategory
||'|'||a.product_type
||'|'||a.priority_code
||'|'||a.assignment
||'|'||a.resolved_by
||'|'||to_char(a.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.close_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||a.folder
||'|'||a.du_cust_value
||'|'||a.du_reopencount
||'|'||a.du_tt_type
||'|'||a.count
||'|'||case 
        when to_char(a.resolved_time+4/24, 'yyyymmddHH24MISS')is null and ((a.open_time+4/24 + interval '12' HOUR)>sysdate or a.problem_status='Pending Input') then ' '
        when to_char(a.resolved_time+4/24, 'yyyymmddHH24MISS')is null and ((a.open_time+4/24 + interval '12' HOUR)<sysdate or a.problem_status!='Pending Input') then 'No' 
        when (a.open_time+4/24 + interval '12' HOUR)<a.resolved_time+4/24 then 'No'
        else 'Yes'
end
from HPSM94BKPADMIN.probsummarym1 a
where a.problem_status not in ('Reopened','Rejected','Rejected to Business') and a."NUMBER" in (select /*+PARALLEL(5)*/ distinct
b."NUMBER"
from activitym1 b,probsummarym1 a where (a.open_time+4/24) >= TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD') and
 folder ='SIEBEL-CRM' 
and (CATEGORY,subcategory,product_type) IN (SELECT  /*+PARALLEL(5)*/  TYPE,AREA,SUB_AREA FROM DU_BILLING_NONBILLING WHERE SOURCE='BILLING' )
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
b.description LIKE '%Core - Mobile IN to%')
and b."NUMBER"=a."NUMBER") and du_cust_value='Platinum';
spool off;
quit;
EOF

#echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_BILLING
#echo "Content-Type: text/plain" >> $REPORTFILE_BILLING
#echo "Content-Disposition: attachement; filename=BILLING_PLATINUM.csv" >> $REPORTFILE_BILLING
#echo "" >> $REPORTFILE_BILLING
echo "" >> $REPORTFILE_BILLING
cat BILLING_PLATINUM.csv >> $REPORTFILE_BILLING

echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_BILLING
echo "Content-Type: text/plain" >> $REPORTFILE_BILLING
echo "Content-Disposition: attachement; filename=BILLING_Non_PLATINUM.csv" >> $REPORTFILE_BILLING

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
set define off
spool BILLING_Non_PLATINUM.csv
-------------------BILLING------------------------------------
select  /*+PARALLEL(5)*/ 
'IncidentNo'
||'|'||'Status'
||'|'||'Category'
||'|'||'Area'
||'|'||'SubArea'
||'|'||'Priority'
||'|'||'ResolverGroup'
||'|'||'ResolvedBy'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'CloseTime'
||'|'||'Folder'
||'|'||'Customer Value'
||'|'||'Reopen COunt'
||'|'||'TTType'
||'|'||'ReassignmentCount'
||'|'||'Resolved_Within_12_hours'
from Dual
UNION ALL
select  /*+PARALLEL(5)*/ 
a."NUMBER"
||'|'||a.problem_status
||'|'||a.category
||'|'||a.subcategory
||'|'||a.product_type
||'|'||a.priority_code
||'|'||a.assignment
||'|'||a.resolved_by
||'|'||to_char(a.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.close_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||a.folder
||'|'||a.du_cust_value
||'|'||a.du_reopencount
||'|'||a.du_tt_type
||'|'||a.count
||'|'||case 
        when to_char(a.resolved_time+4/24, 'yyyymmddHH24MISS')is null and ((a.open_time+4/24 + interval '24' HOUR)>sysdate or a.problem_status='Pending Input') then ' '
        when to_char(a.resolved_time+4/24, 'yyyymmddHH24MISS')is null and ((a.open_time+4/24 + interval '24' HOUR)<sysdate or a.problem_status!='Pending Input') then 'No' 
        when (a.open_time+4/24 + interval '24' HOUR)<a.resolved_time+4/24 then 'No'
        else 'Yes'
end
from HPSM94BKPADMIN.probsummarym1 a
where 
a.problem_status not in ('Reopened','Rejected','Rejected to Business') and a."NUMBER" in (select /*+PARALLEL(5)*/ distinct
b."NUMBER"
from activitym1 b,probsummarym1 a where (a.open_time+4/24) >= TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD') and
 folder ='SIEBEL-CRM' 
and (CATEGORY,subcategory,product_type) IN (SELECT  /*+PARALLEL(5)*/  TYPE,AREA,SUB_AREA FROM DU_BILLING_NONBILLING WHERE SOURCE='BILLING' )
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
b.description LIKE '%Core - Mobile IN to%')
and b."NUMBER"=a."NUMBER") and du_cust_value!='Platinum';
spool off;
quit;
EOF

#echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_BILLING
#echo "Content-Type: text/plain" >> $REPORTFILE_BILLING
#echo "Content-Disposition: attachement; filename=BILLING_Non_PLATINUM.csv" >> $REPORTFILE_BILLING
#echo "" >> $REPORTFILE_BILLING
echo "" >> $REPORTFILE_BILLING
cat BILLING_Non_PLATINUM.csv >> $REPORTFILE_BILLING
cat $REPORTFILE_BILLING | /usr/lib/sendmail -t
