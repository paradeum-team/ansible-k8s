[k8sCluster:children]
masters
nodes
install
new_nodes

# Set variables common for all k8s-cluster hosts
[k8sCluster:vars]
# SSH user, this user should allow ssh based auth without requiring a password
ansible_ssh_user=root
ansible_port=22

# If ansible_ssh_user is not root, ansible_become must be set to true
ansible_become=false

# 是否更新操作系统及内核
is_system_update=True

# 默认节点不是公网节点
public_network_node = True

# 是否开启 flannel
flannel_enable=True

# api server 域名
master_vip="172.26.181.239"
master_vip_advertise_address="x.x.x.x"
node_domain=solarfs.k8s
install_domain=install.{{node_domain}}
api_server_domain="api-server.{{node_domain}}"
api_server_port="6443"

# k8s 版本
k8s_version=1.22.16
# 定义外部镜像仓库
registry_domain=docker.io
registry_repo="{{registry_domain}}"
kubeadm_registry_repo="registry.cn-hangzhou.aliyuncs.com"
coredns_image_repo="{{registry_repo}}/coredns"
coredns_image_tag="1.8.4"
flannel_image_repo="quay.io"
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
master1.solarfs.k8s ansible_host=172.26.181.236 advertise_address="x.x.x.x"
master2.solarfs.k8s ansible_host=172.26.181.237 advertise_address="x.x.x.x"
master3.solarfs.k8s ansible_host=172.26.181.238 advertise_address="x.x.x.x"

[nodes]
node1.solarfs.k8s ansible_host=172.26.181.240 advertise_address="x.x.x.x"
node2.solarfs.k8s ansible_host=x.x.x.x advertise_address="x.x.x.x"

[new_nodes]
node3.solarfs.k8s ansible_host=x.x.x.x advertise_address="x.x.x.x"
