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
spool Outbox_Pending$datestr.csv
-------------------TT extract------------------------------------



select * from outboxm1 where integration_status='Pending' and response_type <>'Invalid Parameters';

spool off;
quit;
EOF
gzip Outbox_Pending$datestr.csv
echo "."| mail -v -s " ALL TT REPORT for `date`" -a /hpsm/hpsm/ops/reports/Outbox_Pending$datestr.csv.gz priyesh.a@du.ae
#(echo "Please find attached pending TTs"; uuencode Outbox_Pending$datestr.csv.gz Outbox_Pending$datestr.csv.gz)| mailx -s " Pending REPORT for `date`" "priyesh.a@du.ae"

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
-------------------TT extract------------------------------------



select * from outboxm1 where integration_status='Pending' and response_type <>'Invalid Parameters';

spool off;
quit;
EOF
