arr1=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)

for (( i = 0 ; i < 24 ; i++ ))
do

if [ $i -le 11 ]
then
datestr[$i]="'01-${arr1[$i]}-2016'"
echo ${datestr[$i]}
else
datestr[$i]="'01-${arr1[$i]}-2017'"
echo ${datestr[$i]}
fi
done
