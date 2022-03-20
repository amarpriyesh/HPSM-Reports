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
spool IWEtisalat_Monthly$datestr.txt
-------------------I&W-Etisalat HPSM Incident extract------------------------------------



select /*+PARALLEL(5)*/ 
'IncidentNo'
||'|'||'IncidentStatus'
||'|'||'IncidentCategory'
||'|'||'IncidentArea'
||'|'||'SubCategory'
||'|'||'priority'
||'|'||'ResolutionCode'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'OpenTime'
||'|'||'ClosedTime'
from Dual
union ALL
select /*+PARALLEL(5)*/ 
A."NUMBER"
||'|'||problem_status
||'|'||category
||'|'||subcategory
||'|'||subcategory
||'|'||priority_code
||'|'||resolution_code
||'|'||resolution_type
||'|'||resolution_area
||'|'||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(close_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
from
probsummarym1 A where du_carrier_name='Etisalat' and 
(open_time+4/24 >= trunc(trunc(sysdate,'MM')-1,'MM') and 
open_time+4/24 < trunc(sysdate,'MM'));


spool off;
quit;
EOF
gzip IWEtisalat_Monthly$datestr.txt

/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\IW-Etisalat\"; lcd /hpsm/hpsm/ops/reports; prompt; recurse; mput IWEtisalat_Monthly$datestr.txt.gz; exit;"

#echo "."| mail -v -s "Monthly IW-Etisalat report for `date`" -a /hpsm/hpsm/ops/reports/IWEtisalat_Monthly$datestr.txt.gz ankur.saxena@du.ae,Baber.Shehzad@du.ae
#( echo "Please find the attached monthly IW report"; uuencode IWEtisalat_Monthly.txt.gz IWEtisalat_Monthly$datestr.txt.gz)| mailx -s "Monthly IW report
#for `date`" "ankur.saxena@du.ae,Baber.Shehzad@du.ae"


                                         
