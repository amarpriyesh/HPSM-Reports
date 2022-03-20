cd
. ./.bash_profile
cd /hpsm/hpsm/ops



sqlplus -S -R 1 SIEBEL@sibpr/mob06du << EOF
set head off;
set trimspool on;
set pagesize 0
set linesize 1000
set feedback off;
spool Siebel288.txt;
select distinct
sr.sr_num ||'|'||
sr.integration_id||'|'||
sr.sr_stat_id ||'|'||
decode(org.name,null,'NOOWNER',org.name)||'|'||
srx.attrib_09
from
siebel.s_srv_req sr,
siebel.s_org_ext org,
siebel.s_srv_req_x srx,
siebel.s_user owner
where
org.row_id(+) = sr.OWNER_OU_ID and
sr.owner_emp_id = owner.row_id(+) and 
sr.created >= sysdate - 365 and
sr.integration_id is not null and
sr.row_id = srx.row_id;
spool off;
EOF



sqlplus HPSM94BKPADMIN@sm9prod/HPSM94BKPADMIN#123 << EOF
truncate table TT_SIEBEL_STAGING drop storage;
EOF

sqlldr HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod control=Sibload.ctl errors=100000 bad=x.bad direct=true;

sqlplus -S -R 1 HPSM94BKPADMIN@sm9prod/HPSM94BKPADMIN#123 << EOF
set head off;
set trimspool on;
set pagesize 0
set linesize 1000
set feedback off;

insert into tt_status_grp_issues_log_hist
select * from tt_status_grp_issues_log;

truncate table tt_status_grp_issues_log;

insert into tt_status_grp_issues_log (
select distinct sysdate , A."NUMBER"
, REFERENCE_NO , B.TTStatus, B.TTOwner, B.ManualFlag, A.problem_status, null
from probsummarym1 A, tt_siebel_staging B, tt_hpsm_sieb_status_map C,exception_TTs e
where A.folder = 'SIEBEL-CRM'
 and A.REFERENCE_NO = B.TTNO
 and A."NUMBER" = B.IncidentNumber
 and B.TTStatus = C.siebel_status
 and (A.problem_status, decode(B.TTOwner,'TSD','TSD','IT - TSD IT','TSD','NOTTSD') ) not in (
        select D.hpsm_status,D.resgrp  from tt_hpsm_sieb_status_map  D where B.TTStatus = D.siebel_status
 ) and A.REFERENCE_NO <> e.tt_number);

update tt_status_grp_issues_log set comments='StatusIssue' where (TTStatus,problem_status) not in 
(select siebel_status,hpsm_status from tt_hpsm_sieb_status_map) and trunc(log_dtm)=trunc(sysdate);

update tt_status_grp_issues_log set comments='GrpIssue' where (TTStatus,problem_status) in
(select siebel_status,hpsm_status from tt_hpsm_sieb_status_map) and trunc(log_dtm)=trunc(sysdate);

commit;
spool ReportData.txt;
select distinct tt_num||'|'||REFERENCE_NO||'|'||TTStatus||'|'||TTOwner||'|'||ManualFlag||'|'||problem_status||'|'||comments 
from tt_status_grp_issues_log where trunc(log_dtm)=trunc(sysdate) and REFERENCE_NO not in (select tt_number from exception_TTs);
spool off;
EOF


(echo "Reconciliation Report"; uuencode ReportData.txt ReportData.txt)|mailx -s "RECONCILIATION REPORT" "mohammed.rezwanali@du.ae,nihalchand.dehury@du.ae";
