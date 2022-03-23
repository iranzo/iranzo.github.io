---
author: Pablo Iranzo Gómez
title: Configuring OpenShift with self-contained NTP
tags:
  - dit
  - foss
  - OpenShift
  - NTP
  - chrony
  - Kubernetes
  - tips
layout: post
date: 2020-12-07 14:10:34 +0200
category: tech
lang: en
modified: 2022-03-23T10:00:46.421Z
---

## Introduction

In a regular OpenShift environment, NTP server is more less like this:

{% graphviz
    dot {
      digraph connected {
          // title
          labelloc="t";
          label="Connected Cluster";
          node [shape = circle];
          { rank = same; "External NTP Server";}
          { rank = same; "Master 1"; "Master 2"; "Master 3"}
          { rank = same; "Worker 1"; "Worker 2"; "Worker 3"}
          "Master 1" -> "External NTP Server" [color=red]
          "Master 2" -> "External NTP Server"[color=red]
          "Master 3" -> "External NTP Server"[color=red]
          "Worker 1" -> "External NTP Server"[color=red]
          "Worker 2" -> "External NTP Server"[color=red]
          "Worker 3" -> "External NTP Server"[color=red]
    }
  }
%}

In a self-contained cluster with no connection to external networks NTP server is not reachable, but a reachable NTP server is required for proper cluster synchronization.
Cluster does use SSL certificates that require validation and might fail if the dates between the systems are not in sync or at least pretty close in time.

{% graphviz
dot {
digraph disconnected {
// title
labelloc="t";
label="Disconnected Cluster";
node [shape = circle];
{ rank = same; "Master 1"; "Master 2"; "Master 3"}
{ rank = same; "Worker 1"; "Worker 2"; "Worker 3"}
"Master 1" -> "Master 2" [color="red"]
"Master 1" -> "Master 3" [color="green"]
"Master 2" -> "Master 1" [color="purple"]
"Master 2" -> "Master 3"[color="green"]
"Master 3" -> "Master 1"[color="purple"]
"Master 3" -> "Master 2"[color="red"]
"Worker 1" -> "Master 1" [color="purple"]
"Worker 1" -> "Master 2" [color="red"]
"Worker 1" -> "Master 3" [color="green"]
"Worker 2" -> "Master 1" [color="purple"]
"Worker 2" -> "Master 2" [color="red"]
"Worker 2" -> "Master 3" [color="green"]
"Worker 3" -> "Master 1" [color="purple"]
"Worker 3" -> "Master 2" [color="red"]
"Worker 3" -> "Master 3" [color="green"]
}
}

%}

We've several components already available in our OpenShift cluster that are very useful:

- `MCO` allows to define configuration to be applied by role, etc to the nodes
- `chrony` is the client/server installed in Red Hat CoreOS images for connecting to an external NTP Server
- `chrony` is already being used and configured via `MachineConfigs` to point to the configured NTP servers.

Via a `MCO` change with a higher number than the prior ones, we can override the `chrony.conf` file by role, so that masters can set up required steps to serve time to other machines in the network even with external access to upstream servers or local GPS devices.

Workers can point to the masters so that those can be in sync via another file or via setting the proper `install-config.yaml` settings at install time.

There are some risks without a proper time sync:

- Systems might be not synced with real clock at all because of no external NTP access and no local time generator attached (like a GPS device).
- Users might forget to define proper BIOS time on all the systems prior to installation.

In regards to system supportability, as applying MCO changes to the cluster and configuring `chrony.conf` is documented already it should not have a heavy impact on the cluster supportability (check references).

## Implementation

First we need an available cluster installed, and remember:

- Define proper clock/date in each system's BIOS settings or installation will fail.

In order to configure the `ntp server`, we'll make use of the `master` servers, but we also need to deal with:

> To allow multiple servers in the network to use the same local configuration and to be synchronized to one another, without confusing clients that poll more than one server, use the orphan option of the local directive which enables the orphan mode. Each server needs to be configured to poll all other servers with local. This ensures that only the server with the smallest reference ID has the local reference active and other servers are synchronized to it. When the server fails, another one will take over.

In order to do so, define a sample `chrony.conf` file:

```conf
# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (https://www.pool.ntp.org/join.html).

# This file is managed by the machine config operator
server master-0.cloud iburst
server master-1.cloud iburst
server master-2.cloud iburst

stratumweight 0
driftfile /var/lib/chrony/drift
rtcsync
makestep 10 3
bindcmdaddress 127.0.0.1
bindcmdaddress ::1
keyfile /etc/chrony.keys
commandkey 1
generatecommandkey
noclientlog
logchange 0.5
logdir /var/log/chrony

# Serve as local NTP server for all clients even if we're not in sync with upstream:

# Allow NTP client access from local network.
allow all
# Serve time even if not synchronized to a time source.
local stratum 3 orphan
```

This file is similar to the standard one but with the added directives at the end to allow all clients to sync time against this and set the `local stratum` to level `3`, so that others can sync from this server.

Additionally the `orphan` option does the following:

> This option enables a special `orphan` mode, where sources with stratum equal to the local stratum are assumed to not serve real time. They are ignored unless no other source is selectable and their reference IDs are smaller than the local reference ID.

> This allows multiple servers in the network to use the same local configuration and to be synchronised to one another, without confusing clients that poll more than one server. Each server needs to be configured to poll all other servers with the local directive. This ensures only the server with the smallest reference ID has the local reference active and others are synchronised to it. When that server fails, another will take over.

In the case of the `worker` nodes, we just point to the `master` servers in our cluster via a sample chrony.conf file:

```conf
# This file is managed by the machine config operator
server master-0.cloud iburst
server master-1.cloud iburst
server master-2.cloud iburst

stratumweight 0
driftfile /var/lib/chrony/drift
rtcsync
makestep 10 3
bindcmdaddress 127.0.0.1
bindcmdaddress ::1
keyfile /etc/chrony.keys
commandkey 1
generatecommandkey
noclientlog
logchange 0.5
logdir /var/log/chrony
```

## Applying the configuration changes

We can later configure prior `chrony.conf` via a yaml applied to our cluster.

For the master nodes:

```yaml
# This example MachineConfig replaces /etc/chrony.conf
apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig
metadata:
  labels:
    machineconfiguration.openshift.io/role: master
  name: 99-master-etc-chrony-conf-override-to-server
spec:
  config:
    ignition:
      version: 2.2.0
    storage:
      files:
        - contents:
            source: data:text/plain;charset=utf-8;base64,BASE64ENCODEDCONFIGFILE
          filesystem: root
          mode: 0644
          path: /etc/chrony.conf
```

And then apply it:

```sh
[user@myhost ~]$ oc apply -f ntp-server.yaml
machineconfig.machineconfiguration.openshift.io/99-master-etc-chrony-conf-override-for-server created
```

And for the workers:

```yaml
# This example MachineConfig replaces /etc/chrony.conf
apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig
metadata:
  labels:
    machineconfiguration.openshift.io/role: worker
  name: 99-master-etc-chrony-conf-override-for-worker
spec:
  config:
    ignition:
      version: 2.2.0
    storage:
      files:
        - contents:
            source: data:text/plain;charset=utf-8;base64,BASE64ENCODEDCONFIGFILE
          filesystem: root
          mode: 0644
          path: /etc/chrony.conf
```

And apply in a similar way to master:

```sh
[user@myhost ~]$ oc apply -f ntp-client.yaml
machineconfig.machineconfiguration.openshift.io/99-master-etc-chrony-conf-override-for-worker created

```

## Validating

Once the above (or equivalent) file is applied for both master and workers, we can execute `oc describe machineconfigpool` to check the status of the applied overrides.

And for final validation, checking:

- `cat /etc/chrony.conf` on the nodes to validate the override we applied.
- `chronyc sources` will list the defined `clock` sources for each system

## References

- Setup chrony on an isolated network: [Red Hat Enterprise Linux Documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-configuring_ntp_using_the_chrony_suite#sect-Setting_up_chrony_for_a_system_in_an_isolated_network)
- [Customizing special chrony configuration](https://docs.openshift.com/container-platform/4.6/installing/install_config/installing-customizing.html#installation-special-config-crony_installing-customizing)
- [How to set up a Network Time Protocol (NTP) Server on a LAN with no Internet access?](https://access.redhat.com/solutions/8778)
