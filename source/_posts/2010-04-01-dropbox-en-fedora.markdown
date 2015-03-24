---
layout: post
title: Dropbox en Fedora
date: '2010-04-01T11:54:00.001+02:00'
author: Pablo
tags: fedora, dropbox
category: desktop
modified_time: '2011-05-09T21:39:53.954+02:00'
blogger_id: tag:blogger.com,1999:blog-4564313404841923839.post-7983751062601820085
blogger_orig_url: http://iranzop.blogspot.com/2010/04/dropbox-en-fedora.html
---

Para instalar dropbox en fedora, no es necesario realizar excesivos pasos:

1- Abrir una cuenta en
[Dropbox](https://www.dropbox.com/referrals/NTM4OTM3ODI5) (o si prefieres,
en una empresa alternativa como
[SpiderOak](https://spideroak.com/download/referral/dfba22f9764b55ab68427da014e9f0e5)
(O [Wuala](http://www.wuala.com/referral/FK4KF3PFHJAF64A74KMB) que ofrece
espacio adicional por compartir espacio en tu propio disco)

2- Instalar en nuestra fedora el paquete correspondiente para
[Nautilus](https://www.dropbox.com/downloading?os=lnx) (aunque ponga que es
para Fedora 10, funciona perfectamente en superiores (probado en 12 y 13))

3- Al volver a iniciar sesión (o la lanzar el programa), aparecerá un icono
en la bandeja de sistema y comenzará el proceso de configuración en el que
se asocia el 'escritorio' a la cuenta de dropbox que creamos anteriormente.

4- Durante el asistente, podremos escoger la ubicación de la carpeta que
empezará a sincronizarse, utilizando los 'emblemas' de Gnome para indicar el
estado de sincronización con 'la nube'.  Adicionalmente, en los menús
contextuales, podremos copiar un enlace público para compartir ese fichero
con otros usuarios sin necesidad de compartir una carpeta, o bien compartir
una carpeta entera y que se pueda colaborar en ella con un grupo de
personas.

5- Repitiendo los pasos 2 a 4 podremos ir enlazando otros pc's entre los que
se replicarán automáticamente los ficheros que compartamos.

6- SELinux: Si tienes problemas con SELinux, revisa la discusión en <http://forums.dropbox.com/topic.php?id=26808&amp;replies=24> en la que se apunta a que realices los siguientes pasos:

{% highlight bash %}
cd .drobpox-dist/
[.dropbox-dist]$ execstack -q _ctypes.so X _ctypes.so
[.dropbox-dist]$ execstack -c _ctypes.so
[.dropbox-dist]$ execstack -q _ctypes.so - _ctypes.so
[.dropbox-dist]$ getenforce
Enforcing

{% endhighlight %}

Y de esta forma, consigas que funcione dropbox con SELinux en modo enforcing.

7 - LANSync
Abre en tu cortafuegos los puertos 17500 por TCP y por UDP para que la funcionalidad de sincronización en la LAN funcione (permitiendo que los equipos con dropbox en la misma red sincronicen mucho más rápido entre ellos)
