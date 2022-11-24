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

# 默认节点是否公网节点
public_network_node = False

# 是否开启 flannel
flannel_enable=True

# api server 域名, 单master 写master ip, 多master 写vip
master_vip="172.16.195.211"
master_vip_advertise_address="x.x.x.x"
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
coredns_image_repo="docker.io/coredns"
coredns_image_tag="1.8.4"
flannel_image_repo="quay.io"
flannel_image_tag="v0.20.1"

# subnet
service_subnet=10.96.0.0/12
pod_subnet=10.128.0.0/16

# helm
helm_binary_md5=77b16cb0ebc6266ac98fc9f2285e361f
helm_binary_url=https://pnode.solarfs.io/dn/file/{{helm_binary_md5}}/helm-v3.7.1-linux-amd64.tar.gz

# os id, centos|ubuntu
OS_ID="centos"

[install]
master1.solarfs.k8s

[masters]
master1.solarfs.k8s ansible_host=172.16.195.211

[nodes]
infra1.solarfs.k8s ansible_host=172.16.3.85
node1.solarfs.k8s ansible_host=172.16.128.250

[new_nodes]
#node2.solarfs.k8s ansible_host=172.16.214.182 OS_ID="ubuntu"
