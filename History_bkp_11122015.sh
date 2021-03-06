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
spool history$datestr.txt
-------------------History extract------------------------------------

select
'SysDate'
||'|'||'IncidentNo'
||'|'||'Category'
||'|'||'Area'
||'|'||'SubArea'
||'|'||'Priority'
||'|'||'ResolverGroup'
||'|'||'ResolvedBy'
||'|'||'OpenTime'
||'|'||'ResolvedTime'
||'|'||'ActivityType'
||'|'||'UpdateTime'
||'|'||'CloseTime'
||'|'||'ResolutionCategory'
||'|'||'ResolutionType'
||'|'||'ResolutionArea'
||'|'||'Folder'
||'|'||'TTType'
||'|'||'RFO TAB'
||'|'||'Customer Type'
||'|'||'Action'
from Dual
UNION ALL
select
trunc(a.close_time+4/24)
||'|'||a."NUMBER"
||'|'||replace(a.category,'
','')
||'|'||replace(a.subcategory,'
','')
||'|'||replace(a.product_type,'
','')
||'|'||a.priority_code
||'|'||a.assignment
||'|'||a.resolved_by
||'|'||to_char(a.open_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||'Resolved'
||'|'||to_char(a.resolved_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||to_char(a.close_time+4/24,'mm/dd/yyyy HH24:MI:SS')
||'|'||replace(a.resolution_code,'
','')
||'|'||replace(a.resolution_type,'
','')
||'|'||replace(a.resolution_area,'
','')
||'|'||a.folder
||'|'||a.du_tt_type
||'|'||is_rfo
||'|'||du_cust_value
||'|'||concat(concat(concat(a.assignment,' to '),a.assignment),' | In Progress to Resolved')
from probsummarym1 a
where a."NUMBER" in (
'IM2122285',
'IM2122299',
'IM2122316',
'IM2122319',
'IM2122377',
'IM2122553',
'IM2122581',
'IM2122744',
'IM2122762',
'IM2122779',
'IM2122841',
'IM2122848',
'IM2122891',
'IM2122918',
'IM2122924',
'IM2122965',
'IM2122987',
'IM2123081',
'IM2123102',
'IM2123144',
'IM2123176',
'IM2123193',
'IM2123194',
'IM2123227',
'IM2123282',
'IM2123299',
'IM2123353',
'IM2123381',
'IM2123404',
'IM2123427',
'IM2123448',
'IM2123530',
'IM2123568',
'IM2123586',
'IM2123627',
'IM2123634',
'IM2123669',
'IM2123697',
'IM2123705',
'IM2123759',
'IM2123880',
'IM2123908',
'IM2123994',
'IM2123996',
'IM2124023',
'IM2124049',
'IM2124167',
'IM2124279',
'IM2124281',
'IM2124342',
'IM2124359',
'IM2124382',
'IM2124439',
'IM2124449',
'IM2124461',
'IM2124475',
'IM2124490',
'IM2124570',
'IM2124592',
'IM2124604',
'IM2124611',
'IM2124625',
'IM2124692',
'IM2124728',
'IM2124831',
'IM2124844',
'IM2124862',
'IM2124890',
'IM2124896',
'IM2124915',
'IM2124916',
'IM2124933',
'IM2124956',
'IM2124963',
'IM2124978',
'IM2125059',
'IM2125068',
'IM2125071',
'IM2125088',
'IM2125100',
'IM2125147',
'IM2125154',
'IM2125155',
'IM2125157',
'IM2125233',
'IM2125256',
'IM2125300',
'IM2125329',
'IM2125382',
'IM2125391',
'IM2125403',
'IM2125434',
'IM2125455',
'IM2125457',
'IM2125500',
'IM2125525',
'IM2125576',
'IM2125577',
'IM2125583',
'IM2125615',
'IM2125620',
'IM2125715',
'IM2125752',
'IM2125832',
'IM2125871',
'IM2125881',
'IM2125926',
'IM2125935',
'IM2126047',
'IM2126077',
'IM2126113',
'IM2126137',
'IM2126165',
'IM2126179',
'IM2126192',
'IM2126221',
'IM2126223',
'IM2126236',
'IM2126350',
'IM2126351',
'IM2126361',
'IM2126426',
'IM2126437',
'IM2126470',
'IM2126476',
'IM2126513',
'IM2126522',
'IM2126536',
'IM2126539',
'IM2126545',
'IM2126623',
'IM2126664',
'IM2126677',
'IM2126715',
'IM2126759',
'IM2126815',
'IM2126881',
'IM2126891',
'IM2126932',
'IM2126943',
'IM2126953',
'IM2127111',
'IM2127207',
'IM2127209',
'IM2127259',
'IM2127281',
'IM2127283',
'IM2127289',
'IM2127384',
'IM2127396',
'IM2127398',
'IM2127503',
'IM2127527',
'IM2127563',
'IM2127581',
'IM2127671',
'IM2127738',
'IM2127791',
'IM2127805',
'IM2127916',
'IM2127986',
'IM2127987',
'IM2128009',
'IM2128032',
'IM2128041',
'IM2128117',
'IM2128139',
'IM2128172',
'IM2128214',
'IM2128218',
'IM2128229',
'IM2128314',
'IM2128389',
'IM2128392',
'IM2128420',
'IM2128439',
'IM2128487',
'IM2128497',
'IM2128517',
'IM2128534',
'IM2128562',
'IM2128571',
'IM2128588',
'IM2128598',
'IM2128623',
'IM2128687',
'IM2128691',
'IM2128713',
'IM2128849',
'IM2128868',
'IM2129019',
'IM2129078',
'IM2129087',
'IM2129104',
'IM2129109',
'IM2129132',
'IM2129180',
'IM2129214',
'IM2129263',
'IM2129309',
'IM2129312',
'IM2129361',
'IM2129364',
'IM2129414',
'IM2129434',
'IM2129451',
'IM2129474',
'IM2129488',
'IM2129540',
'IM2129589',
'IM2129642',
'IM2129654',
'IM2129665',
'IM2129727',
'IM2129737',
'IM2129767',
'IM2129770',
'IM2129772',
'IM2129844',
'IM2129892',
'IM2129999',
'IM2130021',
'IM2130058',
'IM2130142',
'IM2130145',
'IM2130338',
'IM2130371',
'IM2130379',
'IM2130414',
'IM2130596',
'IM2130630',
'IM2130638',
'IM2130672',
'IM2130678',
'IM2130717',
'IM2130728',
'IM2130762',
'IM2130784',
'IM2130798',
'IM2130820',
'IM2130879',
'IM2130881',
'IM2130889',
'IM2130896',
'IM2130935',
'IM2131004',
'IM2131037',
'IM2131103',
'IM2131127',
'IM2131137',
'IM2131157',
'IM2131213',
'IM2131252',
'IM2131259',
'IM2131264',
'IM2131349',
'IM2131351',
'IM2131400',
'IM2131417',
'IM2131422',
'IM2131453',
'IM2131588',
'IM2131614',
'IM2131654',
'IM2131677',
'IM2131684',
'IM2131709',
'IM2131733',
'IM2131875',
'IM2131897',
'IM2131905',
'IM2132021',
'IM2132106',
'IM2132143',
'IM2132167',
'IM2132171',
'IM2132203',
'IM2132279',
'IM2132301',
'IM2132311',
'IM2132599',
'IM2132626',
'IM2132709',
'IM2132713',
'IM2132771',
'IM2132818',
'IM2132829',
'IM2132846',
'IM2132847',
'IM2132853',
'IM2132907',
'IM2133046',
'IM2133150',
'IM2133268',
'IM2133279',
'IM2133342',
'IM2133469',
'IM2133541',
'IM2133571',
'IM2133606',
'IM2133689',
'IM2133762',
'IM2133843',
'IM2133845',
'IM2133881',
'IM2133903',
'IM2133907',
'IM2133927',
'IM2133958',
'IM2133975',
'IM2133999',
'IM2134009',
'IM2134012',
'IM2134054',
'IM2134121',
'IM2134183',
'IM2134237',
'IM2134276',
'IM2134292',
'IM2134339',
'IM2134342',
'IM2134378',
'IM2134383',
'IM2134393',
'IM2134410',
'IM2134415',
'IM2134439',
'IM2134482',
'IM2134484',
'IM2134559',
'IM2134684',
'IM2134728',
'IM2134767',
'IM2134775',
'IM2134806',
'IM2134822',
'IM2134875',
'IM2134898',
'IM2135146',
'IM2135158',
'IM2135185',
'IM2135192',
'IM2135305',
'IM2135366',
'IM2135367',
'IM2135378',
'IM2135433',
'IM2135436',
'IM2135470',
'IM2135555',
'IM2135592',
'IM2135616',
'IM2135648',
'IM2135677',
'IM2135690',
'IM2135697',
'IM2135841',
'IM2135878',
'IM2136088',
'IM2136144',
'IM2136294',
'IM2136325',
'IM2136328',
'IM2136394',
'IM2136592',
'IM2136840',
'IM2136874',
'IM2136914',
'IM2136981',
'IM2137010',
'IM2137131',
'IM2137132',
'IM2137153',
'IM2137205',
'IM2137217',
'IM2137220',
'IM2137326',
'IM2137425',
'IM2137468',
'IM2137868'
);
spool off;
quit;
EOF
/usr/bin/smbclient \\\\172.21.15.11\\HPSMFilesShareFolder -A .passwd_new.txt -c "lcd /hpsm/hpsm/ops/reports/ ; prompt; recurs
e; mput history$datestr.txt; exit;"

