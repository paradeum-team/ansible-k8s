#!/bin/bash
set -e

BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

. ./config.cfg

main(){
		
	read -p "Confirm to uninstall K8S?(yes/no): " yesno

	if [ "$yesno" != "yes" ];then
		exit 0
	fi

	./build_ansible_var.sh
	ansible k8sCluster -m shell -a "kubeadm reset -f && rm -rf /etc/kubernetes/pki && rm -f $HOME/.kube/config && (ip link|grep cni && ip link del cni0 || echo)"
}

main
