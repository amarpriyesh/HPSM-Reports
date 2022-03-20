cd /hpsm/hpsm/ops/reports
datestr=`date "+%d%m%y%H%M"`
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set heading on
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
spool test_tamer.csv 
-------------------All Open TT Incident extract------------------------------------
select
'IncidentNo'
||','||'IncidentStatus'
||','||'Open Time'
||','||'assignment'
||','||'Description'
from Dual
union ALL
select
a."NUMBER"
||','||a.problem_status
||','||to_char(a.OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||a.assignment
||','||a.brief_description
from probsummarym1 a where "NUMBER"='IM4192491' and  (upper(a.assignment) in ('SD_CPE','IT - BSCS (BILLING) - DEV','IT - BSS STREAMSERVE - DEV','IT - BSS POWERBILL - DEV','IT - BSS IN - DEV','DCS - DEV','IT - BSS STRONGMAIL - DEV','IT - PAYMENT GATEWAY - DEV','IT - POS - DEV','RA - MONETA - DEV','IT - ICS - DEV','IT - SIEBEL (CRM)  ATOS','IT - OMP - DEV','IT DSP DEV','IT - ESS MNMI - DEV','IT - EAI - DEV','IT - OSS-DEV-FIXED PROVISIONING','IT - OSS-DEV-MOBILE PROVISIONING','IT - OSS-DEV-MOBILE MEDIATION','IT - GIS - DEV','IT - OSS-DEV-OAIM','IT - OSS-DEV-NPG','MSDP - DEV','IT - DEV - IDASHBOARDS','IT - OSS-DEV- HPSM','CAMPAIGN MANAGEMENT - DEV','IT - EDMS - DEV','IT - ESS DUVERSE - DEV','IT - DATAWAREHOUSE - DEV','CUSTOMER PROFITABILITY - DEV','IT - ICM DEV','IT - ERP - DEV','IT - DEV - INTRANET','IT - EBUSINESS - DEV','DQ - DEV','UCM - DEV','IT - IWV - DEV','IT - ESS MOI - DEV','IT BSS Ops L4 TT','IT ESS Ops L4 TT','IT OSS Ops L4 TT') or assignment like '%Ops L3%' or a.assignment like 'IT - Siebel (CRM)%Atos') and (a.open_time+4/24) between (TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD')-7) and (TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD')) ;
spool off;
quit;
EOF
cat testtamer.txt | mail -v -s " test tt  `date`" -a /hpsm/hpsm/ops/reports/test_tamer.csv priyesh.a@du.ae
