[k8sCluster:children]
masters
nodes
install
new_nodes

# Set variables common for all k8s-cluster hosts
[k8sCluster:vars]
# SSH user, this user should allow ssh based auth without requiring a password
ansible_ssh_user=root
#ansible_ssh_pass=xxxxxxxxxxxx
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
# cluster dns, default docker0 ip
local_dns_address="172.17.0.1"

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
