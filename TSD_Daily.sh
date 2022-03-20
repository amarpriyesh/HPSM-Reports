cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/
datestr=`date "+%d%m%y%H%M"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
spool tsd_daily$datestr.txt
-------------------TSD Daily extract------------------------------------
select
'IncidentNo'
||'|'||'Operator'
||'|'||'Activity'
||'|'||'ActionTime'
||'|'||'ServiceType'
||'|'||'TT Type'
||'|'||'Action'
||'|'||'Auto Assigned'
from Dual
union ALL
select
A."NUMBER"
||'|'||A.operator
||'|'||A.type
||'|'||to_char(A.datestamp+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||B.du_service_type
||'|'||B.folder
||'|'||replace(replace(DBMS_LOB.SUBSTR(A.description, 2000,1),chr(10)),chr(13))
||'|'||B.auto_assigned
from 
activitym1 A,probsummarym1 B where A."NUMBER"=B."NUMBER" and trunc(A.datestamp+4/24) = trunc(sysdate-1) and A.type in ('Open','Accepted','In Progress','Pendi
ng Input','Resolved','Rejected',
'ReAssigned','Rejected to Business') and A.operator<>'falcon' and (A.description LIKE '%TSD%' or A.description LIKE '%CSM%');
spool off;
quit;
EOF
gzip tsd_daily$datestr.txt 
###( echo "Please find attached the TSD daily report"; uuencode tsd_daily$datestr.txt.gz tsd_daily$datestr.txt.gz)| mailx -s "TSD Daily Report for `date`" "Youssef.Aboukhurj@du.ae,tech.sd@du.ae,CustomerServiceDeskReporting@du.ae,Raheel.Amin@du.ae,Vinay.Mistry@du.ae,Mehna.Siddiq@du.ae,florabel.comedes@du.ae,crispin.misquita@du.ae"

/usr/bin/smbclient \\\\172.22.31.31\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\TSD Reports\"; lcd /hpsm/hpsm/ops/reports/; prompt; recurse; mput tsd_daily$datestr.txt.gz  exit;"
