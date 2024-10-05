a=0
while true;
do 
	b=$(nvidia-smi --query-gpu=memory.used --format=csv|grep -v memory|awk '{print $1}')
	echo $b
	if [ $b -ge $a ];
       	then
		a=$b
		echo $a
	fi
	sleep 1 
done
