#!/bin/bash
set -e

BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

. ../config.cfg

# 禁用firewalld,保存现有iptables规则
init_iptables(){
	echo "##### disable firewalld start #####"
	systemctl disable firewalld.service --now || echo
	iptables -F
	echo "##### disable firewalld end #####"

}

main(){
	init_iptables
}
main
