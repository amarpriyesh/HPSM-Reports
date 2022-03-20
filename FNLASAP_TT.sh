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
spool Daily_FNL_TT_AS$datestr.csv
-------------------Daily FNL AS TT Report extract------------------------------------

select
'Incident ID'
||','||'Time Stamp'
||','||'operator'
||','||'Message'
||','||'3rd party reference Number'
||','||'Element Name'
||','||'Priority'
||','||'AS/AP'
||','||'Rejection Reason'
||','||'Issue Description'
from dual
union all
select
b."NUMBER"
||','||to_char(a.datestamp+4/24,'dd/mm/yyyy HH:mi AM')
||','||a.operator
||','||decode(a.type,'Resolved',concat(a.type,concat(' ',b.resolution_area)),a.type)
||','||b.du_3rdpartyref_number
||','||b.du_element
||','||b.priority_code
||','||decode(b.folder,'I\&W-Etisalat','AP','AS')
||','||(select replace(replace(DBMS_LOB.SUBSTR(c.description, 1500,1),chr(10)),chr(13)) from activitym1 c where type='Rejecti
on Reason' and c."NUMBER"=a."NUMBER" and a.datestamp=c.datestamp)
||','||replace(replace(replace(DBMS_LOB.SUBSTR(b.action, 1500,1),chr(10)),chr(13)),',','')
from activitym1 a,probsummarym1 b
where a."NUMBER"=b."NUMBER" and ((b.folder ='FMS' and du_solution='Access Seeker') or folder in ('I\&W-Etisalat'))
and (a.type like 'FNL%' or  a.type in ('Open','Resolved','Rejection Reason')) and
trunc(a.datestamp+4/24)>=trunc(sysdate-30) and decode(b.folder,'I\&W-Etisalat','AP','AS')='AS';

spool off;

spool Daily_FNL_TT_AP$datestr.csv
-------------------Daily FNL AP TT Report extract------------------------------------

select
'Incident ID'
||','||'Time Stamp'
||','||'operator'
||','||'Message'
||','||'Request ID'
||','||'Product Name'
||','||'Priority'
||','||'AS/AP'
||','||'Rejection Reason'
||','||'Issue Description'
from dual
union all
select
b."NUMBER"
||','||to_char(a.datestamp+4/24,'dd/mm/yyyy HH:mi AM')
||','||a.operator
||','||decode(a.type,'Resolved',concat(a.type,concat(' ',b.resolution_area)),a.type)
||','||b.reference_no
||','||b.du_affected_service
||','||b.priority_code
||','||decode(b.folder,'I\&W-Etisalat','AP','AS')
||','||(select replace(replace(DBMS_LOB.SUBSTR(c.description, 1500,1),chr(10)),chr(13)) from activitym1 c where type='Rejecti
on Reason' and c."NUMBER"=a."NUMBER" and a.datestamp=c.datestamp)
||','||replace(replace(replace(DBMS_LOB.SUBSTR(b.action, 1500,1),chr(10)),chr(13)),',','')
from activitym1 a,probsummarym1 b
where a."NUMBER"=b."NUMBER" and ((b.folder ='FMS' and du_solution='Access Seeker') or folder in ('I\&W-Etisalat'))
and (a.type like 'FNL%' or  a.type in ('Open','Resolved','Rejection Reason')) and
trunc(a.datestamp+4/24)>=trunc(sysdate-30) and decode(b.folder,'I\&W-Etisalat','AP','AS')='AP';

spool off;


quit;
EOF

/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\FNL AS AP\"; lcd /hpsm/hpsm/ops/reports; prompt; recurse; mput Daily_FNL_TT_AS$datestr.csv; exit;"
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\FNL AS AP\"; lcd /hpsm/hpsm/ops/reports; prompt; recurse; mput Daily_FNL_TT_AP$datestr.csv; exit;"

echo "."| mail -v -s "Please find attached AS FNL TT report" -a /hpsm/hpsm/ops/reports/Daily_FNL_TT_AS$datestr.csv utkarsh.jauhari@du.ae
echo "."| mail -v -s "Please find attached AP FNL TT report" -a /hpsm/hpsm/ops/reports/Daily_FNL_TT_AP$datestr.csv utkarsh.jauhari@du.ae


