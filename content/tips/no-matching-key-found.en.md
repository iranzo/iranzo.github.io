---
author: Pablo Iranzo Gómez
title: No matching key found
layout: post
date: 2023-08-25T09:42:48.885Z
categories:
  - tech
  - Tips
tags:
  - Linux
  - FOSS
  - CentOS
  - RHEL
  - Red Hat Enterprise Linux
  - AlmaLinux
  - Oracle Linux
  - Rocky Linux
lastmod: 2023-08-25T09:55:20.348Z
---

As you might have experienced... using a recent system to connect to a legacy one could be complicated as some insecure protocols have been disabled, with a message like:

```console
Unable to negotiate with 192.168.2.82 port 22: no matching host key type found. Their offer: ssh-rsa,ssh-dss
```

Create an entry like this in your `.ssh/config` file, so that insecure methods can be used to connect to a specific host:

```console
Host 192.168.2.82
	HostKeyAlgorithms=+ssh-rsa
	KexAlgorithms=+diffie-hellman-group1-sha1
  PubkeyAcceptedKeyTypes=+ssh-rsa
	User root
```

or alternatively on the command line:

```sh
ssh -oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa root@192.168.2.8
```

```

```
