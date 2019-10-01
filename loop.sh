#!/bin/sh
if [ ! $1 ]; then
	echo 'ERROR: Need to apply loop param'
	exit
fi
echo $1

op_git(){
	git pull 1>>/dev/null 2>&1
	git commit -a -m 'git auto commit' 1>>/dev/null 2>&1
	git push origin master 2>>/dev/null
	sleep $((RANDOM/8000))
}

op_random(){
j=`date +"%s"`
j=$((j%3+1))
echo `date +"%Y%m%d_%H%M%S"` $i $j>> log.txt
for i in $(seq 1 $j)
do
	# echo >> log.txt
	op_git
done
}

os_mac(){
	sudo systemsetup -setusingnetworktime off
	for i in $(seq 1 $1)
	do
		echo "\n-------------------------------" >> log.txt
		op_random
		echo "$(($1-$i))\t\c"
		time=`date -v-2d +%m:%d:%Y`
		sudo systemsetup -setdate "$time"
	done
	sudo systemsetup -setusingnetworktime on
}


os_linux(){
	for i in $(seq 1 $1)
	do
		echo "\n-------------------------------" >> log.txt
		op_random
		echo "$(($1-$i))\t\c"
		time=`date +'%G-%m-%d %H:%M:%S' -d '-1 days'`
		timedatectl set-time "$time"
		echo $(($1-$i))
	done
}

op_patch(){
	os=$(uname -s)
	if [[ "$os" == "Linux" ]]; then
		os_linux $1
	elif [[ "$os" == "Darwin" ]]; then
		os_mac $1
	else
		echo "unknown OS"
		exit 1
	fi
}

if [ $1 -eq 0 ]; then op_random
	else op_patch $1
fi


echo "done"
