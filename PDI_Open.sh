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
spool PDI_Open$datestr.csv
-------------------PDI details extract------------------------------------
Select
'IncidentNo'
||','||'IncidentStatus'
||','||'PendingCode'
||','||'priority'
||','||'CurrentResolverGroup'
||','||'AssigneeName'
||','||'OpenTime'
||','||'OpenedBy'
||','||'Category'
||','||'Area'
||','||'SubArea'
||','||'Customer Accountnumber'
||','||'Customer Value'
||','||'Contrtact ID'
||','||'Asset number'
||','||'Current Age of TT (No.of days)'
||','||'Assigned Time'
||','||'Reopen Count'
||','||'Reassign Count'
||','||'Brief Description'
from Dual
union ALL
select
"NUMBER"
||','||problem_status
||','||(case when problem_status='Pending Input' then pending_code else '' end)
||','||priority_code
||','||assignment
||','||assignee_name
||','||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||opened_by
||','||category
||','||subcategory
||','||product_type
||','||du_cust_accnumber
||','||du_cust_value
||','||du_contract_id
||','||du_asset_number
||','||(to_date(trunc(sysdate),' dd-mon-yyyy HH24:MI SS')-TO_DATE(open_time+4/24,'DD-MON-YYYY HH24:MI'))
||','||(select max(to_char(datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')) from activitym1 where "NUMBER"=a."NUMBER" and (type='ReAssigned' or type='Reopened'or type='Open'))
||','||DU_REOPENCOUNT
||','||"COUNT"
||','||(REPLACE(REPLACE (REPLACE (DBMS_LOB.SUBSTR ( brief_description, 2000, 1),CHR (10),' '),CHR (13),' '),CHR (9),' '))
from
HPSM94BKPADMIN.probsummarym1 a
where a.problem_status <>'Closed' and a.assignment like '%PDI%'  and open_time>='01-NOV-2015';
spool off;
quit;
EOF
echo "Dear All,

PFA the Post Production Issues TT Report.

BestRegards,
HPSM Team"| mail -v -s "IT Post Production Issues TT details for `date`" -a /hpsm/hpsm/ops/reports/PDI_Open$datestr.csv Tamer.Awad@du.ae Ankur.Saxena@du.ae Utkarsh.Jauhari@du.ae LaxmaReddy.Kompally@du.ae Shaji.Uddin@du.ae Hemanta.Patra@du.ae Sanjay.Sharma@du.ae Rahul.Gupta1@du.ae Gagan.Atreya@du.ae Neeraj.Sharma@du.ae priyesh.a@du.ae
