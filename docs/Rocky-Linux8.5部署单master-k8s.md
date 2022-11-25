# Rocky Linux部署单master k8s

## 主机规划

| IP           | 主机名或用途        |
| ------------ | ------------------- |
| 172.30.1.198 | master1.solarfs.k8s |
| 172.30.1.199 | infra1.solarfs.k8s  |

| 信息         | 备注            |
| ------------ | --------------- |
| 系统版本     | Rocky Linux 8.5 |
| Docker 版本  | 20.10           |
| K8s 版本     | 1.22.2          |
| Pod 网段     | 10.128.0.0/16   |
| Service 网段 | 10.96.0.0/12    |

## 下载 ansible-k8s

登录master1 主机

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
cp ansible.hosts.tpl ansible.hosts.tmp
```

修改 `ansible.hosts.tmp` 如下

```ini
[k8sCluster:children]
masters
nodes
install
new_nodes

# Set variables common for all k8s-cluster hosts
[k8sCluster:vars]
# SSH user, this user should allow ssh based auth without requiring a password
ansible_ssh_user=root
#ansible_ssh_pass=xxxxx
ansible_port=22

# If ansible_ssh_user is not root, ansible_become must be set to true
ansible_become=false

# 是否更新操作系统及内核
is_system_update=True

# 默认节点是否公网节点
public_network_node = False

# 是否开启 flannel
flannel_enable=True

# api server 域名, 单master 写master ip, 多master 写vip
master_vip="172.30.1.251"
master_vip_advertise_address="172.30.1.251"
node_domain=solarfs.k8s
install_domain=install.{{node_domain}}
api_server_domain="api-server.{{node_domain}}"
api_server_port="6443"

# k8s 版本
k8s_version=1.22.16
# 定义外部镜像仓库
registry_domain=registry.hisun.netwarps.com
registry_repo="{{registry_domain}}"
kubeadm_registry_repo="{{registry_domain}}"
coredns_image_repo="registry.hisun.netwarps.com/coredns"
coredns_image_tag="1.8.4"
flannel_image_repo="registry.hisun.netwarps.com"
flannel_image_tag="v0.20.1"

# subnet
service_subnet=10.96.0.0/12
pod_subnet=10.128.0.0/16

# helm
helm_binary_checksum=31960ff2f76a7379d9bac526ddf889fb79241191f1dbe2a24f7864ddcb3f6560
helm_binary_url=https://pnode.solarfs.io/dn/file/d5b5fd63f068c7a7e950afc840620baf/helm-v3.9.4-linux-amd64.tar.gz
#helm_binary_url=https://get.helm.sh/helm-v3.9.4-linux-amd64.tar.gz

# os id, centos|ubuntu
OS_ID="centos"

[install]
master1.solarfs.k8s

[masters]
master1.solarfs.k8s ansible_host=172.30.1.251

[nodes]
node1.solarfs.k8s ansible_host=172.30.1.252

[new_nodes]
#node2.solarfs.k8s ansible_host=172.16.214.182 OS_ID="ubuntu"
```

## 修改 config 配置

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
upstream_dns_ips="100.100.2.136 100.100.2.138 114.114.114.114"

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

参考：[使用helm在k8s1.22.2安装ingress-nginx](https://github.com/paradeum-team/operator-env/blob/main/ingress/使用helm在k8s1.22.2安装ingress-nginx.md)