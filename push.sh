
j=`date +"%s"`
j=$((j%5))
echo $j
for i in $(seq 0 1 $j)
do
	echo $i
done 


