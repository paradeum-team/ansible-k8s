#!/bin/bash
set -e

upstream_dns_ips=$@

if [ -z "$upstream_dns_ips" ];then
	echo "Usage: $0 <upstream_dns_ips>"
	exit 1
fi


mkdir -p /tmp/install_k8s/dnsmasq 
rm -f  /tmp/install_k8s/dnsmasq/upstream-dns.conf 
for ip in $upstream_dns_ips;do 
	echo server=$ip>>/tmp/install_k8s/dnsmasq/upstream-dns.conf ;  
done
