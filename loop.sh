if [ ! $1 ]; then
   echo 'ERROR: Need to apply loop param'
   exit
fi
for i in $(seq 1 $1)
do 
   echo `date +"%Y%m%d_%H%M%S"` >> log.txt && git pull && git commit -a -m 'git auto commit' && git push origin master
   time=`date +'%G-%m-%d %H:%M:%S' -d '-1 days'`
   timedatectl set-time "$time"
done