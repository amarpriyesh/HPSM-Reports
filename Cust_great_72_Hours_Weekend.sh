cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/

REPORTFILE_AS_New=AS_report_New


recipient="nihalchand.dehury@du.ae"
##recipient="LaxmaReddy.Kompally@du.ae,Shiva.Lagishetty@du.ae,JyothiSaroja.Daggu@du.ae,Phanindra.Boddu@du.ae,Ashfaque.Mohammad@du.ae,Ramyakrishna.Gandi@du.ae,ITASTowerLeads-Onsite@du.ae,gsITASTowerLeads-Offshore@du.ae,Anandkumar.Pacha @du.ae,Venugopal.Bogineni@du.ae,Saikrishna.JV@du.ae,Meher.Nikita@du.ae,BalaKrishna.N@du.ae,Kanakadurga.D@du.ae,Jangiti.Jyothy@du.ae,Leela.Vishnumolakala@du.ae,Mounika.Chalasani@du.ae,Neelima.V@du.ae,Nitesh.Kumar@du.ae,Swati.Samaiya@du.ae,Nagasiva.Krishna@du.ae,ITBillingTTSupport@du.ae,Lokesh.Ongolu@du.ae,Akhila.C@du.ae,Radhika.Varakavi@du.ae,Vinay.Bussa@du.ae,Radhika.Khaitan@du.ae,SivaChaitanya.Kalavala@du.ae,Farookh.Laddaf@du.ae,Kiranmai.Bondili@du.ae,Kshirodarnba.Sahu@du.ae,Sirisha.Pinnamsetty@du.ae,Gouthami.K@du.ae,Chinmay.Pattanaik@du.ae,M.Ravindra@du.ae,Chandramouli.Kemburu@du.ae,Leelavathi.Gandholi@du.ae,Sridhar.SIRIGIRI@du.ae,Divya.Ganji@du.ae"
recipient1="nihalchand.dehury@du.ae,Raghu.Nandan@du.ae,Radhika.Varakavi@du.ae"

MailSubject="All Open  Customer TT Report Greater than 72 Hours @ `date \"+%d/%m/%Y %H:%M\"`"

OUTPUTFLAG=HTML

rm AS_report_New

echo "Subject: $MailSubject
To: $recipient
Cc: $recipient1
MIMEV=\"MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw" 
Content-Disposition: inline
" >> $REPORTFILE_AS_New

echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_AS_New
echo "Content-Type: text/html" >> $REPORTFILE_AS_New
echo "Content-Disposition: inline" >> $REPORTFILE_AS_New

echo "" >> $REPORTFILE_AS_New
echo "<html><P><font color="blue">
Dear All,<br /><br />All Open  Customer TT Report Greater than 72 Hours<B><U> Current Hour </U></B> as on `date +%d/%m/%y-%X`<br />
<br /></P></html>" >> $REPORTFILE_AS_New

echo "<TABLE border="1">" >> $REPORTFILE_AS_New
echo "<TR><TH><font color="blue">Assignement Group</TH></font><TH><font color ="blue">Open</TH></font><TH><font color ="blue">Accepted</TH></font><TH><font color="blue">Reassigned</TH></font><TH><font color="blue">In Progress</TH></font><TH><font color="blue">Pending Input</TH></font><TH><font color="blue">Reopened</TH></font><TH><font color="blue">Total</TH></TR>" >> $REPORTFILE_AS_New 
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF >> $REPORTFILE_AS_New
set linesize 150;
set NEWPAGE none;
set FEEDBACK OFF;
set HEADING OFF;
set ECHO OFF;
set DEFINE OFF;

select '<tr><td>'||x.assignment||'</td><td align=center>'||sum(Open)||'</td><td align=center>'||sum(Accepted) ||
'</td><td align=center>'||sum(ReAssigned)||'</td><td align=center>'||sum(RTB) ||
'</td><td align=center>'||sum(PI) ||'</td><td align=center>'||sum(Reopened) ||
'</td><th>'||count(*) ||'</th></tr>'from (select a.assignment, 
case when (problem_status='Open') then 1 else 0 end Open , 
case when (problem_status='Accepted') then 1 else 0 end Accepted ,
case when (problem_status='ReAssigned') then 1 else 0 end ReAssigned ,
 case when (problem_status='In Progress') then 1 else 0 end RTB ,
 case when (problem_status='Pending Input') then 1 else 0 end PI,
 case when (problem_status='Reopened') then 1 else 0 end Reopened from probsummarym1 a
where a.folder='SIEBEL-CRM' and a.problem_status not in('Rejected to Business','Closed','Resolved','Rejected') 
and a.du_master_tt is NULL and a.Assignment in ('IT - Billing','IT - GIS','IT - ICS
','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT - Payment Gateway',
'IT - POS' ,'IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OS
S-OPS-Fault/Performance MGMT','IT - OSS-OPS-Mobile Provisioning' ,'IT - OSS-OPS-Network Core Services',
'IT - OSS-OPS-OAIM' ,'IT - CRM','IT - OSS-OPS- HPSM','IT - Backup Admin','IT - Desktop & System Support',
'IT - System Admin UNIX','IT - Database Admin','IT - System Admin WINDOWS','IT - Enterprise Systems (HMC)',
'IT - SAN Admin','IT - Retail Technical Support','IT - TSD IT','IT - NOC','IT - EDMS','IT - Corporate Technical Support') 
and (((trunc(sysdate+1)-(open_time+4/24))*24)+10)>=72) x group by assignment;
exit;
EOF


echo "</TABLE>" >> $REPORTFILE_AS_New

echo $NEWLINE
echo $NEWLINE

--------------------------------------------------------


--------------------------------------------------


echo $NEWLINE
echo $NEWLINE

echo "<html><P><font color="blue">Regards,<br />HPSM Support Team<br />
<br />This is system auto generated mail,Please do not reply<br /></P></html>" >> $REPORTFILE_AS_New

echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_AS_New
echo "Content-Type: text/plain" >> $REPORTFILE_AS_New
echo "Content-Disposition: attachement; filename=all_open_AS_tt2.csv" >> $REPORTFILE_AS_New

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep on
set linesize 20000
set feedback off
set echo off
set define off
spool all_open_AS_tt2.csv
-------------------All Open TT Incident extract------------------------------------
Select
'IncidentNo'
||','||'IncidentStatus'
||','||'priority'
||','||'CurrentResolverGroup'
||','||'AssigneeName'
||','||'OpenTime'
||','||'Category'
||','||'Area'
||','||'SubArea'
||','||'Customer Accountnumber'
||','||'Contrtact ID'
||','||'Asset number'
||','||'Assigned Time'
||','||'Reopen Count'
||','||'Folder'
||','||'Ageing'
from Dual
union ALL
select
"NUMBER"
||','||problem_status
||','||priority_code
||','||assignment
||','||assignee_name
||','||to_char(OPEN_TIME+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||category
||','||subcategory
||','||product_type
||','||du_cust_accnumber
||','||du_contract_id
||','||du_asset_number
||','||(select max(to_char(datestamp+4/24,'mm/dd/yyyy HH24:MI:SS')) from activitym1 where "NUMBER"=a."NUMBER" and (type='ReAssigned' or type='Reopened'or type='Open'))
||','||DU_REOPENCOUNT
||','||folder
||','||round(((trunc(sysdate+1)-(open_time+4/24))*24)+10)
from
smadmin.probsummarym1 a
where  a.folder='SIEBEL-CRM' and a.problem_status not in('Rejected to Business','Closed','Resolved','Rejected') and a.du_master_tt is NULL and a.Assignment in ('IT - Billing','IT - GIS','IT - ICS
','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Mobile Mediation','IT - Payment Gateway','IT - POS' ,'IT - Datawarehouse','IT - ERP','IT - EAI','IT - EBusiness','IT - OS
S-OPS-Fault/Performance MGMT','IT - OSS-OPS-Mobile Provisioning' ,'IT - OSS-OPS-Network Core Services' ,'IT - OSS-OPS-OAIM' ,'IT - CRM','IT - OSS-OPS- HPSM','IT - Backu
p Admin','IT - Desktop & System Support','IT - System Admin UNIX','IT - Database Admin','IT - System Admin WINDOWS','IT - Enterprise Systems (HMC)','IT - SAN Admin','IT
 - Retail Technical Support','IT - TSD IT','IT - NOC','IT - EDMS','IT - Corporate Technical Support') 
and (((trunc(sysdate+1)-(open_time+4/24))*24)+10)>=72;
spool off;
quit;
EOF

#echo "--GvXjxJ+pjyke8COw" >> $REPORTFILE_AS_New
#echo "Content-Type: text/plain" >> $REPORTFILE_AS_New
#echo "Content-Disposition: attachement; filename=all_open_AS_tt2.csv" >> $REPORTFILE_AS_New
#echo "" >> $REPORTFILE_AS_New
echo "" >> $REPORTFILE_AS_New
cat all_open_AS_tt2.csv >> $REPORTFILE_AS_New
cat $REPORTFILE_AS_New | /usr/lib/sendmail -t
