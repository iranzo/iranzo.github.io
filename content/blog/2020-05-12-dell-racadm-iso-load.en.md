---
author: Pablo Iranzo Gómez
title: Dell racadm remote ISO load
tags:
  - Dell
  - firmware
  - Linux
  - FOSS
  - racadm
  - dit
  - tips
layout: post
date: "2020-05-12 13:30:24 +0200"
category: tech
lang: en
modified: "2022-01-16T21:11:30.950Z"
---

In order to test IPv6 deployment on Dell hardware I was in need to patch the servers to ensure that UEFI boot mode is in use.

Normally I would had use the DSU that runs from within Linux, but as the servers are part of an OpenShift installation (using [baremetal-deploy](https://github.com/openshift-kni/baremetal-deploy)) and using CoreOS as the underlying system I wanted to load ISO from HTTP server on the `deployhost` (running RHEL).

The command is not that hard, let's first define some variables:

```bash
IDRACIP=1.1.1.1
IDRACUSER=root
IDRACPASS=mysecurepass
ISOURL="http://10.10.10.10/my.iso"
```

Now, let's attach the ISO file:

```bash
racadm  -r ${IDRACIP}  -u ${IDRACUSER} -p ${IDRACPASS} remoteimage -c -l ${ISOURL}
```

Once done, we should check status with:

```bash
racadm  -r ${IDRACIP}  -u ${IDRACUSER} -p ${IDRACPASS} remoteimage -s
```

Once finished, let's disconnect:

```bash
racadm  -r ${IDRACIP}  -u ${IDRACUSER} -p ${IDRACPASS} remoteimage -d
```

And then, verify the status again:

```bash
racadm  -r ${IDRACIP}  -u ${IDRACUSER} -p ${IDRACPASS} remoteimage -s
```

Hope It's useful for you!
