#!/bin/bash
# author ychen
# create:2018.2.23

set -e

BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

. ../config.cfg

healthCheck(){

	echo "##### start offline-registry health check #####"
	ADDR="$CONFIGSERVER_IP:5000"
	test "$(curl -k -s -o /dev/null -w "%{http_code}" https://$ADDR/v2/)" == "200"
	echo "##### finish offline-registry health check #####"

}


main(){
	healthCheck
}

main
