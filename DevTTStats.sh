cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/

REPORTFILE_DEV=DevTTStat
recipient=""
recipient1="utkarsh.jauhari@du.ae"

MailSubject="Dev TTs Statistics of last week"

OUTPUTFLAG=HTML

rm DevTTStat

echo "Subject: $MailSubject
To: $recipient
Cc: $recipient1
From: hpsm@du.ae
MIMEV=\"MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
" >> $REPORTFILE_DEV

echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_DEV
echo "Content-Type: text/html" >> $REPORTFILE_DEV
echo "Content-Disposition: inline" >> $REPORTFILE_DEV
echo "" >> $REPORTFILE_DEV

echo "<html><P><font color="blue">
Dear All,<br /><br />PFA the statistics of Dev TTs for last week<br /><br />Best Regards<br />
<br /></P></html>" >> $REPORTFILE_DEV




sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
drop table reassign_dev;
create table reassign_dev as select a."NUMBER", a.problem_status, a.open_time, a.assignment, a.brief_description, b.type,b.datestamp, DBMS_LOB.SUBSTR (b.description, 2000, 1) Activity from probsummarym1 a, activitym1 b where a."NUMBER"=b."NUMBER" and
(upper(a.assignment) in ('SD_CPE','IT - BSCS (BILLING) - DEV','IT - BSS STREAMSERVE - DEV','IT - BSS POWERBILL - DEV','IT - BSS IN - DEV','DCS - DEV','IT - BSS STRONGMAIL - DEV','IT - PAYMENT GATEWAY - DEV','IT - POS - DEV','RA - MONETA - DEV','IT - ICS - DEV','IT - SIEBEL (CRM)  ATOS','IT - OMP - DEV','IT DSP DEV','IT - ESS MNMI - DEV','IT - EAI - DEV','IT - OSS-DEV-FIXED PROVISIONING','IT - OSS-DEV-MOBILE PROVISIONING','IT - OSS-DEV-MOBILE MEDIATION','IT - GIS - DEV','IT - OSS-DEV-OAIM','IT - OSS-DEV-NPG','MSDP - DEV','IT - DEV - IDASHBOARDS','IT - OSS-DEV- HPSM','CAMPAIGN MANAGEMENT - DEV','IT - EDMS - DEV','IT - ESS DUVERSE - DEV','IT - DATAWAREHOUSE - DEV','CUSTOMER PROFITABILITY - DEV','IT - ICM DEV','IT - ERP - DEV','IT - DEV - INTRANET','IT - EBUSINESS - DEV','DQ - DEV','UCM - DEV','IT - IWV - DEV','IT - ESS MOI - DEV','IT BSS Ops L4 TT','IT ESS Ops L4 TT','IT OSS Ops L4 TT') or assignment like '%Ops L3%' or a.assignment like 'IT - Siebel (CRM)%Atos') and 
b.datestamp between (TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD')-7) and (TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD')) and b.type in ('ReAssigned','Rejected');
quit;
EOF

echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_DEV
echo "Content-Type: text/plain" >> $REPORTFILE_DEV
echo "Content-Disposition: attachement; filename=Reassign_To_Others.csv" >> $REPORTFILE_DEV

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
set define off
spool Reassign_To_Others.csv
-------------------Reassign to Others extract------------------------------------
Select
'IncidentNo'
||','||'Datestamp'
||','||'LAST_ACTIVITY'
from Dual
union ALL
select "NUMBER"
||','||datestamp
||','||LAST_ACTIVITY from (select a."NUMBER", a.datestamp, (select b.activity from reassign_dev b where b.datestamp=a.datestamp and rownum=1) last_activity from (select "NUMBER", max(datestamp) datestamp from reassign_dev group by "NUMBER") a order by a.datestamp) where upper(last_activity) not like '%DEV%TO%OPS%' and upper(last_activity) not like '%DEV%TO%L3%' and upper(last_activity) not like '%L3%TO%DEV%' and upper(last_activity) not like '%OPS%TO%DEV%';
spool off;
quit;
EOF

echo "" >> $REPORTFILE_DEV
cat Reassign_To_Others.csv >> $REPORTFILE_DEV

echo "Content-Disposition: attachement; filename=Reassign_To_Ops.csv" >> $REPORTFILE_DEV

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
set define off
spool Reassign_To_Ops.csv
-------------------Pending to Others extract------------------------------------
Select
'IncidentNo'
||','||'Datestamp'
||','||'LAST_ACTIVITY'
from Dual
union ALL
select "NUMBER"
||','||datestamp
||','||LAST_ACTIVITY from (select a."NUMBER", a.datestamp, (select b.activity from reassign_dev b where b.datestamp=a.datestamp and rownum=1) last_activity from (select "NUMBER", max(datestamp) datestamp from reassign_dev group by "NUMBER") a order by a.datestamp) where upper(last_activity) like '%DEV%TO%OPS%' or upper(last_activity) like '%DEV%TO%L3%';
spool off;
quit;
EOF

echo "" >> $REPORTFILE_DEV
cat Reassign_To_Ops.csv >> $REPORTFILE_DEV

echo "Content-Disposition: attachement; filename=Reassign_To_Dev.csv" >> $REPORTFILE_DEV

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
set define off
spool Reassign_To_Dev.csv
-------------------Pending to Others extract------------------------------------
Select
'IncidentNo'
||','||'Datestamp'
||','||'LAST_ACTIVITY'
from Dual
union ALL
select "NUMBER"
||','||datestamp
||','||LAST_ACTIVITY from (select a."NUMBER", a.datestamp, (select b.activity from reassign_dev b where b.datestamp=a.datestamp and rownum=1) last_activity from (select "NUMBER", max(datestamp) datestamp from reassign_dev group by "NUMBER") a order by a.datestamp) where upper(last_activity) like '%OPS%TO%DEV%' or upper(last_activity) like '%L3%TO%DEV%';
spool off;
quit;
EOF

echo "" >> $REPORTFILE_DEV
cat Reassign_To_Dev.csv >> $REPORTFILE_DEV

echo "Content-Disposition: attachement; filename=Open_Dev.csv" >> $REPORTFILE_DEV


sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
set define off
spool Open_Dev.csv
-------------------Pending to Others extract------------------------------------
Select
'IncidentNo'
||','||'Problem_Status'
||','||'Open_Time'
||','||'Assignment'
||','||'brief_description'
from Dual
union ALL
select a."NUMBER"
||','||a.problem_status
||','||a.open_time
||','||a.assignment
||','||a.brief_description from probsummarym1 a where
(upper(a.assignment) in ('SD_CPE','IT - BSCS (BILLING) - DEV','IT - BSS STREAMSERVE - DEV','IT - BSS POWERBILL - DEV','IT - BSS IN - DEV','DCS - DEV','IT - BSS STRONGMAIL - DEV','IT - PAYMENT GATEWAY - DEV','IT - POS - DEV','RA - MONETA - DEV','IT - ICS - DEV','IT - SIEBEL (CRM)  ATOS','IT - OMP - DEV','IT DSP DEV','IT - ESS MNMI - DEV','IT - EAI - DEV','IT - OSS-DEV-FIXED PROVISIONING','IT - OSS-DEV-MOBILE PROVISIONING','IT - OSS-DEV-MOBILE MEDIATION','IT - GIS - DEV','IT - OSS-DEV-OAIM','IT - OSS-DEV-NPG','MSDP - DEV','IT - DEV - IDASHBOARDS','IT - OSS-DEV- HPSM','CAMPAIGN MANAGEMENT - DEV','IT - EDMS - DEV','IT - ESS DUVERSE - DEV','IT - DATAWAREHOUSE - DEV','CUSTOMER PROFITABILITY - DEV','IT - ICM DEV','IT - ERP - DEV','IT - DEV - INTRANET','IT - EBUSINESS - DEV','DQ - DEV','UCM - DEV','IT - IWV - DEV','IT - ESS MOI - DEV','IT BSS Ops L4 TT','IT ESS Ops L4 TT','IT OSS Ops L4 TT') or assignment like '%Ops L3%' or a.assignment like 'IT - Siebel (CRM)%Atos') and 
a.open_time between (TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD')-7) and (TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD')) order by a.open_time;
spool off;
quit;
EOF

echo "" >> $REPORTFILE_DEV
cat Open_Dev.csv >> $REPORTFILE_DEV

echo "Content-Disposition: attachement; filename=Resolve_Dev.csv" >> $REPORTFILE_DEV

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
set define off
spool Resolve_Dev.csv
-------------------Pending to Others extract------------------------------------
Select
'IncidentNo'
||','||'Problem_Status'
||','||'Open_Time'
||','||'Assignment'
||','||'brief_description'
from Dual
union ALL
select a."NUMBER"
||','||a.problem_status
||','||a.open_time
||','||a.assignment
||','||a.brief_description from probsummarym1 a where
(upper(a.assignment) in ('SD_CPE','IT - BSCS (BILLING) - DEV','IT - BSS STREAMSERVE - DEV','IT - BSS POWERBILL - DEV','IT - BSS IN - DEV','DCS - DEV','IT - BSS STRONGMAIL - DEV','IT - PAYMENT GATEWAY - DEV','IT - POS - DEV','RA - MONETA - DEV','IT - ICS - DEV','IT - SIEBEL (CRM)  ATOS','IT - OMP - DEV','IT DSP DEV','IT - ESS MNMI - DEV','IT - EAI - DEV','IT - OSS-DEV-FIXED PROVISIONING','IT - OSS-DEV-MOBILE PROVISIONING','IT - OSS-DEV-MOBILE MEDIATION','IT - GIS - DEV','IT - OSS-DEV-OAIM','IT - OSS-DEV-NPG','MSDP - DEV','IT - DEV - IDASHBOARDS','IT - OSS-DEV- HPSM','CAMPAIGN MANAGEMENT - DEV','IT - EDMS - DEV','IT - ESS DUVERSE - DEV','IT - DATAWAREHOUSE - DEV','CUSTOMER PROFITABILITY - DEV','IT - ICM DEV','IT - ERP - DEV','IT - DEV - INTRANET','IT - EBUSINESS - DEV','DQ - DEV','UCM - DEV','IT - IWV - DEV','IT - ESS MOI - DEV','IT BSS Ops L4 TT','IT ESS Ops L4 TT','IT OSS Ops L4 TT') or assignment like '%Ops L3%' or a.assignment like 'IT - Siebel (CRM)%Atos') and 
a.resolved_time between (TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD')-7) and (TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD')) order by a.resolved_time;
spool off;
quit;
EOF

echo "" >> $REPORTFILE_DEV
cat Resolve_Dev.csv >> $REPORTFILE_DEV

cat $REPORTFILE_DEV | /usr/lib/sendmail -t
