cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/
datestr=`date "+%d%m%y%H%M"`

a=`sqlplus -S -R 1 HPSM94BKPADMIN/HPSM94BKPADMIN#123@sm9prod << EOF

select b.assignment, 
sum(b.dsp_6) as tickets_0_6,
sum(b.dsp_9) as tickets_6_9,
sum(b.dsp_11) as tickets_09_11,
sum(b.dsp_13) as tickets_11_13,
sum(b.dsp_15) as tickets_13_15,
sum(b.dsp_17) as tickets_15_17,
sum(b.dsp_19) as tickets_17_19,
sum(b.dsp_21) as tickets_19_21,
sum(b.dsp_24) as tickets_21_24,
sum(b.dsp_tot) as tickets_tot
 from  (select  /*+PARALLEL(5)*/
distinct("NUMBER") as nm1,
case when  description like '%Incident Opened with IT DSP Application Support Assignment%' then 'IT DSP Application Support' when  description like '%Incident Opened with IT - CRM Assignment%' then 'IT - CRM' when  description like '%Incident Opened with IT - Billing Assignment%' then 'IT - Billing' else   NULL end   as assignment,
case when (description like '%Incident Opened with IT DSP Application Support Assignment%' or description like '%Incident Opened with IT - CRM Assignment%' or description like '%Incident Opened with IT - Billing Assignment%') and ( datestamp+4/24 >(trunc(sysdate)+0.001/24) and  datestamp+4/24 <=(trunc(sysdate)+6/24))   then 1 else 0 end as dsp_6 ,
case when (description like '%Incident Opened with IT DSP Application Support Assignment%' or description like '%Incident Opened with IT - CRM Assignment%' or description like '%Incident Opened with IT - Billing Assignment%') and ( datestamp+4/24 >(trunc(sysdate)+6/24) and  datestamp+4/24 <=(trunc(sysdate)+9/24))   then 1 else 0 end as dsp_9 ,
case when (description like '%Incident Opened with IT DSP Application Support Assignment%' or description like '%Incident Opened with IT - CRM Assignment%' or description like '%Incident Opened with IT - Billing Assignment%') and ( datestamp+4/24 >(trunc(sysdate)+9/24) and  datestamp+4/24 <=(trunc(sysdate)+11/24))   then 1 else 0 end as dsp_11 ,
case when (description like '%Incident Opened with IT DSP Application Support Assignment%' or description like '%Incident Opened with IT - CRM Assignment%' or description like '%Incident Opened with IT - Billing Assignment%') and ( datestamp+4/24 >(trunc(sysdate)+11/24) and  datestamp+4/24 <=(trunc(sysdate)+13/24))   then 1 else 0 end as dsp_13 ,
case when (description like '%Incident Opened with IT DSP Application Support Assignment%' or description like '%Incident Opened with IT - CRM Assignment%' or description like '%Incident Opened with IT - Billing Assignment%') and ( datestamp+4/24 >(trunc(sysdate)+13/24) and  datestamp+4/24 <=(trunc(sysdate)+15/24))   then 1 else 0 end as dsp_15 ,
case when (description like '%Incident Opened with IT DSP Application Support Assignment%' or description like '%Incident Opened with IT - CRM Assignment%' or description like '%Incident Opened with IT - Billing Assignment%') and ( datestamp+4/24 >(trunc(sysdate)+15/24) and  datestamp+4/24 <=(trunc(sysdate)+17/24))   then 1 else 0 end as dsp_17 ,
case when (description like '%Incident Opened with IT DSP Application Support Assignment%' or description like '%Incident Opened with IT - CRM Assignment%' or description like '%Incident Opened with IT - Billing Assignment%') and ( datestamp+4/24 >(trunc(sysdate)+17/24) and  datestamp+4/24 <=(trunc(sysdate)+19/24))   then 1 else 0 end as dsp_19 ,
case when (description like '%Incident Opened with IT DSP Application Support Assignment%' or description like '%Incident Opened with IT - CRM Assignment%' or description like '%Incident Opened with IT - Billing Assignment%') and ( datestamp+4/24 >(trunc(sysdate)+19/24) and  datestamp+4/24 <=(trunc(sysdate)+21/24))   then 1 else 0 end as dsp_21 ,
case when (description like '%Incident Opened with IT DSP Application Support Assignment%' or description like '%Incident Opened with IT - CRM Assignment%' or description like '%Incident Opened with IT - Billing Assignment%') and ( datestamp+4/24 >(trunc(sysdate)+21/24) and  datestamp+4/24 <=(trunc(sysdate)+24/24))   then 1 else 0 end as dsp_24 ,
case when (description like '%Incident Opened with IT DSP Application Support Assignment%' or description like '%Incident Opened with IT - CRM Assignment%' or description like '%Incident Opened with IT - Billing Assignment%') and( datestamp+4/24 >(trunc(sysdate)+0.001/24) and  datestamp+4/24 <(sysdate ))   then 1  else 0 end as dsp_tot 
from activitym1 where datestamp+4/24>(trunc(sysdate)+0.001/24) and type  ='Initial Assignment Group' and (description like '%Incident Opened with IT DSP Application Support Assignment%' or description like '%Incident Opened with IT - CRM Assignment%' or description like '%Incident Opened with IT - Billing Assignment%') ) b group by b.assignment ;
quit;
EOF`
echo $a
