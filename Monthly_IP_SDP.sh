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
spool Monthly_IP_SDP$datestr.csv
-------------------Monthly IP SDP Report extract------------------------------------

select
'IncidentNo'
||','||'Priority'
||','||'Type'
||','||'Acitivity Date'
||','||'OpenTime'
||','||'CloseTime'
||','||'Operator'
||','||'Category'
||','||'Area'
||','||'SubArea'
||','||'Folder'
||','||'Status'
||','||'SLAStatus'
||','||'SLATargetDate'
||','||'PendingCode'
||','||'PendingTime'
||','||'Description'
||','||'Activity'
from Dual
union ALL
select /*+ full(a) full(b) parallel(a,16) parallel(b,16)  */  distinct
b."NUMBER"
||','||a.priority_code
||','||b.type
||','||to_char(b.datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(a.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(a.close_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||b.operator
||','||replace(replace(replace(a.category,chr(10)),chr(13)),chr(9))
||','||replace(replace(replace(a.subcategory,chr(10)),chr(13)),chr(9))
||','||replace(replace(replace(a.product_type,chr(10)),chr(13)),chr(9))
||','||a.folder
||','||a.problem_status
||','||decode(a.sla_breach,'t','Breached','Achieved')
||','||to_char(a.DU_SLA_END +4/24,'mm/dd/yyyy HH24:MI:SS')
||','||a.pending_code
||','||(select (closed_total -to_date('01014000000000','ddmmyyyyhh24miss'))*24*60 from clocksm1 where key_char =a."NUMBER" and name= 'Network Operation IP SDP.Pending Input')
||','||replace(replace(DBMS_LOB.SUBSTR(a.brief_description, 1500,1),chr(10)),chr(13))
||','||replace(replace(DBMS_LOB.SUBSTR(b.description, 1500,1),chr(10)),chr(13))
from activitym1 b,probsummarym1 a where
(b.datestamp+4/24 < trunc(sysdate,'MM') and
b.datestamp+4/24 >= trunc(trunc(sysdate,'MM')-1,'MM')) and
b.type in ('Resolved','Rejected','ReAssigned','Rejected to Business')
and b.description LIKE '%Network Operation IP SDP to%' 
and b."NUMBER"=a."NUMBER";

spool off;
quit;
EOF
gzip Monthly_IP_SDP$datestr.csv
echo "."| mail -v -s "Monthly IP SDP TT report for `date`" -a /hpsm/hpsm/ops/reports/Monthly_IP_SDP$datestr.csv.gz Anas.Salahudeen@du.ae,nihalchand.dehury@du.ae,mohammed.rezwanali@du.ae
#( echo "Please find the attached Monthly IP SDP TT report"; uuencode Monthly_IP_SDP$datestr.csv.gz Monthly_IP_SDP$datestr.csv.gz)| mailx -s "Monthly IP SDP TT report for `date`" "Anas.Salahudeen@du.ae,nihalchand.dehury@du.ae,mohammed.rezwanali@du.ae"
