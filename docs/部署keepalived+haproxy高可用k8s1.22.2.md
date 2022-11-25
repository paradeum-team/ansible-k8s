# 部署keepalived+haproxy高可用k8s1.22.2

## 主机规划

IP|主机名或用途
-----|-----
172.16.92.250|VIP
172.16.188.11|master1.solarfs.k8s
172.16.94.181|master2.solarfs.k8s
172.16.241.26|master3.solarfs.k8s
172.16.13.77|logging1.solarfs.k8s
172.16.36.25|logging2.solarfs.k8s
172.16.115.194|logging3.solarfs.k8s

信息|备注
-----|-----
系统版本|CentoOS 8.3
Docker 版本|20.10
K8s 版本|1.22.2
Pod 网段|10.128.0.0/16
Service 网段|10.96.0.0/12

## 下载 ansible-k8s

登录 master1 主机

```
yum install -y git epel-release
yum install -y ansible
mkdir -p /data
cd /data
git clone https://github.com/paradeum-team/ansible-k8s.git
```

## 修改 ansible 配置

```
cd /data/ansible-k8s/
cp ansible.hosts.ha.vip.tpl ansible.hosts.tmp
```


修改 `ansible.hosts.tmp` 如下

```
[k8sCluster:children]
masters
nodes
install
new_nodes

# Set variables common for all k8s-cluster hosts
[k8sCluster:vars]
# SSH user, this user should allow ssh based auth without requiring a password
ansible_ssh_user=root
#ansible_ssh_pass=xxxxxx
ansible_port=22

# If ansible_ssh_user is not root, ansible_become must be set to true
ansible_become=false

# 是否更新操作系统及内核
is_system_update=True

# 默认节点不是公网节点
public_network_node = False

# 是否开启 flannel
flannel_enable=True

# k8s 版本
k8s_version=1.22.2
# 定义外部镜像仓库
registry_domain=registry.hisun.netwarps.com
registry_repo="{{registry_domain}}"
kubeadm_registry_repo="registry.hisun.netwarps.com"
coredns_image_repo="{{registry_repo}}/coredns"
coredns_image_tag="1.8.4"
flannel_image_repo="{{registry_repo}}"
flannel_image_tag="v0.14.0"

# subnet
service_subnet=10.96.0.0/12
pod_subnet=10.128.0.0/16

# api server
master_vip="172.16.92.250"
master_vip_advertise_address="172.16.92.250"
node_domain=solarfs.k8s
install_domain=install.{{node_domain}}
api_server_domain="api-server.{{node_domain}}"
api_server_src_port="6443"
api_server_port="8443"
haproxy_image="{{registry_repo}}/library/haproxy:2.1.4"
# keepalived
keepalived_haproxy_enabled=True
keepalived_image="{{registry_repo}}/osixia/keepalived:2.0.17"
# keepalived router id , 不同集群 id 不同
keepalived_router_id=250
keepalived_auth_pass=solarfs{{keepalived_router_id}}

# open haproxy ingress tcp proxy
ingress_nodeport_http=32080
ingress_nodeport_https=32443

# helm
helm_binary_checksum=31960ff2f76a7379d9bac526ddf889fb79241191f1dbe2a24f7864ddcb3f6560
helm_binary_url=https://pnode.solarfs.io/dn/file/d5b5fd63f068c7a7e950afc840620baf/helm-v3.9.4-linux-amd64.tar.gz
#helm_binary_url=https://get.helm.sh/helm-v3.9.4-linux-amd64.tar.gz

[install]
master1.solarfs.k8s

[masters]
master1.solarfs.k8s ansible_host=172.16.188.11
master2.solarfs.k8s ansible_host=172.16.94.181
master3.solarfs.k8s ansible_host=172.16.241.26

[nodes]
logging1.solarfs.k8s ansible_host=172.16.13.77
logging2.solarfs.k8s ansible_host=172.16.36.25
logging3.solarfs.k8s ansible_host=172.16.115.194

[new_nodes]
#node3.solarfs.k8s ansible_host=x.x.x.x

```

## 修改 `config.cfg`

```
cp config.cfg.example config.cfg
```

修改 `config.cfg` 内容如下

```
#!/bin/bash
set -x

# 当前ansible-k8s目录所在路径,默认一般情况下不需要改动，如有变动请根据实际情况修改
BASE_DIR="/data/ansible-k8s"

# local network card
LOCAL_ENNAME=eth0 ## Need to check

# 是否线下安装
is_offline=False

# 主机环境实际使用的上游dns server，酌情修改,公司内部实际使用的dns服务ip地址
upstream_dns_ips="172.16.21.86 172.16.21.87 114.114.114.114"

# 是否安装时间同步服务(chronyd),True表示安装，False表示不安装，默认True，只有已经安装了 ntp 时间同步服务的情况下不安装;
chronyd_install="True"
# chronyd_install=True 时才生效,定义外部 ntp_server, ntp.cloud.aliyuncs.com 为阿里云内部 ntp 同步 server,  非阿里云主机访问可以改为 ntp.aliyun.com, 或自定义的 ntp server
ntp_server="ntp.aliyun.com"

export LOCAL_IP=`ip a show $LOCAL_ENNAME|awk '/inet.*brd.*'$LOCAL_ENNAME'/{print $2}'|awk -F "/" '{print $1}'`  # 无需改动
if [ -z "$LOCAL_IP" ];then
        echo "get $LOCAL_ENNAME ip error!" && exit 1
fi

# yum repo && config server
export CONFIGSERVER_IP="$LOCAL_IP"
export CONFIGSERVER_PORT="8081"


# 高可用部署开关,True为部署高可用版，False为单机版一般无需改动
if [ `$BASE_DIR/read-ansible-hosts.py -k masters|wc -l` -gt 1 ] ;then
	HA="True"
else
	HA="False"
fi
```

## 配置master1免密登录自己和其它主机

略

## 安装 k8s

所有主机初始化, 初始化完成后所有主机会重启

```
./base_init.sh
```

登录 master1 主机，安装 k8s

```
./install_k8s.sh
```

## 安装 ingress-nginx

参考：[使用helm在k8s1.22.2安装ingress-nginx](https://github.com/paradeum-team/operator-env/blob/main/ingress/%E4%BD%BF%E7%94%A8helm%E5%9C%A8k8s1.22.2%E5%AE%89%E8%A3%85ingress-nginx.md)
