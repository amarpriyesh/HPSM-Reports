cd
. ./.bash_profile
cd /hpsm/hpsm/ops
datestr=`date "+%d%m%y%H%M"`
/usr/bin/smbclient \\\\10.175.67.50\\Public\$ -A .passwd.txt -c "cd \"HPSM Reports\OLA Reports\"; lcd /hpsm/hpsm/ops/; prompt; recurse; mput logs.tar; exit;"
