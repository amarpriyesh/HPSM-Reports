cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/
datestr=`date "+%d%m%y%H%M"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set head on
set linesize 20000
set feedback off
set echo off
spool IT_Rejected$datestr.csv
-------------------IT Rejected TT Report------------------------------------

select
'IncidentNo'
||','||'IncidentCreatedate'
||','||'IncidentStatus'
||','||'CurrentResolverGroup'
||','||'Priority'
||','||'Activity Type'
||','||'Activity Datestamp'
||','||'ResolvedTime'
||','||'Folder'
||','||'Age of TT(In days)'
||','||'Activity description'
||','||'Rejection Reason'
from Dual
UNION ALL
select
distinct a."NUMBER"
||','||to_char(b.OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||b.problem_status
||','||b.assignment
||','||b.priority_code
||','||a.type
||','||to_char(C.datestamp+4/24, 'mm/dd/yyyy HH24:MI:SS')
||','||to_char(b.resolved_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||','||b.folder
||','||(to_date(trunc(sysdate),' dd-mon-yyyy HH24:MI SS')-TO_DATE(open_time+4/24,'DD-MON-YYYY HH24:MI'))
||','||replace(replace(DBMS_LOB.SUBSTR(a.description, 2000,1),chr(10)),chr(13))
||','||replace(REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(c.description, 2000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' '),',','')
from activitym1 a, probsummarym1 b ,activitym1 c where a."NUMBER"=b."NUMBER" and a."NUMBER"=C."NUMBER" and
(a.TYPE in ( 'Rejected','Rejected to Business') and (a.datestamp+4/24>to_date(to_char(sysdate-2,'DD-MM-YY')||' 23:59:59','DD-MM-YY HH24:mi:ss') 
and a.datestamp+4/24<=to_date(to_char(sysdate-1,'DD-MM-YY')||' 23:59:59','DD-MM-YY HH24:mi:ss'))
and (a.description LIKE '%IT - Billing %' or a.description LIKE '%IT - Business Application Access%' or
a.description LIKE '%IT - CRM%' or a.description LIKE '%IT - Cognos%' or a.description LIKE '%IT - Content Portal Application Support%' or
a.description LIKE '%IT - DOC1%' or a.description LIKE '%IT - Datawarehouse%' or a.description LIKE '%IT - EAI%' or a.description LIKE '%IT - EBusiness%' or
a.description LIKE '%IT - EDMS%' or a.description LIKE '%IT - ERP%' or a.description LIKE '%IT - GIS%' or
a.description LIKE '%IT - ICS%' or a.description LIKE '%IT - Interconnect Billing%' or a.description LIKE '%IT - OSS-OPS- HPSM%' or
a.description LIKE '%IT - OSS-OPS-Fault/Performance MGMT%' or a.description LIKE '%IT - OSS-OPS-Fixed Mediation%' or
a.description LIKE '%IT - OSS-OPS-Fixed Provisioning%' or a.description LIKE '%IT - OSS-OPS-Mobile Mediation%' or
a.description LIKE '%IT - OSS-OPS-Mobile Provisioning%' or a.description LIKE '%IT - OSS-OPS-NPG%' or
a.description LIKE '%IT - OSS-OPS-Network Core Services%' or a.description LIKE '%IT - OSS-OPS-OAIM%' or
a.description LIKE '%IT - OSS-OPS-OPA%' or a.description LIKE '%IT - POS%' or a.description LIKE '%IT - Payment Gateway%'))  
and a.datestamp=c.datestamp and c.TYPE='Rejection Reason';
spool off;
quit;
EOF
echo "."| mail -v -s "IT Rejected TT Report for `date`" -a /hpsm/hpsm/ops/reports/IT_Rejected$datestr.csv mohammed.rezwanali@du.ae,nihalchand.dehury@du.ae,nagendra.kumar@du.ae,Balaji.Donthi@du.ae,raghu.nandan@du.ae,Srinivas.Sabbella@du.ae,BhanuPrasad@du.ae
#( echo "Please find attached the IT Rejected TTs Report"; uuencode IT_Rejected$datestr.csv IT_Rejected$datestr.csv)| mailx -s "IT Rejected TT Report for `date`" "nihalchand.dehury@du.ae,nagendra.kumar@du.ae,Balaji.Donthi@du.ae,raghu.nandan@du.ae,Srinivas.Sabbella@du.ae,BhanuPrasad@du.ae"
/usr/sfw/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/ ; prompt; recurse; mput IT_Rejected$datestr.csv; exit;"
