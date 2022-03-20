cd
. ./.bash_profile
cd /hpsm/hpsm/ops/
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << !
set head off;
set pagesize 0;
set linesize 100;

update probsummarym1 set current_phase='logging' where  current_phase='Recovery' and 
folder in ('ITSD','SIEBEL-CRM') and
problem_status in ('Reopened');

commit;

quit;
!
