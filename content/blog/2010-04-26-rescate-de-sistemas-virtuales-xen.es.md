---
layout: post
title: Rescate de sistemas virtuales (Xen)
date: 2010-04-23 23:31:00 +0200
author: Pablo Iranzo Gómez
tags:
  - fedora
  - xen
  - foss
lang: es
modified: 2022-03-23T09:59:24.737Z
---

A raíz de un problema debido a reiterados apagones, me vi en la necesidad de levantar una máquina virtual que ya no arrancaba.

En un sistema físico, lo que haríamos, es que según en qué punto estemos, usar un disco de arranque de nuestra distribución y por un lado reparar el sistema de ficheros con fsck o rehacer un initrd.img.

¿Cómo hacemos esto si la máquina en lugar de ser una real, es una virtual?.

Copiando el fichero de configuración de nuestra máquina a 'rescate', podemos editar la línea del cargador (eliminando pygrub) e indicando como kernel e initrd.img los de nuestro cd de distribución (en el caso de Xen, images/xen para EL5).

Una vez arrancado, ya podemos seguir el procedimiento estándar de recuperación.

En el caso de tener que reconstruir el initrd, podemos tener un problema añadido, pero por otro lado, al ser todo máquinas virtuales 'con el mismo hardware', es muy sencillo crear otra máquina virtual e instalarla indicando los mismos nombres para los vg's, particiones de arranque, etc y luego copiar el initrd.img y el kernel de la máquina nueva a la antigua y arrancarla, para llegados a este punto, reinstalar la última versión del kernel disponible con nuestro sistema ya arrancado.

La copia la podemos hacer bien desde el medio de rescate o montando mediante loopback el fichero de la máquina virtual (con LVM's es trivial) (puedes encontrar mucha información al respecto buscando por xen image y loopback offset).
