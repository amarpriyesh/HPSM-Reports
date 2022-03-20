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
spool PDI$datestr.csv
-------------------PDI details extract------------------------------------
select
'IncidentNo'
||','||'CR_Ref_No'
||','||'IncidentStatus'
||','||'Opened By'
||','||'IncidentCategory'
||','||'IncidentArea'
||','||'IncidentSubArea'
||','||'CurrentResolverGroup'
||','||'Priority'
||','||'OpenTime'
||','||'Resolved_Time'
||','||'SLA_End_Time'
||','||'SLA_Remaining'
||','||'Title'
||','||'Description'
from Dual
UNION ALL
select
"NUMBER"
||','||du_1post_crnumber
||','||problem_status
||','||replace(opened_by,',',' ')
||','||category
||','||subcategory
||','||product_type
||','||assignment
||','||priority_code
||','||to_char(open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||to_char(du_sla_end+4/24,'mm/dd/yyyy HH24:MI:SS')
||','||sla_remaining
||','||replace(replace(replace(DBMS_LOB.SUBSTR(brief_description, 2000,1),chr(10)),chr(13)),',',' ')
||','||replace(replace(replace(DBMS_LOB.SUBSTR(action, 2000,1),chr(10)),chr(13)),',',' ')
from probsummarym1 where assignment!='TEST' and (category='Post Deployment' or category='1PostDeployment');
spool off;
quit;
EOF
echo "Dear All,

PFA the Post Production Issues TT Report.

BestRegards,
HPSM Team"| mail -v -s "IT Post Production Issues TT details for `date`" -a /hpsm/hpsm/ops/reports/PDI$datestr.csv Tamer.Awad@du.ae,Prasad.Puttur@du.ae,Ahmed.Jurmut1@du.ae,shadi.trad@du.ae,Huzefa.Ali@du.ae,Beethin.Chakraborty@du.ae,Bismita.Nayak@du.ae,Hemanta.Patra@du.ae,LaxmaReddy.Kompally@du.ae,M.Ravindra@du.ae,Ankur.Saxena@du.ae,Mahmoud.Shalabi@du.ae,Priyanka.Jain@du.ae,Shahid.Bashir@du.ae,Shaji.Uddin@du.ae,Shyam.Nath@du.ae,Siva.Chaitanya@du.ae,Tirupathi.Reddy@du.ae,Anwar.AlHoushi@du.ae,Ibrahim.AlHammadi@du.ae,Mahesh.inbasekaran@du.ae,Hichem.Saim@du.ae,Nauman.Iftikhar@du.ae,Shaikha.Dhahi@du.ae,Mohammad.Alberawi@du.ae,Tomas.Moreno@du.ae,SyedAsadAli.Shah@du.ae,Usman.Khaled@du.ae,Sushil.Patle@du.ae,Bismita.Nayak@du.ae,Srinivas.Bhimanadham@du.ae,Rajan.Purswani1@du.ae,Paromita.Chatterjee@du.ae,Yasir.Khattak1@du.ae,Prakash.M@du.ae,Osama.Anaqwah@du.ae,Amit.Khatri@du.ae

 






