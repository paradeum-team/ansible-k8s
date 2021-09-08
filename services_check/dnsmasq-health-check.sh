#!/bin/bash
set -e

BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

. ../config.cfg

echo "##### dnsmasq heath check start #####"
systemctl is-active dnsmasq
netstat -lndp|grep dnsmasq

ansible OSEv3 -m shell -a "ping -c 2 {{install_domain}}"

echo "##### dnsmasq heath check end #####"
