cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports
datestr=`date "+%d%m%y%H%M"`

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
truncate table  pending_alert_master ;

insert into pending_alert_master  (select "NUMBER" ,operator,(select c.assignment from probsummarym1 c where c."NUMBER"=a."NUMBER") as assignment,datestamp+4/24 as Pending_Date,sysdate as Todays_Date,round(timeToResolve_ITSD(a.datestamp+4/24,sysdate)/9,3) as Business_Days_Pending,(select email from contctsm1 where operator_id=a.operator and rownum=1  ) as email, dbms_lob.substr(a.description,200) as description from activitym1 a where (a."NUMBER",a.datestamp,a.type) in  ( select "NUMBER",datestamp,'Pending Reason' as type from (select "NUMBER", max(datestamp) as datestamp from activitym1 b where b.type='Pending Reason' and b."NUMBER" in ( select "NUMBER" from probsummarym1 where problem_status ='Pending Input' and du_master_tt is NULL and folder='ITSD' and "NUMBER" not in ('IM4947308') and assignment in ('Bill Shock','Bill Shock - L2','Core - Mobile IN','Core - Mobile IN - L2','DuVerse Access','FNL_OPs','IT - BSCS Provisioning','IT - Billing','IT - Billing - L2','IT - Business Application Access','IT - Business Application Access - L2','IT - CRM','IT - CRM - L2','IT - Content Portal Application Support','IT - Content Portal Application Support - L2','IT - Database Admin','IT - Datawarehouse','IT - Datawarehouse - L2','IT - EAI','IT - EAI - L2','IT - EBusiness','IT - EBusiness - L2','IT - EDMS','IT - EDMS - L2','IT - ERP','IT - ERP - L2','IT - GIS','IT - GIS - L2','IT - ICS','IT - ICS - L2','IT - Interconnect Billing','IT - Interconnect Billing - L2','IT - MNP Application Support','IT - MNP Application Support - L2','IT - OSS-OPS- HPSM','IT - OSS-OPS- HPSM - L2','IT - OSS-OPS-Fault/Performance MGMT','IT - OSS-OPS-Fault/Performance MGMT - L2','IT - OSS-OPS-Fixed Mediation','IT - OSS-OPS-Fixed Mediation - L2','IT - OSS-OPS-Fixed Provisioning','IT - OSS-OPS-Fixed Provisioning - L2','IT - OSS-OPS-Mobile Mediation','IT - OSS-OPS-Mobile Mediation - L2','IT - OSS-OPS-Mobile Provisioning','IT - OSS-OPS-Mobile Provisioning - L2','IT - OSS-OPS-OAIM','IT - OSS-OPS-OAIM - L2','IT - POS','IT - POS - L2','IT - Payment Gateway','IT - Payment Gateway - L2','IT - Power Billing','IT - Power Billing - L2','IT APIGateway ops','IT DSP Application Support','IT DSP Application Support - L2','KMUCC Support','KMUCC Support - L2','NOC - IN','NOC - IN - L2','eShop_L1','eShop_L2') ) group by "NUMBER")) and "NUMBER"='IM4976958');

commit;
quit;
EOF

sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF
set colsep ,
set heading on
set pagesize 0
set trimspool on
set headsep off
set linesize 20000
set feedback off
spool pending_alert_master_alert1$datestr.csv
select "NUMBER",email,assignment,Business_Days_Pending from  pending_alert_master  where  Business_Days_Pending > 0 and  Business_Days_Pending < 5 ;
quit;
EOF
