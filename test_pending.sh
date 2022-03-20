cd /hpsm/hpsm/ops/reports/pending/
rm escalation3.csv escalation2.csv escalation1.csv pending_alert.csv
sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
truncate table pending_alert_master ;
insert into   pending_alert_master (select "NUMBER",THENUMBER ,operator,(select c.assignment from probsummarym1 c where c."NUMBER"=a."NUMBER") as assignment,datestamp+4/24 as Pending_Date,sysdate as Todays_Date,round(timeToResolve_ITSD(a.datestamp+4/24,sysdate)/9,3) as Business_Days_Pending,(select email from contctsm1 where operator_id=a.operator and rownum=1  ) as email,(select case when email is not null then email else null end  from leademail where operator_id=a.operator and rownum=1  ) as emaillead, dbms_lob.substr(a.description,200) as description from activitym1 a where (a."NUMBER",a.datestamp,a.type) in  ( select "NUMBER",datestamp,'Pending Reason' as type from (select "NUMBER", max(datestamp) as datestamp from activitym1 b where b.type='Pending Reason' and b."NUMBER" in ( select "NUMBER" from probsummarym1 where problem_status ='Pending Input' and du_master_tt is NULL and folder='ITSD' and "NUMBER" not  in ('IM5002340') and assignment in (select bucket from ebucket) ) group by "NUMBER")) and round(timeToResolve_ITSD(a.datestamp+4/24,sysdate)/9,3)>2  );
commit;
insert into  pending_alert3 (select * from pending_alert_master where thenumber  in (select a.thenumber from pending_alert2 a, pending_alert_master b where a.thenumber=b.thenumber ) );
truncate table  pending_alert2;
commit;
set colsep ,
set heading on
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
spool pending_alert.csv
select 
"NUMBER"
||','||operator
||','||assignment 
||','||emaillead
||','||Pending_Date
||','||Todays_Date
||','||Business_Days_Pending
||','||email
||','||emaillead
||','||description
from pending_alert_master ;
spool off
spool escalation3.csv
select 
"NUMBER"
||','||operator
||','||assignment 
||','||emaillead
||','||Pending_Date
||','||Todays_Date
||','||Business_Days_Pending
||','||email
||','||emaillead
||','||description
from  pending_alert3 ;
spool off

insert into pending_alert2 (select * from pending_alert_master where thenumber in (select a.thenumber from pending_alert1 a, pending_alert_master b where a.thenumber=b.thenumber ) and thenumber not in (select thenumber from pending_alert3) );
truncate table  pending_alert1 ;
commit;

spool escalation2.csv
select 
cases
||','||operator
||','||email
||','||leademail 
from (select cases,operator,(select a.email from pending_alert_master a where b.operator=a.operator and rownum=1) as email,(select a.email from leademail a where b.operator=a.operator_id and rownum=1) as leademail from (select 
LISTAGG(concat(concat("NUMBER",' Pending Since '),to_char(Pending_Date,'dd-mm-yyyy hh:mm:ss am')),' \n ') WITHIN GROUP (ORDER BY Pending_Date) AS cases,operator from  pending_alert2 b where Business_Days_Pending > 4 group by operator) b) ;
spool off

insert into pending_alert1  ( select * from pending_alert_master where  (thenumber not in (select thenumber  from pending_alert2) and thenumber not in (select thenumber from pending_alert3)) ) ;
commit;

spool escalation1.csv
select cases
||','||operator
||','||email
||','||leademail
from (select cases,operator,(select a.email from pending_alert_master a where b.operator=a.operator and rownum=1) as email,(select a.email from leademail a where b.operator=a.operator_id and rownum=1) as leademail from (select
LISTAGG(concat(concat("NUMBER",' Pending Since '),to_char(Pending_Date,'dd-mm-yyyy hh:mm:ss am')),' \n ') WITHIN GROUP (ORDER BY Pending_Date) AS cases,operator from  pending_alert1 b group by operator) b) ;
spool off
quit;
EOF

z=`cat escalation2.csv | wc -l`
echo $z
for (( j = 1 ; j <= $z ; j++ ))
    do
echo $j
         a=`cat escalation2.csv | awk NR==$j`
echo $a
number=`echo $a | awk -F ','  '{print $1}'`
operator=`echo $a | awk -F ',' '{print $2}'`
email=`echo $a | awk -F ',' '{print $3}'`
leademail=`echo $a | awk -F ',' '{print $4}'`
echo $number$email
if [ "$leademail" == "" ] ;
 then
leademail="ankur.saxena@du.ae,priyesh.a@du.ae"
 fi
echo -e "Dear $leademail,\n\nPlease Find below pending input report for $operator, pending for more than 4 Business days. Leads are requested to take action on Priority. Please contact gunjan.mathur@du.ae for any exclusions. \n\n$number\n\nRegards \nHPSM Team" | mail -s "Reminder 2:pending tickets for operator: $operator" -c $email $leademail
echo done
    done

z=`cat escalation1.csv | wc -l`
echo $z
for (( j = 1 ; j <= $z ; j++ ))
    do
echo $j
         a=`cat escalation1.csv | awk NR==$j`
echo $a
number=`echo $a | awk -F ','  '{print $1}'`
operator=`echo $a | awk -F ',' '{print $2}'`
email=`echo $a | awk -F ',' '{print $3}'`
leademail=`echo $a | awk -F ',' '{print $4}'`
echo $number$email
echo -e "Dear $email,\n\nPlease Find below pending input report for $operator, pending for more than 2 Business days. \n\n$number\n\nRegards \nHPSM Team" | mail -s "Reminder 1:pending tickets for operator: $operator" $email
echo done
    done

echo -e "Dear Gunjan,\n\n Please find pending user data in attachment.\n\nRegards\nHPSM Team" | mail -s "Pending user data" -a escalation3.csv -a pending_alert.csv ankur.saxena@du.ae,priyesh.a@du.ae
