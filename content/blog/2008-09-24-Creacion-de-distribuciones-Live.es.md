---
layout: post
title: Creación de distribuciones Live con Fedora
date: 2008-09-24T20:34:16.000Z
author: Pablo Iranzo Gómez
tags:
  - linux
  - fedora
  - foss
lang: es
modified: 2022-05-04T13:15:43.533Z
categories:
  - FOSS
---

## Introducción

Según lo visto en el artículo [Kickstart]({{<ref "2008-05-11-Kickstart-instalaciones.es.md">}}), podemos crear un guión de instalación automatizada que por ejemplo podemos utilizar para crear un DVD autoinstalable, un servidor http, etc.

[Fedora]({{<ref "2008-06-14-Fedora.es.md">}}) proporciona unas utilidades 'livecd-tools' que permiten, utilizando un fichero kickstart crear una imagen ISO con una instalacion del sistema que hayamos escogido que tiene la característica de poderse ejecutar desde un CD/DVD.

## Ejemplo

Por ejemplo, podemos personalizar nuestro medio 'live' cambiando el mensaje de login con un:

```bash
#!bash
%post
echo "Sistema personalizado Live" > /etc/issue
```

Utilizando la sección `%packages` podemos por ejemplo instalar los paquetes openssh, o el entorno gráfico que luego tendremos disponibles en nuestro sistema.

Un ejemplo de kickstart para un medio Live podría ser:

```bash
#!bash
install
cdrom
reboot
lang es_ES.UTF-8
network —bootproto=static —device=eth0 —onboot=on —ip=192.168.1.2 —netmask=255.255.255.0 —gateway=192.168.1.1 —nameserver=172.20.2.11 —hostname=Live
keyboard es
firewall —disabled
selinux —disabled
rootpw —iscrypted $1$wcnLA/us$IV4Ap0LLSB3Dk4Qykg0xf.
timezone —utc Europe/Madrid
authconfig —enableshadow —enablemd5
xconfig —resolution 1024x768 —depth 24
bootloader —location=mbr —append="" —md5pass=$1$L4buo1$9PK59B0iM.WdFDk315gS71
firstboot —disable
key —skip
repo —name=RHEL5Client —baseurl=http://spacewalk.domain.es/kickstart/dist/ks-rhel-i386-client-5-u2/Client
repo —name=RHEL5VT —baseurl=http://spacewalk.domain.es/kickstart/dist/ks-rhel-i386-client-5-u2/VT
repo —name=RHEL5WKS —baseurl=http://spacewalk.domain.es/kickstart/dist/ks-rhel-i386-client-5-u2/Workstation
repo —name=RHEL5SVRC —baseurl=http://spacewalk.domain.es/kickstart/dist/ks-rhel-i386-server-5-u2/Cluster
repo —name=RHEL5SVR —baseurl=http://spacewalk.domain.eskickstart/dist/ks-rhel-i386-server-5-u2/Server
repo —name=RHEL5SVRVT —baseurl=http://spacewalk.domain.es/kickstart/dist/ks-rhel-i386-server-5-u2/VT
repo —name=RHEL5SVRCS —baseurl=http://spacewalk.domain.es/kickstart/dist/ks-rhel-i386-server-5-u2/ClusterStorage
part / —size 1024 #Partitionning
zerombr %packages —ignoremissing
syslinux
grub
screen
joe
mc
anaconda
anaconda-runtime
dialog
grub
@core
bash
kernel
passwd
policycoreutils
chkconfig
authconfig
rootfiles
dialog
wget
telnet
openssh-clients
bc

%post
# FIXME: it'd be better to get this installed from a package
cat > /etc/rc.d/init.d/rhel-live << EOF
#!/bin/bash
#
# live: Init script for live image
#
# chkconfig: 345 00 99
# description: Init script for live image.
. /etc/init.d/functions
if ! strstr "`cat /proc/cmdline`" liveimg || [ "$1" != "start" ] || [ -e /.liveimg-configured ] ; then exit 0
fi
exists()
which $1 >/dev/null 2>&1 || return $*
 touch /.liveimg-configured # mount live image
if [ -b /dev/live ]; then mkdir -p /mnt/live mount -o ro /dev/live /mnt/live
fi # read some variables out of /proc/cmdline
for o in `cat /proc/cmdline` ; do case $o in ks=*) ks="$o#ks=" ;; xdriver=*) xdriver="—set-driver=$o#xdriver=" ;; esac
done # if liveinst or textinst is given, start anaconda
if strstr "`cat /proc/cmdline`" liveinst ; then /usr/sbin/liveinst $ks
fi
if strstr "`cat /proc/cmdline`" textinst ; then /usr/sbin/liveinst —text $ks
fi # enable swaps unless requested otherwise
swaps=`blkid -t TYPE=swap -o device`
if ! strstr "`cat /proc/cmdline`" noswap -a [ -n "$swaps" ] ; then for s in $swaps ; do action "Enabling swap partition $s" swapon $s done
fi passwd -d root > /dev/null # turn off firstboot for livecd boots
echo "RUN_FIRSTBOOT=NO" > /etc/sysconfig/firstboot # don't start yum-updatesd for livecd boots
chkconfig —level 345 yum-updatesd off 2>/dev/null # don't start cron/at as they tend to spawn things which are
# disk intensive that are painful on a live image
chkconfig —level 345 crond off 2>/dev/null
chkconfig —level 345 atd off 2>/dev/null
chkconfig —level 345 anacron off 2>/dev/null
chkconfig —level 345 readahead_early off 2>/dev/null
chkconfig —level 345 readahead_later off 2>/dev/null # Stopgap fix for RH #217966; should be fixed in HAL instead
touch /media/.hal-mtab # workaround clock syncing on shutdown that we don't want (#297421)
sed -i -e 's/hwclock/no-such-hwclock/g' /etc/rc.d/init.d/halt
EOF # workaround avahi segfault (#279301)
touch /etc/resolv.conf
/sbin/restorecon /etc/resolv.conf chmod 755 /etc/rc.d/init.d/rhel-live
/sbin/restorecon /etc/rc.d/init.d/rhel-live
/sbin/chkconfig —add rhel-live # save a little bit of space at least...
rm -f /boot/initrd*
# make sure there aren't core files lying around
rm -f /core* %end #%post —nochroot # only works on x86, x86_64
if [ "$(uname -i)" = "i386" -o "$(uname -i)" = "x86_64" ]; then cp /usr/bin/livecd-iso-to-disk $LIVE_ROOT/LiveOS/
fi
%end
%post
echo "Medio Live personalizado" > /etc/issue
echo "Inicie sesión como 'root' sin contraseña" >> /etc/issue
echo " " >> /etc/issue

```

## Creación

Para generar la imagen Live, ejecutaremos

```bash
#!bash
livecd-creator -c /root/usuario/ks.cfg -f MedioLive
```

Al acabar, obtendremos un fichero ".iso" que contendrá un medio 'Vivo' basado en nuestro guión de instalación.

### Llaves USB/Pendrives

Livecd-tools incorpora dos utilidades más:

- livecd-iso-to-disk
- livecd-iso-to-pxeboot

Que graban esa imagen ISO en un medio USB y lo hacen arrancable, y por otro permiten crear los ficheros necesarios para poder servir en un entorno diskless nuestra imagen Live, por ejemplo, para hacer un medio de rescate más completo que el entorno mínimo que suelen ofrecer las distribuciones.

### Conclusión

Aprovechando los conocimientos que ya teníamos acerca de kickstart y anaconda, podemos personalizar un medio Vivo, livecd-tools se encargarán de la parte 'complicada' de adaptar el sistema a ejecutarse en un medio de sólo lectura.

Ahora sólo nos queda pasar a disfrutar y seguir afinando nuestro medio vivo hasta que se adapte perfectamente a nuestras necesidades, sabiendo que cualquier 'scripting' que necesitáramos hacer para adaptar el sistema, podemos codificarlo en las secciones 'post' de nuestro kickstart.

Este método es también operativo con Red Hat Enterprise Linux 5, CentOS 5 utilizando las livecd-tools de los repositorios de EPEL.
