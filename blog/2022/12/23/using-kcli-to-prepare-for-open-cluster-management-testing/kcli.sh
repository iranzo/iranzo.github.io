# Install tmux
dnf -y install tmux

# Upgrade packages
dnf -y upgrade

# Enable epel
dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

# Install a proper editor
dnf -y install joe

# Install container engine
dnf -y install podman

# Install go
dnf -y install go

# Extend path
echo 'PATH=$PATH:~/go/bin' >~/.bashrc

# Install kind
go install sigs.k8s.io/kind@v0.17

# Install clusteradm
curl -L https://raw.githubusercontent.com/open-cluster-management-io/clusteradm/main/install.sh | bash

# Install kubectl
curl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl >/usr/bin/kubectl
chmod +x /usr/bin/kubectl

# Prepare kcli installation

sudo yum -y install libvirt libvirt-daemon-driver-qemu qemu-kvm
sudo usermod -aG qemu,libvirt $(id -un)
sudo newgrp libvirt
sudo systemctl enable --now libvirtd

# Optional if using docker daemon
sudo groupadd docker
sudo usermod -aG docker $(id -un)
sudo systemctl restart docker

sudo dnf -y copr enable karmab/kcli
sudo dnf -y install kcli

# Create ssh key if missing
[ -f /root/.ssh/id_rsa ] || ssh-keygen -P '' -f /root/.ssh/id_rsa

# Enable libvirt default pool if it's not enabled
virsh pool-define-as default dir --target "/var/lib/libvirt/images"
virsh pool-build default
virsh pool-start default
virsh pool-autostart default

# Prepare Hub Creation

# Download openshift-install to avoid bug when downloading in parallel during plan creation
for command in oc openshift-install; do
    kcli download ${command}
    mv ${command} /usr/bin/
done

# Create plan definition
cat <<EOF >kcli-plan-hub-spoke.yml
parameters:
  cluster: cluster
  domain: karmalabs.corp
  number: 2
  network: default
  cidr: 192.168.122.0/24

{{ network }}:
  type: network
  cidr: {{ cidr }}


{% set num = 0 %}

{% set api_ip = cidr|network_ip(200 + num ) %}

{% set cluster = 'hub' %}

hub:
  type: cluster
  kubetype: openshift
  domain: {{ domain }}
  ctlplanes: 1
  api_ip: {{ api_ip }}
  numcpus: 16
  memory: 32768

api-hub:
 type: dns
 net: {{ network }}
 ip: {{ api_ip }}
 alias:
 - api.{{ cluster }}.{{ domain }}
 - api-int.{{ cluster }}.{{ domain }}

{% if num == 0 %}
apps-hub:
 type: dns
 net: {{ network }}
 ip: {{ api_ip }}
 alias:
 - console-openshift-console.apps.{{ cluster }}.{{ domain }}
 - oauth-openshift.apps.{{ cluster }}.{{ domain }}
 - prometheus-k8s-openshift-monitoring.apps.{{ cluster }}.{{ domain }}
 - canary-openshift-ingress-canary.apps.{{ cluster }}.{{ domain }}
 - multicloud-console.apps.{{ cluster }}.{{ domain }}
{% endif %}


{% for num in range(1, number) %}
{% set api_ip = cidr|network_ip(200 + num ) %}
{% set cluster = "cluster" %}

cluster{{ num }}:
  type: cluster
  kubetype: openshift
  domain: {{ domain }}
  ctlplanes: 1
  api_ip: {{ api_ip }}
  numcpus: 16
  memory: 32768

api-cluster{{ num}}:
 type: dns
 net: {{ network }}
 ip: {{ api_ip }}
 alias:
 - api.{{ cluster }}{{ num }}.{{ domain }}
 - api-int.{{ cluster }}{{ num }}.{{ domain }}

{% endfor %}

EOF

# Create the plan
kcli create plan -f kcli-plan-hub-spoke.yml kmm --force

# Prepare clusteradm on HUB
export KUBECONFIG=/root/.kcli/clusters/hub/auth/kubeconfig
clusteradm init --wait
kubectl -n open-cluster-management get pod

# Add the Policy framework
clusteradm install hub-addon --names governance-policy-framework

# Get values we'll need for adding spokes
apiserver=$(clusteradm get token | grep -v token= | tr " " "\n" | grep apiserver -A1 | tail -1)

MAXSPOKE=2

# Join the spokes to the cluster
for spoke in $(seq 1 ${MAXSPOKE}); do
    export KUBECONFIG=/root/.kcli/clusters/hub/auth/kubeconfig
    token=$(clusteradm get token } | grep token= | cut -d "=" -f 2-)
    export KUBECONFIG=/root/.kcli/clusters/cluster${spoke}/auth/kubeconfig
    clusteradm join --hub-token ${token} --hub-apiserver ${apiserver} --wait --cluster-name "cluster${spoke}" # --force-internal-endpoint-lookup
done

# Check clusterlet status
for spoke in $(seq 1 ${MAXSPOKE}); do
    export KUBECONFIG=/root/.kcli/clusters/cluster${spoke}/auth/kubeconfig
    kubectl get klusterlet
done

# Check CSR pending
export KUBECONFIG=/root/.kcli/clusters/hub/auth/kubeconfig
kubectl get csr

# Accept joins from HUB
for spoke in $(seq 1 ${MAXSPOKE}); do
    export KUBECONFIG=/root/.kcli/clusters/hub/auth/kubeconfig
    clusteradm accept --clusters cluster${spoke}
done

# Watch progress
# HUB
export KUBECONFIG=/root/.kcli/clusters/hub/auth/kubeconfig
watch -d 'oc get clusterversion; oc get nodes; oc get co'

# SPOKE
export KUBECONFIG=/root/.kcli/clusters/cluster1/auth/kubeconfig
watch -d 'oc get clusterversion; oc get nodes; oc get co'
