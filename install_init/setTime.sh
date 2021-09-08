#!/bin/bash

timedatectl set-timezone Asia/Shanghai
tmpdatetime=`date "+%F %T"`
read -p "Please set current time, If it is empty, it is not modified. (example: $tmpdatetime): " datetime

if [ ! -z "$datetime" ];then
	date -s "$datetime"
else
	echo "The current time is not modified."
fi
