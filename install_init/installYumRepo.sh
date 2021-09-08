#!/bin/bash
# Author: jyliu
set -e

BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

# install  install-machine's yum repo
installMachineYumRepo(){
	echo "##### install install-machine's yum repo start #####"
	# 启动offline-yumrepo
	sh ../../offline-yumrepo/enable.sh
	systemctl restart offline-yumrepo
	echo "##### install install-machine's yum repo end #####"
}

main(){
	installMachineYumRepo
}
main
