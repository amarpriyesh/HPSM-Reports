arr1=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)

for (( i = 0 ; i < 24 ; i++ ))
do

if [ $i -lt 11 ]
then
fromdate="'01-${arr1[$i]}-2018'"
todate="'01-${arr1[$i+1]}-2018'"
elif [ $i -eq 11 ]
then
fromdate="'01-${arr1[$i]}-2018'"
todate="'01-${arr1[$i+1]}-2019'"
else
fromdate="'01-${arr1[$i]}-2019'"
todate="'01-${arr1[$i+1]}-2019'"
echo $todate
fi
done
