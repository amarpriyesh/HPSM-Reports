cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports
datestr=`date "+%d%m%y%H%M"`
datestr=$datestr"0215"
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
spool Incidents_Rejected_HPSM$datestr.txt
-------------------Rejected Incident extract------------------------------------

select
'IncidentNo'
||'|'||'Rejection Count'
||'|'||'Folder'
||'|'||'Open Time'
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
|| '|' ||b.du_cust_type
|| '|' ||b.reference_no
|| '|' ||b.du_service_type
|| '|' ||to_char(b.du_siebel_open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
|| '|' ||b.category
|| '|' ||b.subcategory
|| '|' ||b.product_type
|| '|' ||to_char(b.datestamp+4/24,'dd\mm\yyyy hh24:mi')
|| '|' ||'Rejected'
|| '|' ||b.operator
|| '|' ||substr(replace(replace(DBMS_LOB.SUBSTR(b.description, 2000,1),chr(10)),chr(13)),1,instr(b.description,'to')-1)
|| '|' ||substr(replace(replace(DBMS_LOB.SUBSTR(b.description, 2000,1),chr(10)),chr(13)),instr(b.description,' to ')+4,(instr
(b.description,'|')-instr(b.description,' t
o '))-3)
|| '|' ||''
  FROM activitym1 k,
       (SELECT a."NUMBER", a.datestamp,b.du_rejectcount, b.folder,b.open_time,b.du_cust_type, b. reference_no,
 b. du_service_type,b.du_siebel_open_time,b.category, b.subcategory,b. product_type, a. operator, a. description
          FROM activitym1 a, probsummarym1 b
            WHERE (a.TYPE = 'Rejected' or a.TYPE =  'Rejection Reason' or (a.TYPE =  'Status Change'and DESCRIPTION like
 'Incident Status Change to Rejected from%'))
                 AND a."NUMBER" = b."NUMBER") b
                WHERE k."NUMBER" = b."NUMBER" AND k.TYPE = 'Open' and 
b.datestamp < to_date('24/12/2015 02:00:00','dd/mm/yyyy hh24:mi:ss')
                  and B."NUMBER" not in (select r.inc_num from rejectedbusiness r)
union

SELECT distinct
k."NUMBER"
|| '|' ||b.du_rejectcount
|| '|' ||b.folder
|| '|' ||b.open_time
|| '|' ||b.du_cust_type
|| '|' ||b. reference_no
|| '|' ||b. du_service_type
|| '|' ||to_char(b.du_siebel_open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
|| '|' ||b.category
|| '|' ||b.subcategory
|| '|' ||b. product_type
|| '|' ||to_char(b.datestamp+4/24,'dd\mm\yyyy hh24:mi')
|| '|' ||b.type
|| '|' ||round((clock.total - to_date('01014000','ddmmyyyy'))*24*60,2)
|| '|' ||b. operator
|| '|' ||substr(replace(replace(DBMS_LOB.SUBSTR(b.description, 2000,1),chr(10)),chr(13)),1,instr(b.description,'to')-1)
|| '|' ||substr(replace(replace(DBMS_LOB.SUBSTR(b.description, 2000,1),chr(10)),chr(13)),instr(b.description,' to ')+4,(instr
(b.description,'|')-instr(b.description,' t
o '))-3)
|| '|' ||''
  FROM activitym1 k,
       (SELECT a."NUMBER", a.datestamp,b.du_rejectcount, b.folder,b.open_time,b.du_cust_type, b. reference_no, b. du_service_type,b.du_siebel_open_time,
        b.category, b.subcategory,b. product_type,a.type, a. operator, a. description
          FROM activitym1 a, probsummarym1 b
         WHERE (a.TYPE = 'Rejected' or a.TYPE =  'Rejected to Business')
           AND a."NUMBER" = b."NUMBER") b,(select total,key_char from clocksm1 where name  = 'Rejected to Business') clock
 WHERE k."NUMBER" = b."NUMBER" AND k.TYPE = 'Open' and B.datestamp > to_date('24/12/2015 02:00:00','dd/mm/yyyy hh24:mi:ss')
   and k."NUMBER"=clock.key_char(+)
UNION
SELECT distinct
k."NUMBER"
|| '|' ||b.du_rejectcount
|| '|' ||b.folder
|| '|' ||b.open_time
|| '|' ||b.du_cust_type
|| '|' ||b. reference_no
|| '|' ||b. du_service_type
|| '|' ||to_char(b.du_siebel_open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
|| '|' ||b.category
|| '|' ||b.subcategory
|| '|' ||b. product_type
|| '|' ||to_char(b.datestamp+4/24,'dd\mm\yyyy hh24:mi')
|| '|' ||'Rejected to Business'
|| '|' ||b.operator
|| '|' ||substr(replace(replace(DBMS_LOB.SUBSTR(b.description, 2000,1),chr(10)),chr(13)),1,instr(b.description,'to')-1)
|| '|' ||substr(replace(replace(DBMS_LOB.SUBSTR(b.description, 2000,1),chr(10)),chr(13)),instr(b.description,' to ')+4,(instr
(b.description,'|')-instr(b.description,' t
o '))-3)
|| '|' ||''
  FROM activitym1 k,
       (SELECT a."NUMBER", a.datestamp,b.du_rejectcount, b.folder,b.open_time,b.du_cust_type, b. reference_no, b. du_service_type,b.du_siebel_open_time, b.category, b.subcategory,b. product_type, a. operator, a. description
          FROM activitym1 a, probsummarym1 b
         WHERE (a.TYPE = 'Rejected' or a.TYPE =  'Rejection Reason' or (a.TYPE =  'Status Change'and DESCRIPTION like 'Incident Status Change to Rejected from%'))
           AND a."NUMBER" = b."NUMBER") b,rejectedbusiness r
 WHERE k."NUMBER" = b."NUMBER" AND k.TYPE = 'Open' and B.datestamp < to_date('24/12/2015 02:00:00','dd/mm/yyyy hh24:mi:ss')
and B."NUMBER"= r.inc_num;
spool off;
quit;
EOF
gzip Incidents_Rejected_HPSM$datestr.txt
echo "."| mail -v -s "Please find attached Rejected TT report" -a /hpsm/hpsm/ops/reports/Incidents_Rejected_HPSM$datestr.txt.gz Shahidha.Firos@du.ae,Karim.Ramadan@du.ae,Nabeel.UrRehman@du.ae,Raj.Jayaswal@du.ae,Florabel.Comedes@du.ae,ankur.saxena@du.ae
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\Rejected TTs Reports\"; lcd /hpsm/hpsm/ops/reports; prompt; recurse; mput Incidents_Rejected_HPSM$datestr.txt.gz; exit;"

