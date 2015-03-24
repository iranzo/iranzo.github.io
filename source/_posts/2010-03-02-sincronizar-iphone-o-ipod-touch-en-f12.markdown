---
layout: post
title: Sincronizar 'basicamente' iPhone o iPod Touch en Fedora 12
date: '2010-03-02T14:43:00.001+01:00'
author: Pablo
tags: fedora
category: desktop
modified_time: '2011-01-26T08:00:30.406+01:00'
blogger_id: tag:blogger.com,1999:blog-4564313404841923839.post-1811300258953715112
blogger_orig_url: http://iranzop.blogspot.com/2010/03/sincronizar-iphone-o-ipod-touch-en-f12.html
---

Las nuevas versiones no están todavía soportadas en F12, así que tendremos que utilizar las de rawhide.

{% highlight bash %}
yum --enablerepo=rawhide upgrade ifuse gtkpod libgpod libimobiledevice usbmuxd
{% endhighlight %}

Una vez instalados, podemos empezar a utilizarlo ejecutando como root:

{% highlight bash %}
mkdir -p /mnt/ipod
chmod 777 /mnt/ipod
usbmuxd -v -f
{% endhighlight %}

Y como nuestro usuario:

{% highlight bash %}
ifuse /mnt/ipod
{% endhighlight %}

A partir de ahí podrás, si todo ha ido bien, utilizar `gtkpod` para gestionar la biblioteca de tu dispositivo.
