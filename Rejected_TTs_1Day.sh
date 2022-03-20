cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports
datestr=`date "+%d%m%y%H%M"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
spool Incidents_Rejected_HPSM$datestr.csv
-------------------Rejected Incident extract------------------------------------

select
'IncidentNo'
||'|'||'Rejection Count'
||'|'||'Folder'
||'|'||'Open Time'
||'|'||'Current Status'
||'|'||'Customer Type'
||'|'||'Siebel TT number'
||'|'||'Service type'
||'|'||'SiebelTTCreatedAt'
||'|'||'Category'
||'|'||'Area'
||'|'||'Subarea'
||'|'||'Rejection Time'
||'|'||'Type'
||'|'||'Total Rejected  to Business Time'
||'|'||'Rejected By'
||'|'||'Group'
||'|'||'Rejected To' from Dual;
SELECT distinct
k."NUMBER"
|| '|' ||b.du_rejectcount
|| '|' ||b.folder
|| '|' ||b.open_time
|| '|' ||b.problem_status
|| '|' ||b.du_cust_type
|| '|' ||b.reference_no
|| '|' ||b.du_service_type
|| '|' ||to_char(b.du_siebel_open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
|| '|' ||b.category
|| '|' ||b.subcategory
|| '|' ||b. product_type
|| '|' ||to_char(b.datestamp+4/24,'dd\mm\yyyy hh24:mi')
|| '|' ||b.type
|| '|' ||round((clock.total - to_date('01014000','ddmmyyyy'))*24*60,2)
|| '|' ||b. operator
|| '|' ||substr(replace(replace(DBMS_LOB.SUBSTR(b.description, 2000,1),chr(10)),chr(13)),1,instr(b.description,'to')-2)
|| '|' ||substr(substr(replace(replace(DBMS_LOB.SUBSTR(b.description, 2000,1),chr(10)),chr(13)),1,instr(b.description,'|')-1),instr(b.description,'to')+3)
  FROM activitym1 k,
       (SELECT a."NUMBER", a.datestamp,b.du_rejectcount,b.problem_status, b.folder,b.open_time,b.du_cust_type, b. reference_no, b. du_service_type,b.du_siebel_open_time,
        b.category, b.subcategory,b. product_type,a.type, a. operator, a. description
          FROM activitym1 a, probsummarym1 b
         WHERE (a.TYPE = 'Rejected' or a.TYPE =  'Rejected to Business')
           AND a."NUMBER" = b."NUMBER" AND substr(replace(replace(DBMS_LOB.SUBSTR(a.description, 2000,1),chr(10)),chr(13)),1,instr(a.description,'to')-2) like 'IT%') b,(select total,key_char from clocksm1 where name  = 'Rejected to Business') clock
 WHERE k."NUMBER" = b."NUMBER" AND k.TYPE = 'Open' and B.datestamp > to_date('19/09/2016 00:00:00','dd/mm/yyyy hh24:mi:ss')
   and k."NUMBER"=clock.key_char(+);
spool off;
quit;
EOF

sed -i $'s/,/ /g' Incidents_Rejected_HPSM$datestr.csv
sed -i $'s/|/,/g' Incidents_Rejected_HPSM$datestr.csv

echo "."| mail -v -s "Please find attached Rejected TT report" -a /hpsm/hpsm/ops/reports/Incidents_Rejected_HPSM$datestr.csv utkarsh.jauhari@du.ae

