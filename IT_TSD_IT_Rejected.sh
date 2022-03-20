cd
. ./.bash_profile
cd /hpsm/hpsm/ops/
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
spool IT_TSD_IT_Rejected$datestr.csv
-------------------IT Rejected TT Report------------------------------------

select
'IncidentNo'
||','||'InteractionNo'
||','||'Status'
||','||'Category'
||','||'Area'
||','||'SubArea'
||','||'Priority'
||','||'Current Resolver Group'
||','||'Age of TT(In days)'
||','||'Assignee'
||','||'Open Time'
||','||'Rejected By'
||','||'Rejected Group'
||','||'Rejected Reason'
from dual
union all
select
distinct a."NUMBER"
||','||b.incident_id
||','||b.problem_status
||','||b.category
||','||b.subcategory
||','||b.product_type
||','||b.priority_code
||','||b.assignment
||','||(to_date(trunc(sysdate),' dd-mon-yyyy HH24:MI SS')-TO_DATE(open_time+4/24,'DD-MON-YYYY HH24:MI'))
||','||b.assignee_name
||','||to_char(b.OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||a.operator
||','||replace(REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(a.description, 2000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' '),',','')
||','||replace(REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(c.description, 2000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' '),',','')
from activitym1 a, probsummarym1 b ,activitym1 c where a."NUMBER"=b."NUMBER" and a."NUMBER"=c."NUMBER" 
and (a.TYPE ='Rejected') 
and trunc(a.datestamp+4/24)=trunc(sysdate-1)
and (a.description LIKE '%IT - TSD IT%') 
and a.datestamp=c.datestamp and c.TYPE='Rejection Reason';

spool off;
quit;
EOF
echo "."| mail -v -s "IT_TSD_IT Rejected TT Report for `date`" -a /hpsm/hpsm/ops/IT_TSD_IT_Rejected$datestr.csv nihalchand.dehury@du.ae,Shwetha.Ranjini@du.ae,Edward.Paul@du.ae,Iqbal.Khan@du.ae,Kavitha.Rajput@du.ae,Madhuri.J@du.ae,Mansoor.A@du.ae,Midhun.Antony@du.ae,Mohamed.Imam@du.ae,Mohitha.Ambati@du.ae,Mugtaba.Ahmed@du.ae,Pratheek.Reddy@du.ae,Praveen.Naidu@du.ae,Praveen.Singu@du.ae,Sankar.Kotla@du.ae,Winner.Viagularaj@du.ae
##( echo "Please find attached the IT_TSD_IT Rejected TTs Report"; uuencode IT_TSD_IT_Rejected$datestr.csv IT_TSD_IT_Rejected$datestr.csv)| mailx -s "IT_TSD_IT Rejected TT Report for `date`" "nihalchand.dehury@du.ae,Edward.Paul@du.ae,Iqbal.Khan@du.ae,Kavitha.Rajput@du.ae,Madhuri.J@du.ae,Mansoor.A@du.ae,Midhun.Antony@du.ae,Mohamed.Imam@du.ae,Mohitha.Ambati@du.ae,Mugtaba.Ahmed@du.ae,Pratheek.Reddy@du.ae,Praveen.Naidu@du.ae,Praveen.Singu@du.ae,Sankar.Kotla@du.ae,Winner.Viagularaj@du.ae"
