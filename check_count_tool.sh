#!/bin/bash

name=$1
cmd=$2

count=${3:-30}

echo "check $name status "
for i in `seq 1 $count`
do
	sleep 2
	$cmd &>/dev/null && echo "$name status is ok." && break || echo -n "."
	if [ $i -eq $count ];then
		echo -e "\033[31m $name status is error \033[0m"
		exit 1
	fi
done
