#!/bin/bash
set -e

BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

check_ds(){
  desiredNumberScheduled=1
  numberReady=0
  
  name=$1
  
  if [ -z "$name" ]; then
  	echo "$0 <name>"
  	exit 1
  fi
  
  get_cmd="kubectl get ds $name -n kube-system"
  
  get_status(){
  	desiredNumberScheduled=`$get_cmd -o jsonpath='{.status.desiredNumberScheduled}'`
  	numberReady=`$get_cmd -o jsonpath='{.status.numberReady}'`
  }
  
  i=1
  while [[ "$desiredNumberScheduled" -ne "$numberReady" ]] || [[ "$desiredNumberScheduled" -eq '' ]]
  do
  	get_status
  	if [ "$i" -gt 60 ];then
  		echo "check $name status timeout !!!"
  		exit 1
  	fi
  	let i=i+1
  	sleep 1
  done
  
  echo "$name ds is runing!"
}

check_ds node-local-dns
