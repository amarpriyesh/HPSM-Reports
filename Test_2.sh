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
spool Test_Report$datestr.txt
-------------------ITSD Incident extract------------------------------------
set ESCAPE '\'



select
'IncidentNo'
||'|'||'Siebel Reference'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'BriefDescription'
from Dual
union ALL
select "NUMBER"
||'|'||reference_no
||'|'||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||replace(replace(replace(DBMS_LOB.SUBSTR(brief_description,100,1),chr(10)),chr(13)),chr(9))
from probsummarym1
where folder='SIEBEL-CRM' and
open_time+4/24>=to_date('25/09/2015 00:00:00','dd/mm/yyyy hh24:mi:ss') and
open_time+4/24<to_date('01/11/2015 00:00:00','dd/mm/yyyy hh24:mi:ss');


spool off;
quit;
EOF
#/usr/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/ ; prompt; recurse; mput ITSD_Dealer_TSRM_TT$datestr.txt; exit;"
gzip Test_Report$datestr.txt
##(echo "Please find attached TT report"; uuencode  ITSD_Dealer_TSRM_TT$datestr.txt.gz ITSD_Dealer_TSRM_TT$datestr.txt.gz)| mailx -s " TT Report for `date`" "nihalchand.dehury@du.ae,mohammed.rezwanali@du.ae,Edward.Paul@du.ae,Iqbal.Khan@du.ae,Mansoor.A@du.ae,Midhun.Antony@du.ae,Praveen.Singu@du.ae,Sankar.Kotla@du.ae,Winner.Viagularaj@du.ae,ServiceDesk@du.ae" 
echo "."| mail -v -s "Please find attached Test TT report" -a /hpsm/hpsm/ops/reports/Test_Report$datestr.txt.gz mohammed.rezwanali@du.ae
#/usr/bin/smbclient \\\\172.22.31.31\\Public\$ -A .passwd.txt -c "cd \"ITSD HPSM Reports\Siebel HPSM Reports\"; lcd /hpsm/hpsm/ops/; prompt; recurse; mput ITSD_Dealer_TSRM_TT$datestr.txt.gz; exit;"
