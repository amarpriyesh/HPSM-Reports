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
set escape '\'
spool Daily_FNL_TT$datestr.csv
-------------------Daily FNL TT Report extract------------------------------------

select
'Incident ID'
||','||'Time Stamp'
||','||'operator'
||','||'Type'
||','||'Resolution Area'
||','||'Product Name'
||','||'Priority'
||','||'AS/AP'
||','||'Rejection Reason'
||','||'Issue Description'
from dual
union all
select
b."NUMBER"
||','||to_char(a.datestamp+4/24,'dd/mm/yyyy HH24:mi:ss')
||','||a.operator
||','||a.type
||','||b.resolution_area
||','||b.du_affected_service
||','||b.priority_code
||','||decode(b.folder,'I\&W-Etisalat','AP','AS')
||','||(select replace(replace(DBMS_LOB.SUBSTR(c.description, 1500,1),chr(10)),chr(13)) from activitym1 c where type='Rejecti
on Reason' and c."NUMBER"=a."NUMBER" and a.datestamp=c.datestamp)
||','||replace(replace(replace(DBMS_LOB.SUBSTR(b.action, 1500,1),chr(10)),chr(13)),',','')
from activitym1 a,probsummarym1 b
where a."NUMBER"=b."NUMBER" and ((b.folder ='FMS' and du_solution='Access Seeker') or folder in ('I\&W-Etisalat'))
and (a.type like 'FNL%' or  a.type in ('Open','Accepted','Resolved','Rejection Reason')) and
trunc(a.datestamp+4/24)>=trunc(sysdate-30);

spool off;
quit;
EOF
echo "."| mail -v -s "Please find attached ITSD Interaction TT report" -a /hpsm/hpsm/ops/reports/Daily_FNL_TT$datestr.csv nihalchand.dehury@du.ae,mohammed.rezwanali@du.ae
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\FNL Report\"; lcd /hpsm/hpsm/ops/reports; prompt; recurse; mput Daily_FNL_TT$datestr.csv; exit;"

