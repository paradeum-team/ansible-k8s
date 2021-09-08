#!/bin/bash

set -e

BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

. ../config.cfg

HOSTS=OSEv3
if [ ! -z "$2" ];then
	HOSTS=$2
fi

# lock /etc/resolv.conf
lockResolv(){
        ansible $HOSTS -m shell -a "chattr +i /etc/resolv.conf"
}

# unlock /etc/resolv.conf
unlockResolv(){
        ansible $HOSTS -m shell -a "chattr -i /etc/resolv.conf"
}

is_lock=$1

if [ "x$is_lock" == "xtrue" ];then
	lockResolv	
elif [ "x$is_lock" == "xfalse" ];then
	unlockResolv
fi
