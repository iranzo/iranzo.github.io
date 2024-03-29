---
author: Pablo Iranzo Gómez
categories:
  - tech
  - RHEL9
  - libvirt
  - virtualization
  - Tips
title: Enable Libvirt rw socket on RHEL9
tags:
  - RHEL9
  - virtualization
  - FOSS
date: 2023-01-12T14:32:50.658Z
lastmod: 2024-01-16T16:33:53.955Z
---

RHEL9 by default uses read-only socket which is not usable by some tools like [Kcli]({{< relref "/tags/kcli" >}})... to enable it use:

```sh
systemctl enable --now libvirtd.socket libvirtd-ro.socket
systemctl stop libvirtd.service
systemctl enable --now virtproxyd.socket virtproxyd-ro.socket
systemctl stop virtproxyd.service
```
