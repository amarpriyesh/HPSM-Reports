cd
. ./.bash_profile
cd /hpsm/hpsm/ops/reports/
USER=hpsm_ftp_usr
PASS=Oss_Ops_123
datestr=`date "+%d%m%y"`
c=$datestr'0600'
d=$datestr'0030'


####FTP to Server for OLA Requirement###


##gzip OLA_Jan15_Onwards$datestr.txt

cp OLA_Jan15_Onwards$c.txt.gz OLA_Jan15_Onwards_File$c.txt.gz 
gzip -d OLA_Jan15_Onwards_File$c.txt.gz 

cp FMSIncident$d.txt.gz FMSIncident_File$d.txt.gz 
gzip -d FMSIncident_File$d.txt.gz 


cd /hpsm/hpsm/ops/
ftp -n 10.100.100.198 <<EOF
user $USER $PASS
cd /hpsm/OLAReports
put OLA_Jan15_Onwards_File$c.txt
#cd /hpsm/FMSReports
#put FMSIncident$d.txt.gz
bye
EOF


##FMSIncident2602150030.txt.gz

cd /hpsm/hpsm/ops/
ftp -n 10.100.100.198 <<EOF
user $USER $PASS
cd /hpsm/FMSReports
put FMSIncident_File$d.txt
bye
EOF
