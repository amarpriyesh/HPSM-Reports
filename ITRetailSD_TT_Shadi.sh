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
spool ITRetailSD_TT$datestr.txt
-------------------TT extract------------------------------------

select
'IncidentNo'
||'|'||'IncidentStatus'
||'|'||'CurrentResolverGroup'
||'|'||'PreviousResolverGroup'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'ClosedTime'
||'|'||'Title'
||'|'||'Description'
from Dual
union ALL
select
a."NUMBER"
||'|'||a.problem_status
||'|'||a.assignment
||'|'||a.du_previous_assignment
||'|'||to_char(a.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.close_time+4/24, 'mm/dd/yyyy HH24:MI:SS')
||'|'||REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(a.brief_description, 1000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' ')
||'|'||REPLACE(REPLACE(REPLACE(DBMS_LOB.SUBSTR(a.action, 1000,1), CHR(10), ' '), CHR(13), ' '), CHR(9), ' ')
from HPSM94BKPADMIN.probsummarym1 a 
where a."NUMBER" in (Select distinct (b."NUMBER") from HPSM94BKPADMIN.activitym1 b where dbms_lob.substr(b.description,50) like '%IT - Retail Service desk%') and open_time>=(sysdate-10);

spool off;
quit;
EOF
sed -i $'s/\t/ /g' ITRetailSD_TT$datestr.txt
gzip ITRetailSD_TT$datestr.txt
echo "."| mail -v -s "Please find attached ITRetailSD TT report" -a /hpsm/hpsm/ops/reports/ITRetailSD_TT$datestr.txt.gz bhavana.tatti@du.ae,shadi.trad@du.ae,waleed.ibrahim@du.ae,priyesh.a@du.ae
