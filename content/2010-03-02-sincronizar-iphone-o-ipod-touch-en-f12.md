---
layout: post
title: Sincronizar 'basicamente' iPhone o iPod Touch en Fedora 12
date: '2010-03-02T14:43:00.001+01:00'
author: Pablo Iranzo Gómez
tags: fedora, foss
lang: es
modified_time: '2011-01-26T08:00:30.406+01:00'
blogger_id: tag:blogger.com,1999:blog-4564313404841923839.post-1811300258953715112
blogger_orig_url: http://iranzop.blogspot.com/2010/03/sincronizar-iphone-o-ipod-touch-en-f12.html
comments: true
---
Las nuevas versiones no están todavía soportadas en Fedora 12, así que tendremos que utilizar las de rawhide.

~~~bash
#!bash
yum --enablerepo=rawhide upgrade ifuse gtkpod libgpod libimobiledevice usbmuxd
~~~

Una vez instalados, podemos empezar a utilizarlo ejecutando como root:

~~~bash
#!bash
mkdir -p /mnt/ipod
chmod 777 /mnt/ipod
usbmuxd -v -f
~~~

Y como nuestro usuario:

~~~bash
#!bash
ifuse /mnt/ipod
~~~

A partir de ahí podrás, si todo ha ido bien, utilizar `gtkpod` para gestionar la biblioteca de tu dispositivo.
