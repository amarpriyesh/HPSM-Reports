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
spool OLA_Cust_AugToOct_15$datestr.txt
-------------------ITSD Incident extract------------------------------------
set ESCAPE '\'




select
'IncidentNo'
||'|'||'OpenTime'
||'|'||'Name'
||'|'||'TimeSpent'
||'|'||'HPSMStatus'
||'|'||'CurrentResolverGroup'
||'|'||'ResolvedTime'
||'|'||'Folder'
from Dual
union ALL
select
A."NUMBER"
||'|'||to_char(A.OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||B.name
||'|'||(B.closed_total -to_date('01014000000000','ddmmyyyyhh24miss'))*24*60
||'|'||A.problem_status
||'|'||A.assignment
||'|'||to_char(A.RESOLVED_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||A.folder
from
probsummarym1 A, clocksm1 B
where A."NUMBER"=B.key_char and 
(A.open_time+4/24 >= to_date('01/08/2015 00:00:00','dd/mm/yyyy hh24:mi:ss') and
A.open_time+4/24 < to_date('01/11/2015 00:00:00','dd/mm/yyyy hh24:mi:ss')) and folder ='SIEBEL-CRM'
and B.key_char LIKE 'IM%';



spool off;
quit;
EOF
#/usr/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/ ; prompt; recurse; mput ITSD_Dealer_TSRM_TT$datestr.txt; exit;"
gzip OLA_Cust_AugToOct_15$datestr.txt
##(echo "Please find attached TT report"; uuencode  ITSD_Dealer_TSRM_TT$datestr.txt.gz ITSD_Dealer_TSRM_TT$datestr.txt.gz)| mailx -s " TT Report for `date`" "nihalchand.dehury@du.ae,mohammed.rezwanali@du.ae,Edward.Paul@du.ae,Iqbal.Khan@du.ae,Mansoor.A@du.ae,Midhun.Antony@du.ae,Praveen.Singu@du.ae,Sankar.Kotla@du.ae,Winner.Viagularaj@du.ae,ServiceDesk@du.ae" 
echo "."| mail -v -s "Please find attached Test TT report" -a /hpsm/hpsm/ops/reports/OLA_Cust_AugToOct_15$datestr.txt.gz mohammed.rezwanali@du.ae
#/usr/bin/smbclient \\\\172.22.31.31\\Public\$ -A .passwd.txt -c "cd \"ITSD HPSM Reports\Siebel HPSM Reports\"; lcd /hpsm/hpsm/ops/; prompt; recurse; mput ITSD_Dealer_TSRM_TT$datestr.txt.gz; exit;"
