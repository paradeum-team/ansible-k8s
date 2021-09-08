#!/bin/bash
set -e

BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

. ./config.cfg

main(){
        # start offline-registry
        if [ "$is_offline" == "True" ];then
        ./install_init/start-offline-registry.sh
	fi


	./build_ansible_var.sh
	ansible-playbook playbooks/k8s/k8s.yml
}
main
