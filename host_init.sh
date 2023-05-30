#!/bin/bash
base_dir=$(cd `dirname $0` && pwd)
cd $base_dir
set -e

. ./config.cfg

INIT_HOSTS=k8sCluster

if [ ! -z "$1" ];then
	INIT_HOSTS=$1
	shift
fi

export ANSIBLE_SCP_IF_SSH=y

./build_ansible_var.sh

ansible-playbook playbooks/host-init/host-init.yml --extra-vars exec_hosts=$INIT_HOSTS $@
