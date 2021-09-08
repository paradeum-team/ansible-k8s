#!/bin/bash
# Auther: jyliu

desiredNumberScheduled=1
numberReady=0

get_status(){
	desiredNumberScheduled=` kubectl get ds kube-flannel-ds -n kube-system -o jsonpath='{.status.desiredNumberScheduled}'`
	numberReady=`kubectl get ds kube-flannel-ds -n kube-system -o jsonpath='{.status.numberReady}'`
}

i=1
while [[ "$desiredNumberScheduled" -ne "$numberReady" ]] || [[ "$desiredNumberScheduled" -eq '' ]] 
do
	get_status
	if [ "$i" -gt 60 ];then
		echo "check kube flannel status timeout !!!"
		exit 1
	fi
	let i=i+1
	sleep 1
done

echo "kube flannel ds is runing!"
