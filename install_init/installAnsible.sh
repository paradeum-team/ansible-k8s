#!/bin/bash
set -e

BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

. ../config.cfg


# install ansible
installAnsible(){
	echo "##### install ansible start #####"
	# install ansible
	if [ "$is_offline" == "True" ];then
		yum --disablerepo=\* --enablerepo=offline-k8s* install -y ansible pyOpenSSL
	else
		yum install -y ansible pyOpenSSL
	fi
	# 配置/etc/ansible/ansible.cfg
	\cp -f ../ansible.cfg /etc/ansible/ansible.cfg
	echo "##### install ansible end #####"
}

configAnsible(){
	echo "##### config ansible hosts start #####"
        if [ -f "/etc/ansible/hosts" ] && grep -E 'k8sCluster' /etc/ansible/hosts &>/dev/null ;then
		echo "/etc/ansible/hosts is already exists."
	elif [  -f "../ansible.hosts.tmp" ]; then
		\cp ../ansible.hosts.tmp /etc/ansible/hosts
		rm -f ../ansible.hosts.tmp
	else
		echo "请将ansible.hosts.tpl拷贝为ansible.hosts.tmp并根据实际情况修改! "
		exit 1
	fi
	echo "##### config ansible hosts end #####"
}

main(){
	installAnsible
	configAnsible
}
main
