cd 
. ./.bash_profile
cd /hpsm/hpsm/ops/reports
datestr=`date "+%d%m%y%H%M"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
set echo off
spool ProblemTickets$datestr.csv
-------------------ITSD Incident extract------------------------------------
select 
'Incident'
||'|'||'Dependent Incident'
||'|'||'Problem Ticket'
||'|'||'Resolved By'
||'|'||'Resolution Time'
from Dual
UNION ALL
select 
distinct
B."NUMBER"
||'|'||case when a.depend like 'IM%' then a.depend else null end
||'|'||case when a.depend like 'PM%' then a.depend else null end
||'|'||(select resolved_by from probsummarym1 c where c."NUMBER"=a.depend )
||'|'||(select to_char(RESOLVED_TIME+4/24,'mm/dd/yyyy HH24:MI:SS') from probsummarym1 c where c."NUMBER"=a.depend )
 from screlationm1 a , probsummarym1 B  where B."NUMBER"=a.source  and B."NUMBER" in ('IM3656381','IM3656388','IM3590475','IM3590488','IM3590494','IM3590504','IM3590527','IM3590532','IM3590538','IM3590543','IM3590548','IM3590559','IM3590564','IM3590572','IM3590574','IM3593442')  ;
spool off;
quit;
EOF
( echo "Please find attached the Problem Ticket  report"; )| mailx -a ProblemTickets$datestr.csv  -s "Problem Tickets Report for `date`" "Sanjay.Sharma@du.ae,Gagan.Atreya@du.ae,Ashish.Pandita@du.ae,priyesh.a@du.ae,ankur.saxena@du.ae,ravi.kalia@du.ae,neeraj.sharma@du.ae" 
