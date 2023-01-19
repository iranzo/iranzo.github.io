---
title: Using Kcli to prepare for Open Cluster Management testing
date: 2022-12-23T14:04:45.111Z
tags:
  - kcli
  - Kubernetes
  - OpenShift
  - Open Cluster Management
  - ACM
  - Advanced Cluster Management
categories:
  - tech
modified: 2023-01-19T09:58:39.829Z
---

[Kcli](https://github.com/karmab/Kcli) allows to quickly interact with different virtualization platforms to build machines with some specific configurations, and via the use of `plans` it allows to automate most of the setup required to have an environment ready.

In our case, let's setup an environment to practice with [Open Cluster Management](https://open-cluster-management.io/getting-started/quick-start/) but instead of using kind clusters, let's use VM's.

{{<note>}}
We'll require to setup an `openshift_pull.json` file for Kcli to consume when accessing the required resources for this to work. That file, contains the credentials for accessing several container registries used for the deployment.
{{</note>}}

{{<tip>}}
The script described below can be downloaded from [kcli.sh](kcli.sh).
{{</tip>}}

Let's first cover the prerequisites for the different pieces we're going to use:

```sh
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
```

At this point we've our system ready to use go, and some other utilities available.

Let's now continue with cluster adm and some other utilities like kubectl:

```sh
# Install clusteradm
curl -L https://raw.githubusercontent.com/open-cluster-management-io/clusteradm/main/install.sh | bash

# Install kubectl
curl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl >/usr/bin/kubectl
chmod +x /usr/bin/kubectl

```

Now, let's go to install Kcli requirements from its documentation:

```sh
# Prepare Kcli installation

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
```

At this step, we should make sure that our host, has the default `virt-pool` configured so that we can continue with the creation of the cluster.

For doing so, we'll use the following plan, defined with `Jinja` templating.

As you can see, we first define some parameters for the whole cluster, specially the number of machines to create, the Kcli network to use, addressing, etc.

```jinja
parameters:
  cluster: cluster
  domain: karmalabs.corp
  number: 2
  network: default
  cidr: 192.168.122.0/24

{{ network }}:
  type: network
  cidr: {{ cidr }}

```

Then, we define the network and define the first stanza for the hub cluster.

```jinja
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
```

And now, we'll iterate to generate the stanzas for the spoke clusters:

```jinja
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
```

This definition uses a new feature provided by Kcli which allows to start the deployment in parallel, so let's get ready for it:

```sh
# Download openshift-install to avoid bug when downloading in parallel during plan creation
for command in oc openshift-install; do
  kcli download ${command}
  mv ${command} /usr/bin/
done

# Create the plan
kcli create plan -f kcli-plan-hub-spoke.yml
```

Here, Kcli will have created the different VM's, `kubeconfig` files, etc to get access to the environment, so that we can continue with the Open Cluster Management part:

```sh
# Prepare clusteradm on HUB
export KUBECONFIG=/root/.kcli/clusters/hub/auth/kubeconfig
clusteradm init --wait
kubectl -n open-cluster-management get

# Add the Policy framework
clusteradm install hub-addon --names governance-policy-framework

# Get values we'll need for adding spokes
apiserver=$(clusteradm get token | grep -v token= | tr " " "\n" | grep apiserver -A1 | tail -1)

MAXSPOKE=5

# Join the spokes to the cluster
for spoke in $(seq 1 ${MAXSPOKE}); do
  export KUBECONFIG=/root/.kcli/clusters/hub/auth/kubeconfig
  token=$(clusteradm get token } | grep token= | cut -d "=" -f 2-)
  export KUBECONFIG=/root/.kcli/clusters/cluster${spoke}/auth/kubeconfig
  clusteradm join --hub-token ${token} --hub-apiserver ${apiserver} --wait --cluster-name "cluster${spoke}" # --force-internal-endpoint-lookup
done
```

Each host (spoke) will connect to the hub and reach it to request a signed certificate and being accepted as spoke, we can perform some diagnosis when checking the klusterlet status:

```sh
# Check clusterlet status
for spoke in $(seq 1 ${MAXSPOKE}); do
  export KUBECONFIG=/root/.kcli/clusters/cluster${spoke}/auth/kubeconfig
  kubectl get klusterlet
done
```

And the pending Certificate Signing Requests (CSRs):

```sh
# Check pending CSR
export KUBECONFIG=/root/.kcli/clusters/hub/auth/kubeconfig
kubectl get csr
```

Last step, is to accept, from the HUB, all the requests received from the spoke clusters.

```sh
# Accept joins from HUB
for spoke in $(seq 1 ${MAXSPOKE}); do
  export KUBECONFIG=/root/.kcli/clusters/hub/auth/kubeconfig
  clusteradm accept --clusters cluster${spoke}
done
```

With this, we've an environment with several spoke clusters and one hub, that we can use to test the scenarios described at <https://open-cluster-management.io/scenarios/>.

Enjoy!

Pablo
