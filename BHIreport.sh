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
spool BHI_openTTs$datestr.csv
-------------------BHI_openTTs Incident extract------------------------------------
select
'IncidentNo'
||','||'IncidentCreatedate'
||','||'Asset No'
||','||'IncidentStatus'
||','||'Opened By'
||','||'Assignee Name'
||','||'IncidentCategory'
||','||'IncidentArea'
||','||'IncidentSubArea'
||','||'CurrentResolverGroup'
||','||'Customer Segment'
||','||'Priority'
||','||'LastUpdatedTime'
||','||'JournalUpdate'
||','||'Brief Description'
from Dual
UNION ALL
select
"NUMBER"
||','||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||du_asset_number
||','||problem_status
||','||opened_by
||','||assignee_name
||','||category
||','||subcategory
||','||product_type
||','||assignment
||','||du_cust_segment
||','||priority_code
||','||to_char(update_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(update_action, 200,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' ')
||','||replace(replace(DBMS_LOB.SUBSTR(action, 3000,1),chr(10)),chr(13))
from
probsummarym1
where assignment in ('IT - Billing', 'IT - OSS-OPS-Mobile Provisioning','IT - ICS','IT - Business Application Access') and problem_status not in ('Resolved', 'Closed');
spool off;
quit;
EOF

echo "."| mail -v -s "Billing ICS HPSA Incidents Report for `date`" -a /hpsm/hpsm/ops/reports/BHI_openTTs$datestr.csv raghu.nandan@du.ae,Kanakadurga.D@du.ae,Lakshman.Dosapati@du.ae,Mohamedabdul.Azeem@du.ae,Sandeep.viswanath@du.ae,Satish.Malla@du.ae,munagavalasa.rohit@du.ae,leela.vishnumolakala@du.ae,Rahul.Singh@du.ae,Hemanta.Patra@du.ae,Swati.Samaiya@du.ae,Mounika.Chalasani@du.ae
#( echo "Please find attached the Billing HPSA ICS current Open Incidents report"; uuencode BHI_openTTs$datestr.csv BHI_openTTs$datestr.csv)| mailx -s "Billing ICS HPSA Incidents Report for `date`" "raghu.nandan@du.ae,Kanakadurga.D@du.ae,Lakshman.Dosapati@du.ae,Mohamedabdul.Azeem@du.ae,Sandeep.viswanath@du.ae,Satish.Malla@du.ae,munagavalasa.rohit@du.ae,leela.vishnumolakala@du.ae,Rahul.Singh@du.ae,Hemanta.Patra@du.ae,Swati.Samaiya@du.ae,Mounika.Chalasani@du.ae"
