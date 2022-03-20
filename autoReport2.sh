
cd /hpsm/hpsm/ops/reports/

arr1=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)

for (( i = 0 ; i < 12 ; i++ ))
do


datestr[$i]="'01-${arr1[$i]}-2017'"

done
datestr[12]="'01-Jan-2017'"

for (( i = 0 ; i < 11 ; i++ ))
do
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\FMSReports\"; lcd /hpsm/hpsm/ops/reports/; prompt; recurse; mput ITSDIncidents${datestr[$i]}to${datestr[$i+1]}.txt; exit;"


done
