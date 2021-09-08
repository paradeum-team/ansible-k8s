#!/bin/bash
set -e

chronyc sourcestats
chronyc tracking
stratum=`chronyc tracking|grep '^Stratum'|awk '{print $3}'`

if [ "x$stratum" == "x0" ] ;then
	echo "chrony sync error" && exit 1
fi
