cd /hpsm/hpsm/ops/reports
datestr=`date "+%d%m%y%H%M"`

######Drop Table
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set heading on
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off

drop table reassign_dev;
quit;
EOF


#########Create Table
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set heading on
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
create table reassign_dev as select a."NUMBER", a.problem_status, a.open_time, a.assignment, a.brief_description, b.type,(b.datestamp+4/24) datestamp, DBMS_LOB.SUBSTR (b.description, 2000, 1) Activity from probsummarym1 a, activitym1 b where a."NUMBER"=b."NUMBER" and
(upper(a.assignment) in ('SD_CPE','IT - BSCS (BILLING) - DEV','IT - BSS STREAMSERVE - DEV','IT - BSS POWERBILL - DEV','IT - BSS IN - DEV','DCS - DEV','IT - BSS STRONGMAIL - DEV','IT - PAYMENT GATEWAY - DEV','IT - POS - DEV','RA - MONETA - DEV','IT - ICS - DEV','IT - SIEBEL (CRM)  ATOS','IT - OMP - DEV','IT DSP DEV','IT - ESS MNMI - DEV','IT - EAI - DEV','IT - OSS-DEV-FIXED PROVISIONING','IT - OSS-DEV-MOBILE PROVISIONING','IT - OSS-DEV-MOBILE MEDIATION','IT - GIS - DEV','IT - OSS-DEV-OAIM','IT - OSS-DEV-NPG','MSDP - DEV','IT - DEV - IDASHBOARDS','IT - OSS-DEV- HPSM','CAMPAIGN MANAGEMENT - DEV','IT - EDMS - DEV','IT - ESS DUVERSE - DEV','IT - DATAWAREHOUSE - DEV','CUSTOMER PROFITABILITY - DEV','IT - ICM DEV','IT - ERP - DEV','IT - DEV - INTRANET','IT - EBUSINESS - DEV','DQ - DEV','UCM - DEV','IT - IWV - DEV','IT - ESS MOI - DEV','IT BSS Ops L4 TT','IT ESS Ops L4 TT','IT OSS Ops L4 TT') or assignment like '%Ops L3%' or a.assignment like 'IT - Siebel (CRM)%Atos') and 
(b.datestamp+4/24) between (TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD')-8) and (TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD')) and b.type in ('ReAssigned','Rejected');
quit;
EOF

###################To Fetch the details of Assign_To_Others
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set heading on
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
spool Assign_To_Others.csv
select
'IncidentNo'
||','||'DateStamp'
||','||'LastActivity'
from Dual
union ALL
select
"NUMBER"
||','||to_char(datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||replace(replace(DBMS_LOB.SUBSTR(last_activity, 100,1),chr(10)),chr(13))
from (select a."NUMBER", a.datestamp, (select b.activity from reassign_dev b where "NUMBER" not like 'PDI%' and b.datestamp=a.datestamp and rownum=1) last_activity from (select "NUMBER", max(datestamp) datestamp from reassign_dev group by "NUMBER") a order by a.datestamp) where upper(last_activity) not like '%DEV%TO%OPS%' and upper(last_activity) not like '%DEV%TO%L3%' and upper(last_activity) not like '%L3%TO%DEV%' and upper(last_activity) not like '%OPS%TO%DEV%';
spool off;
quit;
EOF
sed -i $'s/\t/ /g' Assign_To_Others.csv
##################To fetch the details of assign to ops
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set heading on
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
spool Assign_To_Ops.csv
select
'IncidentNo'
||','||'DateStamp'
||','||'LastActivity'
from Dual
union ALL
select
"NUMBER"
||','||to_char(datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||replace(replace(DBMS_LOB.SUBSTR(last_activity, 100,1),chr(10)),chr(13))
from (select a."NUMBER", a.datestamp, (select b.activity from reassign_dev b where  "NUMBER" not like 'PDI%' and b.datestamp=a.datestamp and rownum=1) last_activity from (select "NUMBER", max(datestamp) datestamp from reassign_dev group by "NUMBER") a order by a.datestamp) where upper(last_activity) like '%DEV%TO%OPS%' or upper(last_activity) like '%DEV%TO%L3%';
spool off;
quit;
EOF
sed -i $'s/\t/ /g' Assign_To_Ops.csv
##################To fetch the details of assign to dev
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set heading on
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
spool Assign_To_Dev.csv
select
'IncidentNo'
||','||'DateStamp'
||','||'LastActivity'
from Dual
union ALL
select
"NUMBER"
||','||to_char(datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||replace(replace(DBMS_LOB.SUBSTR(last_activity, 100,1),chr(10)),chr(13))
from (select a."NUMBER", a.datestamp, (select b.activity from reassign_dev b where "NUMBER" not like 'PDI%' and b.datestamp=a.datestamp and rownum=1) last_activity from (select "NUMBER", max(datestamp) datestamp from reassign_dev group by "NUMBER") a order by a.datestamp) where upper(last_activity) like '%OPS%TO%DEV%' or upper(last_activity) like '%L3%TO%DEV%';
spool off;
quit;
EOF
sed -i $'s/\t/ /g' Assign_To_Dev.csv
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set heading on
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
spool Open_Dev.csv

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
||','||replace(replace(DBMS_LOB.SUBSTR(a.brief_description, 50,1),chr(10)),chr(13))
from probsummarym1 a where "NUMBER" not like 'PDI%' and   (upper(a.assignment) in ('SD_CPE','IT - BSCS (BILLING) - DEV','IT - BSS STREAMSERVE - DEV','IT - BSS POWERBILL - DEV','IT - BSS IN - DEV','DCS - DEV','IT - BSS STRONGMAIL - DEV','IT - PAYMENT GATEWAY - DEV','IT - POS - DEV','RA - MONETA - DEV','IT - ICS - DEV','IT - SIEBEL (CRM)  ATOS','IT - OMP - DEV','IT DSP DEV','IT - ESS MNMI - DEV','IT - EAI - DEV','IT - OSS-DEV-FIXED PROVISIONING','IT - OSS-DEV-MOBILE PROVISIONING','IT - OSS-DEV-MOBILE MEDIATION','IT - GIS - DEV','IT - OSS-DEV-OAIM','IT - OSS-DEV-NPG','MSDP - DEV','IT - DEV - IDASHBOARDS','IT - OSS-DEV- HPSM','CAMPAIGN MANAGEMENT - DEV','IT - EDMS - DEV','IT - ESS DUVERSE - DEV','IT - DATAWAREHOUSE - DEV','CUSTOMER PROFITABILITY - DEV','IT - ICM DEV','IT - ERP - DEV','IT - DEV - INTRANET','IT - EBUSINESS - DEV','DQ - DEV','UCM - DEV','IT - IWV - DEV','IT - ESS MOI - DEV','IT BSS Ops L4 TT','IT ESS Ops L4 TT','IT OSS Ops L4 TT') or assignment like '%Ops L3%' or a.assignment like 'IT - Siebel (CRM)%Atos') and (a.open_time+4/24) between (TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD')-8) and (TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD')) ;
spool off;
quit;
EOF
sed -i $'s/\t/ /g' Open_Dev.csv
##################To fetch the details of resolve dev TT
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set heading on
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
spool Closed_Dev.csv
select
'IncidentNo'
||','||'IncidentStatus'
||','||'Open Time'
||','||'Resolved Time'
||','||'assignment'
||','||'Description'
from Dual
union ALL
select
a."NUMBER"
||','||a.problem_status
||','||to_char(a.OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(a.resolved_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||a.assignment
||','||replace(replace(DBMS_LOB.SUBSTR(a.brief_description, 50,1),chr(10)),chr(13))
from probsummarym1 a where "NUMBER" not like 'PDI%' and (upper(a.assignment) in ('SD_CPE','IT - BSCS (BILLING) - DEV','IT - BSS STREAMSERVE - DEV','IT - BSS POWERBILL - DEV','IT - BSS IN - DEV','DCS - DEV','IT - BSS STRONGMAIL - DEV','IT - PAYMENT GATEWAY - DEV','IT - POS - DEV','RA - MONETA - DEV','IT - ICS - DEV','IT - SIEBEL (CRM)  ATOS','IT - OMP - DEV','IT DSP DEV','IT - ESS MNMI - DEV','IT - EAI - DEV','IT - OSS-DEV-FIXED PROVISIONING','IT - OSS-DEV-MOBILE PROVISIONING','IT - OSS-DEV-MOBILE MEDIATION','IT - GIS - DEV','IT - OSS-DEV-OAIM','IT - OSS-DEV-NPG','MSDP - DEV','IT - DEV - IDASHBOARDS','IT - OSS-DEV- HPSM','CAMPAIGN MANAGEMENT - DEV','IT - EDMS - DEV','IT - ESS DUVERSE - DEV','IT - DATAWAREHOUSE - DEV','CUSTOMER PROFITABILITY - DEV','IT - ICM DEV','IT - ERP - DEV','IT - DEV - INTRANET','IT - EBUSINESS - DEV','DQ - DEV','UCM - DEV','IT - IWV - DEV','IT - ESS MOI - DEV','IT BSS Ops L4 TT','IT ESS Ops L4 TT','IT OSS Ops L4 TT') or assignment like '%Ops L3%' or a.assignment like 'IT - Siebel (CRM)%Atos') and 
(a.resolved_time+4/24) between (TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD')-8) and (TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD'));
spool off;
quit;
EOF
sed -i $'s/\t/ /g' Closed_Dev.csv
echo -e " Dear All,\n\n PFA for the Dev TT Reports. \n\n Regards \n HPSM Team  " | mail -v -s " DEV TT Status  `date`" -a Open_Dev.csv  -a Closed_Dev.csv -a Assign_To_Others.csv -a Assign_To_Dev.csv -a Assign_To_Ops.csv  priyesh.a@du.ae,ankur.saxena@du.ae,Tamer.Awad@du.ae,LaxmaReddy.Kompally@du.ae,Shaji.Uddin@du.ae,SyedAsadAli.Shah@du.ae,Nitesh.Kumar@du.ae,Hemanta.Patra@du.ae
#echo -e " Dear All,\n\n PFA for the Dev TT Reports. \n\n Regards \n HPSM Team  " | mail -v -s " DEV TT Status  `date`" -a Open_Dev.csv  -a Closed_Dev.csv -a Assign_To_Others.csv -a Assign_To_Dev.csv -a Assign_To_Ops.csv  priyesh.a@du.ae,ankur.saxena@du.ae
[hpsm@meysmlvsvl01 ops]$ vi tamer_weekly.sh
set trimspool on
set headsep off
set linesize 20000
set feedback off
spool Closed_Dev.csv
select
'IncidentNo'
||','||'IncidentStatus'
||','||'Open Time'
||','||'Resolved Time'
||','||'assignment'
||','||'Description'
from Dual
union ALL
select
a."NUMBER"
||','||a.problem_status
||','||to_char(a.OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(a.resolved_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||a.assignment
||','||replace(replace(DBMS_LOB.SUBSTR(a.brief_description, 50,1),chr(10)),chr(13))
from probsummarym1 a where "NUMBER" not like 'PDI%' and (upper(a.assignment) in ('SD_CPE','IT - BSCS (BILLING) - DEV','IT - BSS STREAMSERVE - DEV','IT - BSS POWERBILL - DEV','IT - BSS IN - DEV','DCS - DEV','IT - BSS STRONGMAIL - DEV','IT - PAYMENT GATEWAY - DEV','IT - POS - DEV','RA - MONETA - DEV','IT - ICS - DEV','IT - SIEBEL (CRM)  ATOS','IT - OMP - DEV','IT DSP DEV','IT - ESS MNMI - DEV','IT - EAI - DEV','IT - OSS-DEV-FIXED PROVISIONING','IT - OSS-DEV-MOBILE PROVISIONING','IT - OSS-DEV-MOBILE MEDIATION','IT - GIS - DEV','IT - OSS-DEV-OAIM','IT - OSS-DEV-NPG','MSDP - DEV','IT - DEV - IDASHBOARDS','IT - OSS-DEV- HPSM','CAMPAIGN MANAGEMENT - DEV','IT - EDMS - DEV','IT - ESS DUVERSE - DEV','IT - DATAWAREHOUSE - DEV','CUSTOMER PROFITABILITY - DEV','IT - ICM DEV','IT - ERP - DEV','IT - DEV - INTRANET','IT - EBUSINESS - DEV','DQ - DEV','UCM - DEV','IT - IWV - DEV','IT - ESS MOI - DEV','IT BSS Ops L4 TT','IT ESS Ops L4 TT','IT OSS Ops L4 TT') or assignment like '%Ops L3%' or a.assignment like 'IT - Siebel (CRM)%Atos') and
(a.resolved_time+4/24) between (TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD')-8) and (TO_DATE(TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),'YYYY-MM-DD'));
spool off;
quit;
EOF
sed -i $'s/\t/ /g' Closed_Dev.csv
#echo -e " Dear All,\n\n PFA for the Dev TT Reports. \n\n Regards \n HPSM Team  " | mail -v -s " DEV TT Status  `date`" -a Open_Dev.csv  -a Closed_Dev.csv -a Assign_To_Others.csv -a Assign_To_Dev.csv -a Assign_To_Ops.csv  priyesh.a@du.ae,ankur.saxena@du.ae,Tamer.Awad@du.ae,LaxmaReddy.Kompally@du.ae,Shaji.Uddin@du.ae,SyedAsadAli.Shah@du.ae,Nitesh.Kumar@du.ae,Hemanta.Patra@du.ae
echo -e " Dear All,\n\n PFA for the Dev TT Reports. \n\n Regards \n HPSM Team  " | mail -v -s " DEV TT Status  `date`" -a Open_Dev.csv  -a Closed_Dev.csv -a Assign_To_Others.csv -a Assign_To_Dev.csv -a Assign_To_Ops.csv  priyesh.a@du.ae,ankur.saxena@du.ae
