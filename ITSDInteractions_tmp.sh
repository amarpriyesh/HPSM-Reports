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
spool ITSDInteraction$datestr.txt
-------------------ITSD Interaction extract------------------------------------

select
'IncidentNo'
||'|'||'InteractionOwner'
||'|'||'ContactEmail'
||'|'||'duEmail'
||'|'||'InteractionStatus'
||'|'||'InteractionCategory'
||'|'||'InteractionArea'
||'|'||'InteractionSubArea'
||'|'||'Priority'
||'|'||'Titile'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'ClosedTime'
||'|'||'duFollowup'
||'|'||'Opened By'
||'|'||'ESS Flag'
||'|'||'RelatedIncident'
||'|'||'ResolutionCode'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
from Dual
UNION ALL
select
A.incident_id
||'|'||A.du_interaction_owner
||'|'||A.contact_email
||'|'||A.du_email
||'|'||A.open
||'|'||replace(A.category,'
','')
||'|'||replace(A.subcategory,'
','')
||'|'||replace(replace(A.product_type,chr(10)),chr(13))
||'|'||A.priority_code
||'|'||A.title
||'|'||to_char(A.open_time+4/24, 'mm-dd-yyyy HH24:MI:SS') 
||'|'||to_char(A.resolve_time+4/24, 'mm-dd-yyyy HH24:MI:SS') 
||'|'||to_char(A.close_time+4/24, 'mm-dd-yyyy HH24:MI:SS') 
||'|'||A.du_followup_code 
||'|'||A.callback_type 
||'|'||A.opened_by 
||'|'||A.ess_entry
||'|'||replace(A.resolution_code,'
','') 
||'|'||replace(A.resolution_type,'
','')
||'|'||replace(A.resolution_area,'
','')
from incidentsm1 A where ( A.open_time+4/24>='01-Jan-2017'  );
spool off;
quit;
EOF
gzip ITSDInteraction$datestr.txt
#(echo "Please find attached TT report"; uuencode  ITSDInteraction$datestr.txt.gz ITSDInteraction$datestr.txt.gz)| mailx -s " TT Report for `date`" "nihalchand.dehury@du.ae,ankur.saxena@du.ae,mohammed.rezwanali@du.ae,Edward.Paul@du.ae,Iqbal.Khan@du.ae,Mansoor.A@du.ae,Midhun.Antony@du.ae,Praveen.Singu@du.ae,Sankar.Kotla@du.ae,Winner.Viagularaj@du.ae,ServiceDesk@du.ae"
#echo "."| mail -v -s "Please find attached ITSD Interaction TT report" -a /hpsm/hpsm/ops/reports/ITSDInteraction$datestr.txt.gz priyesh.a@du.ae,ankur.saxena@du.ae,Mugtaba.Ahmed@du.ae
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\6 months incident\"; lcd /hpsm/hpsm/ops/reports/; prompt; recurse; mput ITSDInteraction6months$datestr.txt.gz; exit;"
