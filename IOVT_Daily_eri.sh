cd
. ./.bash_profile
cd /hpsm/hpsm/ops/
datestr=`date "+%d%m%y%H%M"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
set define off
spool IOVT_Daily$datestr.csv
-------------------IOVT Daily report------------------------------------


select
'Incident ID'
||','||'Product'
||','||'Direction'
||','||'Type of Trouble Ticket'
||','||'Carrier TT Reference number'
||','||'3rd Party Reference Number'
||','||'Carrier Name or Distant Carrier Name'
||','||'Status'
||','||'TT Open'
||','||'Date And Time'
||','||'TT Resolved Date And Time'
||','||'Closed Date And Time'
||','||'Current Assignment of TT'
||','||'TT Subject'
||','||'Issue Description'
||','||'TT Resolution Details'
||','||'Journal Updates'
from Dual
union ALL
select 
"NUMBER"
||','||subscriber_service
||','||category
||','||subcategory
||','||reference_no
||','||du_3rdpartyref_number
||','||carrier_name
||','||problem_status
||','||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(resolved_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||','||to_char(close_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||','||assignment
||','||replace(trim(replace(replace(replace(DBMS_LOB.SUBSTR(brief_description, 500,1),chr(10)),chr(13)),',')),',','')
||','||replace(trim(replace(replace(replace(DBMS_LOB.SUBSTR(action, 2000,1),chr(10)),chr(13)),',')),',','')
||','||replace(trim(replace(replace(replace(DBMS_LOB.SUBSTR(resolution, 1000,1),chr(10)),chr(13)),',')),',','')
||','||replace(trim(replace(replace(replace(DBMS_LOB.SUBSTR(update_action, 3000,1),chr(10)),chr(13)),',')),',','')
from probsummarym1
where ((subcategory='Roaming' or subcategory like 'Hubbing%' or subcategory='Calling card' 
or subcategory='Home phone' or subcategory='Premium UAE Termination'
or subcategory='Premium Retail traffic' or subcategory='Hubbing traffic') and
problem_status<>'Closed' and category<>'Service Fault - Mobile') or
((subcategory='Roaming' or subcategory like 'Hubbing%' or subcategory='Calling card' 
or subcategory='Home phone' or subcategory='Premium UAE Termination'
or subcategory='Premium Retail traffic' or subcategory='Hubbing traffic') and
category<>'Service Fault - Mobile' and (close_time+4/24) >= trunc(sysdate,'MM'));
spool off;
quit;
EOF
/hpsm/hpsm/ops/MoveLineUP.sh IOVT_Daily$datestr
echo "."| mail -v -s "Daily IOVT report for `date`" -a /hpsm/hpsm/ops/IOVT_Daily$datestr.csv ankur.saxena@du.ae
