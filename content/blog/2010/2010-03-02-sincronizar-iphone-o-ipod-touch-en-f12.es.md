---
layout: post
title: Sincronizar 'basicamente' iPhone o iPod Touch en Fedora 12
date: 2010-03-02 14:43:00 +0100
author: Pablo Iranzo Gómez
tags:
  - fedora
  - foss
  - iPod
  - iPhone
lang: es
modified: 2023-04-17T21:48:45.536Z
categories:
  - FOSS
  - Fedora
---

Las nuevas versiones no están todavía soportadas en Fedora 12, así que tendremos que utilizar las de rawhide.

```bash
#!bash
yum --enablerepo=rawhide upgrade ifuse gtkpod libgpod libimobiledevice usbmuxd
```

Una vez instalados, podemos empezar a utilizarlo ejecutando como root:

```bash
#!bash
mkdir -p /mnt/ipod
chmod 777 /mnt/ipod
usbmuxd -v -f
```

Y como nuestro usuario:

```bash
#!bash
ifuse /mnt/ipod
```

A partir de ahí podrás, si todo ha ido bien, utilizar `gtkpod` para gestionar la biblioteca de tu dispositivo.
{{<disfruta>}}
