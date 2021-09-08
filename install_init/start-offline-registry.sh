#!/bin/bash
set -e

BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

. ../config.cfg

# start offline registry
startOfflineRegistry(){
	echo "##### start offline registry start #####"
	# 启动offline-registry
	sh ../../offline-registry/enable.sh
	echo "##### start offline registry end #####"
}

main(){
	startOfflineRegistry
	../check_count_tool.sh offline-registry-service ../services_check/offline-registry-health-check.sh
}
main
