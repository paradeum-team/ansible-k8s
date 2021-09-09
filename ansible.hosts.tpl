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
master_vip="172.26.117.104"
master_vip_advertise_address="8.142.71.35"
node_domain=solarfs.k8s
install_domain=install.{{node_domain}}
api_server_domain="api-server.{{node_domain}}"
api_server_port="6443"

# k8s 版本
k8s_version=1.21.6
# 定义外部镜像仓库
registry_domain=registry.hisun.netwarps.com
registry_repo="{{registry_domain}}" 
kubeadm_registry_repo="registry.cn-hangzhou.aliyuncs.com"
coredns_image_repo="docker.io/coredns"
coredns_image_tag="1.8.4"
flannel_image_repo="quay.io"
flannel_image_tag="v0.14.0"

# subnet
service_subnet=10.96.0.0/12
pod_subnet=10.128.0.0/16

# helm
helm_binary_md5=24b16800f8c7f44b5dd128e3355ecf1b
helm_binary_url=https://pnode.solarfs.io/dn/file/{{helm_binary_md5}}/helm-v3.6.3-linux-amd64.tar.gz

[install]
master1.solarfs.k8s

[masters]
master1.solarfs.k8s ansible_host=172.26.117.104 advertise_address="8.142.71.35"

[nodes]
node1.solarfs.k8s ansible_host=8.142.71.142 advertise_address="8.142.71.142"

[new_nodes]
