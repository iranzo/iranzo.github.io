---
slug: Logical-volume-manager-LVM
layout: post
title: Gestor de Volúmenes Lógicos (LVM)
date: 2007-03-09T16:39:35Z
tags: linux, lvm
lang: es
save_as: blog/2007/03/09/Gestor-de-Volumenes-Logicos-LVM/index.html
-------------------------------------------------------------------

### Introducción

LVM son las siglas de Logical Volume Manager, gestor de volúmenes lógicos, una potente herramienta presente en los actuales sistemas Linux, inspirada en la implementación de la que disponían otros sistemas como AIX y HP-UX.

LVM introduce una separación entre la estructura típica de un sistema y los elementos discos, Particiones, Sistemas de ficheros a los que estamos habituados.

LVM funciona a tres niveles, a saber:

-  Volúmenes físicos
-  Grupos de volumen
-  Volúmenes lógicos

Una de las principales ventajas del sistema LVM sobre el sistema tradicional, es que LVM nos abstrae de los discos físicos y de las limitaciones de un disco, permitiendo tener sistemas de ficheros sobre varios discos, redimensionarlos según las necesidades y por lo tanto, hacer un uso más eficiente del espacio del que disponemos, con independencia de su ubicación.

Los volúmenes utilizan los llamados PE[^1], que son las unidades (relacionadas con el tamaño definido durante la creación), en las que se mide el tamaño o futuras ampliaciones/reducciones de los volúmenes.

La estructura de LVM sería la siguiente:

[Estructura de LVM, original de "http://www.ccp-west.de/tipps.html"]({filename}/imagen/lvmschema.gif)

**Estructura de LVM**

### Volúmenes físicos (pv)

Un volumen físico es un disco o una parte del disco que habilitaremos para su inclusión en un grupo de volúmenes.

Los volúmenes físicos, pueden estar ubicados en una partición (si por ejemplo han de coexistir con sistemas tradicionales), o bien extenderse por toda una unidad de disco o incluso, sobre dispositivos md[^2].

### Grupos de volumen (vg)

Los grupos de volumen se definen agrupando uno o más volúmenes físicos y son por así decirlo como discos virtuales, que toman su capacidad de entre los volúmenes físicos asignados al grupo de volumen.

### Volúmenes lógicos (lv)

Los volúmenes lógicos se crean dentro de un grupo de volumen y son el equivalente a las particiones en otros sistemas, es la parte de LVM que formateamos con un sistema de ficheros y que luego anexamos a nuestro sistema para poder utilizarlos como almacén de información.

### Comandos

Los comandos relacionados con LVM utilizan una nomenclatura parecida entre sí, con la particularidad del comienzo de la orden que varía según sea:

- pv(change,display,remove,create,move,resize,scan) para volúmenes físicos
- vg(convert,extend,reduce,scan,create,import,remove,split,change,display,merge,rename,export) para grupos de volumen
- lv(change,display,convert,extend,remove,rename,scan,create,reduce,resize) para volúmenes lógicos

### Preparación de un sistema para LVM

### Particionamiento de discos

Antes de poder utilizar LVM, debemos designar una serie de dispositivos (completos), o bien particiones (tipo 8e en fdisk)

Tras modificar el esquema de particiones en un sistema en ejecución, recuerde ejecutar el comando "partprobe" para actualizar la tabla de particiones en el kernel según el nuevo esquema definido.

En nuestro caso de ejemplo, contamos con dos discos duros hda y sda.

En hda tenemos una partición, `hda1` donde estará almacenado el `/boot` (la partición que contiene el kernel, y los initrd's no puede estar en un volumen LVM) y el resto está disponible, por lo que crearemos una
partición hda2, que ocupará el resto del disco duro.

En sda, tenemos todo el disco duro disponible para utilizarlo con LVM, así que definiremos una partición sda1 que dedicaremos enteramente a esta finalidad.

### Creación de volúmenes físicos (PV)

Los volúmenes físicos son las unidades donde se asienta la estructura de las grupos de volúmenes, su creación, es tan sencilla como ejecutar:


~~~
#!bash
pvcreate /dev/hda2

pvcreate /dev/sda1
~~~

Si a continuación ejecutamos `pvscan`, podremos consultar un listado de los volúmenes físicos definidos en el sistema, así como el tipo de metadatos (lvm o lvm2) y su capacidad y un resumen de la capacidad total, la utilizada y la disponible.

Para ver el estado detallado, podremos ejecutar pvdisplay, que nos mostrará más información como el tamaño, los PE'*s* disponibles, etc

### Creación de grupos de volúmenes (VG)

Los grupos de volúmenes son los cajones, que ubicados sobre los volúmenes físicos, definen la agrupación para los volúmenes lógicos, permitiendo clarificar así la estructura de los mismos.

Para crear un grupo de volumen haremos:

~~~
#!bash
vgcreate Prueba /dev/sda1
~~~

Este comando creará un grupo de volúmenes llamado `Prueba` sobre el volumen físico en `/dev/sda1`

Para comprobar que la acción ha sido realizada correctamente, podremos ejecutar vgscan para ver un listado de los grupos de volumen definidos.

### Creación de volúmenes lógicos (LV)

Los volúmenes lógicos son el equivalente a las particiones, es el lugar donde vamos a poner un sistema de ficheros y en consecuencia los datos.

Los volúmenes lógicos se definen dentro de un grupo de volúmenes de la siguiente forma:

~~~
#!bash
lvcreate Prueba -n Inicial -L 2G
~~~

Si ejecutamos a continuación lvscan, tendremos un listado de todos los grupos de volumen definidos y su tamaño, entre ellos, "Inicial", definido dentro de "Prueba" y con un tamaño de 2 Gb

### Creación de un sistema de ficheros

Antes de poder utilizar el volumen lógico, deberemos prepararlo para contener datos y crear la estructura de un sistema de ficheros, esta vez, el comando es idéntico a cuando creamos un sistema de ficheros sobre un disco físico, pero especificando el volumen lógico, por ejemplo:

~~~
#!bash
mkfs.ext3 /dev/Prueba/Inicial
~~~

Es muy recomendable hacer uso de un sistema de ficheros que podamos redimensionar, ya que como se comentó, una de las ventajas de LVM es la posibilidad de redimensionar las unidades lógicas, y hace falta en consecuencia, que el sistema de ficheros que está en ese "contenedor", sea capaz de crecer o de disminuir del mismo modo.

Ahora, ya podremos montar el sistema de ficheros, por ejemplo:

mount /dev/Prueba/Inicial /mnt

### Redimensionamiento de una unidad LVM

EXT3, el sistema de ficheros utilizado por defecto en la distribución, permite redimensionamiento de discos, el sistema de ficheros puede crecer sin tener que dejar de utilizarlo, pero para reducir su tamaño, es necesario detener su uso, aun así, nos permite la posibilidad muy interesante de crear sistemas de ficheros pequeños, adaptados a nuestro uso inicial y luego ir haciéndolos crecer cuando sea necesario sin tener que detener las operaciones que estemos llevando a caba en el equipo.

A modo de ejemplo, y siguiendo con la dinámica de los ejemplos de creación de un sistema con LVM, vamos a extender el sistema de ficheros de "Inicial", aumentándolo en 250 Mb, para ello haremos:

~~~
#!bash
pvscan #(donde nos mostrará los volúmenes físicos y el espacio libre)
# En caso de ser necesario, ampliaremos el vg añadiendo un nuevo pv:
pvcreate /dev/disconuevo
vgextend Prueba /dev/disconuevo
# A partir de ese momento, el vg tendrá el espacio disponible listo para ser usado por los lv y lo ampliaremos del siguiente modo:
lvextend -L +250M /dev/Prueba/Inicial
ext2online /dev/mapper/Prueba-Inicial
~~~

Al acabar, el sistema de ficheros montado en /mnt habrá aumentado en 250 Mb su capacidad disponible

También, podemos aumentar el volumen a un tamaño total, por ejemplo, aumentar el volumen a 4 Gb, ejecutando:

~~~
#!bash
lvextend -L 4G /dev/Prueba/Inicial
ext2online /dev/mapper/Prueba-Inicial
~~~

En el caso de Fedora Core 6 (FC6), la utilidad ext2online no existe, pues ha sido integrada en resize2fs, por lo que llevaremos a cabo el redimensionamiento con `resize2fs -p /dev/Prueba-Inicial [tamaño final]`.

**ATENCIÓN: Éste es un proceso muy peligroso, pues podemos perder datos**

Si queremos reducir el tamaño de una unidad lógica, primero, deberemos anotar el espacio utilizado en el sistema de ficheros y proceder a desmontarlo:

~~~
#!bash
umount /dev/mapper/Prueba-Inicial
#El siguiente paso, es reducir el sistema de ficheros:
resize2fs /dev/mapper/Prueba-Inicial [Tamaño nuevo]
~~~

Recomiendo reducir el tamaño del sistema de ficheros por debajo del tamaño final que deseamos alcanzar, para así tener un margen de seguridad. Este tamaño, deberá ser SIEMPRE mayor que la capacidad
[^3] utilizada del volumen.

Acabado el proceso, podemos redimensionar el volumen lógico:

~~~
#!bash
lvextend -L -2G /dev/mapper/Prueba-Inicial
~~~

Y volveremos a estirar el sistema de ficheros de nuevo con `resize2fs /dev/mapper/Prueba-Inicial` para ocupar todo el espacio disponible en el volumen.

### Herramienta gráfica

Red Hat o Fedora Core incorporan una herramienta gráfica "system-config-lvm" que permite realizar la gestión de los volúmenes presentes en el sistema de forma gráfica, a continuación se muestran unas capturas de pantalla del aspecto de la aplicación.

En la siguiente captura podemos ver los volúmenes físicos no asignados a algún grupo de volumen, y con las opciones que nos proporciona el gestor, podremos añadirlos a un grupo de volumen existente, o bien crear un nuevo grupo de volumen:

[PV no asignados]({filename}/imagen/lvm3.jpg)

Aquí, podremos crear un nuevo volumen lógico dentro del grupo de volumen, podremos indicar el nombre del volumen, el tipo de volumen, así como el tamaño y sistema de ficheros:

[Crear VL]({filename}/imagen/lvm6.jpg)

En esta vista de la aplicación podemos ver el grupo de volumen "Test" y la vista lógica y física de los volúmenes creados dentro del mismo (como vemos, Test, está compuesto por cuatro particiones o volúmenes físicos: sdb1,sdb2,sdb3,sdb4)

[Vista VL]({filename}/imagen/lvm8.jpg)

Vemos, al tener marcado el espacio libre del volumen lógico, dónde está ubicado el espacio libre a nivel físico y el número de extensiones que corresponden a cada volumen físico.

Quiero destacar mi agradecimiento a [Carlos Hergueta](mailto:chergueta@gmail.com) por su colaboración en la realización de este documento

[^1]:Physical Extents

[^2]:Multiple Devices: Es una tecnología que mediante software permite la creación de distintos niveles de agrupación de discos: linear, raid0, raid1, raid5. Los dispositivos se identifican en un sistema linux por la existencia de unidades /dev/md*0,1,2,3,etc* y un fichero de estado /proc/mdstat que indica el estado actual de los md's definidos y su estado de sincronía en caso de estar agrupados como RAID

[^3]:El que hemos anotado en el paso previo a desmontarlo
