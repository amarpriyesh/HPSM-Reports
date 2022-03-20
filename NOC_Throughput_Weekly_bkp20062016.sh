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
spool NOC_Throughput_Weekly$datestr.csv
-------------------History extract------------------------------------

select
'IncidentNo'
||'|'||'Activity'
||'|'||'ActivityTime'
||'|'||'Operator'
||'|'||'Category'
||'|'||'Area'
||'|'||'SubArea'
||'|'||'Folder'
||'|'||'OpenTime'
||'|'||'Cust Value'
||'|'||'Description'
from Dual
union ALL
select /*+ full(a) full(b) parallel(a,16) parallel(b,16)  */  distinct
b."NUMBER"
||'|'||b.type
||'|'||to_char(b.datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||b.operator
||'|'||a.category
||'|'||a.subcategory
||'|'||a.product_type
||'|'||a.folder
||'|'||to_char(a.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||a.du_cust_value
||'|'||replace(replace(DBMS_LOB.SUBSTR(b.description, 1500,1),chr(10)),chr(13))
from activitym1 b,probsummarym1 a 
where (b.datestamp+4/24 < trunc(sysdate,'d') and 
b.datestamp+4/24 >= trunc(trunc(sysdate,'d')-7)) and
b.type in ('Resolved','Rejected','ReAssigned','Rejected to Business','Pending Input')
and (b.description LIKE '%NOC - Mobile CS Core to%' or b.description LIKE '%Core - Mobile IMEI Requests to%' or b.description LIKE '%NOC - IN to%' 
or b.description LIKE '%NOC - Mobile PS Core to%' or b.description LIKE '%NOC - EPC to%' or b.description LIKE '%NOC - NE RAN to%' 
or b.description LIKE '%NOC - Mobile RAN to%' or b.description LIKE '%NOC - HSPA to%' or b.description LIKE '%NOC -  Mobile Access Transmission to%'
or b.description LIKE '%NOC - Mobile to%' or b.description LIKE '%NOC - Mobile Transmission to%' or b.description LIKE '%NOC - LTE (AUH/AAN) to%' 
or b.description LIKE '%NOC - Wireless to%' or b.description LIKE '%NOC - LTE (DXB/NE) to%' or b.description LIKE '%NOC – Wireless AUH to%' 
or b.description LIKE '%NOC - VAS to%' or b.description LIKE '%NOC - IP Transport to%' or b.description LIKE '%TSD - International and Wholesale to%' 
or b.description LIKE '%NOC - International Voice Services to%' or b.description LIKE '%NOC - TV and IT Services to%' 
or b.description LIKE '%NOC - Voice Services/ Signalling to%' or b.description LIKE '%TSD - Bitstream to%' or b.description LIKE '%NOC TSD to%' 
or b.description LIKE '%NOC - TSO to%') and b."NUMBER"=a."NUMBER" and folder ='SIEBEL-CRM';


spool off;
quit;
EOF
gzip NOC_Throughput_Weekly$datestr.csv
echo "."| mail -v -s " NOC Throughput Weekly Report for `date`" -a /hpsm/hpsm/ops/reports/NOC_Throughput_Weekly$datestr.csv.gz MuhammadImran.Khan@du.ae,Michael.Milad@du.ae,Jamal.SheikDawood@du.ae
#(echo "Please find attached TT report"; uuencode NOC_Throughput_Weekly$datestr.csv.gz NOC_Throughput_Weekly$datestr.csv.gz)| mailx -s " NOC Throughput Weekly Report for `date`" "mohammed.rezwanali@du.ae,MuhammadImran.Khan@du.ae,Michael.Milad@du.ae,Jamal.SheikDawood@du.ae"
