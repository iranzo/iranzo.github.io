---
author: Pablo Iranzo Gómez
categories:
  - tech
  - Tips
title: Upgrade Debian from buster to bullseye
tags:
  - Debian
date: 2023-07-22T13:22:08.502Z
lastmod: 2023-08-25T09:51:52.510Z
---

I had two Raspberry Pi systems running Raspbian and they were failing to find updates for newer packages.

As Debian `stable` was upgraded too, moving from `buster` to `bullseye` the packages failed to get the newer ones.

{{<warning>}}
Beware as this procedure might upgrade the system but might no render a bootable Raspberry Pi
{{</warning>}}

A way to fix it is, to first, change references, if any, to the old codename version by running:

```sh
sed -i 's/buster/bullseye/g' /etc/apt/sources.list
sed -i 's/buster/bullseye/g' /etc/apt/sources.list.d/raspi.list
```

And then, accept the updated new files for the new one:

```sh
apt-get update --allow-releaseinfo-change
```

Finally, we can perform the upgrade by first, installing some dependencies that will be required:

```sh
 apt update
 apt install libgcc-8-dev gcc-8-base
 apt full-upgrade
```

With this, we get the new repository metadata, install the new required dependencies and perform the upgrade itself.
