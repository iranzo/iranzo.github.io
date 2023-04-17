---
layout: post
title: iSCSI y Clustering en RHEL/CentOS
date: 2008-12-13T17:59:41.000Z
author: Pablo Iranzo Gómez
tags:
  - cluster
  - rhel
  - centos
  - foss
modified: 2023-04-17T21:50:28.728Z
categories:
  - FOSS
---

## Introducción

Durante la última semana estuve jugando de nuevo con iSCSI en el curso de [RH436 Enterprise Clustering and Storage Management](http://www.redhat.es/training/course/RH436). Hace tiempo había seguido dos artículos [Instalando un target iSCSI](http://federicosayd.wordpress.com/2007/09/11/instalando-un-target-iscsi/) y su continuación [Montando un iniciador iSCSI](http://federicosayd.wordpress.com/2007/09/13/montando-un-iniciador-iscsi-en-linux/).

iSCSI es una tecnología que permite acceder a almacenamiento remoto como si de unidades locales se tratara. A nivel 'barato', podemos utilizar el espacio de un sevidor central del que hacemos copias de seguridad, etc para ofrecer ese almacenamiento a distintas máquinas.

Con la entrada en juego de las ofertas de virtualización integradas con el SO, como por ejemplo Xen, podemos tener un servidor 'grande' y potente que albergue distintas máquinas virtuales que sirvan las páginas de dicho volumen en red, actualizarlo centralmente y tener muchos servidores actualizados....

Bueno, a medias :-)

Siempre es complicado compartir sistemas de ficheros, existen problemas de bloqueos de ficheros, accesos recurrentes, etc, en el caso de iSCSI no sólo es el FS sino la unidad, desde cualquier equipo podemos particionarla, etc, es por ello que se necesitan algunas utilidades preparadas para dicho funcionamiento en red, así como por supuesto, un sistema de ficheros que soporte dicho uso simultáneo.

Con las últimas versiones del kernel, disponemos tanto de clvm (Cluster [LVM]({{<relref "2007-03-09-Gestor-de-Volumenes-Logicos-LVM.es.md">}})) como de GFS (Global File System), que permiten, por un lado, poder operar en red desde varios equipos con los volúmenes lógicos, redimensionarlos, etc sin afectar a la producción, como de un sistema de ficheros preparado para trabajar en red con varios equipos.

Piensa por un momento, la posibilidad de tener ese host tan potente o una SAN con copias de seguridad bien controladas, etc

Añádele la posibilidad de tener máquinas virtuales que monten por la red una unidad iSCSI.

Añádele que esa unidad iSCSI puede ser de Lectura escritura, y que puedes utilizar enlaces simbólicos con variables que según el host que acceda guarde los logs en una carpeta.

Imagina lanzar tantas máquinas virtuales como sea necesario para atender la demanda, poder distribuirlas en la red.

## Manos a la obra

### Target iSCSI

Si no tenemos un target iSCSI, podemos definirlo en nuestro anfitrión, utilizando la versión Tech Preview de iSCSI Target llamada: `scsi-target-utils`

Esta utilidad contiene un comando `tgtadm` que podemos utilizar para definir las unidades.

Deberemos activar el demonio de tgtd para que esté disponible en cada arranque con los comandos:

```bash
#!bash
chkconfig tgtd on
service tgtd start
```

Actualmente y como tech preview, debemos repetir cada vez los comandos que necesitamos para definir la unidad iSCSI, por ejemplo:

```bash
#!bash
tgtadm --lld iscsi --mode target --op new --tid=1 --targetname iqn.2008-12.tld.dominio.maquina:TARGET tgtadm --lld iscsi --mode logicalunit --op new --tid=1 --lun=1 -b /dev/vg0/TARGET tgtadm --mode target --op bind --tid=1 --initiator-address=14.14.14.14
```

Con estos comandos definimos un nuevo target con ID 1, de nombre IQN `iqn.2008-12.tld.dominio.maquina:TARGET` y le añadimos una unidad lógica (LUN) que se basa en el contenido del volumen LVM /dev/vg0/TARGET.

Además, le permitimos el acceso a dicho target desde la ip `14.14.14.14`

Si todo esto está bien, deberemos, hasta que salga de la Tech Preview, añadir estos comandos al fichero `/etc/rc.local` para que se ejecuten en cada arranque

### Resto de equipos

El primer paso, es instalar en todas las máquinas los paquetes de `lvm2-cluster`, así como `ricci`. En todas ellas deberemos ejecutar `lvm —enable-cluster` para modificar los parámetros de locking para utilizarlo en red.

Para arrancar ricci tendremos que hacer algo parecido a lo que hicimos con tgtd

```bash
#!bash
chkconfig ricci on
service ricci start`
```

Por otro lado necesitaremos tener `kmod-gfs`, `gfs-util` y `iscsi-initiator-utils`.

Las unidades iSCSI se reconocerán a partir de la primera detección de forma automática, para ello deberemos ejecutar los siguientes comandos:

```bash
#!bash
iscsiadm -m discovery -t sendtargets -p IPTARGETISCSI iscsiadm -m node -T iqn.2008-12.tld.dominio.maquina:TARGET -l
```

Que descubrirá los targets disponibles para nuestra IP y luego hará 'login' en la máquina. A partir de este momento tendremos nuevas unidades disponibles que se presentarán como SCSI a nuestro pc, podremos
particionarlas, etc.

### El clúster

Si queremos hacer las cosas de la forma 'sencilla', deberemos instalar `luci` en una de las máquinas, ya sea en un nodo de control, o en el anfitrión Xen.

Luci es un interfaz web que permite la gestión y creación de clusters y para ello utiliza el demonio 'ricci' que hemos instalado en cada máquina.

Si tenemos las máquinas configuradas con los repositorios necesarios, `ricci` se hará cargo de la instalación de los paquetes necesarios para configurar todo.

Desde el interfaz web de luci podemos ir añadiendo cada uno de los nodos a utilizar, indicando sus claves de 'root' y se encargará de contactarlos y a través de ricci, instalar el software necesario y reiniciarlos para integrarlos en el cluster.

Los nodos, una vez en el cluster pueden utilizarse para albergar servicios, que estén de forma exclusiva (por ejemplo una bbdd porque necesite prioridad absoluta), o bien en failover para que no se deje de dar el servicio.

Por defecto tenemos una serie de servicios preconfigurados que podemos dar, como http, nfs, etc que podremos configurar rápidamente desde luci, que se encargará de desplegar dicha configuración a todo el cluster.

La forma de hacerlo es sencilla, se definen recursos (IP, NFS Exports, NFS Clients, http, mount points) que luego se agrupan por cadenas de dependencia en servicios y se les asignan grupos de failover, para que en caso de fallo, podamos definir prioridades.

Imagina el caso de una empresa con dos servidores, uno con la bbdd y otro con la web. En caso de fallo de uno de ellos, podemos hacer 'saltar' los servicios a la máquina que está operativa hasta que arreglemos la dañada y luego, cada servicio, volvería a su máquina 'preferida' o en el orden necesario.

En el caso de máquinas virtuales, en caso de que dejen de responder, CMAN realizará un reinicio (siempre que hayamos distribuido las claves de xen que podemos crear en la interfaz tanto a los guests como al anfitrión que estará escuchando con el demonio de fencing para XVM activado).

En el caso de tener enchufes 'con red' o bien máquinas con tarjetas de gestión remota (iLO, RemoteView Service Board, etc), definiremos los parámetros de acceso.

En caso de detectar un problema con cualquier equipo, el resto de ellos hará votaciones y si la mayoría considera que no responde, lo reiniciarán, por un lado para liberar cualquier tipo de acceso a disco, etc que hubiera estado haciendo a los recursos del cluster, como para intentar recuperarlo.

### GFS: Global File System

¿Qué pinta GFS en todo esto?

GFS1 nos permite crear un sistema de ficheros que tendrá un journal para cada nodo del cluster y que si lo creamos sobre el volumen iSCSI podemos hacer disponible a todos los equipos, si un equipo se bloquea, otro toma el control del journal no acabado, lo verifica y aplica sobre el FS hasta que la máquina retorna para dejarlo en un estado limpio.

Por otro lado, CLVM y GFS permiten aumentar dinámicamente el tamaño de los volúmenes, de forma que no tenemos que dejar inoperativos nuestros sistemas para hacer mantenimientos par añadir más capacidad, etc.

Permite también crear enlaces simbólicos de forma que una unidad con FS GFS1 pueda quedar:

```bash
hosts/
hosts/host1/logs
hosts/host2/logs
hosts/host3/logs
hosts/host4/logs
hosts/host5/logs
logs -> hosts/@hostname/logs/
```

Esto permite que diversos servidores web tengan configurado como ruta para los logs la carpeta 'logs' que se expandirá al hostname de la máquina, haciendo que queden todos recogidos en un lugar central para posterior análisis de estadísticas, etc

Este tipo de enlaces se denominan CDPN: Context-dependent pathnames y nos permiten jugar con este tipo de cosas y aprovechar las ventajas de un almacenamiento único.

### ¿Y si falla la red

Como siempre podemos tener problemas con la red, la forma de solucionarlos consiste en tener varios interfaces de red en los equipos a través de distintos switches, etc y en las máquinas, una vez descubiertos los targets, configurar el fichero `/etc/multipathd.conf` y habilitar el demonio.

Nos creará las rutas necesarias y una serie de dipositivos `/dev/mpath/*` para acceder de forma tolerante a fallos a nuestros recursos, si configuramos las tarjetas de red en modo bonding, ya tenemos el acceso más o menos asegurado ante las catástrofes más comunes y nuestros datos disponibles

### Conclusión

Tenemos a nuestro alcance muchas herramientas para hacer sencilla la utilización y creación de sistemas equivalentes a lo que hace años sólo tenía una alternativa excesivamente cara.

Sinceramente vale la pena perder un rato y probar estas cosas y maravillarnos de las posibilidades que abre de cara a la gestión de los equipos, la información y su acceso y lo mejor de todo, siempre con Software Libre.

Espero que esta introducción os despierte el gusanillo para explorar las diversas funcionalidades que estas tecnologías nos ofrecen!
{{<disfruta>}}
