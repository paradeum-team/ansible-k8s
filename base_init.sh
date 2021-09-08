#!/bin/bash
set -e

BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

. ./config.cfg

base_init(){
	# set date time
	./install_init/setTime.sh
	# install install-machine's yum repo
        if [ "$is_offline" == "True" ];then
		./install_init/installYumRepo.sh
	fi
	# init iptables
	./install_init/init_iptables.sh
	# install ansible
	./install_init/installAnsible.sh
	# all nodes host init
	./host_init.sh
}

main(){
	base_init
}
main
