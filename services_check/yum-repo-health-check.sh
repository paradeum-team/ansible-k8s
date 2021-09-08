#!/bin/bash
# author ychen
# create:2018.2.23

set -e

BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

. ../config.cfg

healthCheck(){

	echo "##### start yum-repo health check #####"
	ADDR="$CONFIGSERVER_IP:$CONFIGSERVER_PORT"
	test "$(curl -s -o /dev/null -w "%{http_code}" http://$ADDR)" == "200"
	echo "##### finish yum-repo health check #####"

}


main(){
	healthCheck
}

main
