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
spool CR_Crossfunctional$datestr.txt
-------------------CR_Crossfunctional report extract------------------------------------

select
'ChangeID'
||'|'||'ChangeCategory'
||'|'||'Opened By'
||'|'||'ChangePhase'
||'|'||'Priority'
||'|'||'ChangeCoordinator'
||'|'||'ChangeStatus'
||'|'||'Planned_Start'
||'|'||'Planned _End'
||'|'||'DownTime_Start'
||'|'||'DownTime_End'
||'|'||'Completion Code'
||'|'||'Closure Comments'
||'|'||'BriefDescription'
from Dual
union ALL
select
"NUMBER"
||'|'||category
||'|'||requested_by
||'|'||current_phase
||'|'||priority_code
||'|'||coordinator_it
||'|'||status
||'|'||to_char(planned_start+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(planned_end+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(down_start+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(down_end+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||du_completion_code
||'|'||replace(replace(DBMS_LOB.SUBSTR(closurecomments, 100,1),chr(10)),chr(13))
||'|'||replace(replace(DBMS_LOB.SUBSTR(brief_description, 100,1),chr(10)),chr(13))
from CM3RM1 where planned_start+4/24 = trunc(sysdate -1) and requested_by in ('BONNY JOSE','CHANDRA KOTHANA','DEEPTHI UMMADI','KIRAN KOLLIPARA','PRAJEESH OLACHERI','RAGHUMA REDDY','RAJENDRA PRASAD MINGI','SYED INTHIYAZAHMED','SRINIVAS RAO');
spool off;
quit;
EOF
/usr/sfw/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/reports/ ; prompt; recurse; mput CR_Crossfunctional$datestr.txt; exit;"
