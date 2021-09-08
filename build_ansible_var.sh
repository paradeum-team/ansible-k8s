#!/bin/bash
base_dir=$(cd `dirname $0` && pwd)
cd $base_dir
set -e
. ./config.cfg

mkdir -p /etc/ansible/group_vars
echo '' > /etc/ansible/group_vars/all

VAR_NAMES=`grep -Ev '^[[:space:]]*#|^$|\`|^set|^if|^elif|^else|^fi|^[[:space:]]*echo|^[[:space:]]*grep|^[[:space:]]*ACCESS_DOMAIN|^[[:space:]]*LB_DOMAIN|^[[:space:]]*MASTER_DOMAINS' ./config.cfg|awk -F '=' '{print $1}'`

for VAR_NAME in $VAR_NAMES
do

	VAR_NAME=`echo $VAR_NAME|xargs|sed 's/export//g'|xargs`
	eval VAR_VALUE=\$$VAR_NAME

	if [ -z "$VAR_NAME" ] || [ -z "$VAR_VALUE" ];then
		continue
	fi

        if [ "$VAR_VALUE" == "true" ] || [ "$VAR_VALUE" == "false" ];then
                VAR_VALUE='"'$VAR_VALUE'"'
        fi
	
	if [ "$VAR_VALUE" == "yes" ] || [ "$VAR_VALUE" == "no" ];then
                VAR_VALUE='"'$VAR_VALUE'"'
        fi	

	grep $VAR_NAME /etc/ansible/group_vars/all &>/dev/null && sed -i 's#'$VAR_NAME':.*#'$VAR_NAME': '"$VAR_VALUE"'#g' /etc/ansible/group_vars/all || echo "$VAR_NAME: $VAR_VALUE" >> /etc/ansible/group_vars/all
done
