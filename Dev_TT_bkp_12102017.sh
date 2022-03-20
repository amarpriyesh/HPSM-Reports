cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/

REPORTFILE_AS=AS_reportDevTT
dt=`date +%H%M`

recipient="ankur.saxena@du.ae,priyesh.a@du.ae,sanjay.sharma@du.ae,gagan.atreya@du.ae,neeraj.sharma@du.ae,rahul.gupta1@du.ae"
#recipient="priyesh.a@du.ae"
MailSubject="All DEV TT Report wrt Assignment Group  for the past week"

OUTPUTFLAG=HTML

rm AS_reportDevTT

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
Dear All,<br /><br />Please find below DEV TTs report w.r.t assignment group <br />
<br /></P></html>" >> $REPORTFILE_AS 

echo $NEWLINE
echo $NEWLINE

echo "<html><P><font color="blue">
<br /><br />Current Status of DEV Resolver Groups<br />
<br /></P></html>" >> $REPORTFILE_AS

echo $NEWLINE
echo $NEWLINE

echo "<TABLE border="1">" >> $REPORTFILE_AS 
echo "<TR><TH><font color="blue">Resolver Group</TH></font><TH><font color ="blue">Open</TH></font><TH><font color ="blue">Accepted</TH></font><TH><font color="blue">In Progress</TH></font><TH><font color="blue">Pending Input</TH></font><TH><font color="blue">ReAssigned</TH></font><TH><font color="blue">Reopened</TH></font><TH><font color="blue">Rejected</TH></font><TH><font color="blue">Rejected to Business</TH></font><TH><font color="blue">Total</TH></font></TR>" >> $REPORTFILE_AS 


sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_AS
set linesize 2000;
set trimspool on;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td>'||x.assignment||'</td><td align=center>'||sum(Open)||'</td><td align=center>'||sum(Accepted) ||'</td><td align=center>'||sum(In_Progress) ||'</td><td align=center>'||sum(Pending_Input) ||'</td><td align=center>'||sum(ReAssigned) ||'</td><td align=center>'||sum(Reopened) ||'</td><td align=center>'||sum(Rejected) ||'</td><td align=center>'||sum(RTB) ||'</td><th>'||count(*) ||'</th></tr>'from (select b.assignment, case when (b.problem_status='Open') then 1 else 0 end Open , case when (b.problem_status='Accepeted') then 1 else 0 end Accepted ,case when (b.problem_status='In Progress') then 1 else 0 end In_Progress , case when (b.problem_status='Pending Input') then 1 else 0 end Pending_Input, case when (b.problem_status='ReAssigned') then 1 else 0 end ReAssigned, case when (b.problem_status='Reopened') then 1 else 0 end Reopened, case when (b.problem_status='Rejected') then 1 else 0 end Rejected, case when (b.problem_status='Rejected to Business') then 1 else 0 end RTB from probsummarym1 b where b.problem_status in ('Open','Accepted','In Progress','Pending Input','ReAssigned','Reopened','Rejected','Rejected to Business') and  (upper(b.assignment) in ('SD_CPE','IT - BSCS (BILLING) - DEV','IT - BSS STREAMSERVE - DEV','IT - BSS POWERBILL - DEV','IT - BSS IN - DEV','DCS - DEV','IT - BSS STRONGMAIL - DEV','IT - PAYMENT GATEWAY - DEV','IT - POS - DEV','RA - MONETA - DEV','IT - ICS - DEV','IT - SIEBEL (CRM) – ATOS','IT - OMP - DEV','IT DSP DEV','IT - ESS MNMI - DEV','IT - EAI - DEV','IT - OSS-DEV-FIXED PROVISIONING','IT - OSS-DEV-MOBILE PROVISIONING','IT - OSS-DEV-MOBILE MEDIATION','IT - GIS - DEV','IT - OSS-DEV-OAIM','IT - OSS-DEV-NPG','MSDP - DEV','IT - DEV - IDASHBOARDS','IT - OSS-DEV- HPSM','CAMPAIGN MANAGEMENT - DEV','IT - EDMS - DEV','IT - ESS DUVERSE - DEV','IT - DATAWAREHOUSE - DEV','CUSTOMER PROFITABILITY - DEV','IT - ICM DEV','IT - ERP - DEV','IT - DEV - INTRANET','IT - EBUSINESS - DEV','DQ - DEV','UCM - DEV','IT - IWV - DEV','IT - ESS MOI - DEV') or b.assignment like '%Ops L3%' or b.assignment like 'IT - Siebel (CRM)%Atos' or b.assignment in ('FNL_DEV','FNL_OPs','FNL_SDM'))) x group by x.assignment;

exit;
EOF

echo "</TABLE>" >> $REPORTFILE_AS
echo $NEWLINE
echo $NEWLINE
echo $NEWLINE
echo $NEWLINE

echo "<html><P><font color="blue">
<br /><br />DEV TTs for the past week<br />
<br /></P></html>" >> $REPORTFILE_AS

echo "<TABLE border="1">" >> $REPORTFILE_AS 
echo "<TR><TH><font color="blue">Resolver Group</TH></font><TH><font color ="blue">Open</TH></font><TH><font color ="blue">Pending Input</TH></font><TH><font color="blue">Resolved</TH></font><TH><font color="blue">Closed</TH></font><TH><font color="blue">Total</TH></font></TR>" >> $REPORTFILE_AS

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_AS
set linesize 2000;
set trimspool on;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td>'||x.assignment||'</td><td align=center>'||sum(Open)||'</td><td align=center>'||sum(Pending_Input) ||'</td><td align=center>'||sum(Resolved) ||'</td><td align=center>'||sum(Closed) ||'</td><th>'||count(*) ||'</th></tr>'from (select /*+PARALLEL(5)*/ b.assignment, case when (b.problem_status='Open' or b.problem_status='Accepted' or b.problem_status='In Progress' or b.problem_status='ReAssigned' or b.problem_status='Reopened' or b.problem_status='Rejected' or b.problem_status='Rejected to Business') then 1 else 0 end Open , case when (b.problem_status='Pending Input') then 1 else 0 end Pending_Input ,case when (b.problem_status='Resolved') then 1 else 0 end Resolved , case when (b.problem_status='Closed') then 1 else 0 end Closed from probsummarym1 b where b.open_time+4/24>trunc(sysdate-7) and  (upper(b.assignment) in ('SD_CPE','IT - BSCS (BILLING) - DEV','IT - BSS STREAMSERVE - DEV','IT - BSS POWERBILL - DEV','IT - BSS IN - DEV','DCS - DEV','IT - BSS STRONGMAIL - DEV','IT - PAYMENT GATEWAY - DEV','IT - POS - DEV','RA - MONETA - DEV','IT - ICS - DEV','IT - SIEBEL (CRM) – ATOS','IT - OMP - DEV','IT DSP DEV','IT - ESS MNMI - DEV','IT - EAI - DEV','IT - OSS-DEV-FIXED PROVISIONING','IT - OSS-DEV-MOBILE PROVISIONING','IT - OSS-DEV-MOBILE MEDIATION','IT - GIS - DEV','IT - OSS-DEV-OAIM','IT - OSS-DEV-NPG','MSDP - DEV','IT - DEV - IDASHBOARDS','IT - OSS-DEV- HPSM','CAMPAIGN MANAGEMENT - DEV','IT - EDMS - DEV','IT - ESS DUVERSE - DEV','IT - DATAWAREHOUSE - DEV','CUSTOMER PROFITABILITY - DEV','IT - ICM DEV','IT - ERP - DEV','IT - DEV - INTRANET','IT - EBUSINESS - DEV','DQ - DEV','UCM - DEV','IT - IWV - DEV','IT - ESS MOI - DEV') or b.assignment like '%Ops L3%' or b.assignment like 'IT - Siebel (CRM)%Atos' or b.assignment in ('FNL_DEV','FNL_OPs','FNL_SDM'))) x group by x.assignment;

exit;
EOF


echo "</TABLE>" >> $REPORTFILE_AS

echo $NEWLINE
echo $NEWLINE

echo "<html><P><font color="blue">Regards,<br />HPSM Support Team<br /><br />This is system auto generated mail,Please do not reply<br /></P></html>" >> $REPORTFILE_AS
echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_AS
echo "Content-Type: text/plain" >> $REPORTFILE_AS
echo "Content-Disposition: attachement; filename=Dev_TT.csv">>$REPORTFILE_AS
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
set define off
spool Dev_TT.csv 
-------------------All Open TT Incident extract------------------------------------


Select /*+PARALLEL(5)*/
'IncidentNo'
||','||'IncidentStatus'
||','||'PendingCode'
||','||'priority'
||','||'CurrentResolverGroup'
||','||'AssigneeName'
||','||'OpenTime'
||','||'ResolvedTime'
||','||'CloseTime'
||','||'OpenedBy'
||','||'Category'
||','||'Area'
||','||'SubArea'
||','||'Customer Accountnumber'
||','||'Customer Value'
||','||'Contrtact ID'
||','||'Asset number'
||','||'Current Age of TT (No.of days)'
||','||'Assigned Time'
||','||'Reopen Count'
||','||'Reassign Count'
||','||'Brief Description'
from Dual
union ALL
select /*+PARALLEL(5)*/
"NUMBER"
||','||problem_status
||','||(case when problem_status='Pending Input' then pending_code else '' end)
||','||priority_code
||','||assignment
||','||assignee_name
||','||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(RESOLVED_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(CLOSE_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||opened_by
||','||category
||','||subcategory
||','||product_type
||','||du_cust_accnumber
||','||du_cust_value
||','||du_contract_id
||','||du_asset_number
||','||(to_date(trunc(sysdate),' dd-mon-yyyy HH24:MI SS')-TO_DATE(open_time+4/24,'DD-MON-YYYY HH24:MI'))
||','||(select max(to_char(datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')) from activitym1 a where a."NUMBER"=b."NUMBER" and (type='ReAssigned' 
or a.type='Reopened'or a.type='Open'))
||','||DU_REOPENCOUNT
||','||"COUNT"
||','||(REPLACE(REPLACE (REPLACE (DBMS_LOB.SUBSTR ( b.brief_description, 2000, 1),CHR (10),' '),CHR (13),' '),CHR (9),' '))
from
HPSM94BKPADMIN.probsummarym1 b
where b.open_time+4/24> trunc(sysdate-7) and (upper(b.assignment) in ('SD_CPE','IT - BSCS (BILLING) - DEV','IT - BSS STREAMSERVE - DEV','IT - BSS POWERBILL - DEV','IT - BSS IN - DEV','DCS - DEV','IT - BSS STRONGMAIL - DEV','IT - PAYMENT GATEWAY - DEV','IT - POS - DEV','RA - MONETA - DEV','IT - ICS - DEV','IT - SIEBEL (CRM) – ATOS','IT - OMP - DEV','IT DSP DEV','IT - ESS MNMI - DEV','IT - EAI - DEV','IT - OSS-DEV-FIXED PROVISIONING','IT - OSS-DEV-MOBILE PROVISIONING','IT - OSS-DEV-MOBILE MEDIATION','IT - GIS - DEV','IT - OSS-DEV-OAIM','IT - OSS-DEV-NPG','MSDP - DEV','IT - DEV - IDASHBOARDS','IT - OSS-DEV- HPSM','CAMPAIGN MANAGEMENT - DEV','IT - EDMS - DEV','IT - ESS DUVERSE - DEV','IT - DATAWAREHOUSE - DEV','CUSTOMER PROFITABILITY - DEV','IT - ICM DEV','IT - ERP - DEV','IT - DEV - INTRANET','IT - EBUSINESS - DEV','DQ - DEV','UCM - DEV','IT - IWV - DEV','IT - ESS MOI - DEV') or b.assignment like '%Ops L3%' or b.assignment like 'IT - Siebel (CRM)%Atos' or b.assignment in ('FNL_DEV','FNL_OPs','FNL_SDM'));

spool off;
quit;
EOF
echo "" >> $REPORTFILE_AS
cat Dev_TT.csv >> $REPORTFILE_AS

echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_AS
echo "Content-Type: text/plain" >> $REPORTFILE_AS
echo "Content-Disposition: attachement; filename=Dev_Reassigned_TT.csv">>$REPORTFILE_AS
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
set define off
spool Dev_Reassigned_TT.csv 
-------------------All Open TT Incident extract------------------------------------

select /*+PARALLEL(5)*/  
'IncidentNo'
||'|'||'Category'
||'|'||'Area'
||'|'||'SubArea'
||'|'||'Priority'
||'|'||'ResolverGroup'
||'|'||'ResolvedBy'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'UpdateTime'
||'|'||'CloseTime'
||'|'||'ResolutionCategory'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'Reopen Count'
||'|'||'ReAssignmentReason'
||'|'||'ReassignmentCount'
||'|'||'LastResolverGroup'
||'|'||'BriefDescription'
||'|'||'Action'
from Dual
UNION ALL
select /*+PARALLEL(5)*/ 
a."NUMBER"
||'|'||a.category
||'|'||a.subcategory
||'|'||a.product_type
||'|'||a.priority_code
||'|'||a.assignment
||'|'||a.resolved_by
||'|'||to_char(a.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(b.datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.close_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||a.resolution_code
||'|'||a.resolution_type
||'|'||a.resolution_area
||'|'||a.du_reopencount
||'|'||REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(b.description, 1000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' ')
||'|'||a.count
||'|'||a.du_previous_assignment
||'|'||REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(a.brief_description, 1000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' ')
||'|'||REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(a.action, 1000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' ')
from probsummarym1 a, activitym1 b
where a."NUMBER"=b."NUMBER" and b.type='Reassignment reason' and a.open_time+4/24> trunc(sysdate-7) and (upper(a.assignment) in ('SD_CPE','IT - BSCS (BILLING) - DEV','IT - BSS STREAMSERVE - DEV','IT - BSS POWERBILL - DEV','IT - BSS IN - DEV','DCS - DEV','IT - BSS STRONGMAIL - DEV','IT - PAYMENT GATEWAY - DEV','IT - POS - DEV','RA - MONETA - DEV','IT - ICS - DEV','IT - SIEBEL (CRM) – ATOS','IT - OMP - DEV','IT DSP DEV','IT - ESS MNMI - DEV','IT - EAI - DEV','IT - OSS-DEV-FIXED PROVISIONING','IT - OSS-DEV-MOBILE PROVISIONING','IT - OSS-DEV-MOBILE MEDIATION','IT - GIS - DEV','IT - OSS-DEV-OAIM','IT - OSS-DEV-NPG','MSDP - DEV','IT - DEV - IDASHBOARDS','IT - OSS-DEV- HPSM','CAMPAIGN MANAGEMENT - DEV','IT - EDMS - DEV','IT - ESS DUVERSE - DEV','IT - DATAWAREHOUSE - DEV','CUSTOMER PROFITABILITY - DEV','IT - ICM DEV','IT - ERP - DEV','IT - DEV - INTRANET','IT - EBUSINESS - DEV','DQ - DEV','UCM - DEV','IT - IWV - DEV','IT - ESS MOI - DEV','FNL_DEV','FNL_OPs','FNL_SDM') or a.assignment like '%Ops L3%' or a.assignment like 'IT - Siebel (CRM)%Atos');



spool off;
quit;
EOF
echo "" >> $REPORTFILE_AS
cat Dev_Reassigned_TT.csv >> $REPORTFILE_AS


echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_AS
echo "Content-Type: text/plain" >> $REPORTFILE_AS
echo "Content-Disposition: attachement; filename=Dev_Closed_TT.csv">>$REPORTFILE_AS
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
set define off
spool Dev_Closed_TT.csv 
-------------------All Closed/Resolved TT Incident extract------------------------------------

Select /*+PARALLEL(5)*/
'IncidentNo'
||','||'IncidentStatus'
||','||'PendingCode'
||','||'priority'
||','||'CurrentResolverGroup'
||','||'AssigneeName'
||','||'OpenTime'
||','||'ResolvedTime'
||','||'ClosedTime'
||','||'OpenedBy'
||','||'Category'
||','||'Area'
||','||'SubArea'
||','||'Customer Accountnumber'
||','||'Customer Value'
||','||'Contrtact ID'
||','||'Asset number'
||','||'Current Age of TT (No.of days)'
||','||'Assigned Time'
||','||'Reopen Count'
||','||'Reassign Count'
||','||'Brief Description'
from Dual
union ALL
select /*+PARALLEL(5)*/
"NUMBER"
||','||problem_status
||','||(case when problem_status='Pending Input' then pending_code else '' end)
||','||priority_code
||','||assignment
||','||assignee_name
||','||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(RESOLVED_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(CLOSE_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||opened_by
||','||category
||','||subcategory
||','||product_type
||','||du_cust_accnumber
||','||du_cust_value
||','||du_contract_id
||','||du_asset_number
||','||(to_date(trunc(sysdate),' dd-mon-yyyy HH24:MI SS')-TO_DATE(open_time+4/24,'DD-MON-YYYY HH24:MI'))
||','||(select max(to_char(datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')) from activitym1 a where a."NUMBER"=b."NUMBER" and (type='ReAssigned' 
or a.type='Reopened'or a.type='Open'))
||','||DU_REOPENCOUNT
||','||"COUNT"
||','||(REPLACE(REPLACE (REPLACE (DBMS_LOB.SUBSTR ( b.brief_description, 2000, 1),CHR (10),' '),CHR (13),' '),CHR (9),' '))
from
HPSM94BKPADMIN.probsummarym1 b
where (b.resolved_time+4/24> trunc(sysdate-30) or b.close_time+4/24>trunc(sysdate-30)) and (upper(b.assignment) in ('SD_CPE','IT - BSCS (BILLING) - DEV','IT - BSS STREAMSERVE - DEV','IT - BSS POWERBILL - DEV','IT - BSS IN - DEV','DCS - DEV','IT - BSS STRONGMAIL - DEV','IT - PAYMENT GATEWAY - DEV','IT - POS - DEV','RA - MONETA - DEV','IT - ICS - DEV','IT - SIEBEL (CRM) – ATOS','IT - OMP - DEV','IT DSP DEV','IT - ESS MNMI - DEV','IT - EAI - DEV','IT - OSS-DEV-FIXED PROVISIONING','IT - OSS-DEV-MOBILE PROVISIONING','IT - OSS-DEV-MOBILE MEDIATION','IT - GIS - DEV','IT - OSS-DEV-OAIM','IT - OSS-DEV-NPG','MSDP - DEV','IT - DEV - IDASHBOARDS','IT - OSS-DEV- HPSM','CAMPAIGN MANAGEMENT - DEV','IT - EDMS - DEV','IT - ESS DUVERSE - DEV','IT - DATAWAREHOUSE - DEV','CUSTOMER PROFITABILITY - DEV','IT - ICM DEV','IT - ERP - DEV','IT - DEV - INTRANET','IT - EBUSINESS - DEV','DQ - DEV','UCM - DEV','IT - IWV - DEV','IT - ESS MOI - DEV') or b.assignment like '%Ops L3%' or b.assignment like 'IT - Siebel (CRM)%Atos' or b.assignment in ('FNL_DEV','FNL_SDM'));


spool off;
quit;
EOF
echo "" >> $REPORTFILE_AS
cat Dev_Closed_TT.csv >> $REPORTFILE_AS
cat $REPORTFILE_AS | /usr/lib/sendmail -t
