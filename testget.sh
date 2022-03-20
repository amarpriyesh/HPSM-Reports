sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod <<END
set lines 256
set trimout on
set tab off
set trimpspool on
set wrap on
SET LINESIZE 2000;
select * from assignmentm1 where rownum=1 ; 
exit;
END
