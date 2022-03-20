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
spool Backup_SAN_TTs$datestr.txt
-------------------Backup_SAN_TTs details extract------------------------------------
select
'IncidentNo'
||'|'||'ResolvedTime'
from Dual
UNION ALL
select
"NUMBER"
||'|'||to_char(RESOLVED_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
from probsummarym1 where (opened_by in (select a.name from operatorm1 a,assignmenta1 b where a.name=b.operators 
and b.name in('IT - Backup Admin','IT - SAN Admin')) or
opened_by in (select a.contact_name from operatorm1 a,assignmenta1 b where a.name=b.operators and b.name in('IT - Backup Admin','IT - SAN Admin')))
and trunc(RESOLVED_TIME+4/24) = trunc(sysdate-1) and assignment='IT - NOC';
spool off;
quit;
EOF
/usr/sfw/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/reports/ ; prompt; recurse; mput Backup_SAN_TTs$datestr.txt; exit;"
( echo "Please find the attached Backup_SAN_TT details"; uuencode Backup_SAN_TTs$datestr.txt ITNOC_daily$datestr.txt)| mailx -s "Backup_SAN_TT details 
for `date`" "nihalchand.dehury@du.ae"
