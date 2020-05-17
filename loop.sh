#!/bin/sh
if [ ! $1 ]; then
	echo 'ERROR: Need to apply loop param'
	exit
fi
echo $1

os_mac(){
	sudo systemsetup -setusingnetworktime off
	for i in $(seq 1 $1)
	do
		echo "-------------------------------" >> log.txt
		echo `date +"%Y%m%d_%H%M%S"` $i >> log.txt
		git pull 1>>log.txt 2>&1
		git commit -a -m 'git auto commit' 1>>log.txt 2>&1
		git push origin master 1>>log.txt 2>&1
		time=`date -v-1d +%m:%d:%Y`
		sudo systemsetup -setdate "$time" 1>>log.txt 2>&1
		echo $(($1-$i))
	done
	sudo systemsetup -setusingnetworktime on
}

os_linux(){
	for i in $(seq 1 $1)
	do
		echo `date +"%Y%m%d_%H%M%S"` >> log.txt
		git pull
		git commit -a -m 'git auto commit'
		git push origin master
		time=`date +'%G-%m-%d %H:%M:%S' -d '-1 days'`
		timedatectl set-time "$time"
		echo $(($1-$i))
	done
}

os=$(uname -s)
if [[ "$os" == "Linux" ]]; then
	os_linux $1
elif [[ "$os" == "Darwin" ]]; then
	os_mac $1
else
	echo "unknown OS"
	exit 1
fi

echo "done"
